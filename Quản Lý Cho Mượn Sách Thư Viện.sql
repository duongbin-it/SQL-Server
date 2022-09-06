CREATE DATABASE QLMS
GO

USE QLMS
GO

CREATE TABLE SinhVien
(
MaSV INT PRIMARY KEY,
HoTen NVARCHAR(50) NOT NULL,
NgaySinh DATE NOT NULL,
GioiTinh BIT NOT NULL,
SDT CHAR(12) NOT NULL UNIQUE,
)
GO

CREATE TABLE Tacgia
(
Matacgia VARCHAR(50) PRIMARY KEY,
Tentacgia NVARCHAR(50) NOT NULL,
)
GO

CREATE TABLE NXB
(
MaNXB VARCHAR(50) PRIMARY KEY,
TenNXB NVARCHAR(300) NOT NULL,
Diachi NVARCHAR(300) NOT NULL,
)
GO

CREATE TABLE Sach
(
Masach VARCHAR(50) PRIMARY KEY,
Tensach NVARCHAR(50) NOT NULL,
NamXB DATE NOT NULL,
Matacgia VARCHAR(50) FOREIGN KEY(Matacgia) REFERENCES dbo.Tacgia(Matacgia),
MaNXB VARCHAR(50) FOREIGN KEY(MaNXB) REFERENCES dbo.NXB(MaNXB),
Soluong INT NOT NULL,
Conlai INT DEFAULT 0 NOT NULL,
)
GO

CREATE TABLE Muon(
MaMuon VARCHAR(50) NOT NULL,
MaSV INT FOREIGN KEY(MaSV) REFERENCES dbo.SinhVien(MaSV),
Masach VARCHAR(50) FOREIGN KEY(Masach) REFERENCES dbo.Sach(Masach),
Ngaymuon DATETIME NOT NULL,
Ngaytra DATETIME DEFAULT NULL,
Hantrasach DATETIME DEFAULT DATEADD(year, 1, GETDATE()) CHECK(Hantrasach >= GETDATE()) NOT NULL,
Tinhtrang BIT DEFAULT 0 NOT NULL,
Tienquahan INT DEFAULT 0 NOT NULL,
)
GO


--NXB(MaNXB, TenNXB, Diachi)
INSERT INTO NXB VALUES ('NXB01', N'Nhà Xuất Bản Bách khoa Hà Nội', N'Số 1 Đường Đại Cồ Việt, Hai Bà Trưng , Hà Nội')
INSERT INTO NXB VALUES ('NXB02', N'Nhà Xuất Bản Chính trị Quốc gia Sự thật', N'6/86 Duy Tân, Cầu Giấy, Hà Nội')
INSERT INTO NXB VALUES ('NXB03', N'Nhà Xuất Bản Công Thương', N'Hà Nội')
INSERT INTO NXB VALUES ('NXB04', N'Nhà Xuất Bản Nhà xuất bản Đại học Quốc Gia Hà Nội', N'Tầng 4, Tòa nhà Bộ Công Thương, số 655 Phạm Văn Đồng, quận Bắc Từ Liêm, Hà Nội')
INSERT INTO NXB VALUES ('NXB05', N'Nhà Xuất Bản Công an nhân dân', N'92 Nguyễn Du, quận Hai Bà Trưng, TP. Hà Nội')
INSERT INTO NXB VALUES ('NXB06', N'Nhà Xuất Bản Dân trí', N'Số 9, ngõ 26, phố Hoàng Cầu, quận Đống Đa, thành phố Hà Nội')
INSERT INTO NXB VALUES ('NXB07', N'Nhà Xuất Bản Giao thông vận tải', N'80B Trần Hưng Đạo, Quận Hoàn Kiếm, Thành phố Hà Nội')
INSERT INTO NXB VALUES ('NXB08', N'Nhà Xuất Bản Giáo dục Việt Nam', N'81 Trần Hưng Đạo - Q. Hoàn KIếm - Hà Nội')
INSERT INTO NXB VALUES ('NXB09', N'Nhà Xuất Bản Hàng hải', N'484 Lạch Tray, Ngô Quyền, Hải Phòng')
INSERT INTO NXB VALUES ('NXB10', N'Nhà Xuất Bản Học viện Nông nghiệp', N'Trường Đại học Nông nghiệp Hà Nội - Thị trấn Trâu Quỳ, huyện Gia Lâm, Hà Nội')
INSERT INTO NXB VALUES ('NXB11', N'Nhà Xuất Bản Hồng Đức', N'65 Tràng Thi, Hà Nội')
INSERT INTO NXB VALUES ('NXB12', N'Nhà Xuất Bản Hội Nhà văn', N'Số 65 Nguyễn Du, Hà Nội')
INSERT INTO NXB VALUES ('NXB13', N'Nhà Xuất Bản Khoa học Tự nhiên và Công nghệ', N'Nhà A16 - Số 18 Hoàng Quốc Việt, Cầu Giấy, Hà Nội')
INSERT INTO NXB VALUES ('NXB14', N'Nhà Xuất Bản Khoa học và Kỹ thuật', N'Số 70 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội')
INSERT INTO NXB VALUES ('NXB15', N'Nhà Xuất Bản Khoa học xã hội', N'26 Lý Thường Kiệt, Hà Nội')
GO


