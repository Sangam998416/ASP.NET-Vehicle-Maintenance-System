<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserProfile.aspx.cs" Inherits="VehicleMaintenance.UserProfile" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Profile - Sarthi</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f7fa; }
        
        /* Top Navigation Bar */
        .topbar { background: white; border-bottom: 1px solid #e0e0e0; padding: 0 30px; display: flex; justify-content: space-between; align-items: center; height: 70px; box-shadow: 0 2px 4px rgba(0,0,0,0.08); }
        .logo-section { display: flex; align-items: center; gap: 15px; cursor: pointer; }
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
        
        /* Page Header with Cover */
        .profile-cover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 25px;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            position: relative;
            overflow: hidden;
        }
        .profile-cover::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.1)" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,122.7C672,117,768,139,864,154.7C960,171,1056,181,1152,165.3C1248,149,1344,107,1392,85.3L1440,64L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>') no-repeat bottom;
            background-size: cover;
            opacity: 0.3;
        }
        .profile-header-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 30px;
        }
        .profile-avatar-large {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #667eea;
            font-weight: 700;
            font-size: 48px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.2);
            flex-shrink: 0;
        }
        .profile-header-info {
            color: white;
            flex: 1;
        }
        .profile-header-name {
            font-size: 2.2em;
            font-weight: 700;
            margin-bottom: 8px;
        }
        .profile-header-email {
            font-size: 1.1em;
            opacity: 0.95;
            margin-bottom: 15px;
        }
        .profile-badges {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(255,255,255,0.2);
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9em;
            backdrop-filter: blur(10px);
        }
        .profile-header-actions {
            display: flex;
            gap: 10px;
        }
        
        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: transform 0.3s, box-shadow 0.3s;
            border-left: 4px solid #667eea;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2);
        }
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-bottom: 15px;
        }
        .stat-icon.vehicles { background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%); }
        .stat-icon.services { background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%); }
        .stat-icon.login { background: linear-gradient(135deg, #f3e5f5 0%, #e1bee7 100%); }
        .stat-icon.member { background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%); }
        .stat-value {
            font-size: 2em;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        .stat-label {
            color: #7f8c8d;
            font-size: 0.95em;
        }
        
        /* Content Grid */
        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 25px;
        }
        
        /* Card Styles */
        .card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 25px;
        }
        .card-title {
            font-size: 1.4em;
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 3px solid #667eea;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Form Styles */
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            display: block;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            font-size: 0.95em;
        }
        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 1em;
            transition: all 0.3s;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .form-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        .form-input[readonly] {
            background: #f8f9fa;
            cursor: not-allowed;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        /* Button Styles */
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }
        .btn {
            padding: 14px 32px;
            border: none;
            border-radius: 10px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }
        .btn-secondary {
            background: #f8f9fa;
            color: #2c3e50;
            border: 2px solid #e0e0e0;
        }
        .btn-secondary:hover {
            background: #e9ecef;
        }
        .btn-danger {
            background: #e74c3c;
            color: white;
        }
        .btn-danger:hover {
            background: #c0392b;
            transform: translateY(-2px);
        }
        .btn-outline {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
        }
        .btn-outline:hover {
            background: #667eea;
            color: white;
        }
        
        /* Alert Messages */
        .message {
            padding: 16px 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideIn 0.3s ease;
        }
        .message.success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }
        .message.error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #e74c3c;
        }
        .message.info {
            background: #d1ecf1;
            color: #0c5460;
            border-left: 4px solid #17a2b8;
        }
        
        /* Activity Timeline */
        .activity-timeline {
            position: relative;
            padding-left: 30px;
        }
        .activity-timeline::before {
            content: '';
            position: absolute;
            left: 10px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #e0e0e0;
        }
        .activity-item {
            position: relative;
            padding-bottom: 25px;
        }
        .activity-item:last-child {
            padding-bottom: 0;
        }
        .activity-dot {
            position: absolute;
            left: -24px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: white;
            border: 3px solid #667eea;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
        }
        .activity-content {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            border-left: 3px solid #667eea;
        }
        .activity-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        .activity-time {
            color: #7f8c8d;
            font-size: 0.85em;
        }
        
        /* Quick Actions */
        .quick-actions {
            display: grid;
            gap: 12px;
        }
        .quick-action-btn {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px;
            background: #f8f9fa;
            border: 2px solid transparent;
            border-radius: 10px;
            text-decoration: none;
            color: #2c3e50;
            transition: all 0.3s;
            cursor: pointer;
        }
        .quick-action-btn:hover {
            background: white;
            border-color: #667eea;
            transform: translateX(5px);
        }
        .quick-action-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }
        .quick-action-text {
            flex: 1;
        }
        .quick-action-title {
            font-weight: 600;
            margin-bottom: 3px;
        }
        .quick-action-desc {
            font-size: 0.85em;
            color: #7f8c8d;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @media (max-width: 1024px) {
            .content-grid {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 768px) {
            .profile-header-content {
                flex-direction: column;
                text-align: center;
            }
            .profile-header-actions {
                flex-direction: column;
                width: 100%;
            }
            .form-row {
                grid-template-columns: 1fr;
            }
            .btn-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Top Navigation Bar -->
        <div class="topbar">
            <div class="logo-section" onclick="window.location='Default.aspx'">
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
            <!-- Profile Cover Header -->
            <div class="profile-cover">
                <div class="profile-header-content">
                    <div class="profile-avatar-large">
                        <%= Session["UserInitials"] != null ? Session["UserInitials"].ToString() : "U" %>
                    </div>
                    <div class="profile-header-info">
                        <div class="profile-header-name">
                            <%= Session["UserName"] != null ? Session["UserName"].ToString() : "User" %>
                        </div>
                        <div class="profile-header-email">
                            <%= Session["UserEmail"] != null ? Session["UserEmail"].ToString() : "user@example.com" %>
                        </div>
                        <div class="profile-badges">
                            <span class="badge">
                                🎖️ <%= Session["UserRole"] != null ? Session["UserRole"].ToString() : "User" %>
                            </span>
                            <span class="badge">
                                ✓ Active Account
                            </span>
                            <span class="badge">
                                📅 Member since <asp:Label ID="lblMemberSinceShort" runat="server" Text="2024"></asp:Label>
                            </span>
                        </div>
                    </div>
                    <div class="profile-header-actions">
                        <asp:Button ID="btnEditProfile" runat="server" Text="✏️ Edit Profile" CssClass="btn btn-outline" OnClientClick="scrollToForm(); return false;" />
                    </div>
                </div>
            </div>
            
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
            
            <!-- Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon vehicles">🚙</div>
                    <div class="stat-value"><asp:Label ID="lblTotalVehicles" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Total Vehicles</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon services">🔧</div>
                    <div class="stat-value"><asp:Label ID="lblTotalServices" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Total Services</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon login">🔑</div>
                    <div class="stat-value"><asp:Label ID="lblLastLogin" runat="server" Text="Today"></asp:Label></div>
                    <div class="stat-label">Last Login</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon member">📅</div>
                    <div class="stat-value"><asp:Label ID="lblMemberSince" runat="server" Text="--"></asp:Label></div>
                    <div class="stat-label">Member Since</div>
                </div>
            </div>
            
            <!-- Content Grid -->
            <div class="content-grid">
                <!-- Left Column -->
                <div>
                    <!-- Personal Information Card -->
                    <div class="card" id="profileForm">
                        <div class="card-title">
                            👤 Personal Information
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Full Name *</label>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-input" placeholder="Enter your full name"></asp:TextBox>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Email Address</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Phone Number</label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-input" placeholder="+91 98765 43210"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Role</label>
                                <asp:TextBox ID="txtRole" runat="server" CssClass="form-input" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label class="form-label">User ID</label>
                                <asp:TextBox ID="txtUserID" runat="server" CssClass="form-input" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="btn-group">
                            <asp:Button ID="btnUpdateProfile" runat="server" Text="💾 Save Changes" CssClass="btn btn-primary" OnClick="btnUpdateProfile_Click" />
                            <asp:Button ID="btnCancel" runat="server" Text="↺ Reset" CssClass="btn btn-secondary" OnClick="btnCancel_Click" />
                        </div>
                    </div>
                    
                    <!-- Recent Activity Card -->
                    <div class="card">
                        <div class="card-title">
                            📊 Recent Activity
                        </div>
                        <div class="activity-timeline">
                            <div class="activity-item">
                                <div class="activity-dot"></div>
                                <div class="activity-content">
                                    <div class="activity-title">🔑 Logged in to dashboard</div>
                                    <div class="activity-time"><asp:Label ID="lblLastLoginActivity" runat="server"></asp:Label></div>
                                </div>
                            </div>
                            <div class="activity-item">
                                <div class="activity-dot"></div>
                                <div class="activity-content">
                                    <div class="activity-title">✏️ Profile viewed</div>
                                    <div class="activity-time">Just now</div>
                                </div>
                            </div>
                            <div class="activity-item">
                                <div class="activity-dot"></div>
                                <div class="activity-content">
                                    <div class="activity-title">👤 Account created</div>
                                    <div class="activity-time"><asp:Label ID="lblAccountCreated" runat="server"></asp:Label></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Right Column -->
                <div>
                    <!-- Quick Actions Card -->
                    <div class="card">
                        <div class="card-title">
                            ⚡ Quick Actions
                        </div>
                        <div class="quick-actions">
                            <a href="Default.aspx" class="quick-action-btn">
                                <div class="quick-action-icon">🏠</div>
                                <div class="quick-action-text">
                                    <div class="quick-action-title">Dashboard</div>
                                    <div class="quick-action-desc">View your overview</div>
                                </div>
                            </a>
                            <a href="Vehicles.aspx" class="quick-action-btn">
                                <div class="quick-action-icon">🚗</div>
                                <div class="quick-action-text">
                                    <div class="quick-action-title">My Vehicles</div>
                                    <div class="quick-action-desc">Manage your fleet</div>
                                </div>
                            </a>
                            <a href="Maintenance.aspx" class="quick-action-btn">
                                <div class="quick-action-icon">🔧</div>
                                <div class="quick-action-text">
                                    <div class="quick-action-title">Maintenance</div>
                                    <div class="quick-action-desc">View service records</div>
                                </div>
                            </a>
                            <a href="Settings.aspx" class="quick-action-btn">
                                <div class="quick-action-icon">⚙️</div>
                                <div class="quick-action-text">
                                    <div class="quick-action-title">Settings</div>
                                    <div class="quick-action-desc">Manage preferences</div>
                                </div>
                            </a>
                            <asp:LinkButton ID="btnLogoutLink" runat="server" CssClass="quick-action-btn" OnClick="btnLogout_Click" style="border: none; width: 100%;">
                                <div class="quick-action-icon" style="background: #e74c3c;">🚪</div>
                                <div class="quick-action-text">
                                    <div class="quick-action-title" style="color: #e74c3c;">Logout</div>
                                    <div class="quick-action-desc">Sign out of account</div>
                                </div>
                            </asp:LinkButton>
                        </div>
                    </div>
                    
                    <!-- Account Security Card -->
                    <div class="card">
                        <div class="card-title">
                            🔒 Account Security
                        </div>
                        <div style="margin-bottom: 20px;">
                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 15px; background: #f8f9fa; border-radius: 10px; margin-bottom: 12px;">
                                <div>
                                    <div style="font-weight: 600; color: #2c3e50; margin-bottom: 3px;">Password</div>
                                    <div style="font-size: 0.85em; color: #7f8c8d;">Last changed 30 days ago</div>
                                </div>
                                <a href="Settings.aspx" style="color: #667eea; text-decoration: none; font-weight: 600;">Change →</a>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 15px; background: #f8f9fa; border-radius: 10px; margin-bottom: 12px;">
                                <div>
                                    <div style="font-weight: 600; color: #2c3e50; margin-bottom: 3px;">Two-Factor Auth</div>
                                    <div style="font-size: 0.85em; color: #7f8c8d;">Not enabled</div>
                                </div>
                                <a href="Settings.aspx" style="color: #667eea; text-decoration: none; font-weight: 600;">Enable →</a>
                            </div>
                        </div>
                        <a href="Settings.aspx" class="btn btn-secondary" style="width: 100%; text-align: center; text-decoration: none; display: block;">
                            View All Security Settings
                        </a>
                    </div>
                    
                    <!-- Account Stats Card -->
                    <div class="card">
                        <div class="card-title">
                            📈 Account Statistics
                        </div>
                        <div style="display: grid; gap: 15px;">
                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid #f0f0f0;">
                                <span style="color: #7f8c8d; font-size: 0.9em;">Total Logins</span>
                                <span style="color: #2c3e50; font-weight: 600;"><asp:Label ID="lblTotalLogins" runat="server" Text="--"></asp:Label></span>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid #f0f0f0;">
                                <span style="color: #7f8c8d; font-size: 0.9em;">Profile Updates</span>
                                <span style="color: #2c3e50; font-weight: 600;">3</span>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid #f0f0f0;">
                                <span style="color: #7f8c8d; font-size: 0.9em;">Active Vehicles</span>
                                <span style="color: #2c3e50; font-weight: 600;"><asp:Label ID="lblActiveVehicles" runat="server" Text="0"></asp:Label></span>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 12px 0;">
                                <span style="color: #7f8c8d; font-size: 0.9em;">Account Status</span>
                                <span style="color: #27ae60; font-weight: 600;">● Active</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <script>
            function scrollToForm() {
                document.getElementById('profileForm').scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        </script>
    </form>
</body>
</html>