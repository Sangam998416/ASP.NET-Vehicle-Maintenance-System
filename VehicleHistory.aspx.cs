using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VehicleMaintenance
{
    public partial class VehicleHistory : Page
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
                LoadVehicles();

                // Check if vehicle ID is in query string
                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int vehicleId;
                    if (int.TryParse(Request.QueryString["id"], out vehicleId))
                    {
                        // Verify the vehicle belongs to the current user before loading
                        if (IsVehicleOwnedByUser(vehicleId))
                        {
                            ddlVehicle.SelectedValue = vehicleId.ToString();
                            LoadVehicleHistory(vehicleId);
                        }
                        else
                        {
                            ShowMessage("Access denied: You don't have permission to view this vehicle's history.");
                        }
                    }
                }
            }
        }

        private bool IsVehicleOwnedByUser(int vehicleId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "SELECT COUNT(*) FROM Vehicles WHERE VehicleID = @VehicleID AND UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@VehicleID", vehicleId);
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        conn.Open();
                        int count = (int)cmd.ExecuteScalar();
                        return count > 0;
                    }
                }
            }
            catch
            {
                return false;
            }
        }

        private void LoadVehicles()
        {
            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // Load only vehicles that belong to the current user
                    string query = @"SELECT VehicleID, 
                                           Make + ' ' + Model + ' (' + LicensePlate + ')' AS VehicleInfo 
                                    FROM Vehicles 
                                    WHERE UserID = @UserID 
                                    ORDER BY Make, Model";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        ddlVehicle.Items.Clear();
                        ddlVehicle.Items.Add(new ListItem("-- Select a Vehicle --", ""));

                        while (reader.Read())
                        {
                            ddlVehicle.Items.Add(new ListItem(
                                reader["VehicleInfo"].ToString(),
                                reader["VehicleID"].ToString()
                            ));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading vehicles: " + ex.Message);
            }
        }

        protected void ddlVehicle_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddlVehicle.SelectedValue))
            {
                int vehicleId = int.Parse(ddlVehicle.SelectedValue);

                // Security check: verify ownership before loading
                if (IsVehicleOwnedByUser(vehicleId))
                {
                    LoadVehicleHistory(vehicleId);
                }
                else
                {
                    ShowMessage("Access denied: You don't have permission to view this vehicle's history.");
                    pnlVehicleInfo.Visible = false;
                    pnlNoSelection.Visible = true;
                }
            }
            else
            {
                pnlVehicleInfo.Visible = false;
                pnlNoSelection.Visible = true;
            }
        }

        private void LoadVehicleHistory(int vehicleId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Load vehicle details - with user verification
                    string vehicleQuery = @"SELECT Make, Model, Year, LicensePlate, Mileage 
                                          FROM Vehicles 
                                          WHERE VehicleID = @VehicleID 
                                          AND UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(vehicleQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@VehicleID", vehicleId);
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        SqlDataReader reader = cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            litVehicleName.Text = reader["Make"].ToString();
                            litModel.Text = reader["Model"].ToString();
                            litYear.Text = reader["Year"].ToString();
                            litLicensePlate.Text = reader["LicensePlate"].ToString();

                            // Format mileage for Indian standard (km)
                            int mileage = Convert.ToInt32(reader["Mileage"]);
                            litMileage.Text = mileage.ToString("N0") + " km";
                        }
                        else
                        {
                            // Vehicle not found or doesn't belong to user
                            ShowMessage("Vehicle not found or access denied.");
                            pnlVehicleInfo.Visible = false;
                            pnlNoSelection.Visible = true;
                            reader.Close();
                            return;
                        }
                        reader.Close();
                    }

                    // Load maintenance statistics - with user verification
                    string statsQuery = @"SELECT 
                                            COUNT(*) AS TotalServices,
                                            ISNULL(SUM(Cost), 0) AS TotalCost,
                                            MAX(ServiceDate) AS LastService
                                         FROM Maintenance m
                                         INNER JOIN Vehicles v ON m.VehicleID = v.VehicleID
                                         WHERE m.VehicleID = @VehicleID 
                                         AND v.UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(statsQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@VehicleID", vehicleId);
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        SqlDataReader reader = cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            lblTotalServices.Text = reader["TotalServices"].ToString();

                            // Format cost for Indian Rupees
                            decimal totalCost = Convert.ToDecimal(reader["TotalCost"]);
                            lblTotalCost.Text = totalCost.ToString("N0");

                            if (reader["LastService"] != DBNull.Value)
                            {
                                // Use DD/MM/YYYY format for Indian standard
                                lblLastService.Text = Convert.ToDateTime(reader["LastService"]).ToString("dd/MM/yyyy");
                            }
                            else
                            {
                                lblLastService.Text = "N/A";
                            }
                        }
                        reader.Close();
                    }

                    // Load maintenance history - with user verification
                    string historyQuery = @"SELECT 
                                              m.ServiceDate,
                                              m.ServiceType,
                                              m.Mileage,
                                              m.Cost,
                                              m.ServiceProvider,
                                              m.Description,
                                              m.NextServiceDate
                                          FROM Maintenance m
                                          INNER JOIN Vehicles v ON m.VehicleID = v.VehicleID
                                          WHERE m.VehicleID = @VehicleID 
                                          AND v.UserID = @UserID
                                          ORDER BY m.ServiceDate DESC";

                    using (SqlCommand cmd = new SqlCommand(historyQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@VehicleID", vehicleId);
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvHistory.DataSource = dt;
                        gvHistory.DataBind();
                    }
                }

                pnlVehicleInfo.Visible = true;
                pnlNoSelection.Visible = false;
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading vehicle history: " + ex.Message);
                pnlVehicleInfo.Visible = false;
                pnlNoSelection.Visible = true;
            }
        }

        private void ShowMessage(string message)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;
        }
    }
}