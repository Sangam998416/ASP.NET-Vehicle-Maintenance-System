<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Maintenance.aspx.cs" Inherits="VehicleMaintenance.Maintenance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Maintenance Records - Sarthi</title>
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
        
        /* Stats Bar */
        .stats-bar { display: flex; gap: 15px; margin-bottom: 25px; flex-wrap: wrap; }
        .stat-item { background: white; border-radius: 10px; padding: 20px; flex: 1; min-width: 200px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-left: 4px solid #667eea; }
        .stat-value { font-size: 2em; font-weight: 700; color: #667eea; }
        .stat-label { color: #7f8c8d; font-size: 0.9em; margin-top: 5px; }
        
        /* Filter Section */
        .filter-section { background: white; border-radius: 15px; padding: 25px; margin-bottom: 25px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .filter-title { font-size: 1.1em; font-weight: 600; color: #2c3e50; margin-bottom: 15px; }
        .filter-row { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 15px; margin-bottom: 20px; }
        .filter-group label { display: block; margin-bottom: 8px; color: #2c3e50; font-weight: 600; font-size: 0.9em; }
        .filter-group select, .filter-group input { width: 100%; padding: 12px; border: 2px solid #ddd; border-radius: 8px; font-size: 1em; }
        .filter-group select:focus, .filter-group input:focus { outline: none; border-color: #667eea; }
        
        /* Buttons */
        .button-group { display: flex; gap: 10px; flex-wrap: wrap; }
        .btn { padding: 12px 25px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 1em; transition: all 0.3s; text-decoration: none; display: inline-block; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4); }
        .btn-secondary { background: white; color: #7f8c8d; border: 2px solid #ddd; }
        .btn-secondary:hover { background: #f8f9fa; border-color: #667eea; color: #667eea; }
        .btn-success { background: linear-gradient(135deg, #28a745 0%, #20c997 100%); color: white; }
        .btn-success:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4); }
        
        /* Message */
        .message { padding: 15px 20px; margin-bottom: 25px; border-radius: 8px; font-weight: 500; }
        .message.success { background: #d4edda; color: #155724; border-left: 4px solid #28a745; }
        .message.error { background: #f8d7da; color: #721c24; border-left: 4px solid #dc3545; }
        
        /* Maintenance Cards */
        .maintenance-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(380px, 1fr)); gap: 20px; }
        .maintenance-card { background: white; border-radius: 12px; padding: 25px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); transition: transform 0.3s, box-shadow 0.3s; border-left: 4px solid #667eea; }
        .maintenance-card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2); }
        
        .card-header { display: flex; justify-content: space-between; align-items: start; margin-bottom: 15px; padding-bottom: 15px; border-bottom: 2px solid #f0f0f0; }
        .service-type { font-size: 1.2em; font-weight: 700; color: #2c3e50; }
        .service-date { font-size: 0.9em; color: #7f8c8d; background: #f8f9fa; padding: 6px 12px; border-radius: 20px; }
        
        .vehicle-info { font-size: 1em; color: #667eea; font-weight: 600; margin-bottom: 15px; }
        
        .card-details { margin: 15px 0; }
        .detail-row { display: flex; justify-content: space-between; padding: 8px 0; }
        .detail-label { color: #7f8c8d; font-size: 0.9em; }
        .detail-value { font-weight: 600; color: #2c3e50; }
        .cost-value { color: #28a745; font-size: 1.1em; font-weight: 700; }
        
        .description { background: #f8f9fa; padding: 12px; border-radius: 8px; margin-top: 12px; font-size: 0.9em; color: #666; line-height: 1.5; }
        
        /* Empty State */
        .empty-state { background: white; border-radius: 12px; padding: 60px 30px; text-align: center; }
        .empty-state-icon { font-size: 4em; margin-bottom: 20px; }
        .empty-state h3 { font-size: 1.5em; color: #2c3e50; margin-bottom: 10px; }
        .empty-state p { color: #7f8c8d; margin-bottom: 25px; }
        
        /* Responsive */
        @media (max-width: 768px) {
            .maintenance-grid { grid-template-columns: 1fr; }
            .filter-row { grid-template-columns: 1fr; }
            .button-group { flex-direction: column; }
            .btn { width: 100%; }
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
                <h1>🔧 My Maintenance Records</h1>
                <div class="breadcrumb">
                    <a href="Default.aspx">← Dashboard</a> / Maintenance Records
                </div>
            </div>
            
            <!-- Message -->
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
            
            <!-- Stats Bar -->
            <div class="stats-bar">
                <div class="stat-item">
                    <div class="stat-value"><asp:Label ID="lblTotalRecords" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Total Services</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">₹<asp:Label ID="lblTotalCost" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Total Maintenance Cost</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">₹<asp:Label ID="lblAvgCost" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Average Cost per Service</div>
                </div>
            </div>
            
            <!-- Filter Section -->
            <div class="filter-section">
                <div class="filter-title">🔍 Filter Records</div>
                <div class="filter-row">
                    <div class="filter-group">
                        <label>Filter by Vehicle</label>
                        <asp:DropDownList ID="ddlFilterVehicle" runat="server"></asp:DropDownList>
                    </div>
                    <div class="filter-group">
                        <label>Service Type</label>
                        <asp:DropDownList ID="ddlFilterServiceType" runat="server"></asp:DropDownList>
                    </div>
                    <div class="filter-group">
                        <label>Start Date</label>
                        <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date" />
                    </div>
                    <div class="filter-group">
                        <label>End Date</label>
                        <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date" />
                    </div>
                </div>
                <div class="button-group">
                    <asp:Button ID="btnFilter" runat="server" Text="🔍 Apply Filters" CssClass="btn btn-primary" OnClick="btnFilter_Click" />
                    <asp:Button ID="btnReset" runat="server" Text="↺ Reset" CssClass="btn btn-secondary" OnClick="btnReset_Click" />
                    <a href="AddMaintenance.aspx" class="btn btn-success">+ Add Maintenance Record</a>
                </div>
            </div>

            <!-- Maintenance Cards -->
            <asp:Repeater ID="rptMaintenance" runat="server">
                <HeaderTemplate>
                    <div class="maintenance-grid">
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="maintenance-card">
                        <div class="card-header">
                            <div class="service-type"><%# Eval("ServiceType") %></div>
                            <div class="service-date">📅 <%# Convert.ToDateTime(Eval("ServiceDate")).ToString("dd MMM yyyy") %></div>
                        </div>
                        
                        <div class="vehicle-info">🚗 <%# Eval("VehicleInfo") %></div>
                        
                        <div class="card-details">
                            <div class="detail-row">
                                <span class="detail-label">Mileage</span>
                                <span class="detail-value"><%# String.Format("{0:N0}", Eval("Mileage")) %> km</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Cost</span>
                                <span class="cost-value">₹<%# String.Format("{0:N0}", Eval("Cost")) %></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Service Provider</span>
                                <span class="detail-value"><%# Eval("ServiceProvider") %></span>
                            </div>
                            <%# Eval("NextServiceDate") != DBNull.Value ? 
                                "<div class='detail-row'><span class='detail-label'>Next Service</span><span class='detail-value'>📅 " + 
                                Convert.ToDateTime(Eval("NextServiceDate")).ToString("dd MMM yyyy") + "</span></div>" : "" %>
                        </div>
                        
                        <%# !string.IsNullOrEmpty(Eval("Description").ToString()) ? 
                            "<div class='description'>📝 " + Eval("Description") + "</div>" : "" %>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    </div>
                </FooterTemplate>
            </asp:Repeater>
            
            <!-- Empty State -->
            <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-state">
                <div class="empty-state-icon">🔧</div>
                <h3>No Maintenance Records Yet</h3>
                <p>Start tracking your vehicle maintenance by adding your first service record</p>
                <a href="AddMaintenance.aspx" class="btn btn-success">+ Add First Maintenance Record</a>
            </asp:Panel>
        </div>
    </form>
</body>
</html>