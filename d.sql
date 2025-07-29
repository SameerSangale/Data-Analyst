create database bank;

USE bank;
SELECT * FROM credit_debit;

SELECT 
    COUNT(*) AS total_rows
FROM 
    credit_debit;
    
SELECT 
    SUM(amount) AS total_amount
FROM 
    credit_debit;
 
 /* Total Amount*/
    SELECT 
    SUM(amount) AS total_amount
FROM 
    credit_debit;

/* Total Balance */
SELECT 
    SUM(balance) AS total_balance
FROM 
    credit_debit;


/* NO.Client */
SELECT 
    COUNT(`Customer Name`) AS total_customer_names
FROM 
    credit_debit;
    
/* Total Credit */
SELECT 
    SUM(amount) AS total_credit
FROM 
    credit_debit
WHERE 
    `Transaction Type` = 'Credit';
    

/* Total Debit */
SELECT 
    SUM(amount) AS total_debit
FROM 
    credit_debit
WHERE 
    `Transaction Type` = 'Debit';


/* Net Balance */   
SELECT 
    ( 
        SUM(CASE WHEN `Transaction Type` = 'Credit' THEN amount ELSE 0 END) - 
        SUM(CASE WHEN `Transaction Type` = 'Debit' THEN amount ELSE 0 END) 
    ) AS net_balance
FROM 
    credit_debit;
    
/* top 3 bank with most customer */
SELECT 
    `Bank Name`,
    COUNT(DISTINCT `Customer Name`) AS total_customers
FROM 
    credit_debit
GROUP BY 
    `Bank Name`
ORDER BY 
    total_customers DESC
LIMIT 3;


/* Branch with most Customer  */
SELECT 
    Branch,
    COUNT(DISTINCT `Customer Name`) AS total_customers
FROM 
    credit_debit
GROUP BY 
    Branch
ORDER BY 
    total_customers DESC
LIMIT 1;

/* transaction method by customer */
SELECT 
    `Transaction Method`,
    COUNT(DISTINCT `Customer Name`) AS total_customers
FROM 
    credit_debit
GROUP BY 
    `Transaction Method`
ORDER BY 
    total_customers DESC;
    
/* customers by discription  */
SELECT 
    Description,
    COUNT(DISTINCT `Customer Name`) AS total_customers
FROM 
    credit_debit
GROUP BY 
    Description
ORDER BY 
    total_customers DESC
LIMIT 5;

/* Campare transaction type  */
SELECT 
    `Transaction Type`,
    COUNT(*) AS total_transactions,
    SUM(Amount) AS total_amount,
        SUM(Balance) AS total_balance,
    AVG(Amount) AS average_amount
FROM 
    credit_debit
GROUP BY 
    `Transaction Type`
ORDER BY 
    total_amount DESC;

/* Count of Customers by Transaction Method */

SELECT TransactionMethod, COUNT(DISTINCT CustomerName) AS CustomerCount
FROM Credit_Debit
GROUP BY TransactionMethod;


/* month wise customer growth */
DELIMITER $$
CREATE PROCEDURE MonthlyCustomerGrowth()
BEGIN
    SELECT 
        Branch, 
        MONTH(STR_TO_DATE(`Transaction Date`, '%d-%m-%Y')) AS MonthNumber,
        MONTHNAME(STR_TO_DATE(`Transaction Date`, '%d-%m-%Y')) AS Month,
        COUNT(*) AS NewCustomers
    FROM credit_debit
    GROUP BY Branch, MonthNumber, Month
    ORDER BY Branch, monthnumber;
END $$
DELIMITER ;


CALL MonthlyCustomerGrowth();


/* create view Monthly customer summary*/ 
CREATE VIEW Monthly_Customer_Summary AS
SELECT 
    `Customer Name`,
    `Branch`,
    DATE_FORMAT(STR_TO_DATE(`Transaction Date`, '%d-%m-%Y'), '%M %Y') AS MonthText,
    
    SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END) AS TotalCredits,
    SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END) AS TotalDebits,
    
    SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END) - 
    SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END) AS NetChange

FROM Credit_Debit
GROUP BY 
    `Customer Name`, 
    `Branch`, 
    DATE_FORMAT(STR_TO_DATE(`Transaction Date`, '%d-%m-%Y'), '%M %Y');
    
    select * from Monthly_Customer_Summary;
