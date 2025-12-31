CREATE DATABASE product_management_system;
USE product_management_system;

-- USERS TABLE
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(100),
    role VARCHAR(20)
);

-- PRODUCT TABLE
CREATE TABLE product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    price DOUBLE,
    quantity INT,
    description VARCHAR(255)
);

-- CART TABLE
CREATE TABLE cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_email VARCHAR(100),
    product_id INT,
    pname VARCHAR(100),
    price DOUBLE,
    quantity INT
);

-- ORDERS TABLE
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_email VARCHAR(100),
    total_amount DOUBLE,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20)
);

-- ORDER ITEMS TABLE
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    pname VARCHAR(100),
    price DOUBLE,
    quantity INT
);

-- ADMIN USER (DEFAULT)
INSERT INTO users(name, email, password, role)
VALUES ('Admin', 'admin@gmail.com', 'admin123', 'admin');
