<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VehicleHistory.aspx.cs" Inherits="VehicleMaintenance.VehicleHistory" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Vehicle History - Sarthi</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f7fa; }
        
        /* Top Navigation Bar */
        .topbar { background: white; border-bottom: 1px solid #e0e0e0; padding: 0 30px; display: flex; justify-content: space-between; align-items: center; height: 70px; box-shadow: 0 2px 4px rgba(0,0,0,0.08); }
        .logo-section { display: flex; align-items: center; gap: 15px; }
        .logo { 
            width: 45px; 
            height: 45px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            border-radius: 10px; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 24px; 
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        .logo::before {
            content: '';
            position: absolute;
            width: 60%;
            height: 60%;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            top: -10%;
            right: -10%;
        }
        .logo-text {
            color: white;
            font-weight: 700;
            font-size: 20px;
            z-index: 1;
        }
        .brand-name { 
            font-size: 1.5em; 
            font-weight: 700; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .brand-tagline { font-size: 0.75em; color: #7f8c8d; font-weight: 400; }
        
        .user-section { display: flex; align-items: center; gap: 20px; }
        .notification-icon { position: relative; cursor: pointer; font-size: 20px; color: #7f8c8d; }
        .notification-badge { position: absolute; top: -5px; right: -5px; background: #e74c3c; color: white; border-radius: 50%; width: 18px; height: 18px; font-size: 11px; display: flex; align-items: center; justify-content: center; }
        .user-profile { display: flex; align-items: center; gap: 12px; cursor: pointer; padding: 8px 15px; border-radius: 25px; transition: background 0.3s; position: relative; }
        .user-profile:hover { background: #f8f9fa; }
        .user-avatar { width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-weight: 600; font-size: 16px; }
        .user-info { text-align: left; }
        .user-name { font-weight: 600; color: #2c3e50; font-size: 0.95em; }
        .user-role { font-size: 0.8em; color: #7f8c8d; }
        
        /* Dropdown Menu */
        .dropdown-menu { 
            display: none; 
            position: absolute; 
            top: 100%; 
            right: 0; 
            background: white; 
            border-radius: 10px; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.15); 
            min-width: 220px; 
            margin-top: 10px; 
            z-index: 1000;
            overflow: hidden;
        }
        .user-profile:hover .dropdown-menu { display: block; }
        .dropdown-menu a { 
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 20px; 
            color: #2c3e50; 
            text-decoration: none; 
            transition: background 0.3s;
            font-size: 0.95em;
        }
        .dropdown-menu a:hover { background: #f8f9fa; }
        .dropdown-menu a .icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }
        .dropdown-menu a.profile-link .icon { background: #e3f2fd; }
        .dropdown-menu a.settings-link .icon { background: #f3e5f5; }
        .dropdown-menu a.logout-link { 
            color: #e74c3c; 
            border-top: 1px solid #f0f0f0;
        }
        .dropdown-menu a.logout-link .icon { background: #ffebee; }
        
        /* Main Container */
        .container { max-width: 1400px; margin: 0 auto; padding: 30px; }
        
        /* Page Header */
        .page-header { 
            background: white; 
            border-radius: 15px; 
            padding: 30px; 
            margin-bottom: 25px; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .page-title { 
            font-size: 1.8em; 
            color: #2c3e50; 
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .back-link { 
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            color: white; 
            text-decoration: none; 
            border-radius: 10px;
            font-weight: 600;
            transition: transform 0.3s, box-shadow 0.3s;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        .back-link:hover { 
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }
        
        /* Select Section */
        .select-section { 
            background: white; 
            padding: 30px; 
            border-radius: 15px; 
            margin-bottom: 25px; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .select-section label { 
            display: block; 
            margin-bottom: 12px; 
            color: #2c3e50; 
            font-weight: 600; 
            font-size: 1.1em;
        }
        .select-section select { 
            width: 100%; 
            max-width: 600px; 
            padding: 15px; 
            border: 2px solid #e0e0e0; 
            border-radius: 10px; 
            font-size: 1em;
            background: white;
            transition: border-color 0.3s;
        }
        .select-section select:focus { 
            outline: none; 
            border-color: #667eea; 
        }
        
        /* Vehicle Info Card */
        .vehicle-info { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            color: white; 
            padding: 35px; 
            border-radius: 15px; 
            margin-bottom: 25px; 
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }
        .vehicle-header { 
            margin-bottom: 25px; 
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }
        .vehicle-title { 
            font-size: 2.2em; 
            font-weight: 700; 
            margin-bottom: 8px;
        }
        .vehicle-subtitle { 
            font-size: 1.3em; 
            opacity: 0.95; 
        }
        .vehicle-details { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); 
            gap: 20px; 
        }
        .detail-item { 
            background: rgba(255,255,255,0.15); 
            padding: 20px; 
            border-radius: 12px; 
            backdrop-filter: blur(10px);
        }
        .detail-label { 
            font-size: 0.9em; 
            opacity: 0.9; 
            margin-bottom: 8px; 
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .detail-value { 
            font-size: 1.4em; 
            font-weight: 700; 
        }
        
        /* Stats Section */
        .stats-section { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); 
            gap: 20px; 
            margin-bottom: 30px; 
        }
        .stat-card { 
            background: white; 
            padding: 25px; 
            border-radius: 15px; 
            text-align: center; 
            border-left: 4px solid #667eea;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2);
        }
        .stat-value { 
            font-size: 2.5em; 
            font-weight: 700; 
            color: #667eea; 
            margin-bottom: 8px; 
        }
        .stat-label { 
            color: #7f8c8d; 
            font-size: 1em;
            font-weight: 500;
        }
        
        /* History Section */
        .history-section { 
            background: white; 
            padding: 30px; 
            border-radius: 15px; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .section-title { 
            font-size: 1.5em; 
            color: #2c3e50; 
            font-weight: 700; 
            margin-bottom: 25px; 
            padding-bottom: 15px; 
            border-bottom: 3px solid #667eea;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Grid Styling */
        .grid-container { overflow-x: auto; margin-top: 20px; }
        .history-grid { 
            width: 100%; 
            border-collapse: collapse; 
        }
        .history-grid th { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            color: white; 
            padding: 15px; 
            text-align: left; 
            font-size: 0.95em;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .history-grid th:first-child { border-radius: 10px 0 0 0; }
        .history-grid th:last-child { border-radius: 0 10px 0 0; }
        .history-grid td { 
            padding: 15px; 
            border-bottom: 1px solid #e0e0e0; 
            font-size: 0.95em;
            color: #2c3e50;
        }
        .history-grid tr:hover { background: #f8f9fa; }
        .history-grid tr:last-child td { border-bottom: none; }
        .cost-cell { 
            font-weight: 700; 
            color: #27ae60; 
            font-size: 1.05em;
        }
        .date-cell { 
            color: #7f8c8d; 
            font-weight: 500;
        }
        
        /* No Selection State */
        .no-selection { 
            text-align: center; 
            padding: 80px 20px; 
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .no-selection-icon {
            font-size: 4em;
            margin-bottom: 20px;
        }
        .no-selection h2 { 
            color: #2c3e50; 
            margin-bottom: 15px; 
            font-size: 1.8em;
        }
        .no-selection p {
            color: #7f8c8d;
            font-size: 1.1em;
            line-height: 1.6;
        }
        
        /* Message Styling */
        .message { 
            padding: 15px 20px; 
            margin-bottom: 20px; 
            border-radius: 10px;
            font-weight: 500;
        }
        .message.error { 
            background: #fee; 
            color: #c33; 
            border-left: 4px solid #e74c3c; 
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Top Navigation Bar -->
        <div class="topbar">
            <div class="logo-section">
                <div class="logo">
                    <span class="logo-text">S</span>
                </div>
                <div>
                    <div class="brand-name">Sarthi</div>
                    <div class="brand-tagline">Vehicle Maintenance Management</div>
                </div>
            </div>
            
            <div class="user-section">
                <div class="notification-icon">
                    🔔
                    <span class="notification-badge">3</span>
                </div>
                <div class="user-profile">
                    <div class="user-avatar">
                        <%= Session["UserInitials"] != null ? Session["UserInitials"].ToString() : "U" %>
                    </div>
                    <div class="user-info">
                        <div class="user-name">
                            <%= Session["UserName"] != null ? Session["UserName"].ToString() : "User" %>
                        </div>
                        <div class="user-role">
                            <%= Session["UserRole"] != null ? Session["UserRole"].ToString() : "User" %>
                        </div>
                    </div>
                    
                    <!-- Dropdown Menu -->
                    <div class="dropdown-menu">
                        <a href="UserProfile.aspx" class="profile-link">
                            <span class="icon">👤</span>
                            <span>My Profile</span>
                        </a>
                        <a href="Settings.aspx" class="settings-link">
                            <span class="icon">⚙️</span>
                            <span>Settings</span>
                        </a>
                        <a href="Logout.aspx" class="logout-link">
                            <span class="icon">🚪</span>
                            <span>Logout</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="page-title">
                    📖 Vehicle Maintenance History
                </div>
                <a href="Default.aspx" class="back-link">
                    ← Back to Dashboard
                </a>
            </div>
            
            <asp:Label ID="lblMessage" runat="server" CssClass="message error" Visible="false"></asp:Label>

            <!-- Vehicle Selection -->
            <div class="select-section">
                <label>🚗 Select a Vehicle to View History:</label>
                <asp:DropDownList ID="ddlVehicle" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlVehicle_SelectedIndexChanged"></asp:DropDownList>
            </div>

            <!-- Vehicle Info Panel -->
            <asp:Panel ID="pnlVehicleInfo" runat="server" Visible="false">
                <div class="vehicle-info">
                    <div class="vehicle-header">
                        <div class="vehicle-title">
                            <asp:Literal ID="litVehicleName" runat="server"></asp:Literal>
                        </div>
                        <div class="vehicle-subtitle">
                            <asp:Literal ID="litModel" runat="server"></asp:Literal>
                        </div>
                    </div>
                    <div class="vehicle-details">
                        <div class="detail-item">
                            <div class="detail-label">Year</div>
                            <div class="detail-value"><asp:Literal ID="litYear" runat="server"></asp:Literal></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">License Plate</div>
                            <div class="detail-value"><asp:Literal ID="litLicensePlate" runat="server"></asp:Literal></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Current Mileage</div>
                            <div class="detail-value"><asp:Literal ID="litMileage" runat="server"></asp:Literal></div>
                        </div>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="stats-section">
                    <div class="stat-card">
                        <div class="stat-value"><asp:Label ID="lblTotalServices" runat="server" Text="0"></asp:Label></div>
                        <div class="stat-label">Total Services</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">₹<asp:Label ID="lblTotalCost" runat="server" Text="0"></asp:Label></div>
                        <div class="stat-label">Total Cost</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value"><asp:Label ID="lblLastService" runat="server" Text="N/A"></asp:Label></div>
                        <div class="stat-label">Last Service</div>
                    </div>
                </div>

                <!-- Maintenance History Grid -->
                <div class="history-section">
                    <div class="section-title">
                        🔧 Maintenance History
                    </div>
                    <div class="grid-container">
                        <asp:GridView ID="gvHistory" runat="server" CssClass="history-grid" 
                            AutoGenerateColumns="False" EmptyDataText="No maintenance records found for this vehicle.">
                            <Columns>
                                <asp:BoundField DataField="ServiceDate" HeaderText="Date" DataFormatString="{0:dd/MM/yyyy}" HtmlEncode="false" ItemStyle-CssClass="date-cell" />
                                <asp:BoundField DataField="ServiceType" HeaderText="Service Type" />
                                <asp:BoundField DataField="Mileage" HeaderText="Mileage" DataFormatString="{0:N0} km" HtmlEncode="false" />
                                <asp:BoundField DataField="Cost" HeaderText="Cost" DataFormatString="₹{0:N0}" HtmlEncode="false" ItemStyle-CssClass="cost-cell" />
                                <asp:BoundField DataField="ServiceProvider" HeaderText="Service Provider" />
                                <asp:BoundField DataField="Description" HeaderText="Description" />
                                <asp:BoundField DataField="NextServiceDate" HeaderText="Next Service" DataFormatString="{0:dd/MM/yyyy}" HtmlEncode="false" ItemStyle-CssClass="date-cell" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </asp:Panel>

            <!-- No Selection State -->
            <asp:Panel ID="pnlNoSelection" runat="server" Visible="true">
                <div class="no-selection">
                    <div class="no-selection-icon">🚗</div>
                    <h2>Select a Vehicle</h2>
                    <p>Choose a vehicle from the dropdown above to view its complete maintenance history and statistics.</p>
                </div>
            </asp:Panel>
        </div>
    </form>
</body>
</html>