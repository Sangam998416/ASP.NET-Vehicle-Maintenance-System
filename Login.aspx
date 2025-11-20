<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="VehicleMaintenance.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login - Sarthi | Vehicle Maintenance System</title>
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
        
        .login-container { 
            background: white; 
            border-radius: 20px; 
            box-shadow: 0 20px 60px rgba(102, 126, 234, 0.4);
            overflow: hidden;
            width: 100%;
            max-width: 1000px;
            display: grid;
            grid-template-columns: 400px 1fr;
            min-height: 550px;
        }
        
        .login-left { 
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
        
        .login-right { 
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .login-header { 
            margin-bottom: 35px; 
        }
        
        .login-title { 
            font-size: 2em; 
            color: #2c3e50; 
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .login-subtitle { 
            color: #7f8c8d; 
            font-size: 1em; 
        }
        
        .form-group { 
            margin-bottom: 22px; 
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
        
        .form-group input { 
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
        
        .form-group input:focus { 
            outline: none; 
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .remember-forgot { 
            display: flex; 
            justify-content: space-between; 
            align-items: center;
            margin-bottom: 28px;
            font-size: 0.9em;
        }
        
        .remember-me { 
            display: flex; 
            align-items: center; 
            gap: 8px;
            color: #7f8c8d;
            cursor: pointer;
        }
        
        .remember-me input { 
            width: 18px;
            height: 18px;
            cursor: pointer;
        }
        
        .forgot-password { 
            color: #667eea; 
            text-decoration: none;
            font-weight: 500;
        }
        
        .forgot-password:hover { 
            text-decoration: underline; 
        }
        
        .btn-login { 
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
        
        .btn-login:hover { 
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
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
        
        .demo-info {
            background: #f0f4ff;
            border: 2px solid #d4e0ff;
            border-radius: 12px;
            padding: 18px;
            margin-top: 25px;
            font-size: 0.9em;
        }
        
        .demo-info strong {
            color: #667eea;
            display: block;
            margin-bottom: 10px;
            font-size: 0.95em;
        }
        
        .demo-info div {
            color: #5a6c7d;
            margin: 6px 0;
            padding: 6px 0;
            font-weight: 500;
        }
        
        .demo-info div strong {
            display: inline;
            color: #2c3e50;
            font-weight: 600;
        }

        .signup-link {
            text-align: center;
            margin-top: 25px;
            padding-top: 25px;
            border-top: 1px solid #e0e0e0;
            color: #7f8c8d;
            font-size: 0.95em;
        }
        
        .signup-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        
        .signup-link a:hover {
            text-decoration: underline;
        }
        
        @media (max-width: 968px) {
            .login-container { 
                grid-template-columns: 1fr;
                max-width: 500px;
            }
            .login-left { 
                display: none; 
            }
        }
        
        @media (max-width: 480px) {
            .login-right {
                padding: 40px 30px;
            }
            
            .login-title {
                font-size: 1.6em;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <!-- Left Side - Branding (Same as Signup) -->
            <div class="login-left">
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
            
            <!-- Right Side - Login Form -->
            <div class="login-right">
                <div class="login-header">
                    <div class="login-title">Welcome Back!</div>
                    <div class="login-subtitle">Please login to your account</div>
                </div>
                
                <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
                
                <div class="form-group">
                    <label>Email Address <span class="required">*</span></label>
                    <asp:TextBox ID="txtEmail" runat="server" placeholder="Enter your email" TextMode="Email"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                        ControlToValidate="txtEmail" ErrorMessage="Email is required" 
                        CssClass="validator" Display="Dynamic"></asp:RequiredFieldValidator>
                </div>
                
                <div class="form-group">
                    <label>Password <span class="required">*</span></label>
                    <asp:TextBox ID="txtPassword" runat="server" placeholder="Enter your password" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                        ControlToValidate="txtPassword" ErrorMessage="Password is required" 
                        CssClass="validator" Display="Dynamic"></asp:RequiredFieldValidator>
                </div>
                
                <div class="remember-forgot">
                    <label class="remember-me">
                        <asp:CheckBox ID="chkRememberMe" runat="server" />
                        Remember me
                    </label>
                    <a href="ForgotPassword.aspx" class="forgot-password">Forgot Password?</a>
                </div>
                
                <asp:Button ID="btnLogin" runat="server" Text="Login to Dashboard" 
                    CssClass="btn-login" OnClick="btnLogin_Click" />
                
                <div class="demo-info">
                    <strong>🔐 Demo Credentials:</strong>
                    <div>📧 Email: <strong>rajesh@autocare.in</strong></div>
                    <div>🔑 Password: <strong>password123</strong></div>
                </div>

                <div class="signup-link">
                    Don't have an account? <a href="Signup.aspx">Create one now</a>
                </div>
            </div>
        </div>
    </form>
</body>
</html>