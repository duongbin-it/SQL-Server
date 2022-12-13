CREATE DATABASE qltv
GO
USE qltv
GO
CREATE TABLE SinhVien (
  MaSV int PRIMARY KEY,
  HoTen nvarchar(50) NOT NULL,
  NgaySinh date NOT NULL,
  GioiTinh bit NOT NULL,
  SDTSV int NOT NULL UNIQUE,
  EmailSV varchar(50) NOT NULL,
  Matkhau varchar(30) NOT NULL,
  Phanquyen bit NOT NULL,
  Lop varchar(10) NOT NULL,

)
GO
CREATE TABLE Tacgia (
  Matacgia varchar(50) PRIMARY KEY,
  Tentacgia nvarchar(50) NOT NULL,
  SDTTG int NOT NULL UNIQUE,
  EmailTG varchar(30) NOT NULL UNIQUE,

)
GO
CREATE TABLE NXB (
  MaNXB varchar(50) PRIMARY KEY,
  TenNXB nvarchar(300) NOT NULL,
  Diachi nvarchar(300) NOT NULL,
)
GO
CREATE TABLE Tinhtrang (
  Matinhtrang varchar(50) PRIMARY KEY,
  Tinhtrangsach nvarchar(50) NOT NULL,
  Tienphatsach varchar(50) NOT NULL,
)
GO
CREATE TABLE Sach (
  Masach varchar(50) PRIMARY KEY,
  Tensach nvarchar(50) NOT NULL,
  NamXB date NOT NULL,
  Theloai nvarchar(50) NOT NULL,
  Matacgia varchar(50) FOREIGN KEY (Matacgia) REFERENCES dbo.Tacgia (Matacgia),
  MaNXB varchar(50) FOREIGN KEY (MaNXB) REFERENCES dbo.NXB (MaNXB),
  Soluong int NOT NULL,
  Conlai int DEFAULT 0 NOT NULL,

)
GO
CREATE TABLE Muon (
  Maindex int IDENTITY (0, 1) PRIMARY KEY,
  MaMuon varchar(50) NOT NULL,
  MaSV int FOREIGN KEY (MaSV) REFERENCES dbo.SinhVien (MaSV),
  Masach varchar(50) FOREIGN KEY (Masach) REFERENCES dbo.Sach (Masach),
  Ngaymuon datetime DEFAULT GETDATE(),
  Ngaytra datetime DEFAULT NULL,
  Hantrasach datetime DEFAULT DATEADD(DAY, 100, GETDATE()) CHECK (Hantrasach >= GETDATE()) NOT NULL,
  Tinhtrangdonmuon bit DEFAULT 0 NOT NULL,
  Matinhtrang varchar(50) FOREIGN KEY (Matinhtrang) REFERENCES dbo.Tinhtrang (Matinhtrang) DEFAULT 'NO' NOT NULL,
  Tienphatquahan varchar(50) DEFAULT '0' NOT NULL,

)
GO--Trigger thêm dữ liệu cho Sach
CREATE TRIGGER check_insert_sach
ON Sach
AFTER INSERT
AS
BEGIN
  DECLARE @soluong int
  DECLARE @conlai int
  SELECT
    @soluong = Sach.Soluong
  FROM Sach,
       Inserted
  WHERE Inserted.Masach = Sach.Masach
  UPDATE Sach
  SET Sach.Conlai = @soluong
  FROM Sach,
  Inserted
  WHERE Inserted.Masach = Sach.Masach
