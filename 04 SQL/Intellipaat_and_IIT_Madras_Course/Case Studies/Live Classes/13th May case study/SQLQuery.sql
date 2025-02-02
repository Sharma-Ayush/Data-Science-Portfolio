Select * from Fact
Select * from Location
Select * from Product


--1) How many states are there where products have been sold ?
Select count(distinct l.state) as [Counts State] from Fact as f left join Location as l on f.Area_Code=l.Area_Code
--or
Select Count(distinct state) as [Counts State] from Location where Area_Code in (Select distinct Area_Code from fact)
--or
select count(distinct state) as [Counts State] from Location

--2) How many products are of regular type ?
Select count(Type) as [Regular Count] from Product where Type='Regular'

--3) How much spending has been done on marketing of product id 1
Select SUM(Marketing) as [Marketing of 1] from Fact where ProductId=1

--4) What is the minimum sales of a product ?
Select ProductID,Min(Sales) as [Min. Sales of product] from Fact group by ProductId
--or
Select Min([Product Sales]) as [Min. Sales of product] from (Select ProductID,SUM(Sales) as [Product Sales] from Fact group by ProductId) as t
--or
Select Top(1) SUM(Sales) as [Min. Sales of product] from Fact group by ProductId order by SUM(Sales) ASC

--5) Display max Cost of Good Sold(COGS).
Select MAX(COGS) as [Max COGS] from Fact

--6) Display the Details of the productid where product type is coffee
Select ProductId from Product where Product_Type='Coffee'

--7) Display the details where total_expenses is greater than 40.
Select * from Fact where Total_Expenses>40

--8) What is the average sales in Area_Code 719 ?
Select AVG(Sales) as [Avg. Sales of 719 area] from Fact group by Area_Code having Area_Code=719
--or
Select AVG(Sales) as [Avg. Sales of 719 area] from Fact where Area_Code=719

--9) Find out the total profit generated by Colorado state.
Select SUM(PROFIT) as [Colorado Profit] from Fact where Area_Code in (Select Area_Code from Location where state='Colorado') --better
--or
Select SUM(PROFIT) as [Colorado Profit] from Fact as f left join Location as l on f.Area_Code=l.Area_Code where l.state='Colorado'

--10) Display the average inventory for each product id.
Select ProductId, AVG(Inventory) as [Average Inventory] from Fact group by ProductId

--11) Display state in a sequential order in a location table.
Select distinct state from Location

--12) Display the average budget margin of the store where average budget margin should be greater than 100.
Select Area_Code, AVG(Budget_Margin) as [Avg. Budget Margin] from Fact group by Area_Code having AVG(Budget_Margin)>100

--13) What is the total sales done on date 2010-01-01
Select SUM(Sales) as [Sum of Sales] from Fact where Date='2010-01-01'

--14) Display the average total expense of each product id on individual date
Select Date, ProductID, AVG(Total_Expenses) as [Avg. Total Expenses] from Fact group by Date, ProductID

--15) Display the table with the following attributes such as
--Date, productid, product_type, product, Sales, profit, state, area_code
Select f.Date,f.ProductId,p.Product_Type,p.Product,f.Sales,f.Profit,l.State,f.Area_Code
from 
Fact as f 
inner join
Location as l on f.Area_Code=l.Area_Code
inner join
Product as p on f.ProductId=p.ProductId

--16) Display the rank without any gap to show the Sales wise rank.
Select [Date],ProductId,Sales,DENSE_RANK() OVER(order by sales Desc) as Ranking from Fact
--or
Select Area_Code, SUM(Sales) as [Sum of Sales], DENSE_RANK() OVER(ORDER BY SUM(Sales) Desc) as Ranking from Fact group by Area_Code
--or
Select l.State, l.Area_Code, SUM(f.Sales) as [Sum of Sales], DENSE_RANK() OVER(ORDER BY SUM(f.Sales) Desc) as Ranking from
Fact as f 
inner join
Location as l on f.Area_Code=l.Area_Code
group by l.state, l.Area_Code

--17) Find the State wise Profit and Sales.
Select l.State,SUM(f.Profit) as [Sum of Profit], SUM(f.Sales) as [Sum of Sales] from
Fact as f 
inner join
Location as l on f.Area_Code=l.Area_Code
group by l.state

--18) Find the State wise Profit and Sales along with the Product Name.
Select l.state, p.product, sum(f.profit) as [Sum of Profit], Sum(f.Sales) as [Sum of Sales]
from
Fact as f 
inner join
Location as l on f.Area_Code=l.Area_Code
inner join
Product as p on f.ProductId=p.ProductId
group by l.state, p.product

--19) If there is an increase in sales of 5%. Calculate the increased sales.
Select sales as [Original Sales], [Increased Sales]=convert(int, sales*1.05) from fact

--20) Find the maximum profit along with the Product id and Product Type.
Select t.ProductId,p.Product_Type, t.[Max of Profit] from (Select ProductId, Max(Profit) as [Max of Profit] from Fact group by ProductId) as t
inner join
Product as p
on t.ProductId=p.ProductId
--or
Select p.ProductId,p.Product_Type,MAX(f.profit) as [Max of Profit]
from
Fact as f 
inner join
Product as p on f.ProductId=p.ProductId
group by p.ProductId,p.Product_Type

--21) Create a Stored Procedure to fetch the result according to the product type from Product.
Create Procedure [dbo].[SP_fetch_product_type](@Var as VARCHAR(20))
AS
BEGIN
Select * from Product where Product_Type=@Var
END

EXEC [dbo].[SP_fetch_product_type] 'Coffee'

--22) Write a query by creating a condition in which if the total expenses is less than 60 then it is a profit or else loss.
Select *, Summary=Case
When Total_Expenses<60 then 'Profit'
else 'Loss'
end
from Fact 

--23) Give the total sales value with the Date and productid details. Use roll-up to pull the data in hierarchical order.
Select Date, ProductId, SUM(Sales) as [Sum of Sales] from Fact group by Date, ProductId  with rollup

--24) Apply union and intersection operator on the tables which consist of attribute area code.
Select Area_Code from Fact
Union
Select Area_Code from Location

Select Area_Code from Fact
intersect
Select Area_Code from Location

--25) Create a user-defined function for the product table to fetch a particular product type based upon the user�s preference.
Create function [dbo].[FN_fetch_product_type](@type varchar(20))
returns table
as
return
Select * from Product where Product_Type=@type

Select * from [dbo].[FN_fetch_product_type]('Coffee')

--26) Change the product type from coffee to tea where product id is 1 and undo it.
Begin transaction
update product set Product_Type='tea' where Product_Type='coffee'
select * from product where Product_Type='tea'
rollback transaction
select * from product where Product_Type='coffee'

--27) Display the Date, productid and sales where total expenses are between 100 to 200.
Select Date, ProductId, Sales from Fact where Total_Expenses between 100 and 200

--28) Delete the records in the product table for regular type.
begin transaction
delete from product where Type='Regular'
Select * from Product
rollback transaction

--29) Display the ASCII value of the fifth character from the column product.
Select Char=SUBSTRING(Product,5,1),ASCII_number=ASCII(SUBSTRING(Product,5,1)) from Product