--SinhVien(MaSV, HoTen, NgaySinh, GioiTinh, SDT)
INSERT INTO SinhVien VALUES (53265, N'Nguyễn Bình Dương', '2002-02-16', 1, '+84383345415')
INSERT INTO SinhVien VALUES (53266, N'Nguyễn Bình Trọng', '2004-09-14', 1, '+84383362816')
INSERT INTO SinhVien VALUES (53267, N'Nguyễn Văn Hải', '2010-02-17', 1, '+84795164402')
INSERT INTO SinhVien VALUES (53268, N'Trần Thị Yến', '2004-02-18', 1, '+84392281647')
INSERT INTO SinhVien VALUES (53269, N'Đinh Hoàng Phong', '2003-02-19', 0, '+84384736383')
INSERT INTO SinhVien VALUES (53270, N'Phạm Huỳnh Thắng', '2005-02-20', 1, '+84173829462')
INSERT INTO SinhVien VALUES (53271, N'Nguyễn Hoàng Quốc', '2006-02-21', 1, '+84859267836')
INSERT INTO SinhVien VALUES (53272, N'Phạm Thị Trang', '2007-02-22', 0, '+84584463826')
INSERT INTO SinhVien VALUES (53273, N'Bùi Thu Hồng', '2009-02-23', 0, '+84987561123')
INSERT INTO SinhVien VALUES (53274, N'Đinh Thị Vy', '2011-02-24', 0, '+84492846223')
INSERT INTO SinhVien VALUES (53275, N'Bùi Hoàng Việt Anh', '2012-02-25', 1, '+84333988926')
GO 


--Tacgia(Matacgia, Tentacgia)
INSERT INTO Tacgia VALUES ('TH', N'Tố Hữu')
INSERT INTO Tacgia VALUES ('XQ', N'Xuân Quỳnh')
INSERT INTO Tacgia VALUES ('TRH', N'Trang Hạ')
INSERT INTO Tacgia VALUES ('PV', N'Nguyễn Phong Việt')
INSERT INTO Tacgia VALUES ('AK', N'An Khang')
INSERT INTO Tacgia VALUES ('NNT', N'Nguyễn Ngọc Thạch')
GO


