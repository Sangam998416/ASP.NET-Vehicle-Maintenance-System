<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Vehicles.aspx.cs" Inherits="VehicleMaintenance.Vehicles" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>All Vehicles - Sarthi</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f7fa; min-height: 100vh; }
        
        /* Top Bar */
        .topbar { background: white; border-bottom: 1px solid #e0e0e0; padding: 0 30px; display: flex; justify-content: space-between; align-items: center; height: 70px; box-shadow: 0 2px 4px rgba(0,0,0,0.08); }
        .logo-section { display: flex; align-items: center; gap: 15px; }
        .logo { width: 45px; height: 45px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 10px; display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 20px; }
        .brand-name { font-size: 1.5em; font-weight: 700; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        
        /* Container */
        .container { max-width: 1400px; margin: 0 auto; padding: 30px; }
        
        /* Header */
        .page-header { background: white; border-radius: 15px; padding: 30px; margin-bottom: 25px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .page-header h1 { font-size: 2em; color: #2c3e50; margin-bottom: 10px; }
        .breadcrumb { color: #7f8c8d; font-size: 0.95em; }
        .breadcrumb a { color: #667eea; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }
        
        /* Search and Actions */
        .controls { background: white; border-radius: 15px; padding: 25px; margin-bottom: 25px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .search-bar { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; }
        .search-bar input { flex: 1; min-width: 250px; padding: 12px 15px; border: 2px solid #ddd; border-radius: 8px; font-size: 1em; }
        .search-bar input:focus { outline: none; border-color: #667eea; }
        .btn { padding: 12px 25px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border: none; border-radius: 8px; cursor: pointer; text-decoration: none; display: inline-block; font-weight: 600; transition: transform 0.2s, box-shadow 0.2s; }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4); }
        .btn-secondary { background: white; color: #667eea; border: 2px solid #667eea; }
        .btn-secondary:hover { background: #f8f9fa; }
        .btn-add { background: linear-gradient(135deg, #28a745 0%, #20c997 100%); }
        
        /* Message */
        .message { padding: 15px 20px; margin-bottom: 20px; border-radius: 8px; font-weight: 500; }
        .message.success { background: #d4edda; color: #155724; border-left: 4px solid #28a745; }
        .message.error { background: #f8d7da; color: #721c24; border-left: 4px solid #dc3545; }
        
        /* Vehicle Cards Grid */
        .vehicle-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 20px; }
        .vehicle-card { background: white; border-radius: 12px; padding: 25px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); transition: transform 0.3s, box-shadow 0.3s; border-left: 4px solid #667eea; }
        .vehicle-card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2); }
        
        .vehicle-header { display: flex; justify-content: space-between; align-items: start; margin-bottom: 15px; }
        .vehicle-title { font-size: 1.3em; font-weight: 700; color: #2c3e50; }
        .vehicle-year { font-size: 0.9em; color: #7f8c8d; margin-top: 3px; }
        
        .status-badge { padding: 6px 12px; border-radius: 20px; font-size: 0.85em; font-weight: 600; }
        .status-active { background: #d4edda; color: #155724; }
        .status-inactive { background: #f8d7da; color: #721c24; }
        
        .vehicle-details { margin: 15px 0; }
        .detail-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #f0f0f0; }
        .detail-row:last-child { border-bottom: none; }
        .detail-label { color: #7f8c8d; font-size: 0.9em; }
        .detail-value { font-weight: 600; color: #2c3e50; }
        
        .vehicle-actions { display: flex; gap: 10px; margin-top: 15px; padding-top: 15px; border-top: 2px solid #f0f0f0; }
        .action-btn { flex: 1; padding: 10px; text-align: center; text-decoration: none; border-radius: 6px; font-weight: 600; font-size: 0.9em; transition: all 0.2s; }
        .action-btn.primary { background: #e3f2fd; color: #1976d2; }
        .action-btn.primary:hover { background: #1976d2; color: white; }
        .action-btn.secondary { background: #f3e5f5; color: #7b1fa2; }
        .action-btn.secondary:hover { background: #7b1fa2; color: white; }
        
        /* Empty State */
        .empty-state { background: white; border-radius: 12px; padding: 60px 30px; text-align: center; }
        .empty-state-icon { font-size: 4em; margin-bottom: 20px; }
        .empty-state h3 { font-size: 1.5em; color: #2c3e50; margin-bottom: 10px; }
        .empty-state p { color: #7f8c8d; margin-bottom: 25px; }
        
        /* Stats Bar */
        .stats-bar { display: flex; gap: 15px; margin-bottom: 25px; flex-wrap: wrap; }
        .stat-item { background: white; border-radius: 10px; padding: 20px; flex: 1; min-width: 200px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .stat-value { font-size: 2em; font-weight: 700; color: #667eea; }
        .stat-label { color: #7f8c8d; font-size: 0.9em; margin-top: 5px; }
        
        /* Responsive */
        @media (max-width: 768px) {
            .vehicle-grid { grid-template-columns: 1fr; }
            .search-bar { flex-direction: column; }
            .search-bar input { width: 100%; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Top Navigation Bar -->
        <div class="topbar">
            <div class="logo-section">
                <div class="logo">S</div>
                <div class="brand-name">Sarthi</div>
            </div>
            <div>
                <span style="color: #7f8c8d;">Welcome, <strong><%= Session["UserName"] != null ? Session["UserName"].ToString() : "User" %></strong></span>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <h1>🚗 My Vehicles</h1>
                <div class="breadcrumb">
                    <a href="Default.aspx">← Dashboard</a> / Vehicles
                </div>
            </div>
            
            <!-- Message -->
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
            
            <!-- Stats Bar -->
            <div class="stats-bar">
                <div class="stat-item">
                    <div class="stat-value"><asp:Label ID="lblTotalCount" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Total Vehicles</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value"><asp:Label ID="lblActiveCount" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Active Vehicles</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">₹<asp:Label ID="lblTotalValue" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Total Fleet Value</div>
                </div>
            </div>
            
            <!-- Search and Actions -->
            <div class="controls">
                <div class="search-bar">
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="🔍 Search by make, model, or license plate..." />
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-secondary" OnClick="btnReset_Click" />
                    <a href="AddVehicle.aspx" class="btn btn-add">+ Add New Vehicle</a>
                </div>
            </div>

            <!-- Vehicle Cards -->
            <asp:Repeater ID="rptVehicles" runat="server">
                <HeaderTemplate>
                    <div class="vehicle-grid">
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="vehicle-card">
                        <div class="vehicle-header">
                            <div>
                                <div class="vehicle-title"><%# Eval("Make") %> <%# Eval("Model") %></div>
                                <div class="vehicle-year"><%# Eval("Year") %> Model</div>
                            </div>
                            <span class='status-badge status-<%# Eval("Status").ToString().ToLower() %>'>
                                <%# Eval("Status") %>
                            </span>
                        </div>
                        
                        <div class="vehicle-details">
                            <div class="detail-row">
                                <span class="detail-label">License Plate</span>
                                <span class="detail-value"><%# Eval("LicensePlate") %></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Color</span>
                                <span class="detail-value"><%# Eval("Color") %></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Mileage</span>
                                <span class="detail-value"><%# String.Format("{0:N0}", Eval("Mileage")) %> km</span>
                            </div>
                            <%# Eval("CurrentValue") != DBNull.Value ? 
                                "<div class='detail-row'><span class='detail-label'>Current Value</span><span class='detail-value'>₹" + 
                                String.Format("{0:N0}", Eval("CurrentValue")) + "</span></div>" : "" %>
                        </div>
                        
                        <div class="vehicle-actions">
                            <a href='VehicleHistory.aspx?id=<%# Eval("VehicleID") %>' class="action-btn primary">
                                📊 View History
                            </a>
                            <a href='EditVehicle.aspx?id=<%# Eval("VehicleID") %>' class="action-btn secondary">
                                ✏️ Edit
                            </a>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    </div>
                </FooterTemplate>
            </asp:Repeater>
            
            <!-- Empty State -->
            <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-state">
                <div class="empty-state-icon">🚗</div>
                <h3>No Vehicles Yet</h3>
                <p>Start building your fleet by adding your first vehicle</p>
                <a href="AddVehicle.aspx" class="btn btn-add">+ Add Your First Vehicle</a>
            </asp:Panel>
        </div>
    </form>
</body>
</html>