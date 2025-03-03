--- In order to monitor and assess our bank's lending activities and performance, 
--- we need to create a comprehensive Bank Loan Report. 

USE [Bank Loan SQL Project]
SELECT * FROM financial_loan

--- Key Performance Indicators Requirements :

-- 1. Total Loan applications
SELECT COUNT(DISTINCT(id)) AS Total_Loan_Applications 
FROM financial_loan

-- 2. Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM financial_loan

-- 3. MTD Loan applications
SELECT COUNT(id) Total_Loan_Applications_MTD
FROM financial_loan
WHERE MONTH(issue_date) = 12

-- 4. total MTD Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_amount_MTD
FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

-- 5. Total aount received
SELECT SUM(total_payment) AS Total_amount_received
FROM financial_loan
WHERE MONTH(issue_date) = 12

-- 6. Average Interest Rate
SELECT ROUND(AVG(int_rate* 100),4) AS Avg_interest_Rate
FROM financial_loan

- 7. Debt to Interest Ration
SELECT ROUND(AVG(dti * 100),4) AS Avg_dti FROM financial_loan

--7. GOOD LOAN ISSUED
SELECT  (COUNT(CASE WHEN loan_status = 'Fully Paid' OR 
		loan_status = 'Current' THEN id END)) AS Good_loan_issued,
		(COUNT(CASE WHEN loan_status = 'Fully Paid' OR 
		loan_status = 'Current' THEN id END) * 100)/ COUNT(id) AS Percentage
FROM financial_loan

-- 8. Good Loan Funded Amount
SELECT SUM(loan_amount)/ 1000000 AS Good_Loan_Funded_Amt_Millions
FROM financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

-- 9. Good and Bad Loan Amounts and their percentage
SELECT (SUM(CASE WHEN loan_status IN ('Fully Paid', 'Current') THEN loan_amount END)) AS Good_Loan_funded_amt
	  ,(SUM(COALESCE(CASE WHEN loan_status IN ('Fully Paid', 'Current') THEN loan_amount END, 0)) * 100.0) 
    / NULLIF((SELECT SUM(loan_amount) FROM financial_loan), 0) AS Good_Loan_Percentage
	   ,(SUM(CASE WHEN loan_status = 'Charged Off' THEN loan_Amount END)) AS Bad_Loan_funded_amt
	   ,(SUM(COALESCE(CASE WHEN loan_status = 'Charged Off' THEN loan_amount ELSE 0 END, 0)) * 100.0)
	/ NULLIF((SELECT SUM(loan_amount) FROM financial_loan), 0) AS Bad_Loan_Percentage
FROM financial_loan

-- 10. Loan Status
SELECT  loan_status, COUNT(id) AS LoanCount,
		SUM(loan_amount) AS Total_Loan_funded,
		SUM(total_payment) AS Total_Amount_received,
		AVG(int_rate * 100) AS Avg_Interest_Rate,
		AVG(dti * 100) AS Avg_dti
FROM financial_loan
GROUP BY loan_status

-- 11. Bank Loan Report Overview - Monthwise Loan Status
SELECT 
	MONTH(issue_date) AS Month_Number, 
	DATENAME(MONTH, issue_date) AS Month_name, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date)

-- 12.Term Plans
SELECT 
	term AS Term,
	--verification_status AS Verification_Status,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
WHERE verification_status IN ('Verified', 'Source Verified')
GROUP BY term ORDER BY term	
--GROUP BY verification_status
--ORDER BY verification_status

-- 13. Employee Length (Age of Loan)
SELECT  emp_length AS Employee_Length,
		COUNT(id) AS Total_Applications,
		SUM(loan_amount) AS Loan_funded,
		SUM(total_payment) AS Loan_paid
FROM financial_loan
GROUP BY emp_length
ORDER BY emp_length

-- 12. Purpose
SELECT  purpose AS Purpose,
		COUNT(id) AS Total_Applications,
		SUM(loan_amount) AS Loan_funded,
		SUM(total_payment) AS Loan_paid
FROM financial_loan
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose
		
-- 13. Home Ownership
SELECT  home_ownership AS Home_Ownership,
		COUNT(id) AS Total_Applications,
		SUM(loan_amount) AS Loan_funded,
		SUM(total_payment) AS Loan_paid
FROM financial_loan
GROUP BY home_ownership
ORDER BY home_ownership