END
GO--Trigger thêm mới dữ liệu cho Muon
CREATE TRIGGER check_insert_muon
ON Muon
AFTER INSERT
AS
BEGIN
  DECLARE @conlai int
  DECLARE @masach varchar(50)
  DECLARE @mamuon varchar(50)
  DECLARE @mamuoncungngay varchar(50)
  DECLARE @masinhvien int
  DECLARE @ngaymuon datetime
  DECLARE @Tinhtrang bit
  SELECT
    @conlai = Sach.Conlai
  FROM Sach,
       Inserted
  WHERE Inserted.Masach = Sach.Masach
  SELECT
    @masach = Muon.Masach
  FROM Muon,
       Inserted
  WHERE Inserted.Masach = Muon.Masach
  SELECT
    @masinhvien = SinhVien.MaSV
  FROM SinhVien,
       Inserted
  WHERE Inserted.MaSV = SinhVien.MaSV
  SELECT
    @mamuon = Muon.Mamuon
  FROM Muon,
       Inserted
  WHERE Inserted.Mamuon = Muon.Mamuon
  SELECT
    @ngaymuon = CONVERT(date, (SELECT TOP 1
      Ngaymuon
    FROM Muon
    WHERE MaMuon = @mamuon)
    )
  SELECT
    @mamuoncungngay = Mamuon
  FROM (SELECT TOP (1)
    Mamuon,
    MaSV
  FROM Muon
  WHERE MaSV = @masinhvien
  AND Tinhtrangdonmuon = 0) AS a
  SELECT
    @Tinhtrang = Tinhtrangdonmuon
  FROM (SELECT TOP (1)
    Tinhtrangdonmuon
  FROM Muon
  WHERE MaSV = 53265
  AND Tinhtrangdonmuon = 0) AS a
  IF (SELECT
      COUNT
      (*)
    FROM (SELECT DISTINCT
      Muon.Mamuon,
      SinhVien.MaSV
    FROM Muon
    INNER JOIN SinhVien
      ON SinhVien.MaSV = Muon.MaSV
    INNER JOIN Sach
      ON Sach.Masach = Muon.Masach
    WHERE Mamuon = @mamuon) AS a)
    <= 1 --Một mã mượn sách chỉ thuộc về 1 sinh viên duy nhất.

    AND (SELECT DISTINCT
      Tinhtrangdonmuon
    FROM Muon
    WHERE Mamuon = @mamuon)
    != 1 --không được trả mã đơn này khi chưa được mượn.

    AND (SELECT
      DATEDIFF(DAYOFYEAR, GETDATE(), @ngaymuon))
    = 0 --Kiểm tra MMS nếu đã được trả thì khi mượn thêm sách trong ngày hôm đó sẽ k được gộp chung vào MMS đó, sang ngày sau nếu mượn thêm sách thì sẽ được cấp MMS mới riêng biệt.
  BEGIN
    IF
      @conlai > 0
    BEGIN
      UPDATE Sach
      SET Conlai = Conlai - 1
      FROM Sach,
      Inserted
      WHERE Inserted.Masach = Sach.Masach
      AND Sach.Masach = @masach
      IF
        @Tinhtrang != 1
      BEGIN
        UPDATE Muon
        SET MaMuon = @mamuoncungngay
        FROM Muon,
        Inserted
        WHERE Inserted.MaMuon = Muon.MaMuon
        AND Muon.MaMuon = @mamuon
      END
    END
    ELSE
    BEGIN
      RAISERROR ('ERROR QUERY', 16, 1)
      ROLLBACK
    END
  END
  ELSE
  BEGIN
    RAISERROR ('ERROR QUERY', 16, 1)
    ROLLBACK
  END
