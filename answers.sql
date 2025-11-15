--QUESTION 1
WITH RecursiveSplit AS (
    -- Anchor Member: Start with the first product in the list
    SELECT
        OrderID,
        CustomerName,
        -- Get the first product (before the comma)
        TRIM(SUBSTRING(Products FROM 1 FOR POSITION(',' IN Products) - 1)) AS Product,
        -- Get the rest of the list for the next iteration
        TRIM(SUBSTRING(Products FROM POSITION(',' IN Products) + 1)) AS RemainingProducts
    FROM
        ProductDetail
    WHERE
        POSITION(',' IN Products) > 0 -- Only process rows with more than one item

    UNION ALL

    -- Recursive Member: Process the remaining list
    SELECT
        r.OrderID,
        r.CustomerName,
        -- Get the next product
        TRIM(SUBSTRING(r.RemainingProducts FROM 1 FOR POSITION(',' IN r.RemainingProducts) - 1)),
        -- Get the rest of the list
        TRIM(SUBSTRING(r.RemainingProducts FROM POSITION(',' IN r.RemainingProducts) + 1))
    FROM
        RecursiveSplit AS r
    WHERE
        POSITION(',' IN r.RemainingProducts) > 0
)

-- Final SELECT: Combine all individual products and the single-item rows
SELECT
    OrderID,
    CustomerName,
    Product
FROM
    RecursiveSplit

UNION ALL

-- Add the orders that originally only had one item (no comma)
SELECT
    OrderID,
    CustomerName,
    Products
FROM
    ProductDetail
WHERE
    POSITION(',' IN Products) = 0 OR Products IS NULL;

--QUESTION 2
-- New Table 1: Orders (PK: OrderID)
SELECT DISTINCT
    OrderID,
    CustomerName
FROM
    OrderDetails;

    -- New Table 2: OrderItems (PK: OrderID, Product)
SELECT
    OrderID,
    Product,
    Quantity
FROM
    OrderDetails;