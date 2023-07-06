use QLDeTai;
go

-- a. In ra câu chào “Hello World !!!”.
CREATE PROCEDURE sp_HelloWorld
as
begin
	print 'Hello World !!!'
end
go

exec sp_HelloWord
go

-- b. In ra tổng 2 số.
CREATE PROCEDURE sp_Tong2So @a int, @b int
as
begin
	declare @sum int
	set @sum = @a + @b
	print @sum
end
go

exec sp_Tong2So 2,3
go

-- c. Tính tổng 2 số (sử dụng biến output để lưu kết quả trả về).
CREATE PROCEDURE sp_OutTong2So @a int, @b int, @sum int out
as
begin
	set @sum = @a + @b
end
go

declare @sum int
exec sp_OutTong2So 10,15, @sum out
print @sum
go

-- d. In ra tổng 3 số (Sử dụng lại stored procedure Tính tổng 2 số).
CREATE PROCEDURE sp_Tong3So @a int, @b int, @c int, @sum int out
as
begin
	exec sp_OutTong2So @a,@b,@sum out
	exec sp_OutTong2So @c, @sum, @sum out
end
go

declare @sum int
exec sp_Tong3So 10,15, 20, @sum out
print @sum
go

-- e. In ra tổng các số nguyên từ m đến n.
CREATE PROCEDURE sp_TongMN @m int, @n int, @sum int out
as
begin
	declare @i int
	set @i = @m
	set @sum = 0
	while(@i<=@n)
	begin
		exec sp_OutTong2So @i, @sum, @sum out
		set @i = @i + 1
	end
end
go

declare @sum int
exec sp_TongMN 1,10, @sum out
print @sum
go

-- f. Kiểm tra 1 số nguyên có phải là số nguyên tố hay không.
create procedure sp_ktSoNguyenTo @a int, @res int out
as
begin
	set @res = 1
	if(@a<=1)
	begin
		set @res = 0
		return 
	end
	declare @i int
	set @i = 2
	while(@i<= sqrt(@a))
	begin
		if(@a % @i =0)
		begin
			set @res = 0
			return
		end
		set @i = @i+1
	end
end
go

declare @res int
exec sp_ktSoNguyenTo 131, @res out
if(@res = 0) print N'Đây không là số nguyên tố'
else print N' Đây là số nguyên tố'
go

-- g. In ra tổng các số nguyên tố trong đoạn m, n.
CREATE PROCEDURE sp_TongNguyenToMN @m int, @n int, @sum int out
as
begin
	declare @i int
	declare @tong int
	set @tong = 0
	set @i = @m
	declare @flag int
	while(@i<=@n)
	begin
		exec sp_ktSoNguyenTo @i, @flag out
		if(@flag =1 )
		begin
			set @tong = @tong + @i
		end
		set @i = @i + 1
	end
	set @sum = @tong
end
go

declare @sum int
exec sp_TongNguyenToMN 1,10, @sum out
print @sum

-- h. Tính ước chung lớn nhất của 2 số nguyên.
CREATE PROCEDURE sp_UCNLN @a int, @b int, @res int out
as
begin
	while(@a * @b != 0)
	begin
		if(@a>@b)
			set @a = @a % @b
		else 
			set @b = @b % @a
	end
	set @res = @a + @b
end
go 

declare @res int
exec sp_UCLN 42, 63, @res out
print @res
go

--i. Tính bội chung nhỏ nhất của 2 số nguyên.
CREATE PROCEDURE sp_BCNN @a int, @b int, @res int out
as
begin
	declare @ucln int
	exec sp_UCLN @a, @b, @ucln out
	set @res = (@a * @b) / @ucln
end
go 

declare @res int
exec sp_BCNN 5, 12, @res out
print @res
go

-- j. Xuất ra toàn bộ danh sách giáo viên.
CREATE PROCEDURE sp_DSGiaoVien
as
begin
	select GV.*
	from GIAOVIEN GV
end
go

exec sp_DSGiaoVien
go

-- k. Tính số lượng đề tài mà một giáo viên đang thực hiện.
CREATE PROCEDURE sp_SLDeTaiThucHien( @MAGV char(3))
as
begin
	select GV.MAGV, count(distinct TG.MADT) as SLDeTaiThucHien
	from GIAOVIEN GV left join THAMGIADT TG on (TG.MAGV = GV.MAGV)
	where GV.MAGV = @MAGV
	group by GV.MAGV
end
go

exec sp_SLDeTaiThucHien '003'
go

