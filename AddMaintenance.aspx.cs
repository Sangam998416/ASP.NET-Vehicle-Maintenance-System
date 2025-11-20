using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace VehicleMaintenance
{
    public partial class AddMaintenance : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserVehicles();
            }
        }

        private void LoadUserVehicles()
        {
            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Load ONLY THIS USER's vehicles
                    string query = @"SELECT VehicleID, 
                                    Make + ' ' + Model + ' (' + LicensePlate + ')' AS VehicleInfo,
                                    Mileage
                                    FROM Vehicles 
                                    WHERE UserID = @UserID AND Status = 'Active'
                                    ORDER BY Make, Model";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            ddlVehicle.Items.Clear();
                            ddlVehicle.Items.Add(new System.Web.UI.WebControls.ListItem("-- Select Vehicle --", ""));

                            bool hasVehicles = false;
                            while (reader.Read())
                            {
                                hasVehicles = true;
                                ddlVehicle.Items.Add(new System.Web.UI.WebControls.ListItem(
                                    reader["VehicleInfo"].ToString(),
                                    reader["VehicleID"].ToString()));
                            }

                            if (!hasVehicles)
                            {
                                ShowMessage("⚠️ You don't have any active vehicles. Please add a vehicle first.", false);
                                btnSave.Enabled = false;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading vehicles: " + ex.Message, false);
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlVehicle.SelectedValue))
            {
                ShowMessage("⚠️ Please select a vehicle", false);
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);
            int vehicleId = Convert.ToInt32(ddlVehicle.SelectedValue);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // IMPORTANT: Verify the vehicle belongs to this user (security check)
                    string verifyQuery = "SELECT COUNT(*) FROM Vehicles WHERE VehicleID = @VehicleID AND UserID = @UserID";
                    using (SqlCommand verifyCmd = new SqlCommand(verifyQuery, conn))
                    {
                        verifyCmd.Parameters.AddWithValue("@VehicleID", vehicleId);
                        verifyCmd.Parameters.AddWithValue("@UserID", userId);

                        int count = Convert.ToInt32(verifyCmd.ExecuteScalar());
                        if (count == 0)
                        {
                            ShowMessage("❌ Invalid vehicle selection. This vehicle doesn't belong to your account.", false);
                            return;
                        }
                    }

                    // Validate numeric fields
                    decimal mileage = Convert.ToDecimal(txtMileage.Text.Trim());
                    if (mileage < 0 || mileage > 9999999)
                    {
                        ShowMessage("⚠️ Mileage must be between 0 and 9,999,999 km", false);
                        return;
                    }

                    decimal cost = Convert.ToDecimal(txtCost.Text.Trim());
                    if (cost < 0 || cost > 99999999)
                    {
                        ShowMessage("⚠️ Cost must be less than ₹10 crore", false);
                        return;
                    }

                    // Insert maintenance record
                    string insertQuery = @"INSERT INTO Maintenance 
                        (VehicleID, ServiceType, ServiceDate, Mileage, Cost, ServiceProvider, 
                         InvoiceNumber, Description, NextServiceDate, CreatedDate) 
                        VALUES 
                        (@VehicleID, @ServiceType, @ServiceDate, @Mileage, @Cost, @ServiceProvider, 
                         @InvoiceNumber, @Description, @NextServiceDate, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@VehicleID", vehicleId);
                        cmd.Parameters.AddWithValue("@ServiceType", ddlServiceType.SelectedValue);
                        cmd.Parameters.AddWithValue("@ServiceDate", Convert.ToDateTime(txtServiceDate.Text));
                        cmd.Parameters.AddWithValue("@Mileage", mileage);
                        cmd.Parameters.AddWithValue("@Cost", cost);
                        cmd.Parameters.AddWithValue("@ServiceProvider", txtServiceProvider.Text.Trim());
                        cmd.Parameters.AddWithValue("@InvoiceNumber",
                            string.IsNullOrEmpty(txtInvoiceNumber.Text) ? (object)DBNull.Value : txtInvoiceNumber.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description",
                            string.IsNullOrEmpty(txtDescription.Text) ? (object)DBNull.Value : txtDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@NextServiceDate",
                            string.IsNullOrEmpty(txtNextServiceDate.Text) ? (object)DBNull.Value : Convert.ToDateTime(txtNextServiceDate.Text));

                        cmd.ExecuteNonQuery();

                        // Optionally update vehicle mileage
                        UpdateVehicleMileage(conn, vehicleId, mileage);

                        ShowMessage("✅ Maintenance record added successfully!", true);
                        ClearForm();

                        // Redirect after 2 seconds
                        Response.AddHeader("REFRESH", "2;URL=Maintenance.aspx");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("❌ Error adding maintenance record: " + ex.Message, false);
            }
        }

        private void UpdateVehicleMileage(SqlConnection conn, int vehicleId, decimal newMileage)
        {
            try
            {
                // Only update if new mileage is higher
                string updateQuery = @"UPDATE Vehicles 
                                      SET Mileage = @Mileage, ModifiedDate = GETDATE()
                                      WHERE VehicleID = @VehicleID AND Mileage < @Mileage";

                using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@VehicleID", vehicleId);
                    cmd.Parameters.AddWithValue("@Mileage", newMileage);
                    cmd.ExecuteNonQuery();
                }
            }
            catch
            {
                // Silently fail - mileage update is optional
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("Maintenance.aspx");
        }

        private void ClearForm()
        {
            ddlVehicle.SelectedIndex = 0;
            ddlServiceType.SelectedIndex = 0;
            txtServiceDate.Text = "";
            txtMileage.Text = "";
            txtCost.Text = "";
            txtServiceProvider.Text = "";
            txtInvoiceNumber.Text = "";
            txtDescription.Text = "";
            txtNextServiceDate.Text = "";
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = isSuccess ? "message success" : "message error";
            lblMessage.Visible = true;
        }
    }
}