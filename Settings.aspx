<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="VehicleMaintenance.Settings" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Settings - Sarthi</title>
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
        .page-subtitle { color: #7f8c8d; font-size: 1.05em; margin-top: 8px; }
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
        
        /* Settings Grid */
        .settings-grid { display: grid; grid-template-columns: 280px 1fr; gap: 25px; }
        
        /* Settings Sidebar */
        .settings-sidebar { background: white; border-radius: 15px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); height: fit-content; position: sticky; top: 30px; }
        .sidebar-item { padding: 15px 18px; border-radius: 10px; cursor: pointer; transition: all 0.3s; margin-bottom: 8px; display: flex; align-items: center; gap: 12px; color: #2c3e50; text-decoration: none; }
        .sidebar-item:hover { background: #f8f9fa; }
        .sidebar-item.active { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3); }
        .sidebar-icon { font-size: 20px; }
        .sidebar-label { font-weight: 500; font-size: 0.95em; }
        
        /* Settings Content */
        .settings-content { background: white; border-radius: 15px; padding: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .settings-section { display: none; }
        .settings-section.active { display: block; }
        
        .section-title { font-size: 1.4em; color: #2c3e50; font-weight: 600; margin-bottom: 10px; }
        .section-desc { color: #7f8c8d; margin-bottom: 30px; line-height: 1.6; }
        
        /* Form Styles */
        .form-group { margin-bottom: 25px; }
        .form-label { display: block; font-weight: 600; color: #2c3e50; margin-bottom: 10px; font-size: 0.95em; }
        .form-label .optional { color: #7f8c8d; font-weight: 400; font-size: 0.9em; }
        .form-input { width: 100%; padding: 12px 16px; border: 2px solid #e0e0e0; border-radius: 10px; font-size: 1em; transition: all 0.3s; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .form-input:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1); }
        .form-textarea { min-height: 120px; resize: vertical; }
        .form-select { cursor: pointer; }
        
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        
        .form-help { font-size: 0.85em; color: #7f8c8d; margin-top: 6px; line-height: 1.4; }
        
        /* Toggle Switch */
        .toggle-group { display: flex; justify-content: space-between; align-items: center; padding: 18px 20px; background: #f8f9fa; border-radius: 12px; margin-bottom: 15px; }
        .toggle-info { flex: 1; }
        .toggle-label { font-weight: 600; color: #2c3e50; margin-bottom: 4px; }
        .toggle-desc { font-size: 0.85em; color: #7f8c8d; }
        
        .toggle-switch { position: relative; width: 52px; height: 28px; }
        .toggle-switch input { display: none; }
        .toggle-slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #ccc; transition: 0.4s; border-radius: 28px; }
        .toggle-slider:before { position: absolute; content: ""; height: 20px; width: 20px; left: 4px; bottom: 4px; background-color: white; transition: 0.4s; border-radius: 50%; }
        .toggle-switch input:checked + .toggle-slider { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .toggle-switch input:checked + .toggle-slider:before { transform: translateX(24px); }
        
        /* Button Styles */
        .btn-group { display: flex; gap: 15px; margin-top: 30px; padding-top: 30px; border-top: 1px solid #e0e0e0; }
        .btn { padding: 14px 32px; border: none; border-radius: 10px; font-size: 1em; font-weight: 600; cursor: pointer; transition: all 0.3s; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3); }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4); }
        .btn-secondary { background: #f8f9fa; color: #2c3e50; }
        .btn-secondary:hover { background: #e9ecef; }
        
        /* Alert Messages */
        .alert { padding: 16px 20px; border-radius: 10px; margin-bottom: 25px; display: flex; align-items: center; gap: 12px; }
        .alert-success { background: #d4edda; color: #155724; border-left: 4px solid #28a745; }
        .alert-error { background: #f8d7da; color: #721c24; border-left: 4px solid #e74c3c; }
        .alert-icon { font-size: 20px; }
        
        /* Info Card */
        .info-card { background: #f0f7ff; border: 2px solid #bee5ff; border-radius: 12px; padding: 20px; margin-bottom: 25px; }
        .info-card-title { font-weight: 600; color: #0056b3; margin-bottom: 8px; display: flex; align-items: center; gap: 10px; }
        .info-card-text { color: #004085; font-size: 0.9em; line-height: 1.6; }
        
        /* Stats Card */
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 25px;
        }
        .stats-card-title {
            font-size: 0.9em;
            opacity: 0.9;
            margin-bottom: 8px;
        }
        .stats-card-value {
            font-size: 2em;
            font-weight: 700;
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
                <div>
                    <div class="page-title">
                        ⚙️ User Settings
                    </div>
                    <div class="page-subtitle">Manage your personal preferences and account settings</div>
                </div>
                <a href="Default.aspx" class="back-link">
                    ← Back to Dashboard
                </a>
            </div>
            
            <!-- Settings Grid -->
            <div class="settings-grid">
                <!-- Sidebar -->
                <div class="settings-sidebar">
                    <div class="sidebar-item active" onclick="showSection('profile')">
                        <span class="sidebar-icon">👤</span>
                        <span class="sidebar-label">My Profile</span>
                    </div>
                    <div class="sidebar-item" onclick="showSection('notifications')">
                        <span class="sidebar-icon">🔔</span>
                        <span class="sidebar-label">Notifications</span>
                    </div>
                    <div class="sidebar-item" onclick="showSection('preferences')">
                        <span class="sidebar-icon">🎯</span>
                        <span class="sidebar-label">Preferences</span>
                    </div>
                    <div class="sidebar-item" onclick="showSection('security')">
                        <span class="sidebar-icon">🔒</span>
                        <span class="sidebar-label">Security</span>
                    </div>
                    <div class="sidebar-item" onclick="showSection('data')">
                        <span class="sidebar-icon">💾</span>
                        <span class="sidebar-label">My Data</span>
                    </div>
                </div>
                
                <!-- Content Area -->
                <div class="settings-content">
                    <!-- Profile Section -->
                    <div id="profile" class="settings-section active">
                        <div class="section-title">My Profile</div>
                        <div class="section-desc">Manage your personal information and contact details</div>
                        
                        <asp:Panel ID="pnlSuccessProfile" runat="server" CssClass="alert alert-success" Visible="false">
                            <span class="alert-icon">✓</span>
                            <span>Profile updated successfully!</span>
                        </asp:Panel>
                        
                        <asp:Panel ID="pnlErrorProfile" runat="server" CssClass="alert alert-error" Visible="false">
                            <span class="alert-icon">⚠</span>
                            <asp:Label ID="lblErrorProfile" runat="server"></asp:Label>
                        </asp:Panel>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">First Name *</label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-input" placeholder="Enter first name"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Last Name *</label>
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-input" placeholder="Enter last name"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Email Address *</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" TextMode="Email" placeholder="your.email@example.com"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Phone Number</label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-input" placeholder="+91 98765 43210"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Address</label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-input form-textarea" TextMode="MultiLine" placeholder="Enter your address"></asp:TextBox>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">City</label>
                                <asp:TextBox ID="txtCity" runat="server" CssClass="form-input" placeholder="City"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label class="form-label">State</label>
                                <asp:TextBox ID="txtState" runat="server" CssClass="form-input" placeholder="State"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">PIN Code</label>
                            <asp:TextBox ID="txtPincode" runat="server" CssClass="form-input" placeholder="360001" MaxLength="6"></asp:TextBox>
                        </div>
                        
                        <div class="btn-group">
                            <asp:Button ID="btnSaveProfile" runat="server" CssClass="btn btn-primary" Text="Save Changes" OnClick="btnSaveProfile_Click" />
                            <asp:Button ID="btnResetProfile" runat="server" CssClass="btn btn-secondary" Text="Reset" OnClick="btnResetProfile_Click" />
                        </div>
                    </div>
                    
                    <!-- Notifications Section -->
                    <div id="notifications" class="settings-section">
                        <div class="section-title">Notification Preferences</div>
                        <div class="section-desc">Choose what notifications you want to receive</div>
                        
                        <asp:Panel ID="pnlSuccessNotifications" runat="server" CssClass="alert alert-success" Visible="false">
                            <span class="alert-icon">✓</span>
                            <span>Notification preferences updated successfully!</span>
                        </asp:Panel>
                        
                        <div class="toggle-group">
                            <div class="toggle-info">
                                <div class="toggle-label">Service Due Reminders</div>
                                <div class="toggle-desc">Get notified when your vehicle service is due</div>
                            </div>
                            <label class="toggle-switch">
                                <asp:CheckBox ID="chkServiceReminders" runat="server" Checked="true" />
                                <span class="toggle-slider"></span>
                            </label>
                        </div>
                        
                        <div class="toggle-group">
                            <div class="toggle-info">
                                <div class="toggle-label">Email Notifications</div>
                                <div class="toggle-desc">Receive notifications via email</div>
                            </div>
                            <label class="toggle-switch">
                                <asp:CheckBox ID="chkEmailNotifications" runat="server" Checked="true" />
                                <span class="toggle-slider"></span>
                            </label>
                        </div>
                        
                        <div class="toggle-group">
                            <div class="toggle-info">
                                <div class="toggle-label">Cost Alert Notifications</div>
                                <div class="toggle-desc">Get alerts when maintenance costs exceed your threshold</div>
                            </div>
                            <label class="toggle-switch">
                                <asp:CheckBox ID="chkCostAlerts" runat="server" Checked="false" />
                                <span class="toggle-slider"></span>
                            </label>
                        </div>
                        
                        <div class="form-group" style="margin-top: 30px;">
                            <label class="form-label">Cost Alert Threshold (₹)</label>
                            <asp:TextBox ID="txtCostThreshold" runat="server" CssClass="form-input" TextMode="Number" placeholder="50000"></asp:TextBox>
                            <div class="form-help">You'll be notified when any single service exceeds this amount</div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Service Reminder (days before due)</label>
                            <asp:TextBox ID="txtReminderDays" runat="server" CssClass="form-input" TextMode="Number" placeholder="7" Text="7"></asp:TextBox>
                            <div class="form-help">Number of days before service is due to receive reminder</div>
                        </div>
                        
                        <div class="btn-group">
                            <asp:Button ID="btnSaveNotifications" runat="server" CssClass="btn btn-primary" Text="Save Preferences" OnClick="btnSaveNotifications_Click" />
                        </div>
                    </div>
                    
                    <!-- Preferences Section -->
                    <div id="preferences" class="settings-section">
                        <div class="section-title">Application Preferences</div>
                        <div class="section-desc">Customize how the application displays information</div>
                        
                        <asp:Panel ID="pnlSuccessPreferences" runat="server" CssClass="alert alert-success" Visible="false">
                            <span class="alert-icon">✓</span>
                            <span>Preferences updated successfully!</span>
                        </asp:Panel>
                        
                        <div class="form-group">
                            <label class="form-label">Default Currency</label>
                            <asp:DropDownList ID="ddlCurrency" runat="server" CssClass="form-input form-select">
                                <asp:ListItem Value="INR" Selected="True">₹ Indian Rupee (INR)</asp:ListItem>
                                <asp:ListItem Value="USD">$ US Dollar (USD)</asp:ListItem>
                                <asp:ListItem Value="EUR">€ Euro (EUR)</asp:ListItem>
                                <asp:ListItem Value="GBP">£ British Pound (GBP)</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Date Format</label>
                            <asp:DropDownList ID="ddlDateFormat" runat="server" CssClass="form-input form-select">
                                <asp:ListItem Value="dd/MM/yyyy" Selected="True">DD/MM/YYYY (Indian)</asp:ListItem>
                                <asp:ListItem Value="MM/dd/yyyy">MM/DD/YYYY (US)</asp:ListItem>
                                <asp:ListItem Value="yyyy-MM-dd">YYYY-MM-DD (ISO)</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Records Per Page</label>
                            <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-input form-select">
                                <asp:ListItem Value="10">10 records</asp:ListItem>
                                <asp:ListItem Value="25" Selected="True">25 records</asp:ListItem>
                                <asp:ListItem Value="50">50 records</asp:ListItem>
                                <asp:ListItem Value="100">100 records</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        
                        <div class="btn-group">
                            <asp:Button ID="btnSavePreferences" runat="server" CssClass="btn btn-primary" Text="Save Preferences" OnClick="btnSavePreferences_Click" />
                        </div>
                    </div>
                    
                    <!-- Security Section -->
                    <div id="security" class="settings-section">
                        <div class="section-title">Security Settings</div>
                        <div class="section-desc">Manage your account security and password</div>
                        
                        <asp:Panel ID="pnlPasswordSuccess" runat="server" CssClass="alert alert-success" Visible="false">
                            <span class="alert-icon">✓</span>
                            <span>Password changed successfully!</span>
                        </asp:Panel>
                        
                        <asp:Panel ID="pnlPasswordError" runat="server" CssClass="alert alert-error" Visible="false">
                            <span class="alert-icon">⚠</span>
                            <asp:Label ID="lblPasswordError" runat="server"></asp:Label>
                        </asp:Panel>
                        
                        <div class="form-group">
                            <label class="form-label">Current Password</label>
                            <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Enter current password"></asp:TextBox>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">New Password</label>
                            <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Enter new password"></asp:TextBox>
                            <div class="form-help">Password must be at least 8 characters with letters and numbers</div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Confirm New Password</label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Re-enter new password"></asp:TextBox>
                        </div>
                        
                        <div class="btn-group">
                            <asp:Button ID="btnChangePassword" runat="server" CssClass="btn btn-primary" Text="Change Password" OnClick="btnChangePassword_Click" />
                        </div>
                    </div>
                    
                    <!-- Data Section -->
                    <div id="data" class="settings-section">
                        <div class="section-title">My Data & Statistics</div>
                        <div class="section-desc">View your data summary and export your information</div>
                        
                        <asp:Panel ID="pnlSuccessExport" runat="server" CssClass="alert alert-success" Visible="false">
                            <span class="alert-icon">✓</span>
                            <span>Data exported successfully!</span>
                        </asp:Panel>
                        
                        <!-- User Statistics -->
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px;">
                            <div class="stats-card">
                                <div class="stats-card-title">Total Vehicles</div>
                                <div class="stats-card-value"><asp:Label ID="lblUserVehicles" runat="server" Text="0"></asp:Label></div>
                            </div>
                            <div class="stats-card">
                                <div class="stats-card-title">Total Services</div>
                                <div class="stats-card-value"><asp:Label ID="lblUserServices" runat="server" Text="0"></asp:Label></div>
                            </div>
                            <div class="stats-card">
                                <div class="stats-card-title">Total Spent</div>
                                <div class="stats-card-value">₹<asp:Label ID="lblUserSpent" runat="server" Text="0"></asp:Label></div>
                            </div>
                        </div>
                        
                        <div class="info-card">
                            <div class="info-card-title">
                                💾 Data Export
                            </div>
                            <div class="info-card-text">
                                Export all your vehicle and maintenance records to keep an offline backup. 
                                Data will be exported in Excel format with all your historical information.
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Export My Data</label>
                            <asp:Button ID="btnExportVehicles" runat="server" CssClass="btn btn-secondary" Text="📊 Export My Vehicles" OnClick="btnExportVehicles_Click" style="margin-right: 10px;" />
                            <asp:Button ID="btnExportMaintenance" runat="server" CssClass="btn btn-secondary" Text="📋 Export My Maintenance Records" OnClick="btnExportMaintenance_Click" />
                        </div>
                        
                        <div style="margin-top: 40px; padding-top: 30px; border-top: 1px solid #e0e0e0;">
                            <div class="info-card" style="background: #fff3cd; border-color: #ffc107;">
                                <div class="info-card-title" style="color: #856404;">
                                    ⚠️ Account Information
                                </div>
                                <div class="info-card-text" style="color: #856404;">
                                    Your account was created on: <strong><asp:Label ID="lblAccountCreated" runat="server"></asp:Label></strong><br />
                                    Last login: <strong><asp:Label ID="lblLastLogin" runat="server"></asp:Label></strong>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <script>
            function showSection(sectionId) {
                // Hide all sections
                var sections = document.querySelectorAll('.settings-section');
                sections.forEach(function (section) {
                    section.classList.remove('active');
                });

                // Remove active class from all sidebar items
                var items = document.querySelectorAll('.sidebar-item');
                items.forEach(function (item) {
                    item.classList.remove('active');
                });

                // Show selected section
                document.getElementById(sectionId).classList.add('active');

                // Add active class to clicked sidebar item
                event.currentTarget.classList.add('active');
            }
        </script>
    </form>
</body>
</html>