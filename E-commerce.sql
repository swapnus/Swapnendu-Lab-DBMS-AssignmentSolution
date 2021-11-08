/* Create a new database */	
	create database eCommerceDB;
	

	/*start using the database */
	use eCommerceDB;
	

	/*create table  supplier */
	create table if not exists Supplier(
	supp_id int primary key, 
	supp_name varchar(50),
	supp_city varchar (10),
	supp_phone varchar(50)
	);
	

	/*Create table Customer */
	create table if not exists Customer(
	cus_id int not null,
	cus_name varchar(20) null default null,
	cus_phone varchar(10),
	cus_city varchar(30),
	cus_gender char, 
	primary key (cus_id)
	);
	

	/*create table with category */
	create table if not exists Category (
	cat_id int not null,
	cat_name varchar(20) null default null, 
	primary key(cat_id)
	);
	

	/*create table product */
	create table if not exists product(
	pro_id int not null,
	pro_name varchar(20) null default null, 
	pro_desc varchar(60) null default null, 
	cat_id int not null, 
	primary key (pro_id),
	foreign key (cat_id) references Category(cat_id)
	);
	

	/* create table orders */
	create table if not exists Orders (
	ord_id int not null,
	ord_amount int not null, 
	ord_date date, 
	cus_id int not null, 
	pro_id int not null, 
	primary key(ord_id),
	foreign key(cus_id) references customer(cus_id),
	foreign key(pro_id) references product(pro_id)
	);
	

	/* create table product details */
	create table if not exists product_details (
	prod_id int not null, 
	pro_id int not null, 
	supp_id int not null, 
	prod_price int not null, 
	primary key(prod_id), 
	foreign key(pro_id) references product (pro_id),
	foreign key(supp_id) references supplier(supp_id)
	);
	

	/*create table rating */
	create table if not exists rating (
	rat_id int not null, 
	cus_id int not null,
	supp_id int null, 
	rat_ratstars int not null,
	primary key(rat_id),
	foreign key (supp_id) references supplier(supp_id),
	foreign key(cus_id) references customer(cus_id)
	);
	

	/* ---------------------------------------------------------------*/
	

	/* Insert values into supplier values */
	insert into supplier values(1, "Rajesh Retails", "Delhi", '1234567890');
	insert into supplier values(2, "Appario Ltd.", "Mumbai", '2589631470');
	insert into supplier values(3, "Knome products", "Banglore", '9785462315');
	insert into supplier values(4, "Bansal Retails", "Kochi", '8975463285');
	insert into supplier values(5, "Mittal Ltd.", "Lucknow", '7898456532');
	

	/* Insert values into customer values */
	insert into customer values(1, "AAKASH", '9999999999', "DELHI", 'M');
	insert into customer values(2, "AMAN", '9785463215', "NOIDA", 'M');
	insert into customer values(3, "NEHA", '9999999999', "MUMBAI", 'F');
	insert into customer values(4, "MEGHA",'9994562399', "KOLKATA", 'F');
	insert into customer values(5, "PULKIT", '7895999999', "LUCKNOW", 'M');
	

	/* Insert values into category values */
	insert into category values(1, "BOOKS");
	insert into category values(2, "GAMES");
	insert into category values(3, "GROCERIES");
	insert into category values(4, "ELECTRONICS");
	insert into category values(5, "CLOTHES");
	

	

	/* Insert values into product values */
	insert into product values(1, "GTA V", "DFJDJFDJFDJFDJFJF", 2);
	insert into product values(2, "TSHIRT", "DFDFJDFJDKFD", 5);
	insert into product values(3, "ROG LAPTOP", "DFNTTNTNTERND", 4);
	insert into product values(4, "OATS", "REURENTBTOTH", 3);
	insert into product values(5, "HARRY POTTER","NBEMCTHTJTH", 1);
	

	/* Insert values into product details values */
	insert into product_details values(1, 1, 2, 1500);
	insert into product_details values(2, 3, 5, 30000);
	insert into product_details values(3, 5, 1, 3000);
	insert into product_details values(4, 2, 3, 2500);
	insert into product_details values(5, 4, 1, 1000);
	

	/* Insert values into orders values */
	insert into orders values(20, 1500, "2021-10-12", 3, 5);
	insert into orders values(25, 30500, "2021-09-16", 5, 2);
	insert into orders values(26, 2000, "2021-10-05", 1, 1);
	insert into orders values(30, 3500, "2021-08-16", 4, 3);
	insert into orders values(50, 2000, "2021-10-06", 2, 1);
	

	/* Insert values into values values */
	insert into rating values(1, 2, 2, 4);
	insert into rating values(2, 3, 4, 3);
	insert into rating values(3, 5, 1, 5);
	insert into rating values(4, 1, 3, 2);
	insert into rating values(5, 4, 5, 4);
	

	/* Q3  Display the number of the customer group by their genders who have placed any order 
	of amount greater than or equal to Rs.3000. */
	

	select count(case when cus_gender='M' then 1 end) as male_cnt,
	count(case when cus_gender='F' then 1 end) as female_cnt from customer where cus_id = ANY (select cus_id from orders where ord_amount > 3000);
	

	select customer.cus_gender, count(customer.cus_gender) as count from customer inner join orders on customer.cus_id=Orders.cus_id where Orders.ord_amount>=3000 group by customer.cus_gender;
	

	/*Q4 Display all the orders along with the product name ordered by a customer having 
	Customer_Id=2. */
	

	select orders.ord_id,  orders.ord_amount, orders.ord_date, orders.cus_id, orders.pro_id, product.pro_name from orders inner join product on product.pro_id=orders.pro_id where orders.cus_id = 2; 
	

	select orders.*, product.pro_name from orders, product_details, product where orders.cus_id=2 and orders.pro_id=product_details.pro_id and product_details.pro_id=product.pro_id;
	

	/* Q5 Display the Supplier details who can supply more than one product. */
	

	select * from supplier inner join product_details on product_details.supp_id = supplier.supp_id group by product_details.supp_id having count(product_details.pro_id)>1;
	

	

	/* Q6) Find the category of the product whose order amount is minimum.*/
	

	select cat_name as minimum_order_category from category, product where  product.cat_id = category.cat_id and product.pro_id  in (select orders.pro_id from orders having min(orders.ord_amount));
	

	select * from category where cat_id in 
	(select cat_id from product where pro_id in 
	(select pro_id from product_details where pro_id in 
	(select pro_id from orders where ord_amount = (select min(ord_amount)from orders))));
	

	/* Q7 Display the Id and Name of the Product ordered after “2021-10-05”.*/
	

	select pro_id, pro_name from product where pro_id = any (select pro_id from orders where ord_date > '2021-10-05');
	

	

	/* Q8 Print the top 3 supplier name and id and their rating on the basis of their rating along
	with the customer name who has given the rating.*/
	

	select rating.supp_id, supplier.supp_name, customer.cus_name, rating.rat_ratstars from rating, supplier, customer where customer.cus_id = rating.cus_id and supplier.supp_id = rating.supp_id order by rat_ratstars desc limit 0, 3;
	

	

	

	/* Q9 Display customer name and gender whose names start or end with character 'A'.*/
	

	select cus_name, cus_gender from customer where cus_name like 'A%' or  cus_name like 'a%' or  cus_name like  '%a' or  cus_name like  '%A';
	

	

	/* Q10 Display the total order amount of the male customers.*/
	

	 select sum(ord_amount), customer.cus_gender from orders inner join customer on orders.cus_id = customer.cus_id and customer.cus_gender = 'M';
	

	/* Q11 Display all the Customers left outer join with the orders.*/
	

	select * from customer left outer join orders on customer.cus_id = orders.cus_id ;
	

	

	/* Q12 Create a stored procedure to display the Rating for a Supplier if any along with the 
	Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average 
	Supplier” else “Supplier should not be considered”*/
	delimiter &&
	CREATE PROCEDURE ratingverdict()
	BEGIN
	select rating.rat_ratstars, supplier.supp_name, 
	case when  rating.rat_ratstars > 4 then 'Genuine Supplier'
	when rating.rat_ratstars > 2 then 'Average Supplier'
	else 'Supplier should not be considered'
	end as verdict from rating, supplier  where rating.supp_id = supplier.supp_id;
	END && ;
	delimiter ;
	

	call ratingverdict();

