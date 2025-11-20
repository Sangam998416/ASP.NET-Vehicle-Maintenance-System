using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace VehicleMaintenance
{
    public partial class AddVehicle : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;

            // Get the logged-in user's ID
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Check if license plate already exists for THIS USER
                    string licensePlate = txtLicensePlate.Text.Trim().ToUpper().Replace(" ", "").Replace("-", "");

                    string checkQuery = "SELECT COUNT(*) FROM Vehicles WHERE REPLACE(REPLACE(UPPER(LicensePlate), ' ', ''), '-', '') = @LicensePlate AND UserID = @UserID";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@LicensePlate", licensePlate);
                        checkCmd.Parameters.AddWithValue("@UserID", userId);

                        int count = Convert.ToInt32(checkCmd.ExecuteScalar());
                        if (count > 0)
                        {
                            ShowMessage($"⚠️ A vehicle with license plate '{txtLicensePlate.Text.Trim()}' already exists in your account! Please check your vehicle list.", false);
                            return;
                        }
                    }

                    // Insert new vehicle with UserID
                    string insertQuery = @"INSERT INTO Vehicles 
                        (Make, Model, Year, LicensePlate, VIN, Color, Mileage, Status, 
                         PurchaseDate, PurchasePrice, CurrentValue, Notes, UserID, CreatedDate) 
                        VALUES 
                        (@Make, @Model, @Year, @LicensePlate, @VIN, @Color, @Mileage, @Status, 
                         @PurchaseDate, @PurchasePrice, @CurrentValue, @Notes, @UserID, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Make", txtMake.Text.Trim());
                        cmd.Parameters.AddWithValue("@Model", txtModel.Text.Trim());
                        cmd.Parameters.AddWithValue("@Year", Convert.ToInt32(txtYear.Text.Trim()));
                        cmd.Parameters.AddWithValue("@LicensePlate", txtLicensePlate.Text.Trim().ToUpper());
                        cmd.Parameters.AddWithValue("@VIN", string.IsNullOrEmpty(txtVIN.Text) ? (object)DBNull.Value : txtVIN.Text.Trim().ToUpper());
                        cmd.Parameters.AddWithValue("@Color", txtColor.Text.Trim());
                        // Handle numeric fields with proper validation
                        decimal mileage = Convert.ToDecimal(txtMileage.Text.Trim());
                        if (mileage < 0 || mileage > 9999999) // Max 7 digits before decimal
                        {
                            ShowMessage("Mileage must be between 0 and 9,999,999 km", false);
                            return;
                        }
                        cmd.Parameters.AddWithValue("@Mileage", mileage);
                        cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);

                        // Optional fields with validation
                        cmd.Parameters.AddWithValue("@PurchaseDate",
                            string.IsNullOrEmpty(txtPurchaseDate.Text) ? (object)DBNull.Value : Convert.ToDateTime(txtPurchaseDate.Text));

                        if (!string.IsNullOrEmpty(txtPurchasePrice.Text))
                        {
                            decimal purchasePrice = Convert.ToDecimal(txtPurchasePrice.Text.Trim());
                            if (purchasePrice > 99999999) // Max 8 digits before decimal
                            {
                                ShowMessage("Purchase price must be less than ₹10 crore", false);
                                return;
                            }
                            cmd.Parameters.AddWithValue("@PurchasePrice", purchasePrice);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@PurchasePrice", DBNull.Value);
                        }

                        if (!string.IsNullOrEmpty(txtCurrentValue.Text))
                        {
                            decimal currentValue = Convert.ToDecimal(txtCurrentValue.Text.Trim());
                            if (currentValue > 99999999) // Max 8 digits before decimal
                            {
                                ShowMessage("Current value must be less than ₹10 crore", false);
                                return;
                            }
                            cmd.Parameters.AddWithValue("@CurrentValue", currentValue);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@CurrentValue", DBNull.Value);
                        }
                        cmd.Parameters.AddWithValue("@Notes",
                            string.IsNullOrEmpty(txtNotes.Text) ? (object)DBNull.Value : txtNotes.Text.Trim());

                        // IMPORTANT: Assign the vehicle to the logged-in user
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        cmd.ExecuteNonQuery();

                        ShowMessage("Vehicle added successfully!", true);
                        ClearForm();

                        // Optionally redirect after 2 seconds
                        Response.AddHeader("REFRESH", "2;URL=Vehicles.aspx");
                    }
                }
            }
            catch (SqlException ex)
            {
                // Handle specific SQL errors
                if (ex.Number == 2627 || ex.Number == 2601) // Unique constraint violation
                {
                    ShowMessage($"⚠️ A vehicle with license plate '{txtLicensePlate.Text.Trim()}' already exists. Each vehicle must have a unique license plate.", false);
                }
                else
                {
                    ShowMessage("❌ Error adding vehicle: " + ex.Message, false);
                }
            }
            catch (Exception ex)
            {
                ShowMessage("❌ Error adding vehicle: " + ex.Message, false);
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("Vehicles.aspx");
        }

        protected void btnCheckPlate_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtLicensePlate.Text))
            {
                lblPlateStatus.Text = "⚠️ Please enter a license plate number";
                lblPlateStatus.CssClass = "input-hint plate-taken";
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);
            string licensePlate = txtLicensePlate.Text.Trim().ToUpper().Replace(" ", "").Replace("-", "");

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string checkQuery = @"SELECT COUNT(*) FROM Vehicles 
                                         WHERE REPLACE(REPLACE(UPPER(LicensePlate), ' ', ''), '-', '') = @LicensePlate 
                                         AND UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(checkQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@LicensePlate", licensePlate);
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        int count = Convert.ToInt32(cmd.ExecuteScalar());

                        if (count > 0)
                        {
                            lblPlateStatus.Text = "❌ This license plate is already registered in your account";
                            lblPlateStatus.CssClass = "input-hint plate-taken";
                        }
                        else
                        {
                            lblPlateStatus.Text = "✅ License plate is available";
                            lblPlateStatus.CssClass = "input-hint plate-available";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblPlateStatus.Text = "⚠️ Error checking availability";
                lblPlateStatus.CssClass = "input-hint plate-taken";
            }
        }

        private void ClearForm()
        {
            txtMake.Text = "";
            txtModel.Text = "";
            txtYear.Text = "";
            txtLicensePlate.Text = "";
            txtVIN.Text = "";
            txtColor.Text = "";
            txtMileage.Text = "";
            txtPurchaseDate.Text = "";
            txtPurchasePrice.Text = "";
            txtCurrentValue.Text = "";
            txtNotes.Text = "";
            ddlStatus.SelectedIndex = 0;
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = isSuccess ? "message success" : "message error";
            lblMessage.Visible = true;
        }
    }
}