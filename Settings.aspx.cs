using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace VehicleMaintenance
{
    public partial class Settings : Page
    {
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
                    LoadUserSettings();
                    LoadUserStatistics();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Page_Load Error: " + ex.Message);
                ShowError("Error loading page: " + ex.Message);
            }
        }

        private void LoadUserSettings()
        {
            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Load User Profile Information
                    string userQuery = @"SELECT FirstName, LastName, Email, Phone, Address, City, State, Pincode, 
                                        Currency, DateFormat, PageSize, ReminderDays,
                                        ServiceReminders, EmailNotifications, CostAlerts, CostThreshold,
                                        CreatedDate, LastLoginDate
                                        FROM Users WHERE UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(userQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Profile Information
                                txtFirstName.Text = GetSafeString(reader, "FirstName");
                                txtLastName.Text = GetSafeString(reader, "LastName");
                                txtEmail.Text = GetSafeString(reader, "Email");
                                txtPhone.Text = GetSafeString(reader, "Phone");
                                txtAddress.Text = GetSafeString(reader, "Address");
                                txtCity.Text = GetSafeString(reader, "City");
                                txtState.Text = GetSafeString(reader, "State");
                                txtPincode.Text = GetSafeString(reader, "Pincode");

                                // Preferences
                                string currency = GetSafeString(reader, "Currency", "INR");
                                if (ddlCurrency.Items.FindByValue(currency) != null)
                                    ddlCurrency.SelectedValue = currency;

                                string dateFormat = GetSafeString(reader, "DateFormat", "dd/MM/yyyy");
                                if (ddlDateFormat.Items.FindByValue(dateFormat) != null)
                                    ddlDateFormat.SelectedValue = dateFormat;

                                string pageSize = GetSafeString(reader, "PageSize", "25");
                                if (ddlPageSize.Items.FindByValue(pageSize) != null)
                                    ddlPageSize.SelectedValue = pageSize;

                                txtReminderDays.Text = GetSafeString(reader, "ReminderDays", "7");

                                // Notifications
                                chkServiceReminders.Checked = GetSafeBool(reader, "ServiceReminders", true);
                                chkEmailNotifications.Checked = GetSafeBool(reader, "EmailNotifications", true);
                                chkCostAlerts.Checked = GetSafeBool(reader, "CostAlerts", false);
                                txtCostThreshold.Text = GetSafeString(reader, "CostThreshold", "50000");

                                // Account Info
                                if (reader["CreatedDate"] != DBNull.Value)
                                {
                                    lblAccountCreated.Text = Convert.ToDateTime(reader["CreatedDate"]).ToString("dd/MM/yyyy");
                                }
                                if (reader["LastLoginDate"] != DBNull.Value)
                                {
                                    lblLastLogin.Text = Convert.ToDateTime(reader["LastLoginDate"]).ToString("dd/MM/yyyy HH:mm");
                                }
                            }
                        }
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                System.Diagnostics.Debug.WriteLine("SQL Error loading settings: " + sqlEx.Message);
                ShowError("Database error: " + sqlEx.Message);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading settings: " + ex.Message);
                ShowError("Error loading settings: " + ex.Message);
            }
        }

        private void LoadUserStatistics()
        {
            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Get total vehicles for this user
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM Vehicles WHERE UserID = @UserID AND Status = 'Active'", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        lblUserVehicles.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Get total services for this user's vehicles
                    using (SqlCommand cmd = new SqlCommand(@"
                        SELECT COUNT(*) 
                        FROM Maintenance m
                        INNER JOIN Vehicles v ON m.VehicleID = v.VehicleID
                        WHERE v.UserID = @UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        lblUserServices.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Get total cost for this user's vehicles
                    using (SqlCommand cmd = new SqlCommand(@"
                        SELECT ISNULL(SUM(m.Cost), 0) 
                        FROM Maintenance m
                        INNER JOIN Vehicles v ON m.VehicleID = v.VehicleID
                        WHERE v.UserID = @UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        object result = cmd.ExecuteScalar();
                        decimal totalCost = result != DBNull.Value ? Convert.ToDecimal(result) : 0;
                        lblUserSpent.Text = totalCost.ToString("N0");
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading statistics: " + ex.Message);
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                // Validate required fields
                if (string.IsNullOrWhiteSpace(txtFirstName.Text) || string.IsNullOrWhiteSpace(txtLastName.Text))
                {
                    lblErrorProfile.Text = "First Name and Last Name are required.";
                    pnlErrorProfile.Visible = true;
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtEmail.Text))
                {
                    lblErrorProfile.Text = "Email address is required.";
                    pnlErrorProfile.Visible = true;
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Check if email is already used by another user
                    string checkEmailQuery = "SELECT COUNT(*) FROM Users WHERE Email = @Email AND UserID != @UserID";
                    using (SqlCommand cmd = new SqlCommand(checkEmailQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        int count = (int)cmd.ExecuteScalar();
                        if (count > 0)
                        {
                            lblErrorProfile.Text = "This email address is already in use by another account.";
                            pnlErrorProfile.Visible = true;
                            return;
                        }
                    }

                    string query = @"UPDATE Users SET 
                                    FirstName = @FirstName,
                                    LastName = @LastName,
                                    Email = @Email,
                                    Phone = @Phone,
                                    Address = @Address,
                                    City = @City,
                                    State = @State,
                                    Pincode = @Pincode
                                    WHERE UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                        cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@Phone", string.IsNullOrEmpty(txtPhone.Text) ? (object)DBNull.Value : txtPhone.Text.Trim());
                        cmd.Parameters.AddWithValue("@Address", string.IsNullOrEmpty(txtAddress.Text) ? (object)DBNull.Value : txtAddress.Text.Trim());
                        cmd.Parameters.AddWithValue("@City", string.IsNullOrEmpty(txtCity.Text) ? (object)DBNull.Value : txtCity.Text.Trim());
                        cmd.Parameters.AddWithValue("@State", string.IsNullOrEmpty(txtState.Text) ? (object)DBNull.Value : txtState.Text.Trim());
                        cmd.Parameters.AddWithValue("@Pincode", string.IsNullOrEmpty(txtPincode.Text) ? (object)DBNull.Value : txtPincode.Text.Trim());
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Update session variables
                            Session["UserName"] = txtFirstName.Text.Trim() + " " + txtLastName.Text.Trim();
                            Session["UserInitials"] = txtFirstName.Text.Trim().Substring(0, 1).ToUpper() +
                                                      txtLastName.Text.Trim().Substring(0, 1).ToUpper();

                            pnlErrorProfile.Visible = false;
                            pnlSuccessProfile.Visible = true;
                            System.Diagnostics.Debug.WriteLine("Profile updated successfully");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error saving profile: " + ex.Message);
                lblErrorProfile.Text = "Error saving profile: " + ex.Message;
                pnlErrorProfile.Visible = true;
            }
        }

        protected void btnResetProfile_Click(object sender, EventArgs e)
        {
            LoadUserSettings();
            pnlSuccessProfile.Visible = false;
            pnlErrorProfile.Visible = false;
        }

        protected void btnSaveNotifications_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string query = @"UPDATE Users SET 
                                    ServiceReminders = @ServiceReminders,
                                    EmailNotifications = @EmailNotifications,
                                    CostAlerts = @CostAlerts,
                                    CostThreshold = @CostThreshold,
                                    ReminderDays = @ReminderDays
                                    WHERE UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ServiceReminders", chkServiceReminders.Checked);
                        cmd.Parameters.AddWithValue("@EmailNotifications", chkEmailNotifications.Checked);
                        cmd.Parameters.AddWithValue("@CostAlerts", chkCostAlerts.Checked);
                        cmd.Parameters.AddWithValue("@CostThreshold", string.IsNullOrEmpty(txtCostThreshold.Text) ? 0 : Convert.ToDecimal(txtCostThreshold.Text));
                        cmd.Parameters.AddWithValue("@ReminderDays", string.IsNullOrEmpty(txtReminderDays.Text) ? 7 : Convert.ToInt32(txtReminderDays.Text));
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        cmd.ExecuteNonQuery();
                        pnlSuccessNotifications.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error saving notifications: " + ex.Message);
                ShowError("Error saving notifications: " + ex.Message);
            }
        }

        protected void btnSavePreferences_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string query = @"UPDATE Users SET 
                                    Currency = @Currency,
                                    DateFormat = @DateFormat,
                                    PageSize = @PageSize
                                    WHERE UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Currency", ddlCurrency.SelectedValue);
                        cmd.Parameters.AddWithValue("@DateFormat", ddlDateFormat.SelectedValue);
                        cmd.Parameters.AddWithValue("@PageSize", Convert.ToInt32(ddlPageSize.SelectedValue));
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        cmd.ExecuteNonQuery();
                        pnlSuccessPreferences.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error saving preferences: " + ex.Message);
                ShowError("Error saving preferences: " + ex.Message);
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            pnlPasswordSuccess.Visible = false;
            pnlPasswordError.Visible = false;

            // Validate passwords
            if (string.IsNullOrEmpty(txtCurrentPassword.Text) ||
                string.IsNullOrEmpty(txtNewPassword.Text) ||
                string.IsNullOrEmpty(txtConfirmPassword.Text))
            {
                lblPasswordError.Text = "All password fields are required";
                pnlPasswordError.Visible = true;
                return;
            }

            if (txtNewPassword.Text != txtConfirmPassword.Text)
            {
                lblPasswordError.Text = "New passwords do not match";
                pnlPasswordError.Visible = true;
                return;
            }

            if (txtNewPassword.Text.Length < 8)
            {
                lblPasswordError.Text = "Password must be at least 8 characters long";
                pnlPasswordError.Visible = true;
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Verify current password
                    string verifyQuery = "SELECT Password FROM Users WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(verifyQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        string currentHashedPassword = cmd.ExecuteScalar()?.ToString();

                        // In production, use proper password hashing (BCrypt, etc.)
                        if (currentHashedPassword != HashPassword(txtCurrentPassword.Text))
                        {
                            lblPasswordError.Text = "Current password is incorrect";
                            pnlPasswordError.Visible = true;
                            return;
                        }
                    }

                    // Update password
                    string updateQuery = "UPDATE Users SET Password = @Password WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Password", HashPassword(txtNewPassword.Text));
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.ExecuteNonQuery();

                        pnlPasswordSuccess.Visible = true;
                        txtCurrentPassword.Text = "";
                        txtNewPassword.Text = "";
                        txtConfirmPassword.Text = "";
                    }
                }
            }
            catch (Exception ex)
            {
                lblPasswordError.Text = "Error changing password: " + ex.Message;
                pnlPasswordError.Visible = true;
                System.Diagnostics.Debug.WriteLine("Error changing password: " + ex.Message);
            }
        }

        protected void btnExportVehicles_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Query to get user's vehicles only
                    string query = @"SELECT VehicleID, Make, Model, Year, LicensePlate, VIN, Color, 
                                    Mileage, PurchaseDate, InsuranceExpiry, Status 
                                    FROM Vehicles 
                                    WHERE UserID = @UserID 
                                    ORDER BY Make, Model";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                // Export to CSV (simple implementation)
                                ExportToCSV(dt, "MyVehicles_" + DateTime.Now.ToString("yyyyMMdd") + ".csv");
                                pnlSuccessExport.Visible = true;
                            }
                            else
                            {
                                ShowError("No vehicles found to export.");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Export error: " + ex.Message);
            }
        }

        protected void btnExportMaintenance_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Query to get user's maintenance records only
                    string query = @"SELECT m.MaintenanceID, v.Make, v.Model, v.LicensePlate,
                                    m.ServiceDate, m.ServiceType, m.Mileage, m.Cost, 
                                    m.ServiceProvider, m.Description, m.NextServiceDate
                                    FROM Maintenance m
                                    INNER JOIN Vehicles v ON m.VehicleID = v.VehicleID
                                    WHERE v.UserID = @UserID
                                    ORDER BY m.ServiceDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                // Export to CSV
                                ExportToCSV(dt, "MyMaintenanceRecords_" + DateTime.Now.ToString("yyyyMMdd") + ".csv");
                                pnlSuccessExport.Visible = true;
                            }
                            else
                            {
                                ShowError("No maintenance records found to export.");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Export error: " + ex.Message);
            }
        }

        private void ExportToCSV(DataTable dt, string filename)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=" + filename);
            Response.Charset = "";
            Response.ContentType = "application/text";

            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            // Add column headers
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                sb.Append(dt.Columns[i]);
                if (i < dt.Columns.Count - 1)
                    sb.Append(",");
            }
            sb.Append("\r\n");

            // Add rows
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                for (int k = 0; k < dt.Columns.Count; k++)
                {
                    string value = dt.Rows[i][k].ToString();
                    // Escape commas and quotes
                    if (value.Contains(",") || value.Contains("\""))
                    {
                        value = "\"" + value.Replace("\"", "\"\"") + "\"";
                    }
                    sb.Append(value);
                    if (k < dt.Columns.Count - 1)
                        sb.Append(",");
                }
                sb.Append("\r\n");
            }

            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        // Helper methods
        private string GetSafeString(SqlDataReader reader, string columnName, string defaultValue = "")
        {
            try
            {
                int ordinal = reader.GetOrdinal(columnName);
                return reader.IsDBNull(ordinal) ? defaultValue : reader.GetString(ordinal);
            }
            catch
            {
                return defaultValue;
            }
        }

        private bool GetSafeBool(SqlDataReader reader, string columnName, bool defaultValue = false)
        {
            try
            {
                int ordinal = reader.GetOrdinal(columnName);
                return reader.IsDBNull(ordinal) ? defaultValue : reader.GetBoolean(ordinal);
            }
            catch
            {
                return defaultValue;
            }
        }

        private string HashPassword(string password)
        {
            // Simple hash for demonstration - use BCrypt or similar in production
            using (var sha256 = System.Security.Cryptography.SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
                return Convert.ToBase64String(bytes);
            }
        }

        private void ShowError(string message)
        {
            Response.Write("<script>alert('" + message.Replace("'", "\\'") + "');</script>");
        }
    }
}