--Sach(Masach, Tensach, NamXB, Matacgia, MaNXB)
INSERT INTO Sach(Masach,Tensach,NamXB,Matacgia,MaNXB,Soluong) VALUES ('MS7290', N'Mạng Máy Tính', '2014-12-10', 'TRH', 'NXB01', 182)
INSERT INTO Sach(Masach,Tensach,NamXB,Matacgia,MaNXB,Soluong) VALUES ('MS7291', N'Tin Học Đại Cương', '1998-08-07', 'TH', 'NXB01', 100)
INSERT INTO Sach(Masach,Tensach,NamXB,Matacgia,MaNXB,Soluong) VALUES ('MS7292', N'Hóa Học Đại Cương', '1996-02-19', 'XQ', 'NXB02', 200)
INSERT INTO Sach(Masach,Tensach,NamXB,Matacgia,MaNXB,Soluong) VALUES ('MS7293', N'Pháp Luật Đại Cương', '1995-07-02', 'TRH', 'NXB03', 1000)
INSERT INTO Sach(Masach,Tensach,NamXB,Matacgia,MaNXB,Soluong) VALUES ('MS7294', N'Triết Học Đại Cương', '1994-10-20', 'TH', 'NXB04', 1021)
INSERT INTO Sach(Masach,Tensach,NamXB,Matacgia,MaNXB,Soluong) VALUES ('MS7295', N'Khoa Học Đại Cương', '1993-03-29', 'TH', 'NXB05', 839)
INSERT INTO Sach(Masach,Tensach,NamXB,Matacgia,MaNXB,Soluong) VALUES ('MS7296', N'Hệ Cơ Sở Dữ Liệu', '1992-02-28', 'TH', 'NXB06', 302)
INSERT INTO Sach(Masach,Tensach,NamXB,Matacgia,MaNXB,Soluong) VALUES ('MS7297', N'CNXH và Khoa Học', '1991-10-12', 'TH', 'NXB07', 283)
INSERT INTO Sach(Masach,Tensach,NamXB,Matacgia,MaNXB,Soluong) VALUES ('MS7298', N'CTDL và Thuật Toán 1', '1990-08-01', 'TH', 'NXB08', 12)
INSERT INTO Sach(Masach,Tensach,NamXB,Matacgia,MaNXB,Soluong) VALUES ('MS7299', N'CTDL và Thuật Toán 2', '1997-09-11', 'TH', 'NXB09', 10)
INSERT INTO Sach(Masach,Tensach,NamXB,Matacgia,MaNXB,Soluong) VALUES ('MS7300', N'Giáo Dục Quốc Phòng 3', '1993-04-04', 'TH', 'NXB10', 0)
INSERT INTO Sach(Masach,Tensach,NamXB,Matacgia,MaNXB,Soluong) VALUES ('MS7301', N'Giáo Dục Quốc Phòng 2', '1992-04-18', 'TH', 'NXB11', 203)
INSERT INTO Sach(Masach,Tensach,NamXB,Matacgia,MaNXB,Soluong) VALUES ('MS7302', N'Giáo Dục Quốc Phòng 1', '1991-12-12', 'TH', 'NXB12', 932)
INSERT INTO Sach(Masach,Tensach,NamXB,Matacgia,MaNXB,Soluong) VALUES ('MS7303', N'Pháp Luật Đại Cương', '2010-12-10', 'TRH', 'NXB13', 5000)
GO

INSERT INTO Muon(Mamuon, MaSV, Masach, Ngaymuon) VALUES ('MMS02', 53265, 'MS7291', GETDATE())
INSERT INTO Muon(Mamuon, MaSV, Masach, Ngaymuon) VALUES ('MMS01', 53265, 'MS7291', GETDATE())
INSERT INTO Muon(Mamuon, MaSV, Masach, Ngaymuon) VALUES ('MMS01', 53265, 'MS7291', GETDATE())
INSERT INTO Muon(Mamuon, MaSV, Masach, Ngaymuon) VALUES ('MMS01', 53265, 'MS7291', GETDATE())
INSERT INTO Muon(Mamuon, MaSV, Masach, Ngaymuon) VALUES ('MMS01', 53265, 'MS7291', GETDATE())
INSERT INTO Muon(Mamuon, MaSV, Masach, Ngaymuon) VALUES ('MMS01', 53265, 'MS7292', GETDATE())
INSERT INTO Muon(Mamuon, MaSV, Masach, Ngaymuon) VALUES ('MMS03', 53267, 'MS7292', GETDATE())
INSERT INTO Muon(Mamuon, MaSV, Masach, Ngaymuon) VALUES ('MMS03', 53267, 'MS7295', GETDATE())
GO


--Trigger thêm dữ liệu cho Sach
CREATE TRIGGER check_insert_sach ON Sach AFTER INSERT
AS
BEGIN
DECLARE @soluong INT
DECLARE @conlai INT
SELECT @soluong = Sach.Soluong FROM Sach, Inserted WHERE Inserted.Masach = Sach.Masach
UPDATE Sach SET Sach.Conlai = @soluong FROM Sach,Inserted WHERE Inserted.Masach = Sach.Masach
END
GO

--Trigger thêm mới dữ liệu cho Muon
CREATE TRIGGER check_insert_muon ON Muon AFTER INSERT
AS
BEGIN
DECLARE @conlai INT
DECLARE @masach VARCHAR(50)
DECLARE @mamuon VARCHAR(50)
DECLARE @ngaymuon DATETIME
SELECT @conlai = Sach.Conlai FROM Sach, Inserted WHERE Inserted.Masach = Sach.Masach
SELECT @masach = Muon.Masach FROM Muon, Inserted WHERE Inserted.Masach = Muon.Masach
SELECT @mamuon = Muon.Mamuon FROM Muon, Inserted WHERE Inserted.Mamuon = Muon.Mamuon
SELECT @ngaymuon = CONVERT(DATE,(SELECT TOP 1 Ngaymuon FROM Muon WHERE MaMuon = @mamuon))

IF (SELECT COUNT(*) FROM (SELECT DISTINCT Muon.Mamuon,SinhVien.MaSV FROM Muon INNER JOIN SinhVien ON SinhVien.MaSV = Muon.MaSV INNER JOIN Sach ON Sach.Masach = Muon.Masach WHERE Mamuon = @mamuon) AS a) <= 1
    --Một mã mượn sách chỉ thuộc về 1 sinh viên duy nhất.
    AND (SELECT DISTINCT Tinhtrang FROM Muon WHERE Mamuon = @mamuon) != 1 AND (SELECT DATEDIFF(dayofyear,GETDATE(),@ngaymuon)) = 0
	--Kiểm tra MMS nếu đã được trả thì khi mượn thêm sách trong ngày hôm đó sẽ k được gộp chung vào MMS đó, sau 24h nếu mượn thêm sách thì sẽ được cấp MMS mới riêng biệt.
           BEGIN
              IF @conlai > 0
                    BEGIN
                       UPDATE Sach SET Conlai = Conlai - 1 FROM Sach,Inserted WHERE Inserted.Masach = Sach.Masach AND Sach.Masach = @masach
                    END
              ELSE
                     BEGIN
                       RAISERROR('ERROR QUERY', 16, 1)
                       ROLLBACK
                     END
           END
ELSE
              BEGIN
                RAISERROR('ERROR QUERY', 16, 1)
                ROLLBACK
              END
END
GO

CREATE TRIGGER check_update_Muon ON Muon AFTER UPDATE
AS
BEGIN
DECLARE @sosach INT
DECLARE @conlai INT
DECLARE @Hantrasach DATETIME
DECLARE @masach VARCHAR(50)
DECLARE @Tinhtrang BIT
DECLARE @Mamuon VARCHAR(50)
DECLARE @vonglap INT = 0
SELECT @Mamuon = Muon.Mamuon FROM Muon, Inserted WHERE Inserted.Mamuon = Muon.Mamuon
SELECT @Hantrasach = Muon.Hantrasach FROM Muon, Inserted WHERE Inserted.Hantrasach = Muon.Hantrasach
SELECT @Tinhtrang = Muon.Tinhtrang FROM Muon, Inserted WHERE Inserted.Tinhtrang = Muon.Tinhtrang
SELECT @sosach = Sach.Soluong FROM Sach, Inserted WHERE Inserted.Masach = Sach.Masach
SELECT @conlai = Sach.Conlai FROM Sach, Inserted WHERE Inserted.Masach = Sach.Masach

IF @conlai <= @sosach 
   AND @Tinhtrang = 1
   AND (SELECT TOP(1) ISNULL(Ngaytra, 0) FROM Muon WHERE MaMuon = @Mamuon) = '1900-01-01 00:00:00.000'  --kiểm tra nếu mã mượn sách này đã trả thì không trả nữa
          BEGIN
		    DECLARE Cursors CURSOR FOR
            SELECT Muon.Masach FROM Muon INNER JOIN SinhVien ON SinhVien.MaSV = Muon.MaSV INNER JOIN Sach ON Sach.Masach = Muon.Masach WHERE MaMuon = @Mamuon GROUP BY Muon.Masach
            Open Cursors
            FETCH NEXT FROM Cursors INTO @masach
            WHILE @@FETCH_STATUS = 0
            BEGIN
                WHILE @vonglap < (SELECT COUNT(*) FROM Muon WHERE Mamuon = @Mamuon AND Masach = @masach)
                BEGIN
				   UPDATE Sach SET Conlai = Conlai + 1 FROM Sach,Inserted WHERE Inserted.Masach = Sach.Masach AND Sach.Masach = @masach
				   UPDATE Muon SET Ngaytra = CONVERT(DATE,GETDATE()) FROM Muon, Inserted WHERE Inserted.Tinhtrang = Muon.Tinhtrang AND Muon.MaMuon = @Mamuon
                      IF DATEDIFF(dayofyear, GETDATE(), @Hantrasach) < 0
                          BEGIN
                             UPDATE Muon SET Tienquahan = DATEDIFF(dayofyear, GETDATE(), @Hantrasach) * (-100) WHERE Tienquahan = Muon.Tienquahan AND Muon.MaMuon = @Mamuon
                          END
                   SET @vonglap = @vonglap + 1
                END
				SET @vonglap = 0
                FETCH NEXT FROM Cursors INTO @masach
            END
            CLOSE Cursors
            DEALLOCATE Cursors
          END
