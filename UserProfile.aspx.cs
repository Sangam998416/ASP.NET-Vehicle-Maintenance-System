using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace VehicleMaintenance
{
    public partial class UserProfile : Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                // Check if user is logged in
                if (Session["UserID"] == null)
                {
                    Response.Redirect("Login.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                if (!IsPostBack)
                {
                    LoadUserProfile();
                    LoadUserStatistics();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Page_Load Error: " + ex.Message);
                ShowMessage("Error loading page: " + ex.Message, "error");
            }
        }

        private void LoadUserProfile()
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Updated query to use FirstName and LastName instead of FullName
                    string query = @"SELECT 
                                        UserID,
                                        FirstName,
                                        LastName,
                                        FirstName + ' ' + LastName as FullName,
                                        Email, 
                                        Phone, 
                                        Role, 
                                        CreatedDate,
                                        LastLoginDate
                                    FROM Users 
                                    WHERE UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Populate form fields
                                string fullName = reader["FullName"].ToString();
                                txtFullName.Text = fullName;
                                txtEmail.Text = reader["Email"].ToString();
                                txtPhone.Text = reader["Phone"] != DBNull.Value ? reader["Phone"].ToString() : "";
                                txtRole.Text = reader["Role"].ToString();
                                txtUserID.Text = reader["UserID"].ToString();

                                // Update session with latest data
                                Session["UserName"] = fullName;
                                Session["UserEmail"] = reader["Email"].ToString();
                                Session["UserRole"] = reader["Role"].ToString();

                                // Format dates
                                if (reader["CreatedDate"] != DBNull.Value)
                                {
                                    DateTime createdDate = Convert.ToDateTime(reader["CreatedDate"]);
                                    lblMemberSince.Text = createdDate.ToString("MMM yyyy");
                                    lblMemberSinceShort.Text = createdDate.ToString("MMM yyyy");
                                    lblAccountCreated.Text = createdDate.ToString("dd MMM yyyy");
                                }
                                else
                                {
                                    lblMemberSince.Text = DateTime.Now.ToString("MMM yyyy");
                                    lblMemberSinceShort.Text = DateTime.Now.ToString("MMM yyyy");
                                    lblAccountCreated.Text = DateTime.Now.ToString("dd MMM yyyy");
                                }

                                if (reader["LastLoginDate"] != DBNull.Value)
                                {
                                    DateTime lastLogin = Convert.ToDateTime(reader["LastLoginDate"]);
                                    lblLastLogin.Text = GetRelativeTime(lastLogin);
                                    lblLastLoginActivity.Text = lastLogin.ToString("dd MMM yyyy hh:mm tt");
                                }
                                else
                                {
                                    lblLastLogin.Text = "Today";
                                    lblLastLoginActivity.Text = "First login - " + DateTime.Now.ToString("dd MMM yyyy hh:mm tt");
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading profile: " + ex.Message);
                ShowMessage("Error loading profile: " + ex.Message, "error");
            }
        }

        private void LoadUserStatistics()
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Get total vehicles for this user
                    string vehicleQuery = "SELECT COUNT(*) FROM Vehicles WHERE UserID = @UserID AND Status = 'Active'";
                    using (SqlCommand cmd = new SqlCommand(vehicleQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        int vehicleCount = (int)cmd.ExecuteScalar();
                        lblTotalVehicles.Text = vehicleCount.ToString();
                        lblActiveVehicles.Text = vehicleCount.ToString();
                    }

                    // Get total services for this user's vehicles
                    string serviceQuery = @"SELECT COUNT(*) 
                                          FROM Maintenance m
                                          INNER JOIN Vehicles v ON m.VehicleID = v.VehicleID
                                          WHERE v.UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(serviceQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        lblTotalServices.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Get total logins (if LoginAudit table exists)
                    try
                    {
                        string loginQuery = @"SELECT COUNT(*) FROM LoginAudit 
                                            WHERE UserID = @UserID AND Success = 1";
                        using (SqlCommand cmd = new SqlCommand(loginQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            object result = cmd.ExecuteScalar();
                            lblTotalLogins.Text = result != null ? result.ToString() : "N/A";
                        }
                    }
                    catch
                    {
                        lblTotalLogins.Text = "N/A";
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading statistics: " + ex.Message);
            }
        }

        protected void btnUpdateProfile_Click(object sender, EventArgs e)
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                string fullName = txtFullName.Text.Trim();
                string phone = txtPhone.Text.Trim();

                // Validate inputs
                if (string.IsNullOrEmpty(fullName))
                {
                    ShowMessage("⚠️ Full name is required.", "error");
                    return;
                }

                // Split full name into first and last name
                string[] nameParts = fullName.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                string firstName = nameParts.Length > 0 ? nameParts[0] : fullName;
                string lastName = nameParts.Length > 1 ? string.Join(" ", nameParts, 1, nameParts.Length - 1) : "";

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string query = @"UPDATE Users 
                                   SET FirstName = @FirstName,
                                       LastName = @LastName,
                                       Phone = @Phone 
                                   WHERE UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FirstName", firstName);
                        cmd.Parameters.AddWithValue("@LastName", lastName);
                        cmd.Parameters.AddWithValue("@Phone", string.IsNullOrEmpty(phone) ? (object)DBNull.Value : phone);
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Update session variables
                            Session["UserName"] = fullName;

                            // Update initials
                            string initials = firstName.Substring(0, 1).ToUpper();
                            if (!string.IsNullOrEmpty(lastName))
                            {
                                initials += lastName.Substring(0, 1).ToUpper();
                            }
                            Session["UserInitials"] = initials;

                            ShowMessage("✓ Profile updated successfully!", "success");
                            LoadUserProfile(); // Reload to show updated data
                        }
                        else
                        {
                            ShowMessage("⚠️ Failed to update profile. Please try again.", "error");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error updating profile: " + ex.Message);
                ShowMessage("⚠️ Error updating profile: " + ex.Message, "error");
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            // Reload original data
            LoadUserProfile();
            ShowMessage("ℹ️ Changes cancelled. Original data restored.", "info");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            try
            {
                // Log the logout
                if (Session["UserID"] != null)
                {
                    LogLogoutAttempt(Convert.ToInt32(Session["UserID"]));
                }

                // Clear all session variables
                Session.Clear();
                Session.Abandon();

                // Redirect to login page
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error during logout: " + ex.Message);
                ShowMessage("⚠️ Error during logout: " + ex.Message, "error");
            }
        }

        private void LogLogoutAttempt(int userId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Check if LoginAudit table exists
                    string checkTableQuery = @"IF EXISTS (SELECT * FROM sys.objects 
                                              WHERE object_id = OBJECT_ID(N'[dbo].[LoginAudit]') 
                                              AND type in (N'U'))
                                              SELECT 1 ELSE SELECT 0";

                    using (SqlCommand checkCmd = new SqlCommand(checkTableQuery, conn))
                    {
                        int tableExists = (int)checkCmd.ExecuteScalar();

                        if (tableExists == 1)
                        {
                            string query = @"INSERT INTO LoginAudit (UserID, LoginTime, Success, IPAddress, Message) 
                                           VALUES (@UserID, GETDATE(), 1, @IPAddress, 'User logged out')";

                            using (SqlCommand cmd = new SqlCommand(query, conn))
                            {
                                cmd.Parameters.AddWithValue("@UserID", userId);
                                cmd.Parameters.AddWithValue("@IPAddress", Request.UserHostAddress ?? "Unknown");
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Silently fail - don't prevent logout
                System.Diagnostics.Debug.WriteLine("Error logging logout: " + ex.Message);
            }
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message " + type;
            lblMessage.Visible = true;
        }

        private string GetRelativeTime(DateTime dateTime)
        {
            TimeSpan timeSince = DateTime.Now - dateTime;

            if (timeSince.TotalMinutes < 1)
                return "Just now";
            if (timeSince.TotalMinutes < 60)
                return $"{(int)timeSince.TotalMinutes} min ago";
            if (timeSince.TotalHours < 24)
                return $"{(int)timeSince.TotalHours}h ago";
            if (timeSince.TotalDays < 7)
                return $"{(int)timeSince.TotalDays}d ago";
            if (timeSince.TotalDays < 30)
                return $"{(int)(timeSince.TotalDays / 7)}w ago";
            if (timeSince.TotalDays < 365)
                return $"{(int)(timeSince.TotalDays / 30)}mo ago";

            return $"{(int)(timeSince.TotalDays / 365)}y ago";
        }
    }
}