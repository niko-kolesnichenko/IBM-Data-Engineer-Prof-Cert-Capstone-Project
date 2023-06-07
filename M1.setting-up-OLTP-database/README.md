# Setting up MySQL as an OLTP database for e-commerce organization "SoftCart"

## Database design

I've been provided only with following sample data for future database:

![Alt text](sampledata.png)

Using sample data, I've decided to use following data types for columns:

- int for "product_id"
- int for "customer_id"
- decimal (4,2) for "price" (we need fixed-precision data type for prices)
- smallint for "quantity"
- timestamp for "timestamp"

I'm creating database named "sales" with table named "sales_data" using SQL statement inside MySQL CLI:
