CREATE DATABASE QLPhuong_1
GO

USE QLPhuong_1
GO

CREATE TABLE Phuong (
	IDPhuong VARCHAR(4),
	IDChuTich VARCHAR(4),
	TenPhuong NVARCHAR(20),
	PRIMARY KEY (IDPhuong)
)

CREATE TABLE KhuPho (
	IDKhuPho INT, 
	IDTrKhuPho VARCHAR(4),
	IDPhuong VARCHAR(4),
	PRIMARY KEY (IDKhuPho, IDPhuong)
)

CREATE TABLE Dan (
	IDDan VARCHAR(4),
	IDKhuPho INT,
	Ten NVARCHAR(20),
	TinhTrang NVARCHAR(50),
	CHECK (TinhTrang IN (N'Còn sống', N'Qua đời')),
	IDPhuong VARCHAR(4),
	PRIMARY KEY (IDDan, IDPhuong)
)

-- Foreign key
ALTER TABLE Phuong
	ADD CONSTRAINT FK_Phuong_Dan
	FOREIGN KEY (IDChuTich, IDPhuong)
	REFERENCES Dan(IDDan, IDPhuong)

ALTER TABLE KhuPho
	ADD CONSTRAINT FK_KhuPho_Phuong
	FOREIGN KEY (IDPhuong)
	REFERENCES Phuong(IDPhuong)

ALTER TABLE KhuPho
	ADD CONSTRAINT FK_KhuPho_Dan
	FOREIGN KEY(IDTrKhuPho, IDPhuong)
	REFERENCES DAN(IDDAN, IDPhuong)

ALTER TABLE Dan
	ADD CONSTRAINT FK_Dan_KhuPho
	FOREIGN KEY (IDKhuPho, IDPhuong)
	REFERENCES KhuPho(IDKhuPho, IDPhuong)

ALTER TABLE Dan
	ADD CONSTRAINT FK_Dan_Phuong 
	FOREIGN KEY (IDPhuong)
	REFERENCES Phuong(IDPhuong)

-- input data
-- Phuong
INSERT INTO Phuong(IDPhuong, TenPhuong) VALUES ('PHA', N'Phường A' )
INSERT INTO Phuong(IDPhuong, TenPhuong) VALUES ('PHB', N'Phường B' )
INSERT INTO Phuong(IDPhuong, TenPhuong) VALUES ('PHC', N'Phường C' )

-- KhuPho
INSERT INTO KhuPho(IDPhuong, IDKhuPho) VALUES ('PHA', 1 )
INSERT INTO KhuPho(IDPhuong, IDKhuPho) VALUES ('PHA', 2 )
INSERT INTO KhuPho(IDPhuong, IDKhuPho) VALUES ('PHB', 1 )
INSERT INTO KhuPho(IDPhuong, IDKhuPho) VALUES ('PHB', 2 )

-- Dan
INSERT INTO Dan(IDPhuong, IDKhuPho, Ten, TinhTrang, IDDan) VALUES ('PHA', 1, N'Nguyễn Văn A', N'Còn sống', 'NVA')
INSERT INTO Dan(IDPhuong, IDKhuPho, Ten, TinhTrang, IDDan) VALUES ('PHA', 1, N'Nguyễn Văn B', N'Còn sống', 'NVB')
INSERT INTO Dan(IDPhuong, IDKhuPho, Ten, TinhTrang, IDDan) VALUES ('PHA', 2, N'Nguyễn Văn C', N'Còn sống', 'NVC')
INSERT INTO Dan(IDPhuong, IDKhuPho, Ten, TinhTrang, IDDan) VALUES ('PHA', 2, N'Nguyễn Văn D', N'Qua đời', 'NVD')
INSERT INTO Dan(IDPhuong, IDKhuPho, Ten, TinhTrang, IDDan) VALUES ('PHB', 1, N'Nguyễn Văn E', N'Còn sống', 'NVE')
INSERT INTO Dan(IDPhuong, IDKhuPho, Ten, TinhTrang, IDDan) VALUES ('PHB', 1, N'Nguyễn Văn F', N'Qua đời', 'NVF')
INSERT INTO Dan(IDPhuong, IDKhuPho, Ten, TinhTrang, IDDan) VALUES ('PHB', 2, N'Nguyễn Văn G', N'Qua đời', 'NVG')
INSERT INTO Dan(IDPhuong, IDKhuPho, Ten, TinhTrang, IDDan) VALUES ('PHB', 2, N'Nguyễn Văn H', N'Qua đời', 'NVH')

-- addition
UPDATE Phuong SET IDChuTich = 'NVA' WHERE IDPhuong = 'PHA'
UPDATE Phuong SET IDChuTich = 'NVE' WHERE IDPhuong = 'PHB'
UPDATE Phuong SET IDChuTich = 'NVC' WHERE IDPhuong = NULL

UPDATE KhuPho SET IDTrKhuPho = 'NVA' WHERE (IDKhuPho = 1 AND IDPhuong = 'PHA')
UPDATE KhuPho SET IDTrKhuPho = 'NVC' WHERE (IDKhuPho = 2 AND IDPhuong = 'PHA')
UPDATE KhuPho SET IDTrKhuPho = 'NVE' WHERE (IDKhuPho = 1 AND IDPhuong = 'PHB')
UPDATE KhuPho SET IDTrKhuPho = 'NVG' WHERE (IDKhuPho = 2 AND IDPhuong = 'PHB')










