using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VehicleMaintenance
{
    public partial class EditVehicle : Page
    {
        private int vehicleId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Get vehicle ID from query string
            if (Request.QueryString["id"] != null)
            {
                int.TryParse(Request.QueryString["id"], out vehicleId);
            }

            if (vehicleId == 0)
            {
                Response.Redirect("Vehicles.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadVehicleData();
            }
        }

        private void LoadVehicleData()
        {
            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);
            int vehicleId = Convert.ToInt32(Request.QueryString["id"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // IMPORTANT: Use correct column names - VIN instead of RCNumber
                    string query = @"SELECT Make, Model, Year, Color, LicensePlate, VIN, 
                                    PurchaseDate, PurchasePrice, Status, Mileage, CurrentValue, Notes
                                    FROM Vehicles 
                                    WHERE VehicleID = @VehicleID AND UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@VehicleID", vehicleId);
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Populate form fields
                                txtMake.Text = reader["Make"].ToString();
                                txtModel.Text = reader["Model"].ToString();
                                txtYear.Text = reader["Year"].ToString();
                                txtColor.Text = reader["Color"] != DBNull.Value ? reader["Color"].ToString() : "";
                                txtLicensePlate.Text = reader["LicensePlate"].ToString();
                                txtVIN.Text = reader["VIN"] != DBNull.Value ? reader["VIN"].ToString() : "";

                                if (reader["PurchaseDate"] != DBNull.Value)
                                {
                                    DateTime purchaseDate = Convert.ToDateTime(reader["PurchaseDate"]);
                                    txtPurchaseDate.Text = purchaseDate.ToString("yyyy-MM-dd");
                                }

                                if (reader["PurchasePrice"] != DBNull.Value)
                                {
                                    txtPurchasePrice.Text = reader["PurchasePrice"].ToString();
                                }

                                ddlStatus.SelectedValue = reader["Status"].ToString();

                                if (reader["Mileage"] != DBNull.Value)
                                {
                                    txtMileage.Text = reader["Mileage"].ToString();
                                }

                                if (reader["CurrentValue"] != DBNull.Value)
                                {
                                    txtCurrentValue.Text = reader["CurrentValue"].ToString();
                                }

                                txtNotes.Text = reader["Notes"] != DBNull.Value ? reader["Notes"].ToString() : "";
                            }
                            else
                            {
                                // Vehicle not found or doesn't belong to this user
                                ShowMessage("Vehicle not found or you do not have permission to edit it.", false);
                                Response.Redirect("Vehicles.aspx");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading vehicle data: " + ex.Message, false);
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);
            int vehicleId = Convert.ToInt32(Request.QueryString["id"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // First verify the vehicle belongs to this user
                    string checkQuery = "SELECT COUNT(*) FROM Vehicles WHERE VehicleID = @VehicleID AND UserID = @UserID";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@VehicleID", vehicleId);
                        checkCmd.Parameters.AddWithValue("@UserID", userId);
                        int count = (int)checkCmd.ExecuteScalar();

                        if (count == 0)
                        {
                            ShowMessage("You do not have permission to edit this vehicle.", false);
                            return;
                        }
                    }

                    // Check for duplicate license plate (excluding current vehicle)
                    string licensePlate = txtLicensePlate.Text.Trim().ToUpper().Replace(" ", "").Replace("-", "");
                    string checkDuplicateQuery = @"SELECT COUNT(*) FROM Vehicles 
                                                   WHERE REPLACE(REPLACE(UPPER(LicensePlate), ' ', ''), '-', '') = @LicensePlate 
                                                   AND VehicleID != @VehicleID 
                                                   AND UserID = @UserID";

                    using (SqlCommand checkCmd = new SqlCommand(checkDuplicateQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@LicensePlate", licensePlate);
                        checkCmd.Parameters.AddWithValue("@VehicleID", vehicleId);
                        checkCmd.Parameters.AddWithValue("@UserID", userId);

                        int count = Convert.ToInt32(checkCmd.ExecuteScalar());
                        if (count > 0)
                        {
                            ShowMessage("A vehicle with license plate '" + txtLicensePlate.Text.Trim() + "' already exists in your account!", false);
                            return;
                        }
                    }

                    // Validate numeric fields
                    decimal mileage = 0;
                    if (!string.IsNullOrEmpty(txtMileage.Text))
                    {
                        mileage = Convert.ToDecimal(txtMileage.Text.Trim());
                        if (mileage < 0 || mileage > 9999999)
                        {
                            ShowMessage("Mileage must be between 0 and 9,999,999 km", false);
                            return;
                        }
                    }

                    decimal purchasePrice = 0;
                    if (!string.IsNullOrEmpty(txtPurchasePrice.Text))
                    {
                        purchasePrice = Convert.ToDecimal(txtPurchasePrice.Text.Trim());
                        if (purchasePrice > 99999999)
                        {
                            ShowMessage("Purchase price must be less than Rs 10 crore", false);
                            return;
                        }
                    }

                    decimal currentValue = 0;
                    if (!string.IsNullOrEmpty(txtCurrentValue.Text))
                    {
                        currentValue = Convert.ToDecimal(txtCurrentValue.Text.Trim());
                        if (currentValue > 99999999)
                        {
                            ShowMessage("Current value must be less than Rs 10 crore", false);
                            return;
                        }
                    }

                    // Update the vehicle using correct column names
                    string query = @"UPDATE Vehicles 
                                   SET Make = @Make, 
                                       Model = @Model, 
                                       Year = @Year, 
                                       Color = @Color, 
                                       LicensePlate = @LicensePlate, 
                                       VIN = @VIN, 
                                       PurchaseDate = @PurchaseDate,
                                       PurchasePrice = @PurchasePrice,
                                       Status = @Status, 
                                       Mileage = @Mileage, 
                                       CurrentValue = @CurrentValue, 
                                       Notes = @Notes,
                                       ModifiedDate = GETDATE()
                                   WHERE VehicleID = @VehicleID AND UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@VehicleID", vehicleId);
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@Make", txtMake.Text.Trim());
                        cmd.Parameters.AddWithValue("@Model", txtModel.Text.Trim());
                        cmd.Parameters.AddWithValue("@Year", Convert.ToInt32(txtYear.Text));
                        cmd.Parameters.AddWithValue("@Color", string.IsNullOrEmpty(txtColor.Text) ? (object)DBNull.Value : txtColor.Text.Trim());
                        cmd.Parameters.AddWithValue("@LicensePlate", txtLicensePlate.Text.Trim().ToUpper());
                        cmd.Parameters.AddWithValue("@VIN", string.IsNullOrEmpty(txtVIN.Text) ? (object)DBNull.Value : txtVIN.Text.Trim().ToUpper());

                        if (string.IsNullOrEmpty(txtPurchaseDate.Text))
                        {
                            cmd.Parameters.AddWithValue("@PurchaseDate", DBNull.Value);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@PurchaseDate", Convert.ToDateTime(txtPurchaseDate.Text));
                        }

                        if (string.IsNullOrEmpty(txtPurchasePrice.Text))
                        {
                            cmd.Parameters.AddWithValue("@PurchasePrice", DBNull.Value);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@PurchasePrice", purchasePrice);
                        }

                        cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);

                        if (string.IsNullOrEmpty(txtMileage.Text))
                        {
                            cmd.Parameters.AddWithValue("@Mileage", DBNull.Value);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@Mileage", mileage);
                        }

                        if (string.IsNullOrEmpty(txtCurrentValue.Text))
                        {
                            cmd.Parameters.AddWithValue("@CurrentValue", DBNull.Value);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@CurrentValue", currentValue);
                        }

                        cmd.Parameters.AddWithValue("@Notes", string.IsNullOrEmpty(txtNotes.Text) ? (object)DBNull.Value : txtNotes.Text.Trim());

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ShowMessage("Vehicle updated successfully!", true);
                            // Redirect back to Vehicles page with success message
                            Response.AddHeader("REFRESH", "2;URL=Vehicles.aspx");
                        }
                        else
                        {
                            ShowMessage("No changes were made.", false);
                        }
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 2627 || sqlEx.Number == 2601)
                {
                    ShowMessage("A vehicle with license plate '" + txtLicensePlate.Text.Trim() + "' already exists.", false);
                }
                else
                {
                    ShowMessage("Database error: " + sqlEx.Message, false);
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating vehicle: " + ex.Message, false);
            }
        }

        protected void btnDeleteConfirm_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);
            int vehicleId = Convert.ToInt32(Request.QueryString["id"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // First verify the vehicle belongs to this user
                    string checkQuery = "SELECT COUNT(*) FROM Vehicles WHERE VehicleID = @VehicleID AND UserID = @UserID";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@VehicleID", vehicleId);
                        checkCmd.Parameters.AddWithValue("@UserID", userId);
                        int count = (int)checkCmd.ExecuteScalar();

                        if (count == 0)
                        {
                            ShowMessage("You do not have permission to delete this vehicle.", false);
                            return;
                        }
                    }

                    // Delete associated maintenance records first
                    string deleteMaintenance = "DELETE FROM Maintenance WHERE VehicleID = @VehicleID";
                    using (SqlCommand cmd = new SqlCommand(deleteMaintenance, conn))
                    {
                        cmd.Parameters.AddWithValue("@VehicleID", vehicleId);
                        cmd.ExecuteNonQuery();
                    }

                    // Delete the vehicle
                    string deleteVehicle = "DELETE FROM Vehicles WHERE VehicleID = @VehicleID AND UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(deleteVehicle, conn))
                    {
                        cmd.Parameters.AddWithValue("@VehicleID", vehicleId);
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            Response.Redirect("Vehicles.aspx");
                        }
                        else
                        {
                            ShowMessage("Error: Vehicle could not be deleted.", false);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting vehicle: " + ex.Message, false);
            }
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = isSuccess ? "message success" : "message error";
            lblMessage.Visible = true;
        }
    }
}   