END
GO
CREATE TRIGGER check_update_Muon
ON Muon
AFTER UPDATE
AS
BEGIN
  DECLARE @sosach int
  DECLARE @conlai int
  DECLARE @Hantrasach datetime
  DECLARE @masach varchar(50)
  DECLARE @Tinhtrang bit
  DECLARE @Mamuon varchar(50)
  DECLARE @vonglap int = 0
  SELECT
    @Mamuon = Muon.Mamuon
  FROM Muon,
       Inserted
  WHERE Inserted.Mamuon = Muon.Mamuon
  SELECT
    @Hantrasach = Muon.Hantrasach
  FROM Muon,
       Inserted
  WHERE Inserted.Hantrasach = Muon.Hantrasach
  SELECT
    @Tinhtrang = Muon.Tinhtrangdonmuon
  FROM Muon,
       Inserted
  WHERE Inserted.Tinhtrangdonmuon = Muon.Tinhtrangdonmuon
  SELECT
    @sosach = Sach.Soluong
  FROM Sach,
       Inserted
  WHERE Inserted.Masach = Sach.Masach
  SELECT
    @conlai = Sach.Conlai
  FROM Sach,
       Inserted
  WHERE Inserted.Masach = Sach.Masach
  IF
    @conlai <= @sosach
    AND @Tinhtrang = 1
    AND (SELECT TOP (1)
      ISNULL(Ngaytra, 0)
    FROM Muon
    WHERE MaMuon = @Mamuon)
    = '1900-01-01 00:00:00.000' --kiểm tra nếu mã mượn sách này đã trả thì không trả nữa
  BEGIN
    DECLARE Cursors CURSOR FOR
    SELECT
      Muon.Masach
    FROM Muon
    INNER JOIN SinhVien
      ON SinhVien.MaSV = Muon.MaSV
    INNER JOIN Sach
      ON Sach.Masach = Muon.Masach
    WHERE MaMuon = @Mamuon
    GROUP BY Muon.Masach
    OPEN Cursors
    FETCH NEXT
    FROM
    Cursors INTO @masach
    WHILE
      @@FETCH_STATUS = 0
    BEGIN
      WHILE
        @vonglap < (SELECT
          COUNT(*)
        FROM Muon
        WHERE Mamuon = @Mamuon
        AND Masach = @masach)
      BEGIN
        UPDATE Sach
        SET Conlai = Conlai + 1
        FROM Sach,
        Inserted
        WHERE Inserted.Masach = Sach.Masach
        AND Sach.Masach = @masach
        UPDATE Muon
        SET Ngaytra = GETDATE()
        FROM Muon,
        Inserted
        WHERE Inserted.Tinhtrangdonmuon = Muon.Tinhtrangdonmuon
        AND Muon.MaMuon = @Mamuon
        SET @vonglap = @vonglap + 1
      END
      SET @vonglap = 0
      FETCH NEXT
      FROM
      Cursors INTO @masach
    END
    CLOSE Cursors
    DEALLOCATE Cursors
  END
  ELSE
  BEGIN
    IF
      @Tinhtrang != 0
    BEGIN
      RAISERROR ('ERROR QUERY', 16, 1)
      ROLLBACK
    END
  END
END
GO
INSERT INTO NXB
  VALUES ('NXB01', N'Nhà Xuất Bản Bách khoa Hà Nội', N'Số 1 Đường Đại Cồ Việt, Hai Bà Trưng , Hà Nội')
INSERT INTO NXB
  VALUES ('NXB02', N'Nhà Xuất Bản Chính trị Quốc gia Sự thật', N'6/86 Duy Tân, Cầu Giấy, Hà Nội')
INSERT INTO NXB
  VALUES ('NXB03', N'Nhà Xuất Bản Công Thương', N'Hà Nội')
INSERT INTO NXB
  VALUES ('NXB04', N'Nhà Xuất Bản Nhà xuất bản Đại học Quốc Gia Hà Nội', N'Tầng 4, Tòa nhà Bộ Công Thương, số 655 Phạm Văn Đồng, quận Bắc Từ Liêm, Hà Nội')
INSERT INTO NXB
  VALUES ('NXB05', N'Nhà Xuất Bản Công an nhân dân', N'92 Nguyễn Du, quận Hai Bà Trưng, TP. Hà Nội')
INSERT INTO NXB
  VALUES ('NXB06', N'Nhà Xuất Bản Dân trí', N'Số 9, ngõ 26, phố Hoàng Cầu, quận Đống Đa, thành phố Hà Nội')
INSERT INTO NXB
  VALUES ('NXB07', N'Nhà Xuất Bản Giao thông vận tải', N'80B Trần Hưng Đạo, Quận Hoàn Kiếm, Thành phố Hà Nội')
INSERT INTO NXB
  VALUES ('NXB08', N'Nhà Xuất Bản Giáo dục Việt Nam', N'81 Trần Hưng Đạo - Q. Hoàn KIếm - Hà Nội')
INSERT INTO NXB
  VALUES ('NXB09', N'Nhà Xuất Bản Hàng hải', N'484 Lạch Tray, Ngô Quyền, Hải Phòng')
