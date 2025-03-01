USE WideWorldImporters
GO

--1
WITH T1
AS
	(
	SELECT YEAR(O.OrderDate) AS "Year"
		, SUM(IL.UnitPrice*IL.Quantity) AS "IncomePerYear"
		, COUNT(DISTINCT MONTH(O.OrderDate)) AS "NumberOfDistinctMonths"
	FROM Sales.Orders O JOIN Sales.Invoices I
		ON O.OrderID = I.OrderID
	JOIN Sales.InvoiceLines IL
		ON I.InvoiceID = IL.InvoiceID
	GROUP BY YEAR(O.OrderDate)
	),
T2
AS
	(SELECT*
		, CASE WHEN NumberOfDistinctMonths<12 THEN (IncomePerYear/NumberOfDistinctMonths)*12
		ELSE IncomePerYear
		END AS "YearlyLinearIncome"
	 FROM T1
	)
SELECT T1.Year
	, FORMAT(T1.IncomePerYear, '#,#.00') AS "IncomePerYear"
	, T1.NumberOfDistinctMonths
	, FORMAT(T2.YearlyLinearIncome, '#,#.00') AS "YearlyLinearIncome"
	, FORMAT(ROUND(((YearlyLinearIncome-LAG(YearlyLinearIncome, 1)OVER(ORDER BY T1."YEAR"))/LAG(YearlyLinearIncome, 1)OVER(ORDER BY T1."YEAR"))*100, 2), 'N2') AS "GrowthRate"
FROM T1 JOIN T2
	ON T1."Year" = T2."Year"
GO

--2
WITH T1
AS
	(
	SELECT YEAR(SO.OrderDate) AS TheYear
		, DATEPART(Q, SO.OrderDate) AS TheQuarter
		, SC.CustomerName
		, SUM(SIL.ExtendedPrice-SIL.TaxAmount) AS IncomePerYear
	FROM sales.Orders SO JOIN Sales.Customers SC
		ON SO.CustomerID = SC.CustomerID
	JOIN Sales.Invoices SI
		ON SI.OrderID = SO.OrderID
	JOIN Sales.InvoiceLines SIL
		ON SIL.InvoiceID = SI.InvoiceID
	GROUP BY YEAR(SO.OrderDate)
		, DATEPART(Q, SO.OrderDate)
		, SC.CustomerName
	),
T2
AS
	(
	SELECT T1.*
		, DENSE_RANK()OVER(ORDER BY T1.TheYear, T1.TheQuarter,T1.IncomePerYear DESC) AS DNR
	FROM T1
	)
SELECT T1.*
	, T2.DNR
FROM T1 JOIN T2
	ON T1.CustomerName=T2.CustomerName
WHERE DNR <= 5
ORDER BY T1.TheYear, T1.TheQuarter,T1.IncomePerYear DESC
GO

--3
SELECT TOP 10 SIL.StockItemID
	, WSI.StockItemName
	, SUM(SIL.ExtendedPrice - SIL.TaxAmount) AS "TotalProfit"
FROM Sales.InvoiceLines SIL LEFT JOIN Warehouse.StockItems WSI
	ON SIL.StockItemID = WSI.StockItemID
GROUP BY SIL.StockItemID
	, WSI.StockItemName
ORDER BY TotalProfit DESC
GO

--4
WITH T
AS
	(
	SELECT WSI.StockItemID
		, WSI.StockItemName
		, WSI.UnitPrice
		, WSI. RecommendedRetailPrice
		, WSI. RecommendedRetailPrice - WSI.UnitPrice AS "NominalProductProfit"
	FROM Warehouse.StockItems WSI
	)
SELECT ROW_NUMBER()OVER(ORDER BY T.NominalProductProfit DESC) AS RN
	, T.*
	, DENSE_RANK()OVER(ORDER BY T.NominalProductProfit DESC) AS DNR
FROM T
GO

--5
WITH T
AS
	(SELECT CONCAT(PS.SupplierID, ' - ', PS.SupplierName) AS "SupplierDetails"
		, STRING_AGG(CONCAT(WSI.StockItemID,' ', WSI.StockItemName),'/') AS "ProductDetails"
		, PS.SupplierID
	FROM Purchasing.Suppliers PS LEFT JOIN Warehouse.StockItems WSI
		ON PS.SupplierID = WSI.SupplierID
	GROUP BY CONCAT(PS.SupplierID, ' - ', PS.SupplierName), PS.SupplierID
	)
SELECT T.SupplierDetails
	, T.ProductDetails
FROM T
WHERE ProductDetails <> ''
ORDER BY CAST(T.SupplierID AS INT)
GO

--6
WITH T
AS
	(
	SELECT TOP 5 SC.CustomerID
		, C.CityName
		, CO.CountryName
		, CO.Continent
		, CO.Region
		, SUM(IL.ExtendedPrice) AS "TotalExtendedPrice"
	FROM Sales.Customers SC JOIN Sales.Invoices I
		ON SC.CustomerID = I.CustomerID
	INNER JOIN Sales.InvoiceLines IL
		ON I.InvoiceID = IL.InvoiceID
	INNER JOIN Application.Cities C
		ON C.CityID = SC.PostalCityID
	INNER JOIN Application.StateProvinces SP
		ON SP.StateProvinceID = C.StateProvinceID
	INNER JOIN Application.Countries CO
		ON CO.CountryID = SP.CountryID
	GROUP BY SC.CustomerID, C.CityName, CO.CountryName, CO.Continent, CO.Region
	ORDER BY TotalExtendedPrice DESC
	)
SELECT T.CustomerID
	, T.CityName
	, T.CountryName
	, T.Continent
	, T.Region
	, FORMAT(T.TotalExtendedPrice, '#,#.00') AS "TotalExtendedPrice"
FROM T
GO

--7
WITH T1
AS
	(
	SELECT YEAR(SO.OrderDate) AS "OrderYear"
		, MONTH(SO.OrderDate) AS "OrderMonth"
		, SUM(SOL.PickedQuantity*SOL.UnitPrice) AS "MonthlyTotal"
	FROM Sales.Orders SO LEFT JOIN Sales.OrderLines SOL
		ON SO.OrderID = SOL.OrderID
	GROUP BY YEAR(SO.OrderDate) , MONTH(SO.OrderDate)
	),
T2
AS
	(
	SELECT T1.*
		, SUM(T1.MonthlyTotal)OVER(ORDER BY T1.OrderYear, T1.OrderMonth
									ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
									AS "CumulativeTotal"
	FROM T1
	),
T3
AS
	(
	SELECT T2.OrderYear
		, CONCAT('', T2.OrderMonth) AS "OrderMonth"
		, T2.MonthlyTotal
		, T2.CumulativeTotal
		, T2.OrderMonth AS "mm_temp"
	FROM T2
	UNION
	SELECT T2.OrderYear
		, 'Grand Total'
		, SUM(T2.MonthlyTotal)
		, MAX(T2.CumulativeTotal)
		, 13
	FROM T2
	GROUP BY T2.OrderYear
	)
SELECT T3.OrderYear
	, T3.OrderMonth
	, FORMAT(T3.MonthlyTotal, '#,#.00') AS "MonthlyTotal"
	, FORMAT(T3.CumulativeTotal, '#,#.00') AS "CumulativeTotal"
FROM T3
ORDER BY T3.OrderYear, mm_temp
GO


--8
SELECT OrderMonth, [2013], [2014], [2015], [2016]
FROM (SELECT SO.OrderID
		, YEAR(SO.OrderDate) AS YY
		, MONTH(SO.OrderDate) AS "OrderMonth"
	  FROM Sales.Orders SO
	  ) T
PIVOT (COUNT(OrderID) FOR YY IN ([2013], [2014], [2015], [2016])) PVT
ORDER BY OrderMonth
GO

--9
WITH T1
AS
	(
		SELECT C.CustomerID
			, C.CustomerName
			, SO.OrderDate
			, LAG(SO.OrderDate, 1)OVER(PARTITION BY C.CustomerID ORDER BY SO.OrderDate) AS PreviousOrderDate
			, MAX(SO.OrderDate)OVER(PARTITION BY C.CustomerID) AS "MaxDate"
		FROM Sales.Customers C
		JOIN Sales.Orders SO
			ON C.CustomerID = SO.CustomerID
	),
T2
AS
	(
	SELECT T1.*
		, DATEDIFF(DD, MaxDate, MAX(OrderDate)OVER())AS "DaysSinceLastOrder"	
		, AVG(DATEDIFF(DD, T1.PreviousOrderDate, T1.OrderDate))OVER(PARTITION BY CustomerID) AS "AvgDaysBetweenOrders"
	FROM T1
	),
T3
AS
	(
	SELECT T2.*
		, CASE WHEN DaysSinceLastOrder>(AvgDaysBetweenOrders*2)
		THEN 'Potential Churn'
		ELSE 'Active'
		END AS "CustomerStatus"
	FROM T2
	)
SELECT T3.CustomerID
	, T3.CustomerName
	, T3.OrderDate
	, T3.PreviousOrderDate
	, T3.DaysSinceLastOrder
	, T3.AvgDaysBetweenOrders
	, T3.CustomerStatus
FROM T3
ORDER BY T3.CustomerID, T3.OrderDate

--10
WITH T1
AS
	(
	SELECT DISTINCT CASE WHEN SC.CustomerName LIKE 'Wingtip%' THEN 'WingtipNew'
		WHEN SC.CustomerName LIKE 'Tailspin%' THEN 'TailspinNew'
		ELSE SC.CustomerName
		END AS "CustomerNameNew"
		, SCC.CustomerCategoryName
	FROM Sales.CustomerCategories SCC JOIN Sales.Customers SC
		ON SCC.CustomerCategoryID = SC.CustomerCategoryID
	),
T2
AS
	(
	SELECT T1.CustomerCategoryName
		, COUNT(T1.CustomerNameNew) AS "CustomerCOUNT"
	FROM T1
	GROUP BY T1.CustomerCategoryName
	),
T3
AS
	(
	SELECT T2.CustomerCategoryName
	, T2.CustomerCOUNT
	, SUM(T2.CustomerCOUNT)OVER() AS "TotalCustCount"
	FROM T2
	)
SELECT*
	,  CONCAT((CAST(T3.CustomerCOUNT AS MONEY)/CAST(T3.TotalCustCount AS MONEY)) * 100, '%') AS "DistributionFactor"
FROM T3