# Domino's Pizza SQL Analytics Project
#1- Total Orders 
create database dominos;
use dominos;
select count(distinct(order_id)) as Total_Orders from orders;

#2- Total Revenue 
use dominos;
select sum(od.quantity*p.price) as Total_Revenue 
from order_details od join pizzas p on od.pizza_id=p.pizza_id;

#3- Average Order Value 
use dominos;
select sum(p.price*od.quantity)/count(distinct(o.order_id)) as Average_Order_Value 
from order_details od join orders o 
on o.order_id=od.order_id join pizzas p 
on od.pizza_id=p.pizza_id;

#4-Orders by hour 
use dominos;
select hour(order_time) as hours,count(order_id) as
Order_id_count from orders 
group by hour(order_time);

#5-Orders by Weekday 
use dominos;
select dayname(order_date) as weekdays,count(order_id) as
Order_id_count from orders group by dayname(order_date);

#6-Monthly Revenue 
use dominos;
select year(o.order_date)as year,month(o.order_date) as Month,sum(od.quantity*p.price) as 
Total_Revenue from orders o join order_details od 
on o.order_id=od.order_id join pizzas p 
on od.pizza_id=p.pizza_id 
group by year(o.order_date),month(o.order_date);

#7-Top 5 Pizzas by revenue 
use dominos;
select p1.pizza_type_id,p1.name,sum(p.price*od.quantity) as Total_Revenue
from pizza_types p1 join pizzas p 
on p1.pizza_type_id=p.pizza_type_id 
join order_details od on od.pizza_id=p.pizza_id
group by p1.pizza_type_id,p1.name 
order by sum(p.price*od.quantity)desc limit 5;

#8-Top 5 pizza by quantity 
use dominos;
select p1.pizza_type_id,p1.name,sum(od.quantity) as Total_Quantity
from order_details od join orders o 
on od.order_id=o.order_id join pizzas p 
on od.pizza_id=p.pizza_id join pizza_types p1 
on p.pizza_type_id=p1.pizza_type_id 
group by p1.pizza_type_id,p1.name 
order by sum(od.quantity)desc limit 5;

#9-Revenue by Category
use dominos;
select p1.category,sum(p.price*od.quantity)as Total_Revenue 
from pizza_types p1 join pizzas p 
on p.pizza_type_id=p1.pizza_type_id join order_details od 
on od.pizza_id=p.pizza_id 
group by p1.category;

#10-Avg Price by size 
use dominos;
select size,round(avg(price),2) as Average_price 
from pizzas group by size;

#11-Top Customers by spend 
use dominos;
select * from(
select o.customer_id,sum(od.quantity*p.price)as Total_Revenue,dense_rank()
over(order by sum(od.quantity*p.price)desc) as PriceRankings 
from orders o join order_details od 
on o.order_id=od.order_id join pizzas p 
on od.pizza_id=p.pizza_id 
group by o.customer_id)t 
where PriceRankings<=3;

#12 Repeat Customers
use dominos;
select o.customer_id,count(distinct(o.order_id))as Order_Id_Count
from orders o join order_details od 
on o.order_id=od.order_id 
group by o.customer_id
having count(distinct o.order_id)>1;

#13 Rank Pizza's by Revenue 
use dominos;
select p1.name,sum(od.quantity*p.price)as Total_Revenue,dense_rank()
over(order by sum(od.quantity*p.price)desc) as PizzaRankings 
from pizzas p join pizza_types p1 
on p.pizza_type_id=p1.pizza_type_id 
join order_details od 
on od.pizza_id=p.pizza_id
group by p1.name;

#14 Top Pizza per category
use dominos;
select * from(
select p1.category,p1.name,sum(od.quantity*p.price)as Total_Revenue,dense_rank()
over(partition by p1.category order by sum(od.quantity*p.price)desc)as PizzaCategoryRankings 
from pizza_types p1 join pizzas p 
on p.pizza_type_id=p1.pizza_type_id
join order_details od 
on od.pizza_id=p.pizza_id
group by p1.category,p1.name)t 
where PizzaCategoryRankings=1;

#15 Cumulative Revenue
use dominos;
select p1.pizza_type_id,p1.name,
sum(sum(p.price*od.quantity))
over(order by sum(p.price*od.quantity)) as CumulativeRevenue
from pizzas p join pizza_types p1 
on p.pizza_type_id=p1.pizza_type_id 
join order_details od 
on od.pizza_id=p.pizza_id
group by p1.pizza_type_id,p1.name;

#16 Contribution % of Top Pizza
use dominos;
SELECT 
    p1.name,
    p1.category,
    SUM(od.quantity * p.price) AS revenue,
    ROUND(
        (SUM(od.quantity * p.price) / 
        (SELECT SUM(od2.quantity * p2.price)
         FROM order_details od2
         JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id)
        ) * 100, 2
    ) AS contribution_percentage
FROM pizza_types p1
JOIN pizzas p ON p.pizza_type_id = p1.pizza_type_id
JOIN order_details od ON od.pizza_id = p.pizza_id
GROUP BY p1.name, p1.category
ORDER BY revenue DESC;














