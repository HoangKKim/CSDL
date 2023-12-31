﻿USE QLDeTai;
GO

-- Q27. Cho biết số lượng giáo viên viên và tổng lương của họ. --
SELECT COUNT(GIAOVIEN.MAGV) AS SLGIAOVIEN, SUM(GIAOVIEN.LUONG) AS TONGLUONG
FROM GIAOVIEN;

-- Q28. Cho biết số lượng giáo viên và lương trung bình của từng bộ môn. -- 
SELECT TENBM, COUNT(GIAOVIEN.MAGV) AS SLGIAOVIEN, AVG(GIAOVIEN.LUONG) AS LUONGTB  
FROM GIAOVIEN JOIN BOMON ON GIAOVIEN.MABM = BOMON.MABM 
GROUP BY TENBM 

-- Q29. Cho biết tên chủ đề và số lượng đề tài thuộc về chủ đề đó. -- 
SELECT TENCD, COUNT(DETAI.MADT) AS SLDETAI
FROM CHUDE LEFT JOIN DETAI ON DETAI.MACD = CHUDE.MACD
GROUP BY TENCD

-- Q30. Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó tham gia. --
SELECT GIAOVIEN.HOTEN AS TENGV, GIAOVIEN.MAGV AS MAGV, COUNT(DISTINCT THAMGIADT.MADT) AS SLDETAI
FROM GIAOVIEN LEFT JOIN THAMGIADT ON GIAOVIEN.MAGV = THAMGIADT.MAGV
GROUP BY GIAOVIEN.HOTEN, GIAOVIEN.MAGV -- trường hợp tên giáo viên bị trung

-- Q31. Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó làm chủ nhiệm.--
SELECT GIAOVIEN.HOTEN AS TENGV, COUNT(DETAI.MADT) AS SLDETAICN
FROM GIAOVIEN LEFT JOIN DETAI ON GIAOVIEN.MAGV = DETAI.GVCNDT
GROUP BY GIAOVIEN.HOTEN 

-- Q32. Với mỗi giáo viên cho tên giáo viên và số người thân của giáo viên đó. --
SELECT GIAOVIEN.HOTEN, COUNT(NGUOITHAN.TEN) AS SLNGUOITHAN
FROM GIAOVIEN LEFT JOIN NGUOITHAN ON (GIAOVIEN.MAGV = NGUOITHAN.MAGV)
GROUP BY GIAOVIEN.HOTEN

-- Q33. Cho biết tên những giáo viên đã tham gia từ 3 đề tài trở lên. -- 
SELECT GIAOVIEN.HOTEN				
FROM GIAOVIEN JOIN THAMGIADT ON (GIAOVIEN.MAGV = THAMGIADT.MAGV)
GROUP BY GIAOVIEN.HOTEN
HAVING COUNT(DISTINCT THAMGIADT.MADT) >= 3

-- Q34. Cho biết số lượng giáo viên đã tham gia vào đề tài Ứng dụng hóa học xanh. -- 
SELECT DETAI.TENDT, COUNT(DISTINCT GIAOVIEN.MAGV) AS SLGIAOVIEN
FROM (DETAI JOIN THAMGIADT ON (DETAI.MADT = THAMGIADT.MADT)) JOIN GIAOVIEN ON (THAMGIADT.MAGV = GIAOVIEN.MAGV)
GROUP BY DETAI.TENDT
HAVING DETAI.TENDT = N'Ứng dụng hóa học xanh'




