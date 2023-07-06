create database QLPhong;
go

use QLPhong;
go

create table PHONG(
	MaPhong varchar(10) PRIMARY KEY,
	TinhTrang nvarchar(20),
	LoaiPhong nvarchar(20),
	DonGia float
)

create table KHACH(
	MaKH varchar(10) PRIMARY KEY,
	HoTen nvarchar(50),
	DiaChi nvarchar(50),
	DienThoai varchar(20)
)

create table DATPHONG(
	MaDatPhong int PRIMARY KEY,
	MaKH varchar(10),
	MaPhong varchar(10),
	NgayDP date,
	NgayTra date,
	ThanhTien float
)

ALTER TABLE DATPHONG 
  ADD CONSTRAINT FK_DATPHONG_KHACH 
  FOREIGN KEY (MaKH)
REFERENCES KHACH(MaKH)

ALTER TABLE DATPHONG 
  ADD CONSTRAINT FK_DATPHONG_PHONG 
  FOREIGN KEY (MaPhong)
REFERENCES PHONG(MaPhong)

insert into PHONG values
('P1', N'Rảnh', 'L1', 80000),
('P2', N'Bận', 'L2', 120000),
('P3', N'Rảnh', 'L1', 100000),
('P4', N'Rảnh', 'L4', 220000)

insert into KHACH values
('K1', N'Nguyễn Văn An', 'DC1', '1234567890'),
('K2', N'Nguyễn Văn Bình', 'DC1', '1234567890'),
('K3', N'Nguyễn Văn Cường', 'DC1', '1234567890'),
('K4', N'Nguyễn Văn Dũng', 'DC1', '1234567890')

insert into DATPHONG values
(1, 'K3', 'P2', '2023-04-15', NULL, NULL)

create procedure spDatPhong (@makh varchar(10), @maphong varchar(10), @ngaydat date)
as
begin
-- mã đặt phòng
	declare @madatphong int
	set @madatphong = ( select max(MaDatPhong) from DATPHONG ) 
	if(@madatphong is NULL)
		set @madatphong = 1
	else set @madatphong = @madatphong + 1

-- kiểm tra các yêu cầu
	declare @flag int
	set @flag = 1
	-- kiểm tra mã khách hàng
	if(@makh not in (select MaKH from KHACH))
		set @flag = 0 
	-- kiểm tra mã phòng
	if(@maphong not in (select MaPhong from PHONG))
		set @flag = 0
	-- kiểm tra tình trạng phòng
	if(N'Bận' = (select TinhTrang from PHONG where @maphong = MaPhong))
		set @flag = 0
	-- kết luận
	if(@flag = 1)
	begin
		print N'Đặt phòng thành công'
		insert into DATPHONG(MaDatPhong, MaKH, MaPhong, NgayDP ) values
		(@madatphong, @makh, @maphong, @ngaydat)
		update PHONG set TinhTrang = N'Bận' where MaPhong = @maphong
	end 
	else print N'Thông tin đặt phòng không hợp lệ'	
end
go

exec spDatPhong 'K1', 'P4', '2023-04-04'
go

create procedure spTraPhong (@madp varchar(10), @makh varchar(10))
as
begin
	declare @flag int
	set @flag = 1
-- kiểm tra mã đặt phòng và mã khách hàng
	if(not exists (select *
					from DATPHONG
					where @madp = MaDatPhong and @makh = MaKH))
		set @flag = 0

	if(@flag = 1)
	begin
		-- lấy thông tin phòng
		declare @maphong  varchar(10)
		set @maphong = (select MaPhong from DATPHONG where MaDatPhong = @madp)
	
		declare @dongia float
		set @dongia = (select DonGia from PHONG where @maphong = MaPhong)
	
		-- ngày trả phòng
		declare @ngaytraphong date
		set @ngaytraphong = GETDATE()
	
		-- tính số ngày mượn
		declare @songaymuon int
		set @songaymuon = DATEDIFF(d,(select NGAYDP from DATPHONG where @madp = MaDatPhong),@ngaytraphong)
		
		-- tính tiền thanh toán
		declare @tienthanhtoan float
		set @tienthanhtoan = @songaymuon * @dongia

		-- cập nhật thông tin trả phòng 
		update DATPHONG set NgayTra = @ngaytraphong, ThanhTien = @tienthanhtoan where ( @madp = MaDatPhong and @makh = MaKH )
		
		-- cập nhật tình trạng phòng
		update PHONG set TinhTrang = N'Rảnh' where MaPhong = @maphong
		
		print N'Trả phòng thành công'
	end
	else print N'Thông tin trả phòng không hợp lệ'
end
go

exec spTraPhong 1,'K3'
go


