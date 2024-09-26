CREATE DATABASE QUANLYBANHANG;
use QUANLYBANHANG;

CREATE TABLE customer(
customer_id VARCHAR(4) PRIMARY KEY,
customer_nam VARCHAR(100),
customer_email VARCHAR(100),
customer_phone VARCHAR(25),
customer_address VARCHAR(255)
);

CREATE TABLE products(
productId VARCHAR(4) PRIMARY KEY,
product_name VARCHAR(255),
description TEXT,
price DOUBLE,
status BIT(1)
);

CREATE TABLE orders(
order_id VARCHAR(4) PRIMARY KEY,
customer_id VARCHAR(4),FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
order_date DATE,
total_amount DOUBLE
);

CREATE TABLE orders_details (
    order_id VARCHAR(4),
    productId VARCHAR(4), 
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (productId) REFERENCES products(productId),
    quantity INT(11),
    price DOUBLE
);

INSERT into customer(customer_id,customer_nam,customer_email,customer_phone,customer_address)VALUES
('C001','nguyen trung manh','manhnt@gmail.com','984756322','cau giay ha noi'),
('C002','ho nam hai','namhh@gmail.com','984875926','ba vi ha noi'),
('C003','to ngoc vu','vutn@gmail.com','904725784','moc chau son la'),
('C004','pham ngoc anh','anhpn@gmail.com','98465365','vinh nghe an'),
('C005','trung minh cuong','cungtm@gmail.com','989735624','hai ba trung ha noi');


INSERT into products(productId,product_name,description,price,status) VALUES
('P001','iphone 13 pro max','512 ban xanh la',22999999,1),
('P002','deli votros v3510','core i5 tam 8gb',14999999,1),
('P003','macbook pro m2','8cpu 10cpu 8gb 256gb',28999999,1),
('P004','apple utra ultra','titanium alpine loop small',18999999,1),
('P005','aipods 2 2002','spatial audio',40900000,1);

INSERT into orders(order_id,customer_id,order_date,total_amount) VALUES
('H001','C001','2023-02-22',52999997),
('H002','C001','2023-03-11',80999997),
('H003','C002','2023-01-22',54359998),
('H004','C003','2023-03-14',102999995),
('H005','C003','2023-03-13',80999997),
('H006','C004','2023-02-01',110449994),
('H007','C004','2023-03-29',79999996),
('H008','C005','2023-02-14',29999998),
('H009','C005','2023-01-10',28999999),
('H010','C005','2023-04-01',149999994);

INSERT into orders_details(order_id,productId,quantity,price) VALUES
('H001','P002',1,14999999),
('H001','P004',2,18999999),
('H002','P001',1,22999999),
('H002','P003',2,28999999),
('H003','P004',2,18999999),
('H003','P005',4,40900000),
('H004','P002',3,14999999),
('H004','P003',2,28999999),
('H005','P001',1,22999999),
('H005','P003',2,28999999),
('H006','P005',5,40900000),
('H006','P002',6,14999999),
('H007','P004',3,18999999),
('H007','P001',1,22999999),
('H008','P002',2,14999999),
('H009','P003',1,28999999),
('H010','P003',2,28999999),
('H010','P001',4,22999999);


SELECT * from customer;

SELECT customer.customer_nam , customer.customer_phone,customer.customer_address 
FROM customer 
JOIN orders on customer.customer_id = orders.customer_id
WHERE
year(orders.order_date) = 2023 AND month(orders.order_date) = 3;


SELECT 
    MONTH(order_date) AS month, 
    SUM(total_amount) AS tong_danh_thu
FROM 
    orders
WHERE 
    YEAR(order_date) = 2023
GROUP BY 
    MONTH(order_date)
ORDER BY 
    month;


SELECT
customer.* FROM customer
LEFT JOIN orders on customer.customer_id = orders.customer_id
AND year(orders.order_date) = 2023 AND month(orders.order_date) = 2 
WHERE 
orders.customer_id IS NULL
;


SELECT 
products.productId ,
products.product_name,
SUM(orders_details.quantity) as soLuongBanRa
FROM products
JOIN orders_details
on products.productId = orders_details.productId
JOIN orders
on orders_details.order_id = orders.order_id 
AND year(orders.order_date) = 2023 AND month(orders.order_date) = 2 
GROUP BY
products.productId;


SELECT
customer.customer_id,
customer.customer_nam,
sum(orders.total_amount) as mucChiTieu
FROM
customer
JOIN
orders
on
customer.customer_id = orders.customer_id 
AND year(orders.order_date) = 2023
GROUP BY
customer.customer_id
ORDER BY mucChiTieu DESC
;


SELECT
customer.customer_nam , sum(orders_details.quantity * orders_details.price) as tongTien,
orders.order_date , sum(orders_details.quantity) as tongSoLuongSanPham
FROM customer
JOIN orders on customer.customer_id = orders.customer_id 
JOIN orders_details on orders_details.order_id = orders.order_id
GROUP BY
orders.order_id
HAVING 
tongSoLuongSanPham >= 5
;

CREATE VIEW getOders as
SELECT customer.customer_nam, customer.customer_phone , customer.customer_address , orders.total_amount , orders.order_date
FROM customer
JOIN orders on customer.customer_id = orders.customer_id ;

CREATE VIEW getOderCount as
SELECT customer.customer_nam, customer.customer_phone , customer.customer_address , COUNT(orders.customer_id) as soDonDaDat
FROM customer 
JOIN orders on customer.customer_id = orders.customer_id 
GROUP BY
customer.customer_id
;

CREATE VIEW getProductCount as
SELECT products.* , SUM(orders_details.quantity) 
FROM products
JOIN orders_details on products.productId = orders_details.productId 
GROUP BY
products.productId ;

CREATE INDEX index_phone on customer(customer_phone);
CREATE INDEX index_address on customer(customer_address);

DELIMITER //
CREATE PROCEDURE getCustomerInfo(in id VARCHAR(4))
BEGIN
SELECT * FROM customer WHERE customer.customer_id = id;
END //
DELIMITER ;

CALL getCustomerInfo('C001');

DELIMITER //
CREATE PROCEDURE getProductsInfo()
BEGIN
SELECT * FROM products ;
END //
DELIMITER ;

CALL getProductsInfo();
DELIMITER //
CREATE PROCEDURE getOders(in id VARCHAR(4))
BEGIN
SELECT * FROM orders WHERE orders.customer_id = id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE addOrder(
IN order_id VARCHAR(4),
IN customer_id VARCHAR(4),
IN order_date DATE,
in total_amount DOUBLE
)
BEGIN
INSERT into orders(order_id,customer_id,order_date,total_amount) VALUES
(order_id,customer_id,order_date,total_amount);
SELECT * FROM orders WHERE order_id = order_id;
END //
DELIMITER ;

DROP PROCEDURE addOrder;
CALL addOrder('H018','C005','2023-12-28',150000);


DELIMITER //

CREATE PROCEDURE getProductSalesByDate(
    IN startDate DATE,
    IN endDate DATE
)
BEGIN
    SELECT 
        products.productId AS maSanPham,
        products.product_name AS tenSanPham,
        SUM(orders_details.quantity) AS soLuongBanRa
    FROM 
        products
    JOIN 
        orders_details ON products.productId = orders_details.productId
    JOIN 
        orders ON orders_details.order_id = orders.order_id
    WHERE 
        orders.order_date BETWEEN startDate AND endDate
    GROUP BY 
        products.productId, products.product_name;
END //

DELIMITER ;