ELSE
          BEGIN
           RAISERROR('ERROR QUERY', 16, 1)
		   ROLLBACK
          END
END
GO

DELETE FROM Muon
DELETE FROM Sach

--Hiển thị tổng quan thông tin các hóa đơn mượn sách
SELECT Muon.Mamuon,Muon.MaSV,HoTen,NgaySinh,GioiTinh,SDT,Muon.Masach,Tensach,MaNXB,NamXB,Matacgia,Tinhtrang,Tienquahan,CONVERT(DATE,Ngaymuon) AS Ngaymuon, CONVERT(DATE,Hantrasach) AS Hantrasach, CONVERT(DATE,Ngaytra) AS Ngaytra, COUNT(*) 
AS Total FROM Muon INNER JOIN SinhVien ON SinhVien.MaSV = Muon.MaSV INNER JOIN Sach ON Sach.Masach = Muon.Masach
GROUP BY Mamuon,Muon.MaSV,HoTen,NgaySinh,GioiTinh,SDT,Muon.Masach,Tensach,MaNXB,NamXB,Matacgia,Tinhtrang,Tienquahan,CONVERT(DATE,Ngaymuon), CONVERT(DATE,Hantrasach), CONVERT(DATE,Ngaytra)


--Trả sách dựa trên mã mượn sách và cập nhật lại số lượng sách, tính toán số tiền phải trả khi mượn quá thời hạn
UPDATE Muon SET Tinhtrang = 1 WHERE Mamuon = 'MMS03'

--Hiển thị toàn bộ thông tin mượn sách cua thư viện
SELECT Mamuon,Muon.MaSV,HoTen,NgaySinh,GioiTinh,SDT,Muon.Masach,Tensach,MaNXB,TenNXB,Diachi,NamXB,Matacgia,Tentacgia,CONVERT(DATE,Ngaymuon) AS Ngaymuon, CONVERT(DATE,Hantrasach) AS Hantrasach FROM Muon
INNER JOIN SinhVien ON SinhVien.MaSV = Muon.MaSV
INNER JOIN(SELECT Masach,Tensach,NamXB,Soluong,Conlai,Tentacgia,TenNXB,Diachi,Tacgia.Matacgia,NXB.MaNXB FROM Sach
INNER JOIN Tacgia ON Tacgia.Matacgia = Sach.Matacgia 
INNER JOIN NXB ON NXB.MaNXB = Sach.MaNXB) AS this ON this.Masach = Muon.Masach WHERE SinhVien.MaSV = '53265' AND (SELECT YEAR(Ngaymuon)) = 2022

--Liệt kê các đầu sách theo độ thịnh hành
SELECT Sach.Masach,Sach.Tensach,Sach.Matacgia,Tentacgia,Sach.MaNXB,TenNXB,Sach.NamXB,COUNT(*) AS Solanmuon FROM Muon
INNER JOIN Sach ON Sach.Masach = Muon.masach
INNER JOIN(SELECT Masach,Tensach,NamXB,Soluong,Conlai,Tentacgia,TenNXB,Diachi,Tacgia.Matacgia,NXB.MaNXB FROM Sach
INNER JOIN Tacgia ON Tacgia.Matacgia = Sach.Matacgia
INNER JOIN NXB ON NXB.MaNXB = Sach.MaNXB) AS this ON this.Masach = Muon.Masach
GROUP BY Sach.Masach,Sach.Tensach,Sach.Matacgia,Tentacgia,Sach.MaNXB,TenNXB,Sach.NamXB ORDER BY Solanmuon DESC

--Liệt kê các đầu sách từ trước tới giờ chưa từng được mượn
SELECT Muon.Masach,Tensach,NamXB,Matacgia,MaNXB,Soluong,Conlai,CONVERT(DATE,Ngaymuon) AS Ngaymuon FROM Muon RIGHT JOIN Sach ON Sach.Masach = Muon.Masach WHERE (SELECT ISNULL(Ngaymuon, 0)) = '1900-01-01 00:00:00.000'