INSERT INTO NXB
  VALUES ('NXB10', N'Nhà Xuất Bản Học viện Nông nghiệp', N'Trường Đại học Nông nghiệp Hà Nội - Thị trấn Trâu Quỳ, huyện Gia Lâm, Hà Nội')
INSERT INTO NXB
  VALUES ('NXB11', N'Nhà Xuất Bản Hồng Đức', N'65 Tràng Thi, Hà Nội')
INSERT INTO NXB
  VALUES ('NXB12', N'Nhà Xuất Bản Hội Nhà văn', N'Số 65 Nguyễn Du, Hà Nội')
INSERT INTO NXB
  VALUES ('NXB13', N'Nhà Xuất Bản Khoa học Tự nhiên và Công nghệ', N'Nhà A16 - Số 18 Hoàng Quốc Việt, Cầu Giấy, Hà Nội')
INSERT INTO NXB
  VALUES ('NXB14', N'Nhà Xuất Bản Khoa học và Kỹ thuật', N'Số 70 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội')
INSERT INTO NXB
  VALUES ('NXB15', N'Nhà Xuất Bản Khoa học xã hội', N'26 Lý Thường Kiệt, Hà Nội')
GO
INSERT INTO SinhVien
  VALUES (53265, N'Nguyễn Bình Dương', '2002-02-16', 1, '0383345415', 'duong53265@nuce.edu.vn', 'tungduonghj', '1', 'ADMIN')
INSERT INTO SinhVien
  VALUES (53266, N'Nguyễn Bình Trọng', '2004-09-14', 1, '0383362816', 'trong53266@nuce.edu.vn', 'tungduonghj', '0', '65IT4')
GO
INSERT INTO Tacgia
  VALUES ('TH', N'Tố Hữu', '0383345415', 'jfu@gmail.com')
INSERT INTO Tacgia
  VALUES ('XQ', N'Xuân Quỳnh', '0383345417', 'jfwdu@gmail.com')
INSERT INTO Tacgia
  VALUES ('TRH', N'Trang Hạ', '0383345416', 'jf343u@gmail.com')
INSERT INTO Tacgia
  VALUES ('PV', N'Nguyễn Phong Việt', '0383345420', 'jf3243u@gmail.com')
INSERT INTO Tacgia
  VALUES ('AK', N'An Khang', '0383345413', 'jf121u@gmail.com')
INSERT INTO Tacgia
  VALUES ('NNT', N'Nguyễn Ngọc Thạch', '0383345443', 'jf356u@gmail.com')
GO
INSERT INTO Tinhtrang (Matinhtrang, Tinhtrangsach, Tienphatsach)
  VALUES ('NO', N'nguyên vẹn', '0')
INSERT INTO Tinhtrang (Matinhtrang, Tinhtrangsach, Tienphatsach)
  VALUES ('BR', N'bị rách', '50.000')
INSERT INTO Tinhtrang (Matinhtrang, Tinhtrangsach, Tienphatsach)
  VALUES ('BM', N'bị mất', '500.000')
INSERT INTO Tinhtrang (Matinhtrang, Tinhtrangsach, Tienphatsach)
  VALUES ('BN', N'bị nhàu', '20.000')
INSERT INTO Tinhtrang (Matinhtrang, Tinhtrangsach, Tienphatsach)
  VALUES ('BOTH', N'bị nhàu và bị rách', '70.000')
