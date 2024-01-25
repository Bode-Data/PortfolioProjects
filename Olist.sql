
--Customer Behavior Analysis:

--What is the average number of orders per customer?
--How many customers have placed orders more than once?
--What are the most common payment types used by customers

select count(order_id)/ count(distinct customer_id) as AvgOrdersPerCustomer
from olist_orders_dataset$

  --select count(customer_id)
	--from     (select customer_id, count(order_id) as OrderCount
              --from olist_orders_dataset$
	          --group by customer_id
		      --having  OrderCount>1) as MultipleOrders



	with OrderCountCTE as
	          (select customer_id, count(order_id) as OrderCount
              from olist_orders_dataset$
	          group by customer_id)
			  select *
			  from OrderCountCTE
			  where OrderCount >1


select payment_type, count(*) as Paymentcount
from olist_order_payments_dataset$
group by payment_type
order by Paymentcount desc


--Product Analysis:

--What is the average product weight and dimensions across different categories?
--Which product categories have the longest/shortest descriptions?

select *
from olist_products_dataset$

SELECT product_category_name, AVG(product_weight_g) AS AvgWeight,
       AVG(product_length_cm * product_height_cm * product_width_cm) AS AvgSize
FROM olist_products_dataset$
GROUP BY product_category_name

SELECT product_category_name, AVG(product_description_lenght) AS AvgDescriptionLength
FROM olist_products_dataset$
GROUP BY product_category_name
ORDER BY AvgDescriptionLength DESC

--Geolocation Insights:

--Which cities have the highest number of customers or sellers?
--Are there any correlations between customer locations and product orders?

SELECT 'Customer' AS UserType, customer_city AS Location, COUNT(*) AS Count
FROM olist_customers_dataset$
GROUP BY customer_city
UNION
SELECT 'Seller' AS UserType, seller_city AS Location, COUNT(*) AS Count
FROM olist_sellers_dataset$
GROUP BY seller_city;



SELECT c.customer_city, COUNT(o.order_id) AS OrderCount
FROM olist_customers_dataset$ c
LEFT JOIN olist_orders_dataset$ o ON c.customer_id = o.customer_id
GROUP BY c.customer_city



--Customer behaviour analysis
--Average number of payment installments choses by customers
--How does order status correlate with customer reviews

select payment_installments, count(order_id) as orders
from olist_order_payments_dataset$
group by payment_installments 
order by 2 Desc

SELECT payment_type, SUM(payment_value) AS TotalPayment
FROM olist_order_payments_dataset$
GROUP BY payment_type

select *
from olist_orders_dataset$
 
select order_status, count(*) as OrderCount
from olist_orders_dataset$
group by order_status

SELECT pc.product_category_name_english, AVG(p.product_weight_g) AS AvgWeight
FROM product_category_name_translati$ pc
JOIN olist_products_dataset$ p
ON pc.product_category_name = p.product_category_name
GROUP BY pc.product_category_name_english

select customer_city, customer_state, count(customer_id) as CustomerCount
from olist_customers_dataset$
group by customer_city, customer_state


--Seller performance metrics

select s.seller_state, s.seller_city, avg(oi.price) as AvgPrice
from olist_sellers_dataset$ s
join olist_order_items_dataset$ oi
on s.seller_id=oi.seller_id
group by s.seller_state, s.seller_city


SELECT pe.product_category_name_english, AVG(pb.product_weight_g) AS AvgWeight,
       AVG(pb.product_length_cm + pb.product_height_cm + pb.product_width_cm) AS AvgSize
FROM olist_products_dataset$ pb
join product_category_name_translati$ pe
on pb.product_category_name=pe.product_category_name_english
GROUP BY pe.product_category_name_english
