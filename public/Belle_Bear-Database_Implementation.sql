DROP DATABASE IF EXISTS Belle_Bear;

CREATE DATABASE Belle_Bear;
USE Belle_Bear;

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
    Name VARCHAR(100) NOT NULL,
    Release_Date DATE NOT NULL,
    Description TEXT NOT NULL
);

-- Stock Table
CREATE TABLE Stock (
    Stock_ID CHAR(12) PRIMARY KEY,
    Size VARCHAR(30),
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
    Image_Data LONGTEXT,
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

-- Product (15 multi-brand)
INSERT INTO Product VALUES
('Pro000000001','Sanrio','Sanrio Usahana Plush Multi-Color','2023-01-01',
'Medium size Usahana plush in pastel multi-color design. Soft and lightweight, ideal for display or gifting.'),

('Pro000000002','Build-A-Bear x Sanrio','Sanrio Usahana Plush (Build-A-Bear)','2023-02-01',
'Official Usahana plush from Build-A-Bear Workshop featuring soft yellow fur and colorful pastel ears. Customizable with outfits and accessories.'),

('Pro000000003','Sanrio','Sanrio Sugarbunnies Kurousa Fluffy Heart Plush','2023-03-01',
'Sanrio Sugarbunnies Kurousa plush from the Heisei Characters Fluffy Heart Series. Features soft brown fur, fluffy heart detail, and pastel hat.'),

('Pro000000004','Sanrio','Sanrio Pochacco Dress-Up Plush Doll','2023-04-01',
'Sanrio Pochacco dress-up plush featuring two interchangeable outfits and posable ears and arms. Soft fluffy material with a cute collectible design.'),

('Pro000000005','Pop Mart','THE MONSTERS x Hello Kitty Vinyl Plush Doll','2023-05-01',
'Labubu x Hello Kitty vinyl plush doll from Pop Mart featuring a hybrid design with vinyl face and soft plush body. A collectible art toy collaboration.'),

('Pro000000006','Monchhichi','Monchhichi Sweet Sugar Large Plush','2023-06-01',
'Large Monchhichi plush from the Sweet Sugar collection featuring soft pastel colors and fluffy texture. Perfect for hugging and collectors.'),

('Pro000000007','Monchhichi','Monchhichi Kindergarten Style Plush','2023-07-01',
'Monchhichi plush in kindergarten school uniform with yellow hat and shoulder bag. Discontinued collectible item from Japan.'),

('Pro000000008','Fuggler','Fuggler Gremlins Gizmo Plush','2023-08-01',
'Fuggler x Gremlins Gizmo plush featuring the signature creepy-cute design with human-like teeth. A unique collectible collaboration item.'),

('Pro000000009','Disney','ShellieMay Springtime Voyage Plush','2023-09-01',
'ShellieMay plush from Duffy and Friends Springtime Voyage 2026 collection featuring a pastel spring outfit. Soft and collectible Disneyland exclusive item.'),

('Pro000000010','Disney','CookieAnn Plush Hand Puppet','2023-10-01',
'CookieAnn plush hand puppet from Duffy and Friends. Soft plush design with interactive puppet feature, perfect for play and collection.'),

('Pro000000011','Disney','Minnie x ShellieMay Plush','2023-11-01',
'HKDL 2026 ShellieMay plush dressed in Minnie Mouse style from Duffy and Friends 2026 collection. A soft and collectible Hong Kong Disneyland exclusive.'),

('Pro000000012','Jellycat','Jellycat Peanut Penguin Plush','2023-12-01',
'Jellycat Peanut Penguin plush toy featuring super soft fabric and a cute rounded design. A popular collectible soft toy from the UK.'),

('Pro000000013','Jellycat','Jellycat Bashful Bunny Snow Suit','2024-01-01',
'Jellycat Bashful Bunny plush dressed in a cozy snow suit. Features ultra-soft fabric and a winter-themed design, perfect for gifting and collecting.'),

('Pro000000014','Disney','Toy Story Alien Plush','2024-02-01',
'Official Disney Store Toy Story Alien plush featuring soft velour fabric and embroidered details. Inspired by the Pizza Planet alien character.'),

('Pro000000015','Sanei Boeki','Crayon Shin-chan School Uniform Plush','2024-03-01',
'Crayon Shin-chan plush in school uniform from the Transformation series by Sanei Boeki. Soft and collectible Japanese plush toy.');

-- Stock (match Product 15)
INSERT INTO Stock VALUES
('Stk000000001','9-10 inch (M)',950,18,'Pro000000001'),
('Stk000000002','16 inch (L)',1350,4,'Pro000000002'),
('Stk000000003','8.5 inch (M)',1350,10,'Pro000000003'),
('Stk000000004','8.5 inch (M)',1000,12,'Pro000000004'),
('Stk000000005','15 inch (L)',3190,14,'Pro000000005'),

('Stk000000006','15 inch (L)',3900,1,'Pro000000006'),
('Stk000000007','9 inch (M)',1550,2,'Pro000000007'),
('Stk000000008','9 inch (M)',990,6,'Pro000000008'),
('Stk000000009','6 inch (S)',2000,12,'Pro000000009'),
('Stk000000010','9.4 inch (M)',2100,2,'Pro000000010'),

('Stk000000011','10-12 inch (M)',1350,10,'Pro000000011'),
('Stk000000012','9 inch (M)',1400,21,'Pro000000012'),
('Stk000000013','9 inch (M)',2500,8,'Pro000000013'),
('Stk000000014','8 inch (M)',820,14,'Pro000000014'),
('Stk000000015','9 inch (M)',500,15,'Pro000000015');

-- Image (match Stock)
INSERT INTO Image VALUES
('Img000000001',1,'Stk000000001', NULL),
('Img000000002',1,'Stk000000002', NULL),
('Img000000003',1,'Stk000000003', NULL),
('Img000000004',1,'Stk000000004', NULL),
('Img000000005',1,'Stk000000005', NULL),
('Img000000006',1,'Stk000000006', NULL),
('Img000000007',1,'Stk000000007', NULL),
('Img000000008',1,'Stk000000008', NULL),
('Img000000009',1,'Stk000000009', NULL),
('Img000000010',1,'Stk000000010', NULL),
('Img000000011',1,'Stk000000011', NULL),
('Img000000012',1,'Stk000000012', NULL),
('Img000000013',1,'Stk000000013', NULL),
('Img000000014',1,'Stk000000014', NULL),
('Img000000015',1,'Stk000000015', NULL);

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
('Adm0000010','A','A','BKK',25),
('Adm0000011','A','A','BKK',25),
('Adm0000012','A','A','BKK',25),
('Adm0000013','A','A','BKK',25),
('Adm0000014','A','A','BKK',25),
('Adm0000015','A','A','BKK',25);

-- Manage (Admin ↔ Product)
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
('Adm0000010','Pro000000010',1,0,0),
('Adm0000011','Pro000000011',1,1,0),
('Adm0000012','Pro000000012',1,0,1),
('Adm0000013','Pro000000013',1,1,0),
('Adm0000014','Pro000000014',1,0,0),
('Adm0000015','Pro000000015',1,1,1);
