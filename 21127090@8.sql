USE QLDeTai;
GO

-- Q75. Cho biết họ tên giáo viên và tên bộ môn họ làm trưởng bộ môn nếu có
select GV.HOTEN, BM.TENBM
from GIAOVIEN GV left join BOMON BM on (BM.TRUONGBM = GV.MAGV)

--Q76. Cho danh sách tên bộ môn và họ tên trưởng bộ môn đó nếu có
select BM.TENBM, GV.HOTEN as TruongBoMon
from BOMON BM left join GIAOVIEN GV on (BM.TRUONGBM = GV.MAGV)

-- Q77. Cho danh sách tên giáo viên và các đề tài giáo viên đó chủ nhiệm nếu có
select GV.HOTEN, DT.TENDT
from GIAOVIEN GV left join DETAI DT on (DT.GVCNDT = GV.MAGV)

/* Q78. Xuất ra thông tin của giáo viên (MAGV, HOTEN) và mức lương của giáo viên. Mức
lương được xếp theo quy tắc: Lương của giáo viên < $1800 : “THẤP” ; Từ $1800 đến
$2200: TRUNG BÌNH; Lương > $2200: “CAO” */
select GV.MAGV, GV.HOTEN,
(case 
	when GV.LUONG <1800 then N'THẤP'
	when GV.LUONG >=1800 and GV.LUONG <=2200 then N'TRUNG BÌNH'
	when GV.LUONG >2200 then N'CAO'
end) as MucLuong 
FROM GIAOVIEN GV

/*Q79. Xuất ra thông tin giáo viên (MAGV, HOTEN) và xếp hạng dựa vào mức lương. Nếu giáo
viên có lương cao nhất thì hạng là 1.*/
select GV.MAGV, GV.HOTEN,GV.LUONG,
(case 
	when GV.LUONG = (select MAX(GV2.LUONG)
						from GIAOVIEN GV2)
	then 1
	else 1+ (select COUNT(DISTINCT LUONG)
			from GIAOVIEN GV3
			where GV3.LUONG > GV.LUONG AND GV.MAGV!=GV3.MAGV) 
end) as HangMucLuong 
from GIAOVIEN GV
order by GV.LUONG DESC

/* Q80. Xuất ra thông tin thu nhập của giáo viên. Thu nhập của giáo viên được tính bằng
LƯƠNG + PHỤ CẤP. Nếu giáo viên là trưởng bộ môn thì PHỤ CẤP là 300, và giáo viên là
trưởng khoa thì PHỤ CẤP là 600 */ --> xét mức phụ cấp lớn hơn

select GV.MAGV, GV.HOTEN,  
(case
	-- nếu là trưởng khoa và trưởng bộ môn thì phụ cấp sẽ là 900
	when GV.MAGV IN (select TRUONGKHOA from KHOA) AND GV.MAGV IN (select TRUONGBM from BOMON) then GV.LUONG + 300 + 600
	when GV.MAGV IN (select TRUONGKHOA from KHOA) then GV.LUONG + 600
	when GV.MAGV IN (select TRUONGBM from BOMON) then GV.LUONG + 300
	else GV.LUONG
end) as ThuNhap
from GIAOVIEN GV 

-- Q81. Xuất ra năm mà giáo viên dự kiến sẽ nghĩ hưu với quy định: Tuổi nghỉ hưu của Nam là 60, của Nữ là 55.
select GV.MAGV,  
(case
	when GV.PHAI = N'Nam' then YEAR(GV.NGAYSINH) + 60
	when GV.PHAI = N'Nữ' then YEAR(GV.NGAYSINH) + 55
end) as NamNghiHuu
from GIAOVIEN GV 

--Q82. Cho biết danh sách tất cả giáo viên (magv, hoten) và họ tên giáo viên là quản lý chuyên môn của họ.
select GV.MAGV, GV.HOTEN, GVQL.HOTEN as GVQLCM
from GIAOVIEN GV left join GIAOVIEN GVQL on (GV.GVQLCM = GVQL.MAGV)