-- l. In thông tin chi tiết của một giáo viên(sử dụng lệnh print): Thông tin cá nhân, Số lượng đề
-- tài tham gia, Số lượng thân nhân của giáo viên đó.
CREATE PROCEDURE sp_TTChiTiet (@maGV char(3))
as
begin
	declare @tenGV nvarchar(50), @ngaysinh date, @luong float, @maBM varchar(5), @slDeTai int, @slThanNhan int, @phai nvarchar(10), @gvql char(3)

	set @tenGV = (select GV.HOTEN from GIAOVIEN GV where GV.MAGV = @maGV)
	set @luong = (select GV.LUONG from GIAOVIEN GV where GV.MAGV = @maGV) 
	set @phai = (select GV.PHAI from GIAOVIEN GV where GV.MAGV = @maGV) 
	set @ngaysinh = (select GV.NGAYSINH from GIAOVIEN GV where GV.MAGV = @maGV) 
	set @maBM = (select GV.MABM from GIAOVIEN GV where GV.MAGV = @maGV) 
	set @gvql = (select GV.GVQLCM from GIAOVIEN GV where GV.MAGV = @maGV) 
	set @slDeTai = (select count (distinct MADT) from THAMGIADT where THAMGIADT.MAGV = @maGV group by THAMGIADT.MAGV)
	set @slThanNhan = (select count (*) from NGUOITHAN where NGUOITHAN.MAGV = @maGV group by NGUOITHAN.MAGV)
	
	print N'Mã giáo viên: ' + @maGV
	print N'Tên giáo viên: ' + @tenGV
	print concat ( N'Lương: ', @luong)
	print concat ( N'Ngày sinh: ', @ngaysinh)
	print N'Mã bộ môn: ' + @maBM
	print concat ( N'Giáo viên quản lý chuyên môn: ', @gvql)
	print concat ( N'Số lượng đề tài tham gia: ', @slDeTai)
	print concat ( N'Số lượng thân nhân: ', @slThanNhan)

end 
go

exec sp_TTChiTiet '005'
go

-- m. Kiểm tra xem một giáo viên có tồn tại hay không (dựa vào MAGV).
CREATE PROCEDURE sp_KiemTraGiaoVienTonTai (@maGV char(3))
as
begin
	if(@maGV IN ( select GIAOVIEN.MAGV
					from GIAOVIEN) )
		print(N'Giáo viên tồn tại')
	else print (N'Giáo viên không tồn tại')
end 
go

exec sp_KiemTraGiaoVienTonTai '003'
go

-- n. Kiểm tra quy định của một giáo viên: Chỉ được thực hiện các đề tài mà bộ môn của giáo viên đó làm chủ nhiệm.
CREATE PROCEDURE sp_KiemTraQuyDinhGV (@maGV char(3), @res int out)
as
begin
	if(@maGV IN (select TG.MAGV 
				from GIAOVIEN GV join THAMGIADT TG on (TG.MAGV = GV.MAGV) 
					join DETAI DT on (DT.MADT = TG.MADT)
					join GIAOVIEN GVQL on (GVQL.MAGV = DT.GVCNDT)
				where GVQL.MABM = GV.MABM
				group by TG.MAGV
				having count (*) = (select count(*)
									from THAMGIADT TG2
									where TG2.MAGV = TG.MAGV
									group by TG2.MAGV) ))
		set @res = 1
	else set @res = 0
end
go

declare @res int
exec sp_KiemTraQuyDinhGV '001', @res out
if(@res = 1) 
	print(N'Giáo viên đáp ứng đúng quy định')
else 
	print(N'Giáo viên không đáp ứng đúng quy định')
go

-- o. Thực hiện thêm một phân công cho giáo viên thực hiện một công việc của đề tài:
-- Kiểm tra thông tin đầu vào hợp lệ: giáo viên phải tồn tại, công việc phải tồn tại, thời gian tham gia phải >0
-- Kiểm tra quy định ở câu n.
CREATE PROCEDURE sp_PhanCongGiaoVien (@maGV char(3), @maDT char(3), @soTT int , @res int out)
as
begin
	declare @tmpRes int
	if(@maGV in (select GIAOVIEN.MAGV from GIAOVIEN)
	and	exists (select * 
					from CONGVIEC CV 
					where CV.MADT = @maDT and CV.SOTT = @soTT and DATEDIFF(d,CV.NGAYBD,CV.NGAYKT)>0))
	begin
		exec sp_KiemTraQuyDinhGV @maGV , @tmpRes out
		if(@tmpRes = 1)
			set @res = 1
		else set @res = 0
	end 
	else set @res = 0
end
go

declare @res int
exec sp_PhanCongGiaoVien '003', '002', 1, @res out
if(@res = 1) 
	print(N'Phân công thành công')
else 
	print(N'Không thể phân công')
go

-- p. Thực hiện xoá một giáo viên theo mã. Nếu giáo viên có thông tin liên quan (Có thân nhân, có làm đề tài, …) thì báo lỗi.
CREATE PROCEDURE sp_XoaGiaoVien (@maGV char(3))
as
begin
	if(@maGV in (select THAMGIADT.MAGV from THAMGIADT) 
	or @maGV in (select NGUOITHAN.MAGV from NGUOITHAN) 
	or @maGV in (select DETAI.GVCNDT from DETAI)
	or @maGV in (select GIAOVIEN.GVQLCM from GIAOVIEN)
	or @maGV in (select BOMON.TRUONGBM from BOMON)
	or @maGV in (select KHOA.TRUONGKHOA from KHOA)
	or @maGV in (select GV_DT.MAGV from GV_DT))
		print(N'Không thể xóa giáo viên')
	else if(@maGV not in (select GIAOVIEN.MAGV from GIAOVIEN))
		print(N'Giáo viên không tồn tại')
	else
	begin
		print(N'Giáo viên đã được xóa')
		delete from GIAOVIEN where GIAOVIEN.MAGV = @maGV
	end

