drop database Belle_Bear;

create database Belle_Bear;
use Belle_Bear;

-- Customer Table
CREATE TABLE Customer (
    Customer_ID CHAR(12) PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    Address VARCHAR(500) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE
);

-- Admin Table
CREATE TABLE Admin (
    Admin_ID CHAR(10) PRIMARY KEY,
    FN VARCHAR(50) NOT NULL,
    LN VARCHAR(50) NOT NULL,
    Address VARCHAR(500) NOT NULL,
    Age INT NOT NULL CHECK (Age BETWEEN 18 AND 65)
);

-- Product Table
CREATE TABLE Product (
    Product_ID CHAR(12) PRIMARY KEY,
    Brand VARCHAR(50) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    Release_Date DATE NOT NULL
);

-- Stock Table
CREATE TABLE Stock (
    Stock_ID CHAR(12) PRIMARY KEY,
    Size VARCHAR(10),
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    Product_ID CHAR(12) NOT NULL,
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

-- Cart Table
CREATE TABLE Cart (
    Cart_ID CHAR(12) PRIMARY KEY,
    Status VARCHAR(20) NOT NULL,
    Expired_date DATE,
    Customer_ID CHAR(12) NOT NULL,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

-- Containment Table 
CREATE TABLE Containment (
    Cart_ID CHAR(12),
    Stock_ID CHAR(12),
    Quantity INT NOT NULL CHECK (Quantity >= 1),
    PRIMARY KEY (Cart_ID, Stock_ID),
    FOREIGN KEY (Cart_ID) REFERENCES Cart(Cart_ID),
    FOREIGN KEY (Stock_ID) REFERENCES Stock(Stock_ID)
);


-- Account Table
CREATE TABLE Account (
    Account_ID CHAR(10) PRIMARY KEY,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Role VARCHAR(20) NOT NULL,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Active', 'Inactive')),
    Admin_ID CHAR(10) NOT NULL,
    FOREIGN KEY (Admin_ID) REFERENCES Admin(Admin_ID)
);

-- Log Table
CREATE TABLE Log (
    Log_ID CHAR(10) PRIMARY KEY,
    Login_time DATETIME NOT NULL,
    Logout_time DATETIME,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Success', 'Fail')),
    Account_ID CHAR(10) NOT NULL,
    FOREIGN KEY (Account_ID) REFERENCES Account(Account_ID)
);

-- Image Table
CREATE TABLE Image (
    Image_ID CHAR(12) PRIMARY KEY,
    Image_num INT NOT NULL CHECK (Image_num >= 1),
    Stock_ID CHAR(12) NOT NULL,
    FOREIGN KEY (Stock_ID) REFERENCES Stock(Stock_ID)
);

-- Manage Table 
CREATE TABLE Manage (
    Admin_ID CHAR(10),
    Product_ID CHAR(12),
    Add_Product BOOLEAN,
    Edit_Product BOOLEAN,
    Delete_Product BOOLEAN,
    PRIMARY KEY (Admin_ID, Product_ID),
    FOREIGN KEY (Admin_ID) REFERENCES Admin(Admin_ID),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

-- =========================
-- Product (15 multi-brand)
-- =========================
INSERT INTO Product VALUES
('Pro000000001','Sanrio','Usahana Plush Multi-Color','2023-01-01'),
('Pro000000002','Sanrio','Usahana Giga Plush','2023-02-01'),
('Pro000000003','Sanrio','Usahana Sitting Doll','2023-03-01'),
('Pro000000004','Sanrio','Hello Kitty Friends Usahana','2023-04-01'),
('Pro000000005','Sanrio','Bloom Usahana Plush','2023-05-01'),

('Pro000000006','Pop Mart','Labubu Classic Figure','2023-06-01'),
('Pro000000007','Pop Mart','Skullpanda Winter Series','2023-07-01'),
('Pro000000008','Pop Mart','Dimoo Space Travel Series','2023-08-01'),
('Pro000000009','Pop Mart','Molly Sweet Heart Figure','2023-09-01'),
('Pro000000010','Pop Mart','Crybaby Sad Club Figure','2023-10-01');


-- =========================
-- Stock (match Product 15)
-- =========================
INSERT INTO Stock VALUES
('Stk000000001','M',950,10,'Pro000000001'),
('Stk000000002','L',1050,5,'Pro000000002'),
('Stk000000003','M',1090,8,'Pro000000003'),
('Stk000000004','L',1200,6,'Pro000000004'),
('Stk000000005','S',1300,4,'Pro000000005'),
('Stk000000006','M',500,20,'Pro000000006'),
('Stk000000007','M',520,18,'Pro000000007'),
('Stk000000008','M',550,15,'Pro000000008'),
('Stk000000009','M',600,12,'Pro000000009'),
('Stk000000010','M',650,10,'Pro000000010');


-- =========================
-- Image (match Stock)
-- =========================
INSERT INTO Image VALUES
('Img000000001',1,'Stk000000001'),
('Img000000002',1,'Stk000000002'),
('Img000000003',1,'Stk000000003'),
('Img000000004',1,'Stk000000004'),
('Img000000005',1,'Stk000000005'),
('Img000000006',1,'Stk000000006'),
('Img000000007',1,'Stk000000007'),
('Img000000008',1,'Stk000000008'),
('Img000000009',1,'Stk000000009'),
('Img000000010',1,'Stk000000010');


INSERT INTO Admin VALUES
('Adm0000001','A','A','BKK',25),
('Adm0000002','A','A','BKK',25),
('Adm0000003','A','A','BKK',25),
('Adm0000004','A','A','BKK',25),
('Adm0000005','A','A','BKK',25),
('Adm0000006','A','A','BKK',25),
('Adm0000007','A','A','BKK',25),
('Adm0000008','A','A','BKK',25),
('Adm0000009','A','A','BKK',25),
('Adm0000010','A','A','BKK',25);


-- =========================
-- Manage (Admin ↔ Product)
-- =========================
INSERT INTO Manage VALUES
('Adm0000001','Pro000000001',1,1,0),
('Adm0000002','Pro000000002',1,0,0),
('Adm0000003','Pro000000003',1,1,1),
('Adm0000004','Pro000000004',1,0,0),
('Adm0000005','Pro000000005',1,1,0),
('Adm0000006','Pro000000006',1,0,1),
('Adm0000007','Pro000000007',1,1,0),
('Adm0000008','Pro000000008',1,0,0),
('Adm0000009','Pro000000009',1,1,1),
('Adm0000010','Pro000000010',1,0,0);
