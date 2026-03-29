How to Run the Belle Bear search.html
1. Start MySQL Database
Open MySQL (XAMPP / MySQL Workbench / Command Line)
Make sure the database Belle_Bear is running
Ensure tables like:
Product
Stock
If using XAMPP → Click Start on MySQL
2. Open Project in VS Code
Open your project folder in VS Code
Make sure your main server file (e.g., server.js or app.js) is inside
3. Install Dependencies (only first time)

Open terminal in VS Code and run:

npm install express mysql2
4. Start the Server

In terminal:

node server.js

(or whatever your file name is)

You should see:

Server is running on port 3000
Connected to MySQL
5. Open the Website
Open browser
Go to:
http://localhost:3000/search.html