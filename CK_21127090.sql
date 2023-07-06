use QLDeTai
go

-- 1. Cho biết những Bộ Môn nào có nhiều Giáo Viên nhất có Số Điện Thoại. --> đếm số lượng theo mã giáo viênselect GV.MABM, BM.TENBMfrom GV_DT DT join GIAOVIEN GV on (GV.MAGV = DT.MAGV)	join BOMON BM on (GV.MABM = BM.MABM)group by GV.MABM, BM.TENBMhaving count(*) = (select max(T.SLDienThoai)					from ( select GV.MABM, count(*) as SLDienThoai							from GV_DT DT join GIAOVIEN GV on (GV.MAGV = DT.MAGV)							group by GV.MABM ) as T)-- 2. Cho biết những Giáo Viên nào có tham gia tất cả các Đề Tài của Giáo Viên “Trương Nam Sơn” làm chủ nhiệm đề tài.-- bị chia: đề tài do Trương Nam Sơn chủ nhiệmselect distinct GV.MAGV, GV.HOTENfrom GIAOVIEN GV join THAMGIADT TG on (TG.MAGV = GV.MAGV)	join DETAI DT on (DT.MADT = TG.MADT)	join GIAOVIEN GVQL on (DT.GVCNDT = GVQL.MAGV)where  GVQL.HOTEN = N'Trương Nam Sơn' and	NOT EXISTS ( select DT2.MADT					from DETAI DT2 join GIAOVIEN GV2 on (DT2.GVCNDT = GV2.MAGV)					where GV2.HOTEN = N'Trương Nam Sơn'				except 					select TG2.MADT					from THAMGIADT TG2					where TG2.MAGV = TG.MAGV)-- 3. Cho biết những Giáo Viên nào mà tất cả các Đề Tài mình tham gia đều có Kinh Phí trên 80 triệu.-- c2: lấy các gv tham gia đề tài mà NOT IN các( gv tham gia đề tài có kinh phí dưới 80)-- bị chia : các đề tài kinh phí trên 80trselect GV.HOTEN, GV.MAGVfrom GIAOVIEN GV join THAMGIADT TG on (TG.MAGV = GV.MAGV)	join DETAI DT on (DT.MADT = TG.MADT)group by GV.HOTEN, GV.MAGVhaving count(distinct TG.MADT) = (select count(distinct DT2.MADT)									from DETAI DT2 join THAMGIADT TG2 on (TG2.MADT = DT2.MADT)									where TG2.MAGV = GV.MAGV and DT2.KINHPHI >80									group by TG2.MAGV)-- 4create procedure spHienThi_DSGV_ThamGia_DeTai (@tu_ngay date, @den_ngay date)asbegin-- kiểm tra hợp lệ	if(DATEDIFF(d,@tu_ngay,@den_ngay)<0)	begin	-- lệnh RAISERORR		raiserror (N'Ngày không hợp lệ', 16,1)		return	end-- xác định các đề tài có thời gian thực hiện nằm trong khoảng thời gian yêu cầu	-- khai báo bảng dt	declare @dt_table table (MADT char(3), TENDT nvarchar(50), CAPQL nvarchar(20), KINHPHI float, NGAYBD date, NGAYKT date, MACD nvarchar(5),GVCNDT char(3));		insert into @dt_table 		select DT.MADT, DT.TENDT, DT.CAPQL, DT.KINHPHI, DT.NGAYBD, DT.NGAYKT, DT.MACD, DT.GVCNDT		from DETAI DT		where DATEDIFF(d,DT.NGAYBD,@tu_ngay)>0 and DATEDIFF(d,@den_ngay,DT.NGAYKT)<0		order by NGAYBD desc, NGAYKT desc-- xác định số dòng dữ liệu	declare @count int	select @count = count(*)					from @dt_table	if(@count>0)	-- hoặc lệnh cast(biến, keiẻu dữ liệu)		print concat (N'Số lượng đề tài thỏa yêu cầu: ',@count)	else 	begin		--print concat (N'Không có đề tài nào thỏa yêu cầu: ',@count)		return	end	-- mặc định sẽ lấy dòng cuối cùng khi select	-- truy vấn max, min, all, only, sp
-- Xuất thông tin
--Xuất tất cả thông tin của đề tài đó kèm theo Số lượng GV tham gia đề tài đó (bỏ qua GVCNDT nếu có).
	DECLARE @MaDT char(3)
	WHILE ( @count > 0 ) -- lap cho den khi moi dong du lieu trong @vtable duoc xu ly het
	BEGIN
		-- Chon ra dong du lieu dau tien trong @vtable
		SELECT TOP 1 @MaDT = dt.MADT, count(TG.MAGV)
			FROM @dt_table dt join THAMGIADT TG on (TG.MADT = dt.MADT)
			group by dt.MADT;

		-- Thuc hien xu ly voi cac thong tin duoc chon ra
		print @MaGV + ' : ' + @TenGV + ' @ ' + @MaBM;

		-- Xoa dong du lieu tuong ung da thuc hien trong @vtable
		DELETE @vtable WHERE MaGV = @MaGV;

		SET @count = @count -1;
	END
	end											