<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="VehicleMaintenance.Signup" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sign Up - Sarthi | Vehicle Maintenance System</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .signup-container { 
            background: white; 
            border-radius: 20px; 
            box-shadow: 0 20px 60px rgba(102, 126, 234, 0.4);
            overflow: hidden;
            width: 100%;
            max-width: 1200px;
            display: grid;
            grid-template-columns: 400px 1fr;
            min-height: 600px;
        }
        
        .signup-left {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 60px 40px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
        }
        
        .logo { 
            width: 80px; 
            height: 80px; 
            background: rgba(255,255,255,0.2); 
            border-radius: 20px; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 45px;
            margin-bottom: 30px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            position: relative;
            overflow: hidden;
            font-weight: 700;
        }
        
        .logo::before {
            content: '';
            position: absolute;
            width: 60%;
            height: 60%;
            background: rgba(255,255,255,0.15);
            border-radius: 50%;
            top: -10%;
            right: -10%;
        }
        
        .brand-title { 
            font-size: 2.5em; 
            font-weight: 700; 
            margin-bottom: 12px;
            letter-spacing: -0.5px;
        }
        
        .brand-subtitle { 
            font-size: 1.05em; 
            opacity: 0.95;
            line-height: 1.5;
            margin-bottom: 35px;
        }
        
        .features {
            list-style: none;
            margin-top: 20px;
        }
        
        .features li {
            padding: 12px 0;
            padding-left: 30px;
            position: relative;
            font-size: 0.95em;
            line-height: 1.5;
            opacity: 0.95;
        }
        
        .features li::before {
            content: '✓';
            position: absolute;
            left: 0;
            font-weight: bold;
            font-size: 1.2em;
            color: #4ade80;
        }
        
        .signup-right { 
            padding: 50px 45px;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            max-height: 90vh;
            overflow-y: auto;
        }
        
        .signup-header { 
            margin-bottom: 30px; 
        }
        
        .signup-title { 
            font-size: 2em; 
            color: #2c3e50; 
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .signup-subtitle { 
            color: #7f8c8d; 
            font-size: 1em; 
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group { 
            margin-bottom: 0; 
        }
        
        .form-group.full-width {
            grid-column: 1 / -1;
            margin-bottom: 20px;
        }
        
        .form-group label { 
            display: block; 
            margin-bottom: 8px; 
            color: #2c3e50; 
            font-weight: 600;
            font-size: 0.9em;
        }
        
        .required { 
            color: #667eea;
            font-weight: 700;
        }
        
        .form-group input,
        .form-group select { 
            width: 100%; 
            padding: 12px 15px;
            border: 2px solid #e0e0e0; 
            border-radius: 10px; 
            font-size: 0.95em;
            transition: all 0.3s;
            font-family: inherit;
            background: white;
            color: #2c3e50;
            line-height: 1.5;
            height: 46px;
        }
        
        .form-group input:focus,
        .form-group select:focus { 
            outline: none; 
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-group select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%232c3e50' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            padding-right: 40px;
        }
        
        .password-hint {
            font-size: 0.82em;
            color: #7f8c8d;
            margin-top: 6px;
            display: block;
        }
        
        .terms-checkbox {
            display: flex;
            align-items: start;
            gap: 10px;
            margin: 25px 0;
        }
        
        .terms-checkbox input[type="checkbox"] {
            width: 18px;
            height: 18px;
            margin-top: 3px;
            cursor: pointer;
            flex-shrink: 0;
        }
        
        .terms-checkbox label {
            font-size: 0.9em;
            color: #7f8c8d;
            font-weight: normal;
            line-height: 1.6;
        }
        
        .terms-checkbox a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        
        .terms-checkbox a:hover {
            text-decoration: underline;
        }
        
        .btn-signup { 
            width: 100%; 
            padding: 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; 
            border: none; 
            border-radius: 10px; 
            font-size: 1.05em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-signup:hover { 
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }
        
        .btn-signup:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        
        .divider {
            display: flex;
            align-items: center;
            margin: 25px 0;
            color: #7f8c8d;
            font-size: 0.9em;
        }
        
        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #e0e0e0;
        }
        
        .divider span {
            padding: 0 15px;
        }
        
        .btn-google {
            width: 100%;
            padding: 13px;
            border: 2px solid #e0e0e0;
            background: white;
            border-radius: 10px;
            font-size: 0.95em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            color: #2c3e50;
        }
        
        .btn-google:hover {
            border-color: #4285f4;
            background: #f8f9fa;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(66, 133, 244, 0.2);
        }
        
        .login-link {
            text-align: center;
            margin-top: 25px;
            color: #7f8c8d;
            font-size: 0.95em;
        }
        
        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
        
        .message { 
            padding: 14px 16px; 
            margin-bottom: 20px; 
            border-radius: 10px; 
            font-size: 0.95em;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .message.error { 
            background: #fee; 
            color: #c33; 
            border: 1px solid #fcc; 
        }
        
        .message.success { 
            background: #dfd; 
            color: #2c662d; 
            border: 1px solid #a3d5a5; 
        }
        
        .validator {
            color: #e74c3c;
            font-size: 0.85em;
            margin-top: 5px;
            display: block;
        }
        
        /* Modal Styles */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background: white;
            padding: 35px;
            border-radius: 15px;
            max-width: 400px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
        }

        .modal-content h3 {
            color: #667eea;
            margin-bottom: 15px;
            font-size: 1.5em;
        }

        .modal-content p {
            color: #7f8c8d;
            margin-bottom: 25px;
            line-height: 1.6;
        }

        .btn-close-modal {
            padding: 12px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.95em;
            transition: all 0.3s;
        }
        
        .btn-close-modal:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }
        
        /* Custom Scrollbar */
        .signup-right::-webkit-scrollbar {
            width: 6px;
        }
        
        .signup-right::-webkit-scrollbar-track {
            background: #f8f9fa;
            border-radius: 10px;
        }
        
        .signup-right::-webkit-scrollbar-thumb {
            background: #667eea;
            border-radius: 10px;
        }
        
        .signup-right::-webkit-scrollbar-thumb:hover {
            background: #764ba2;
        }
        
        @media (max-width: 1100px) {
            .signup-container {
                grid-template-columns: 1fr;
                max-width: 650px;
            }
            
            .signup-left {
                padding: 40px 30px;
                min-height: auto;
            }
            
            .brand-title {
                font-size: 2em;
            }
            
            .features {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 8px;
            }
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .signup-right {
                padding: 30px 25px;
            }
            
            .signup-left {
                display: none;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="signup-container">
            <!-- Left Side - Branding -->
            <div class="signup-left">
                <div class="logo">S</div>
                <div class="brand-title">Sarthi</div>
                <div class="brand-subtitle">
                    Your trusted companion for vehicle maintenance management
                </div>
                <ul class="features">
                    <li>Track unlimited vehicles in your fleet</li>
                    <li>Never miss a service date again</li>
                    <li>Monitor all maintenance costs</li>
                    <li>Generate detailed reports instantly</li>
                    <li>Secure cloud storage</li>
                    <li>Access from anywhere, anytime</li>
                </ul>
            </div>
            
            <!-- Right Side - Signup Form -->
            <div class="signup-right">
                <!-- HEADER SECTION - THIS WAS MISSING IN YOUR CODE -->
                <div class="signup-header">
                    <div class="signup-title">Create Account</div>
                    <div class="signup-subtitle">Join Sarthi today and start managing your vehicles</div>
                </div>
                
                <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
                
                <!-- Name and Phone Fields -->
                <div class="form-row">
                    <div class="form-group">
                        <label>Full Name <span class="required">*</span></label>
                        <asp:TextBox ID="txtFullName" runat="server" placeholder="Rajesh Sharma" MaxLength="100"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFullName" runat="server" 
                            ControlToValidate="txtFullName" ErrorMessage="Full name is required" 
                            CssClass="validator" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    
                    <div class="form-group">
                        <label>Phone Number <span class="required">*</span></label>
                        <asp:TextBox ID="txtPhone" runat="server" placeholder="+91-9876543210" MaxLength="15"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPhone" runat="server" 
                            ControlToValidate="txtPhone" ErrorMessage="Phone is required" 
                            CssClass="validator" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>
                
                <!-- Email -->
                <div class="form-row">
                    <div class="form-group full-width">
                        <label>Email Address <span class="required">*</span></label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="rajesh@company.com" MaxLength="100"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                            ControlToValidate="txtEmail" ErrorMessage="Email is required" 
                            CssClass="validator" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revEmail" runat="server"
                            ControlToValidate="txtEmail" 
                            ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"
                            ErrorMessage="Invalid email format"
                            CssClass="validator" Display="Dynamic"></asp:RegularExpressionValidator>
                    </div>
                </div>
                
                <!-- Company and Role -->
                <div class="form-row">
                    <div class="form-group">
                        <label>Company Name</label>
                        <asp:TextBox ID="txtCompany" runat="server" placeholder="Your Company Name (Optional)" MaxLength="100"></asp:TextBox>
                    </div>
                    
                    <div class="form-group">
                        <label>Role <span class="required">*</span></label>
                        <asp:DropDownList ID="ddlRole" runat="server">
                            <asp:ListItem Value="">-- Select Role --</asp:ListItem>
                            <asp:ListItem Value="Admin">Admin</asp:ListItem>
                            <asp:ListItem Value="FleetManager">Fleet Manager</asp:ListItem>
                            <asp:ListItem Value="Mechanic">Mechanic</asp:ListItem>
                            <asp:ListItem Value="Driver">Driver</asp:ListItem>
                            <asp:ListItem Value="User">User</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvRole" runat="server" 
                            ControlToValidate="ddlRole" InitialValue="" ErrorMessage="Please select a role" 
                            CssClass="validator" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>
                
                <!-- Password -->
                <div class="form-row">
                    <div class="form-group full-width">
                        <label>Password <span class="required">*</span></label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Create a strong password" MaxLength="100"></asp:TextBox>
                        <span class="password-hint">At least 8 characters with uppercase, lowercase and number</span>
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                            ControlToValidate="txtPassword" ErrorMessage="Password is required" 
                            CssClass="validator" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revPassword" runat="server"
                            ControlToValidate="txtPassword"
                            ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$"
                            ErrorMessage="Password must be at least 8 characters with uppercase, lowercase and number"
                            CssClass="validator" Display="Dynamic"></asp:RegularExpressionValidator>
                    </div>
                </div>
                
                <!-- Confirm Password -->
                <div class="form-row">
                    <div class="form-group full-width">
                        <label>Confirm Password <span class="required">*</span></label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="Re-enter password" MaxLength="100"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" 
                            ControlToValidate="txtConfirmPassword" ErrorMessage="Please confirm password" 
                            CssClass="validator" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="cvPassword" runat="server"
                            ControlToValidate="txtConfirmPassword"
                            ControlToCompare="txtPassword"
                            ErrorMessage="Passwords do not match"
                            CssClass="validator" Display="Dynamic"></asp:CompareValidator>
                    </div>
                </div>
                
                <!-- Terms & Conditions -->
                <div class="terms-checkbox">
                    <asp:CheckBox ID="chkTerms" runat="server" />
                    <label>
                        I agree to the <a href="#" target="_blank">Terms of Service</a> and 
                        <a href="#" target="_blank">Privacy Policy</a> <span class="required">*</span>
                    </label>
                </div>
                <asp:CustomValidator ID="cvTerms" runat="server"
                    ErrorMessage="You must accept the terms and conditions"
                    CssClass="validator" Display="Dynamic"
                    ClientValidationFunction="ValidateTerms"></asp:CustomValidator>
                
                <!-- Signup Button -->
                <asp:Button ID="btnSignup" runat="server" Text="Create My Account" 
                    CssClass="btn-signup" OnClick="btnSignup_Click" />
                
                <!-- OR Divider -->
                <div class="divider"><span>OR</span></div>
                
                <!-- Google Signup -->
                <asp:Button ID="btnGoogleSignup" runat="server" CssClass="btn-google" 
                    Text="🔐 Continue with Google" OnClientClick="return showComingSoon();" CausesValidation="false" />
                
                <!-- Login Link -->
                <div class="login-link">
                    Already have an account? <a href="Login.aspx">Login here</a>
                </div>
            </div>
        </div>
        
        <!-- Coming Soon Modal -->
        <div id="comingSoonModal" class="modal-overlay" onclick="closeModal()">
            <div class="modal-content" onclick="event.stopPropagation()">
                <h3>🚀 Coming Soon!</h3>
                <p>Google Sign-In feature will be available in the next update. Stay tuned!</p>
                <button class="btn-close-modal" onclick="closeModal()">Got it</button>
            </div>
        </div>
    </form>
    
    <script type="text/javascript">
        // Validate terms checkbox
        function ValidateTerms(sender, args) {
            var checkbox = document.getElementById('<%= chkTerms.ClientID %>');
            args.IsValid = checkbox.checked;
        }

        // Show coming soon modal
        function showComingSoon() {
            document.getElementById('comingSoonModal').style.display = 'flex';
            return false; // Prevent postback
        }

        // Close modal
        function closeModal() {
            document.getElementById('comingSoonModal').style.display = 'none';
        }
    </script>
</body>
</html>