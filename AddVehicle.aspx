<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddVehicle.aspx.cs" Inherits="VehicleMaintenance.AddVehicle" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add New Vehicle - Sarthi</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f7fa; min-height: 100vh; }
        
        /* Top Bar */
        .topbar { background: white; border-bottom: 1px solid #e0e0e0; padding: 0 30px; display: flex; justify-content: space-between; align-items: center; height: 70px; box-shadow: 0 2px 4px rgba(0,0,0,0.08); }
        .logo-section { display: flex; align-items: center; gap: 15px; }
        .logo { width: 45px; height: 45px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 10px; display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 20px; }
        .brand-name { font-size: 1.5em; font-weight: 700; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        
        /* Container */
        .container { max-width: 900px; margin: 0 auto; padding: 30px; }
        
        /* Header */
        .page-header { background: white; border-radius: 15px; padding: 30px; margin-bottom: 25px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .page-header h1 { font-size: 2em; color: #2c3e50; margin-bottom: 10px; }
        .breadcrumb { color: #7f8c8d; font-size: 0.95em; }
        .breadcrumb a { color: #667eea; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }
        
        /* Form */
        .form-container { background: white; border-radius: 15px; padding: 35px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .form-section { margin-bottom: 30px; }
        .section-title { font-size: 1.2em; font-weight: 600; color: #2c3e50; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid #f0f0f0; }
        
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; }
        .form-group { display: flex; flex-direction: column; }
        .form-group.full-width { grid-column: 1 / -1; }
        
        .form-label { font-weight: 600; color: #2c3e50; margin-bottom: 8px; font-size: 0.95em; }
        .required { color: #e74c3c; margin-left: 4px; }
        .optional-tag { color: #7f8c8d; font-weight: 400; font-size: 0.85em; margin-left: 8px; }
        
        .form-input { padding: 12px 15px; border: 2px solid #ddd; border-radius: 8px; font-size: 1em; transition: border-color 0.3s; }
        .form-input:focus { outline: none; border-color: #667eea; }
        .form-input:required:invalid { border-color: #ddd; }
        
        textarea.form-input { resize: vertical; min-height: 100px; font-family: inherit; }
        select.form-input { cursor: pointer; }
        
        .input-hint { font-size: 0.85em; color: #7f8c8d; margin-top: 5px; }
        
        /* Message */
        .message { padding: 15px 20px; margin-bottom: 25px; border-radius: 8px; font-weight: 500; }
        .message.success { background: #d4edda; color: #155724; border-left: 4px solid #28a745; }
        .message.error { background: #f8d7da; color: #721c24; border-left: 4px solid #dc3545; }
        
        /* Buttons */
        .form-actions { display: flex; gap: 15px; padding-top: 20px; border-top: 2px solid #f0f0f0; }
        .btn { padding: 14px 30px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 1em; transition: all 0.3s; text-decoration: none; display: inline-block; text-align: center; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; flex: 1; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4); }
        .btn-secondary { background: white; color: #7f8c8d; border: 2px solid #ddd; }
        .btn-secondary:hover { background: #f8f9fa; border-color: #667eea; color: #667eea; }
        
        /* Required Fields Notice */
        .required-notice { background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px 20px; border-radius: 8px; margin-bottom: 25px; }
        .required-notice p { color: #856404; font-size: 0.95em; }
        
        /* Responsive */
        @media (max-width: 768px) {
            .form-row { grid-template-columns: 1fr; }
            .form-actions { flex-direction: column; }
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
                <h1>➕ Add New Vehicle</h1>
                <div class="breadcrumb">
                    <a href="Default.aspx">Dashboard</a> / <a href="Vehicles.aspx">Vehicles</a> / Add New
                </div>
            </div>
            
            <!-- Required Fields Notice -->
            <div class="required-notice">
                <p><strong>📝 Note:</strong> Fields marked with <span class="required">*</span> are required</p>
            </div>
            
            <!-- Message -->
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
            
            <!-- Form Container -->
            <div class="form-container">
                <!-- Basic Information -->
                <div class="form-section">
                    <div class="section-title">🚗 Basic Information</div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Make<span class="required">*</span></label>
                            <asp:TextBox ID="txtMake" runat="server" CssClass="form-input" 
                                placeholder="e.g., Maruti, Hyundai, Honda" MaxLength="50" required="required"></asp:TextBox>
                            <span class="input-hint">Vehicle manufacturer</span>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Model<span class="required">*</span></label>
                            <asp:TextBox ID="txtModel" runat="server" CssClass="form-input" 
                                placeholder="e.g., Swift, Creta, City" MaxLength="50" required="required"></asp:TextBox>
                            <span class="input-hint">Vehicle model name</span>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Year<span class="required">*</span></label>
                            <asp:TextBox ID="txtYear" runat="server" CssClass="form-input" 
                                TextMode="Number" placeholder="2024" min="1900" max="2025" required="required"></asp:TextBox>
                            <span class="input-hint">Manufacturing year</span>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Color<span class="required">*</span></label>
                            <asp:TextBox ID="txtColor" runat="server" CssClass="form-input" 
                                placeholder="e.g., White, Red, Silver" MaxLength="30" required="required"></asp:TextBox>
                            <span class="input-hint">Vehicle color</span>
                        </div>
                    </div>
                </div>
                
                <!-- Registration Details -->
                <div class="form-section">
                    <div class="section-title">📋 Registration Details</div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">License Plate<span class="required">*</span></label>
                            <div style="display: flex; gap: 10px;">
                                <asp:TextBox ID="txtLicensePlate" runat="server" CssClass="form-input" 
                                    placeholder="GJ-01-AB-1234" MaxLength="20" required="required" 
                                    style="text-transform: uppercase; flex: 1;"></asp:TextBox>
                                <asp:Button ID="btnCheckPlate" runat="server" Text="Check" 
                                    CssClass="btn btn-secondary" OnClick="btnCheckPlate_Click" 
                                    CausesValidation="false" style="padding: 12px 20px;" />
                            </div>
                            <asp:Label ID="lblPlateStatus" runat="server" CssClass="input-hint" style="margin-top: 8px;"></asp:Label>
                            <span class="input-hint">Vehicle registration number</span>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">VIN<span class="optional-tag">(Optional)</span></label>
                            <asp:TextBox ID="txtVIN" runat="server" CssClass="form-input" 
                                placeholder="17-digit Vehicle ID Number" MaxLength="17"></asp:TextBox>
                            <span class="input-hint">Chassis number</span>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Current Mileage (km)<span class="required">*</span></label>
                            <asp:TextBox ID="txtMileage" runat="server" CssClass="form-input" 
                                TextMode="Number" placeholder="25000" step="0.01" min="0" max="9999999" required="required"></asp:TextBox>
                            <span class="input-hint">Maximum: 9,999,999 km</span>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Status<span class="required">*</span></label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-input">
                                <asp:ListItem Value="Active" Selected="True">Active</asp:ListItem>
                                <asp:ListItem Value="Inactive">Inactive</asp:ListItem>
                            </asp:DropDownList>
                            <span class="input-hint">Current status of vehicle</span>
                        </div>
                    </div>
                </div>
                
                <!-- Financial Details -->
                <div class="form-section">
                    <div class="section-title">💰 Financial Details <span class="optional-tag">(All Optional)</span></div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Purchase Date<span class="optional-tag">(Optional)</span></label>
                            <asp:TextBox ID="txtPurchaseDate" runat="server" CssClass="form-input" 
                                TextMode="Date"></asp:TextBox>
                            <span class="input-hint">Date when vehicle was purchased</span>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Purchase Price (₹)<span class="optional-tag">(Optional)</span></label>
                            <asp:TextBox ID="txtPurchasePrice" runat="server" CssClass="form-input" 
                                TextMode="Number" placeholder="500000" step="0.01" min="0" max="99999999"></asp:TextBox>
                            <span class="input-hint">Maximum: ₹10 crore</span>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Current Value (₹)<span class="optional-tag">(Optional)</span></label>
                            <asp:TextBox ID="txtCurrentValue" runat="server" CssClass="form-input" 
                                TextMode="Number" placeholder="450000" step="0.01" min="0" max="99999999"></asp:TextBox>
                            <span class="input-hint">Maximum: ₹10 crore</span>
                        </div>
                        <div></div>
                    </div>
                </div>
                
                <!-- Additional Information -->
                <div class="form-section">
                    <div class="section-title">📝 Additional Information</div>
                    
                    <div class="form-group full-width">
                        <label class="form-label">Notes<span class="optional-tag">(Optional)</span></label>
                        <asp:TextBox ID="txtNotes" runat="server" CssClass="form-input" 
                            TextMode="MultiLine" Rows="4" 
                            placeholder="Any additional information about the vehicle..."></asp:TextBox>
                        <span class="input-hint">Additional details, modifications, or special notes</span>
                    </div>
                </div>
                
                <!-- Form Actions -->
                <div class="form-actions">
                    <asp:Button ID="btnSave" runat="server" Text="💾 Save Vehicle" 
                        CssClass="btn btn-primary" OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" 
                        CssClass="btn btn-secondary" OnClick="btnCancel_Click" CausesValidation="false" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>