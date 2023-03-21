use portfolio;
-- Looking at the dataset --
select *
from asosmenfashion
order by 2,3;
-- Finding number of rows --
Select count(*) as number_of_records
from asosmenfashion;
-- We can see that values in colour column are all null but there are values of colour in the title column. We can extract them out. --
-- Deleting the column "colour" and creating a new one with the same name --
alter table asosmenfashion
drop column colour;

alter table asosmenfashion
add colour text;
-- Extracting colour from the column "title"
update asosmenfashion
set colour = (substring_index(title," ", -1));
-- Looking at unique values in column "colour" --
select distinct(colour)
from asosmenfashion; 
-- We see that there are some invalid values in the column. Also, there are two values "BLACK" and "black", which are same. -- 
-- Looking at titles of invalid values to see if colour is present anywhere else. --
select title, colour
from asosmenfashion
where colour = ('Exclusive','Bombshell','Text'
,'Bronzer','30ml','Oil','Paper','Massager','print','leather','dial')
group by title;
-- We see that titles of invalid values ('print','leather','dial','mix') contain correct values of colour somewhere in title, so we will extract them out now. --
-- Extracting values --
update asosmenfashion
set colour = (substring_index(substring_index(title," ", 6), " ",-1))
where colour = "print";

update asosmenfashion
set colour = (substring_index(substring_index(title," ", 7), " ",-1))
where colour = "leather";

update asosmenfashion
set colour = (substring_index(substring_index(title," ", -2), " ",1))
where colour = "mix";

update asosmenfashion
set colour = "silver/black"
where colour = "dial";
-- Removing rest invalid values from column "colour" --
update asosmenfashion
set colour = null
where colour in ('Exclusive','Bombshell','Text'
,'Bronzer','30ml','Oil','Paper','Massager');
-- Substituting "BLACK" with "black" in colour --
update asosmenfashion
set colour = "black"
where colour = "BLACK";
-- Looking at average current and previous price --
select avg(current_price), avg(previous_price)
from asosmenfashion;
-- Looking at products and their colour --
select title, colour
from asosmenfashion
group by title
order by 2;
-- Here, we notice that products with no colour are cosmetic products and the rest are clothes or accessories. --
-- Current price vs Previous Price --
-- Shows change in price --
select brand_name, title,current_price, previous_price, (current_price - previous_price)/previous_price*100 as percentage_change_in_price
from asosmenfashion
order by 1,2;
-- Looking at unique brand names --
select distinct(brand_name)
from asosmenfashion;
-- Most expensive product --
select product_id, brand_name,title as most_expensive_product, current_price
from asosmenfashion
group by product_id
order by current_price desc
limit 1;
-- Least expensive product --
select brand_name,title as least_expensive_product, current_price
from asosmenfashion
group by brand_name
order by current_price
limit 1;
-- Brands with their average prices --
select brand_name, avg(current_price) as avg_current, avg(previous_price) as avg_previous
from asosmenfashion
group by brand_name;
-- Top 3 expensive Brands --
select brand_name, current_price
from asosmenfashion
group by brand_name
order by current_price desc
limit 3;
-- Brands having price more than average current price --
select brand_name, title, current_price
from asosmenfashion
where current_price > (select avg(current_price)
from asosmenfashion)
group by brand_name;
-- Product type in the order of decreasing prices --
select productType, current_price
from asosmenfashion
group by productType
order by current_price desc;
-- There is only 1 product type. --
-- Top 3 expensive colours --
select colour, current_price
from asosmenfashion
group by colour 
order by current_price desc
limit 3;
-- Which 3 brands have the most product listings? --
select brand_name, count(brand_name) as Products_Listed
from asosmenfashion
group by brand_name
order by count(brand_name) desc
limit 3;
-- Do expensive brands have higher product listings? --
select brand_name, count(brand_name) as Products_Listed
from asosmenfashion
where brand_name in (select * from(select brand_name
from asosmenfashion
group by brand_name
order by current_price desc
limit 3) as ep)
group by brand_name;
-- Top 3 colours in products --
select colour, count(*) as number_of_products
from asosmenfashion
where colour is not null
group by colour
order by 2 desc
limit 3;






