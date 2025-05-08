-- Answers 1
-- Assuming you have a table named ProductDetail

WITH RECURSIVE SplitProducts AS (
  SELECT 
    OrderID,
    CustomerName,
    SUBSTRING_INDEX(Products, ',', 1) AS Product,
    SUBSTRING(Products, LENGTH(SUBSTRING_INDEX(Products, ',', 1)) + 2) AS Rest
  FROM ProductDetail

  UNION ALL

  SELECT
    OrderID,
    CustomerName,
    SUBSTRING_INDEX(Rest, ',', 1),
    SUBSTRING(Rest, LENGTH(SUBSTRING_INDEX(Rest, ',', 1)) + 2)
  FROM SplitProducts
  WHERE Rest != ''
)

SELECT 
  OrderID,
  CustomerName,
  TRIM(Product) AS Product
FROM 
  SplitProducts;


-- QUESTION 2

  CREATE TABLE Orders (
   OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
     );

INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM ProductDetail;

CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

ALTER TABLE ProductDetail ADD COLUMN Quantity INT DEFAULT 1;

INSERT INTO OrderItems (OrderID, Product, Quantity)
 SELECT OrderID, Products, Quantity
FROM ProductDetail;
