# 🚗 Vehicle Maintenance System (ASP.NET Web Forms)

The *Vehicle Maintenance System* is a web-based application developed using *ASP.NET Web Forms (ASPX)*.  
It helps users efficiently manage vehicles, keep maintenance records, set reminders, and track service history through an interactive and user-friendly interface.

---

## 📌 Features

### 🔧 Vehicle Management
- Add, edit, delete vehicle information  
- Store details like model, registration number, owner name, fuel type, etc.

### 🛠 Maintenance & Service Tracking
- Add service records  
- Track date, type of service, cost, next service due, notes  
- View complete maintenance history per vehicle

### ⏰ Service Reminder System
- Alerts for upcoming service dates  
- Dashboard showing vehicle health and pending reminders

### 👨‍💼 Admin/User Roles
- Admin can manage all vehicles and records  
- Normal users can manage only their vehicles  
- Login/Signup with authentication

### 🎨 ASPX UI
- Clean and simple UI  
- Built using ASP.NET Web Forms, C#, and ADO.NET  
- Works on all browsers

### 🗄 Database Integration
- Connected to SQL Server  
- Uses stored procedures / ADO.NET queries  
- Handles CRUD operations for vehicles and maintenance logs

---

## 🏗 Tech Stack

### Frontend
- ASP.NET Web Forms (ASPX)  
- HTML, CSS, JavaScript  
- ASP.NET Controls (GridView, TextBox, Buttons, Validators)

### Backend
- C#  
- ADO.NET  
- ASP.NET Web Forms architecture  
- Code-behind logic

### Database
- MS SQL Server  

---

## 📂 Project Structure

/VehicleMaintenanceSystem ├── App_Data ├── Models ├── Scripts ├── Styles ├── Vehicle.aspx ├── Vehicle.aspx.cs ├── Maintenance.aspx ├── Maintenance.aspx.cs ├── Login.aspx ├── Login.aspx.cs ├── Web.config └── DatabaseScripts.sql

---

## ⚙ Installation & Setup

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/yourusername/vehicle-maintenance-system.git

2️⃣ Open in Visual Studio

Open the .sln file

Restore NuGet packages if needed


3️⃣ Configure Database

Open SQL Server

Execute the DatabaseScripts.sql file to create required tables

Update Web.config connection string:


<connectionStrings>
  <add name="Conn"
       connectionString="Data Source=SERVER_NAME;Initial Catalog=DB_NAME;Integrated Security=True;" 
       providerName="System.Data.SqlClient" />
</connectionStrings>

4️⃣ Run the Project

Press F5 or click Start Debugging



---

🧪 Main Modules

✔ Vehicle Module

Add Vehicle

Update Vehicle

Delete Vehicle

View All Vehicles


✔ Maintenance Module

Add Maintenance Entry

Update Maintenance

Delete Entry

View Full History


✔ Authentication Module

Login

Logout

Session Handling



---

🎯 Screenshots (Optional)

(Add images once uploaded)


---

🤝 Contributing

1. Fork this repository


2. Create a new feature branch


3. Commit your changes


4. Submit a pull request




---

📜 License

This project is licensed under the MIT License.


---

👨‍💻 Developer

Vivek Pandey
B.Tech Computer Engineering
Built using ASP.NET Web Forms and SQL Server.

---