-- Q83. Cho biết danh sách tất cả bộ môn (mabm, tenbm), tên trưởng bộ môn cùng số lượng giáo viên của mỗi bộ môn
select BM.MABM, BM.TENBM, TBM.HOTEN as TruongBoMon, COUNT(GV.MAGV) as SLGiaoVien
from BOMON BM left join GIAOVIEN TBM on (TBM.MAGV = BM.TRUONGBM) 
	left join GIAOVIEN GV on (GV.MABM = BM.MABM)
GROUP BY BM.MABM, BM.TENBM, TBM.HOTEN

-- Q84. Cho biết danh sách tất cả các giáo viên nam và thông tin các công việc mà họ đã tham gia
select GV.*, CV.*
from GIAOVIEN GV left join THAMGIADT TG on (TG.MAGV = GV.MAGV)
	left join CONGVIEC CV on (TG.MADT = CV.MADT and  TG.STT = CV.SOTT)
where GV.PHAI = N'Nam'

-- Q85. Cho biết danh sách tất cả các giáo viên và thông tin các công việc thuộc đề tài 001 mà họ tham gia
select GV.*, CV.*
from GIAOVIEN GV join THAMGIADT TG on (TG.MAGV = GV.MAGV)
	join CONGVIEC CV on (CV.MADT = TG.MADT and TG.STT = CV.SOTT)
where TG.MADT = '001'

-- Q86. Cho biết thông tin các trưởng bộ môn (magv, hoten) sẽ về hưu vào năm 2014. Biết rằng độ tuổi về hưu của giáo viên nam là 60 còn giáo viên nữ là 55.
select GV.MAGV, GV.HOTEN 
from BOMON BM join GIAOVIEN GV on (GV.MAGV = BM.TRUONGBM)
where (GV.PHAI = 'Nam' and YEAR(GV.NGAYSINH)+60 = 2014) OR (GV.PHAI = N'Nữ' and YEAR(GV.NGAYSINH)+55 = 2014)

-- Q87. Cho biết thông tin các trưởng khoa (magv) và năm họ sẽ về hưu.
select GV.MAGV,
(case
	when GV.PHAI = N'Nam' then YEAR(GV.NGAYSINH) + 60
	when GV.PHAI = N'Nữ' then YEAR(GV.NGAYSINH) + 55
end) as NamNghiHuu
from GIAOVIEN GV join KHOA K on (K.TRUONGKHOA = GV.MAGV)

--Q88. Tạo bảng DANHSACHTHIDUA (magv, sodtdat, danhhieu) gồm thông tin mã giáo viên, số đề tài họ tham gia đạt kết quả và danh hiệu thi đua:
--a. Insert dữ liệu cho bảng này (để trống cột danh hiệu)
--b. Dựa vào cột sldtdat (số lượng đề tài tham gia có kết quả là “đạt”) để cập nhật dữ
--liệu cho cột danh hiệu theo quy định:
--i. Sodtdat = 0 thì danh hiệu “chưa hoàn thành nhiệm vụ”
--ii. 1 <= Sodtdat <= 2 thì danh hiệu “hoàn thành nhiệm vụ”
--iii. 3 <= Sodtdat <= 5 thì danh hiệu “tiên tiến”
--iv. Sodtdat >= 6 thì danh hiệu “lao động xuất sắc

-- tạo bảng
create table DANHSACHTHIDUA (
	MAGV char(3) PRIMARY KEY,
	SODTDAT int,
	DANHHIEU nvarchar(50),
	FOREIGN KEY(MAGV) REFERENCES GIAOVIEN
)
--a
insert into DANHSACHTHIDUA(MAGV, SODTDAT)
select TG.MAGV, COUNT(TG.KETQUA)
from THAMGIADT TG
group by TG.MAGV


--b
update DANHSACHTHIDUA 
set DANHHIEU = (select (case 
							when SODTDAT = 0 then N'Chưa hoàn thành nhiệm vụ'
							when SODTDAT >=1 and SODTDAT<=2 then N'Hoàn thành nhiệm vụ'
							when SODTDAT >=3 and SODTDAT<=5 then N'Tiên tiến'
							else 'Lao động xuất sắc'
						end)
				from DANHSACHTHIDUA ds
				where ds.MAGV = DANHSACHTHIDUA.MAGV)



