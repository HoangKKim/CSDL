USE QLKHOHANG
GO

-- 1
select HH.MaHangHoa, HH.TenHangHoa
from HangHoa HH join  ChiTietBienNhan CTBN on (CTBN.MaHangHoa = HH.MaHangHoa)
where CTBN.SoLuong <0 and CTBN.SoLuong < ALL (select SoLuong
												from ChiTietBienNhan
												where ChiTietBienNhan.MaHangHoa = N'NCĐ001' and ChiTietBienNhan.SoLuong <0)

--2
-- bị chia: hàng hóa của chủng loại NCĐ
select NV.MaNhanVien, NV.TenNhanVien
from NhanVien NV join PhieuBienNhan PBN on (PBN.MaNhanVien = NV.MaNhanVien)
	join ChiTietBienNhan CTBN on (CTBN.MaBienNhan = PBN.MaBienNhan)
	join HangHoa HH on (HH.MaHangHoa = CTBN.MaHangHoa)
where HH.ChungLoai = N'NCĐ' and PBN.LoaiPhieu = N'Nhập'
	and NOT EXISTS (select HH2.MaHangHoa
					from HangHoa HH2
					where HH2.ChungLoai  = N'NCĐ'
				except
					select CTBN2.MaHangHoa
					from PhieuBienNhan PBN2 join ChiTietBienNhan CTBN2 on (CTBN2.MaBienNhan = PBN2.MaBienNhan)
					where PBN2.MaNhanVien = NV.MaNhanVien)

-- 3
create procedure sp_ThongKe_NhanVien_TSLXuat (@MaNhanVien nchar(8))
as
begin
	--b1: kiểm tra MNV khác null và có tồn tại
	if(@MaNhanVien is NULL or @MaNhanVien not in (select MaNhanVien from NhanVien))
		return 0

	-- b2: Tính tổng số lượng hàng hóa được xuất từ nhân viên này
	declare @TongSLHangHoaXuat int
	select @TongSLHangHoaXuat = sum(CTBN.SoLuong)
		from ChiTietBienNhan CTBN join PhieuBienNhan PBN on (PBN.MaBienNhan = CTBN.MaBienNhan)
		where PBN.MaNhanVien = @MaNhanVien and CTBN.SoLuong <0 

	-- b3: 
	if(@TongSLHangHoaXuat = (select TSLXuat from NhanVien where MaNhanVien = @MaNhanVien))
		return 0
	else 
	begin
		update NhanVien set TSLXuat = @TongSLHangHoaXuat where MaNhanVien = @MaNhanVien
		return 1
	end												
end
go

exec sp_ThongKe_NhanVien_TSLXuat ('001')
go

-- 4
create procedure sp_ThongKe_All_NhanVien_TSLXuat 
as
begin
	-- đếm số lượng nhân viên
	declare @SLNhanVien int
	select @SLNhanVien = count(MaNhanVien)
		from NhanVien

	-- lấy bảng nhân viên
	declare @Table_NV TABLE (STT int,MaNV nchar(8))
	insert into @Table_NV
		select ROW_NUMBER() OVER ( ORDER BY MaNhanVien asc) AS rownumber, MaNhanVien
		from NhanVien

	declare @i int, @SLNhanVienCapNhat int, @MaNV nchar(8), @tmp int
	set @i = 1
	set @SLNhanVienCapNhat = 0
	
	while(@i<=@SLNhanVien)
	begin
		select @MaNV = MaNV
		from @Table_NV
		where @i = STT

		exec @tmp = sp_ThongKe_NhanVien_TSLXuat @MaNV
		if(@tmp =1)
			set @SLNhanVienCapNhat = @SLNhanVienCapNhat +1

		set @i = @i+1
	end
	print concat (N'Số lượng nhân viên được cập nhật trong thống kê này: ',@SLNhanVienCapNhat)
end

exec sp_ThongKe_All_NhanVien_TSLXuat 
go
