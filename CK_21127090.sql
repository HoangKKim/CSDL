﻿use QLDeTai
go

-- 1. Cho biết những Bộ Môn nào có nhiều Giáo Viên nhất có Số Điện Thoại. --> đếm số lượng theo mã giáo viên
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
	