end
go

exec sp_XoaGiaoVien '011'
go

-- q. In ra danh sách giáo viên của một bộ môn nào đó cùng với số lượng đề tài mà giáo viên tham gia, số thân nhân, số giáo viên mà giáo viên đó quản lý nếu có,
CREATE PROCEDURE sp_DSGiaoVienBoMon (@maBM nvarchar(5))
as
begin
	select T1.MAGV, T1.HOTEN, T2.SLDeTai, T1.SLThanNhan, T3.SLGVQuanLy
	from (select GV1.MAGV, GV1.HOTEN, count(*) as SLThanNhan
			from GIAOVIEN GV1 left join NGUOITHAN NT1 on (NT1.MAGV = GV1.MAGV)
			where GV1.MABM = @maBM
			group by GV1.MAGV, GV1.HOTEN) as T1 
		join
		( select GV2.MAGV, GV2.HOTEN, count(distinct TG2.MADT) as SLDeTai
			from GIAOVIEN GV2 left join THAMGIADT TG2 on (TG2.MAGV = GV2.MAGV)
			where GV2.MABM = @maBM
			group by GV2.MAGV, GV2.HOTEN ) as T2 on (T2.MAGV = T1.MAGV) 
		join
		( select GVQL.MAGV, GVQL.HOTEN, count(GV3.MAGV) as SLGVQuanLy
			from GIAOVIEN GV3 right join GIAOVIEN GVQL on (GVQL.MAGV = GV3.GVQLCM)
			where GVQL.MABM = @maBM
			group by GVQL.MAGV, GVQL.HOTEN) as T3 on (T3.MAGV = T2.MAGV)
end
go

exec sp_DSGiaoVienBoMon 'HTTT'
go

--r. Kiểm tra quy định của 2 giáo viên a, b: Nếu a là trưởng bộ môn c của b thì lương của a phải cao hơn lương của b. (a, b: mã giáo viên)
CREATE PROCEDURE sp_KT2GiaoVien (@gv1 char(3), @gv2 char(3), @res int out)
as
begin
	set @res = -1
	if( @gv1 = (select BM1.TRUONGBM
				from GIAOVIEN GV2 join BOMON BM1 on (BM1.MABM = GV2.MABM)
				where GV2.MAGV = @gv2))
	begin
		declare @luong1 float, @luong2 float
		set @luong1 = (select GIAOVIEN.LUONG
						from GIAOVIEN
						where GIAOVIEN.MAGV = @gv1)

		set @luong2 = (select GIAOVIEN.LUONG
						from GIAOVIEN
						where GIAOVIEN.MAGV = @gv2)
		if(@luong1 > @luong2)
			set @res = 1
		else set @res = 0
	end
end
go

declare @res int
exec sp_KT2GiaoVien '007','010', @res out
if(@res = 0)
	print(N'Không đúng quy định')
else if(@res= 1)
	print(N'Đúng quy định')
else print(N'Không có mối liên hệ như yêu cầu giữa hai giáo viên')
go

--s. Thêm một giáo viên: Kiểm tra các quy định: Không trùng tên, tuổi > 18,lương > 0
CREATE PROCEDURE sp_ThemGiaoVien (@maGV char(3), @tenGV nvarchar(50), @ngaysinh date, @luong float)
as
begin
	if(@tenGV not in (select GV.HOTEN from GIAOVIEN GV) 
	and (year(GETDATE()) - year(@ngaysinh) > 18)
	and @luong >0)
	begin
		insert into GIAOVIEN(MAGV, HOTEN, NGAYSINH, LUONG) values(@maGV,@tenGV, @ngaysinh, @luong)
		print N'Thêm giáo viên thành công'
	end 
	else print N'Giáo viên cần thêm không hợp lệ'
end
go

exec sp_ThemGiaoVien '011', N'Lý Hòa Hà', '12/12/2004', 12.200
go

--t. Mã giáo viên được xác định tự động theo quy tắc: Nếu đã có giáo viên 001, 002, 003 thì MAGV của giáo viên mới sẽ là 004. Nếu đã có giáo viên 001,
-- 002, 005 thì MAGV của giáo viên mới là 003.
CREATE PROCEDURE sp_XDMaGV 
as
begin
	declare @i int
	declare @newMaGV varchar (3)
	set @i = 1
	while(@i>0)
	begin
		if(@i<10)
			set @newMaGV = concat('00',@i)
		else set @newMaGV = concat('0',@i)
		if(@newMaGV not in (select GIAOVIEN.MAGV from GIAOVIEN))
		begin	
			print N'Đã thêm mã giáo viên'
			insert into GIAOVIEN(MAGV) values (@newMaGV)
			return
		end else
		set @i = @i +1
	end
end
go

exec sp_XDMaGV
go