GO
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7290', N'Mạng Máy Tính', '2014-12-10', N'Giáo trình', 'TRH', 'NXB01', 182)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7291', N'Tin Học Đại Cương', '1998-08-07', N'Giáo trình', 'TH', 'NXB01', 100)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7292', N'Hóa Học Đại Cương', '1996-02-19', N'Giáo trình', 'XQ', 'NXB02', 200)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7293', N'Pháp Luật Đại Cương', '1995-07-02', N'Giáo trình', 'TRH', 'NXB03', 1000)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7294', N'Triết Học Đại Cương', '1994-10-20', N'Giáo trình', 'TH', 'NXB04', 1021)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7295', N'Khoa Học Đại Cương', '1993-03-29', N'Giáo trình', 'TH', 'NXB05', 839)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7296', N'Hệ Cơ Sở Dữ Liệu', '1992-02-28', N'Giáo trình', 'TH', 'NXB06', 302)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7297', N'CNXH và Khoa Học', '1991-10-12', N'Giáo trình', 'TH', 'NXB07', 283)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7298', N'CTDL và Thuật Toán 1', '1990-08-01', N'Giáo trình', 'TH', 'NXB08', 12)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7299', N'CTDL và Thuật Toán 2', '1997-09-11', N'Giáo trình', 'TH', 'NXB09', 10)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7300', N'Giáo Dục Quốc Phòng 3', '1993-04-04', N'Giáo trình', 'TH', 'NXB10', 0)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7301', N'Giáo Dục Quốc Phòng 2', '1992-04-18', N'Giáo trình', 'TH', 'NXB11', 203)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7302', N'Giáo Dục Quốc Phòng 1', '1991-12-12', N'Giáo trình', 'TH', 'NXB12', 932)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7303', N'Pháp Luật Đại Cương', '2010-12-10', N'Giáo trình', 'TRH', 'NXB13', 5000)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7304', N'Phân tích thiết kế và hệ thống thông tin', '2011-12-10', N'Giáo trình', 'TRH', 'NXB13', 5000)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7305', N'Lập trình hướng đối tượng', '2012-12-10', N'Giáo trình', 'TRH', 'NXB13', 5000)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7306', N'Tư tưởng Hồ Chí Minh', '2013-12-10', N'Giáo trình', 'TRH', 'NXB13', 5000)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7307', N'Hệ cơ sở dữ liệu', '2014-12-10', N'Giáo trình', 'TRH', 'NXB13', 5000)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7308', N'Lập trình Linux', '2015-12-10', N'Giáo trình', 'TRH', 'NXB13', 5000)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7309', N'Lập trình C++', '2016-12-10', N'Giáo trình', 'TRH', 'NXB13', 5000)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7310', N'Nhập môn cơ sở Hệ Điều Hành', '2017-12-10', N'Giáo trình', 'TRH', 'NXB13', 5000)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7311', N'Cấu trúc dữ liệu và giải thuật 1', '2017-12-10', N'Giáo trình', 'TRH', 'NXB13', 5000)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7312', N'Cấu trúc dữ liệu và giải thuật 2', '2017-12-10', N'Giáo trình', 'TRH', 'NXB13', 5000)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7313', N'Cấu trúc dữ liệu và giải thuật 3', '2017-12-10', N'Giáo trình', 'TRH', 'NXB13', 5000)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7314', N'Nhập môn giải tích 1', '2017-12-10', N'Giáo trình', 'TRH', 'NXB13', 5000)
INSERT INTO Sach (Masach, Tensach, NamXB, Theloai, Matacgia, MaNXB, Soluong)
  VALUES ('MS7315', N'Nhập môn giải tích 2', '2017-12-10', N'Giáo trình', 'TRH', 'NXB13', 5000)
GO
INSERT INTO Muon (Mamuon, MaSV, Masach)
  VALUES ('MMS01', 53266, 'MS7291')
INSERT INTO Muon (Mamuon, MaSV, Masach)
  VALUES ('MMS01', 53266, 'MS7291')
INSERT INTO Muon (Mamuon, MaSV, Masach)
  VALUES ('MMS01', 53266, 'MS7291')
INSERT INTO Muon (Mamuon, MaSV, Masach)
  VALUES ('MMS01', 53266, 'MS7291')
INSERT INTO Muon (Mamuon, MaSV, Masach)
  VALUES ('MMS05', 53265, 'MS7291')
INSERT INTO Muon (Mamuon, MaSV, Masach)
  VALUES ('MMS05', 53265, 'MS7291')
INSERT INTO Muon (Mamuon, MaSV, Masach)
  VALUES ('MMS05', 53265, 'MS7291')
INSERT INTO Muon (Mamuon, MaSV, Masach)
  VALUES ('MMS05', 53265, 'MS7291')
GO



-- QUERY SQL SERVER

SELECT DISTINCT YEAR(Ngaytra) AS Ngaytra FROM Muon WHERE Tinhtrangdonmuon = 1


























