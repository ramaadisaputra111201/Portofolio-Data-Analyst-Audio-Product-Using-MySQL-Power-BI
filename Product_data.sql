-- DATA CLEANING
-- ganti format costprice $ yang tidak terdeteksi
select `Cost Price`, trim(trailing '$' from `Cost Price`) from `rama adi`.product_data;

update `rama adi`.product_data
set `Cost Price` = trim(leading '$' from `Cost price`)
where `Cost Price` like '$%';

-- atau dengan

UPDATE `rama adi`.product_data 
SET `Cost Price` = REPLACE(`Cost Price`, '$', '')
WHERE `Cost Price` LIKE '%$%';


-- ganti format sale price $ yang tidak terdeteksi
select `Sale Price`, trim(leading '$' from `Sale Price`) from `rama adi`.product_data;

update `rama adi`.product_data
set `Sale Price` = trim(leading '$' from `Sale Price`) 
where `Sale Price` like '$%';

-- Exploratory Data Analyst
with produk_data as (
SELECT 
	a.Product,
    a.Category,
    a.Brand,
    a.Description,
    a.`Cost Price`,
    a.`Sale Price`,
    a.`Image url`,
    b.date,
    b.`Customer Type`,
    b.`Discount Band`,
    b.`Units Sold`,
	(`sale price` * `Units Sold`) as revenue,
    (`Cost Price` * `Units Sold`) as Total_Cost,
    date_format(Date, '%M') AS months,
	year(Date) AS years
FROM `rama adi`.product_data a	
	join `rama adi`.product_sales b
		on a.`Product ID` = b.Product
)

select * ,
	(1-Discount * 1.0/100) * revenue as discount_revenue
from produk_data a
	join `rama adi`.discount_data b
		 on
         a.months = b.Month
         and
         LOWER(TRIM(a.`Discount Band`)) = LOWER(TRIM(b.`Discount Band`))
;
	