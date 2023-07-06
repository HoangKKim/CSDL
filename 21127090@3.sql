USE QLDeTai;
GO

-- Q1. Cho biết họ tên và mức lương của các giáo viên nữ --
SELECT HOTEN, LUONG
FROM GIAOVIEN
WHERE PHAI = N'Nữ'

--Q2. Cho biết họ tên của các giáo viên và lương của họ sau khi tăng 10%--
SELECT HOTEN, LUONG*1.1 --lương sau khi tăng 10%--
FROM GIAOVIEN

--Q3. Cho biết mã của các giáo viên có họ tên bắt đầu là “Nguyễn” và lương trên $2000 hoặc, giáo viên là trưởng bộ môn nhận chức sau năm 1995 --
SELECT DISTINCT MAGV
FROM GIAOVIEN, BOMON
WHERE (GIAOVIEN.HOTEN LIKE N'Nguyễn %' AND GIAOVIEN.LUONG > 2000 ) OR (GIAOVIEN.MAGV = BOMON.TRUONGBM AND YEAR(BOMON.NGAYNHANCHUC)>1995)

-- Q4 Cho biết tên những giáo viên khoa Công nghệ thông tin. --> dùng tên là công nghệ thông tin để truy vấn-- --> chỉ in tên
/* SELECT *
FROM (KHOA JOIN BOMON ON (KHOA.TENKHOA = N'Công nghệ thông tin' AND (BOMON.MAKHOA = KHOA.MAKHOA))) JOIN GIAOVIEN ON (GIAOVIEN.MABM = BOMON.MABM) */
SELECT GIAOVIEN.HOTEN
FROM GIAOVIEN, BOMON, KHOA
WHERE (KHOA.TENKHOA = N'Công nghệ thông tin') AND (KHOA.MAKHOA = BOMON.MAKHOA) AND (GIAOVIEN.MABM = BOMON.MABM)

-- Q5. Cho biết thông tin của bộ môn cùng thông tin giảng viên làm trưởng bộ môn đó --
-- cach 1: dùng JOIN 
SELECT *
FROM BOMON LEFT JOIN GIAOVIEN ON BOMON.TRUONGBM = GIAOVIEN.MAGV -- giữ toàn bộ bộ môn, chỗ nào không có thì để trống 

/* cach 2: dùng distinct để loại bỏ chỗ trưởng khoa = NULL 
SELECT *
FROM GIAOVIEN, BOMON
WHERE BOMON.TRUONGBM = GIAOVIEN.MAGV */

--Q6.Với mỗi giáo viên, hãy cho biết thông tin của bộ môn mà họ đang làm việc-- 
SELECT *			-- select * nên sẽ xuất hiện 2 cái MABM, muốn 1 bảng thì liệt kê ra -- 
FROM (GIAOVIEN JOIN BOMON ON (GIAOVIEN.MABM = BOMON.MABM))

-- Q7. Cho biết tên đề tài và giáo viên chủ nhiệm đề tài -- 
SELECT DETAI.TENDT, GIAOVIEN.HOTEN
FROM DETAI, GIAOVIEN
WHERE DETAI.GVCNDT = GIAOVIEN.MAGV

-- Q8. Với mỗi khoa cho biết thông tin trưởng khoa. -- 
SELECT KHOA.*, GIAOVIEN.*
FROM KHOA, GIAOVIEN
WHERE KHOA.TRUONGKHOA = GIAOVIEN.MAGV

-- Q9. Cho biết các giáo viên của bộ môn “Vi sinh” có tham gia đề tài 006 -- 
SELECT DISTINCT GIAOVIEN.*
FROM GIAOVIEN, BOMON, DETAI, THAMGIADT
WHERE GIAOVIEN.MABM = BOMON.MABM AND BOMON.TENBM = 'Vi sinh' AND DETAI.MADT = '006' AND DETAI.MADT = THAMGIADT.MADT AND THAMGIADT.MAGV = GIAOVIEN.MAGV

-- Q10. Với những đề tài thuộc cấp quản lý “Thành phố”, cho biết mã đề tài, đề tài thuộc về chủ đề nào, -- 
-- họ tên người chủ nghiệm đề tài cùng với ngày sinh và địa chỉ của người ấy. --
SELECT DETAI.MADT, CHUDE.TENCD, GIAOVIEN.HOTEN, GIAOVIEN.NGAYSINH, GIAOVIEN.DIACHI
FROM DETAI, CHUDE, GIAOVIEN
WHERE (DETAI.CAPQL LIKE N'Trường') AND (DETAI.MACD = CHUDE.MACD) AND (DETAI.GVCNDT = GIAOVIEN.MAGV)

-- Q11. Tìm họ tên của từng giáo viên và người phụ trách chuyên môn trực tiếp của giáo viên đó--
SELECT GV.HOTEN AS TENGV, NPT.HOTEN AS NPTCM
FROM GIAOVIEN AS GV LEFT JOIN GIAOVIEN AS NPT
ON GV.GVQLCM = NPT.MAGV

--Q12. Tìm họ tên của những giáo viên được “Nguyễn Thanh Tùng” phụ trách trực tiếp --
SELECT GV.HOTEN
FROM GIAOVIEN AS GV, GIAOVIEN AS NPT
WHERE GV.GVQLCM = NPT.MAGV AND NPT.HOTEN LIKE N'Nguyễn Thanh Tùng'

-- Q13. Cho biết tên giáo viên là trưởng bộ môn “Hệ thống thông tin”--
SELECT GIAOVIEN.HOTEN
FROM GIAOVIEN, BOMON
WHERE BOMON.TENBM LIKE N'Hệ thống thông tin' AND BOMON.TRUONGBM = GIAOVIEN.MAGV

-- Q14. Cho biết tên người chủ nhiệm đề tài của những đề tài thuộc chủ đề Quản lý giáo dục. --
SELECT GIAOVIEN.HOTEN, DETAI.TENDT
FROM GIAOVIEN, DETAI, CHUDE
WHERE CHUDE.TENCD LIKE N'Quản lý giáo dục' AND DETAI.MACD = CHUDE.MACD AND DETAI.GVCNDT = GIAOVIEN.MAGV

-- Q15. Cho biết tên các công việc của đề tài HTTT quản lý các trường ĐH có thời gian bắt đầu --
-- trong tháng 3/2008                     
SELECT CONGVIEC.TENCV
FROM CONGVIEC, DETAI
WHERE (DETAI.TENDT LIKE N'HTTT quản lý các trường ĐH') AND (DETAI.MADT = CONGVIEC.MADT) AND DATEDIFF(M,CONGVIEC.NGAYBD,'2008-03-01')=0 --CONGVIEC.NGAYBD LIKE '2008-03-__'

--Q16. Cho biết tên giáo viên và tên người quản lý chuyên môn của giáo viên đó. giống Q11--
SELECT GV.HOTEN AS TENGV , NQL.HOTEN AS NQLCM
FROM  GIAOVIEN AS GV LEFT JOIN GIAOVIEN AS NQL
ON GV.GVQLCM = NQL.MAGV

-- Q17. Cho các công việc bắt đầu trong khoảng từ 01/01/2007 đến 01/08/2007. -- 
SELECT CONGVIEC.*
FROM CONGVIEC
WHERE CONGVIEC.NGAYBD BETWEEN '01/01/2007' AND '08/01/2007'

-- Q18. Cho biết họ tên các giáo viên cùng bộ môn với giáo viên “Trần Trà Hương”. -- 
SELECT GV.HOTEN
FROM GIAOVIEN AS TTH,  GIAOVIEN AS GV
WHERE TTH.HOTEN LIKE N'Trần Trà Hương' AND TTH.MABM = GV.MABM AND GV.HOTEN != TTH.HOTEN

-- Q19. Tìm những giáo viên vừa là trưởng bộ môn vừa chủ nhiệm đề tài. -- 
SELECT DISTINCT GIAOVIEN.*
FROM GIAOVIEN, BOMON, DETAI
WHERE BOMON.TRUONGBM = GIAOVIEN.MAGV AND DETAI.GVCNDT = GIAOVIEN.MAGV 

-- Q20. Cho biết tên những giáo viên vừa là trưởng khoa và vừa là trưởng bộ môn. -- 
SELECT DISTINCT GV.HOTEN
FROM GIAOVIEN AS GV, KHOA, BOMON
WHERE KHOA.TRUONGKHOA = GV.MAGV AND BOMON.TRUONGBM = GV.MAGV

-- Q21. Cho biết tên những trưởng bộ môn mà vừa chủ nhiệm đề tài --
SELECT DISTINCT GIAOVIEN.HOTEN
FROM GIAOVIEN, BOMON, DETAI
WHERE BOMON.TRUONGBM = GIAOVIEN.MAGV AND DETAI.GVCNDT = GIAOVIEN.MAGV 

--Q22. Cho biết mã số các trưởng khoa có chủ nhiệm đề tài--
SELECT DISTINCT GIAOVIEN.MAGV
FROM GIAOVIEN, KHOA, DETAI
WHERE KHOA.TRUONGKHOA = GIAOVIEN.MAGV AND DETAI.GVCNDT = GIAOVIEN.MAGV

-- Q23. Cho biết mã số các giáo viên thuộc bộ môn “HTTT” hoặc có tham gia đề tài mã “001”. --
SELECT DISTINCT GIAOVIEN.MAGV
FROM GIAOVIEN, THAMGIADT
WHERE (GIAOVIEN.MABM LIKE 'HTTT') OR (THAMGIADT.MAGV = GIAOVIEN.MAGV AND THAMGIADT.MADT = '001')

-- Q24. Cho biết giáo viên làm việc cùng bộ môn với giáo viên 002. -- 
SELECT GV.* 
FROM GIAOVIEN AS GV, GIAOVIEN AS GV002
WHERE GV.MAGV != GV002.MAGV AND GV.MABM = GV002.MABM AND GV002.MAGV = '002' 

--Q25. Tìm những giáo viên là trưởng bộ môn.--
SELECT GIAOVIEN.*
FROM GIAOVIEN, BOMON
WHERE BOMON.TRUONGBM = GIAOVIEN.MAGV

-- Q26. Cho biết họ tên và mức lương của các giáo viên. -- 
SELECT GV.HOTEN, GV.LUONG
FROM GIAOVIEN AS GV
