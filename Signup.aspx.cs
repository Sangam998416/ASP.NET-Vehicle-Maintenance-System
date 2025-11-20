using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace VehicleMaintenance
{
    public partial class Signup : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // If user is already logged in, redirect to dashboard
                if (Session["UserID"] != null)
                {
                    Response.Redirect("Default.aspx");
                }
            }
        }

        protected void btnSignup_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // Check if terms are accepted
                if (!chkTerms.Checked)
                {
                    ShowMessage("Please accept the Terms of Service and Privacy Policy to continue.", "error");
                    return;
                }

                string fullName = txtFullName.Text.Trim();
                string email = txtEmail.Text.Trim().ToLower();
                string phone = txtPhone.Text.Trim();
                string company = txtCompany.Text.Trim();
                string role = ddlRole.SelectedValue;
                string password = txtPassword.Text.Trim();
                string confirmPassword = txtConfirmPassword.Text.Trim();

                // Validate role selection
                if (string.IsNullOrEmpty(role))
                {
                    ShowMessage("Please select a role.", "error");
                    return;
                }

                // Additional password validation
                if (!IsValidPassword(password))
                {
                    ShowMessage("Password must be at least 8 characters and contain uppercase, lowercase, and number.", "error");
                    return;
                }

                // Check if passwords match (additional server-side check)
                if (password != confirmPassword)
                {
                    ShowMessage("Passwords do not match. Please try again.", "error");
                    return;
                }

                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        conn.Open();

                        // Check if email already exists
                        if (EmailExists(conn, email))
                        {
                            ShowMessage("This email is already registered. Please <a href='Login.aspx' style='color: #667eea; text-decoration: underline;'>login here</a> or use a different email.", "error");
                            return;
                        }

                        // Insert new user - Using exact column order that matches database
                        string insertQuery = @"
                            INSERT INTO Users (FullName, Email, Password, Phone, Role, CompanyName, IsActive, CreatedDate) 
                            VALUES (@FullName, @Email, @Password, @Phone, @Role, @CompanyName, 1, GETDATE());
                            SELECT CAST(SCOPE_IDENTITY() as int)";

                        int newUserId;

                        using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@FullName", fullName);
                            cmd.Parameters.AddWithValue("@Email", email);
                            // NOTE: In production, ALWAYS hash passwords using BCrypt, Argon2, or PBKDF2
                            // Never store plain text passwords in production!
                            cmd.Parameters.AddWithValue("@Password", password);
                            cmd.Parameters.AddWithValue("@Phone", phone);
                            cmd.Parameters.AddWithValue("@Role", role);
                            cmd.Parameters.AddWithValue("@CompanyName", string.IsNullOrEmpty(company) ? (object)DBNull.Value : company);

                            try
                            {
                                newUserId = (int)cmd.ExecuteScalar();
                            }
                            catch (SqlException sqlEx)
                            {
                                // Handle specific SQL errors
                                if (sqlEx.Message.Contains("CHECK constraint"))
                                {
                                    ShowMessage("Invalid role selected. Please choose a valid role from the dropdown and try again.", "error");
                                }
                                else if (sqlEx.Message.Contains("UNIQUE") || sqlEx.Message.Contains("duplicate"))
                                {
                                    ShowMessage("This email is already registered. Please use a different email address.", "error");
                                }
                                else
                                {
                                    ShowMessage("Database error: Unable to create account. Please try again later.", "error");
                                }
                                LogSignupAttempt(0, false, "SQL Error: " + sqlEx.Message + " | Email: " + email);
                                return;
                            }
                        }

                        if (newUserId > 0)
                        {
                            // Log the successful signup
                            LogSignupAttempt(newUserId, true, "Account created successfully");

                            // Auto-login the user after successful registration
                            CreateUserSession(newUserId, fullName, email, role);

                            // Show success message and redirect
                            Session["WelcomeMessage"] = "Welcome to Sarthi! Your account has been created successfully.";
                            Response.Redirect("Default.aspx");
                        }
                        else
                        {
                            ShowMessage("Registration failed. Please try again.", "error");
                            LogSignupAttempt(0, false, "Registration failed - no user ID returned");
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Registration error: An unexpected error occurred. Please try again.", "error");
                    LogSignupAttempt(0, false, "General Error: " + ex.Message);
                }
            }
        }

        protected void btnGoogleSignup_Click(object sender, EventArgs e)
        {
            // Google OAuth implementation placeholder
            // The JavaScript modal handles this on client side
            // This server-side method should not be reached due to OnClientClick returning false
        }

        private void CreateUserSession(int userId, string fullName, string email, string role)
        {
            Session["UserID"] = userId;
            Session["UserName"] = fullName;
            Session["UserEmail"] = email;
            Session["UserRole"] = role;

            // Get user initials for display
            string[] nameParts = fullName.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            string initials = "";

            if (nameParts.Length > 0)
            {
                initials = nameParts[0].Substring(0, 1);
                if (nameParts.Length > 1)
                {
                    initials += nameParts[nameParts.Length - 1].Substring(0, 1);
                }
                else if (nameParts[0].Length > 1)
                {
                    initials += nameParts[0].Substring(1, 1);
                }
            }

            Session["UserInitials"] = initials.ToUpper();
        }

        private bool EmailExists(SqlConnection conn, string email)
        {
            string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        private bool IsValidPassword(string password)
        {
            if (string.IsNullOrEmpty(password))
                return false;

            // Password must be at least 8 characters
            if (password.Length < 8)
                return false;

            // Must contain at least one uppercase letter
            if (!Regex.IsMatch(password, @"[A-Z]"))
                return false;

            // Must contain at least one lowercase letter
            if (!Regex.IsMatch(password, @"[a-z]"))
                return false;

            // Must contain at least one digit
            if (!Regex.IsMatch(password, @"\d"))
                return false;

            return true;
        }

        private void LogSignupAttempt(int userId, bool success, string message)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Try to log to SignupAudit first, fallback to LoginAudit
                    string checkTableQuery = @"
                        SELECT COUNT(*) 
                        FROM INFORMATION_SCHEMA.TABLES 
                        WHERE TABLE_NAME = 'SignupAudit'";

                    bool hasSignupAudit = false;
                    using (SqlCommand checkCmd = new SqlCommand(checkTableQuery, conn))
                    {
                        hasSignupAudit = (int)checkCmd.ExecuteScalar() > 0;
                    }

                    string tableName = hasSignupAudit ? "SignupAudit" : "LoginAudit";
                    string timeColumn = hasSignupAudit ? "SignupTime" : "LoginTime";

                    string query = $@"
                        INSERT INTO {tableName} (UserID, {timeColumn}, Success, IPAddress, Message) 
                        VALUES (@UserID, GETDATE(), @Success, @IPAddress, @Message)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId > 0 ? (object)userId : DBNull.Value);
                        cmd.Parameters.AddWithValue("@Success", success);
                        cmd.Parameters.AddWithValue("@IPAddress", Request.UserHostAddress ?? "Unknown");
                        cmd.Parameters.AddWithValue("@Message", "Signup: " + message);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch
            {
                // Silently fail - don't show audit logging errors to user
            }
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message " + type;
            lblMessage.Visible = true;
        }
    }
}