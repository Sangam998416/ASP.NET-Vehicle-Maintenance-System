using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VehicleMaintenance
{
    public partial class Vehicles : Page
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
                LoadStatistics();
            }
        }

        private void LoadVehicles(string searchTerm = "")
        {
            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;

            // Get the logged-in user's ID
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // IMPORTANT: Added UserID filter to show only THIS USER's vehicles
                    string query = @"SELECT VehicleID, Make, Model, Year, LicensePlate, Color, 
                                    Mileage, Status, CurrentValue 
                                    FROM Vehicles 
                                    WHERE UserID = @UserID
                                        AND (@Search = '' OR Make LIKE '%' + @Search + '%' 
                                            OR Model LIKE '%' + @Search + '%' 
                                            OR LicensePlate LIKE '%' + @Search + '%')
                                    ORDER BY Make, Model";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@Search", searchTerm);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptVehicles.DataSource = dt;
                            rptVehicles.DataBind();
                            pnlEmpty.Visible = false;
                        }
                        else
                        {
                            rptVehicles.DataSource = null;
                            rptVehicles.DataBind();
                            pnlEmpty.Visible = true;

                            if (!string.IsNullOrEmpty(searchTerm))
                            {
                                ShowMessage($"No vehicles found matching '{searchTerm}'", true);
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

        private void LoadStatistics()
        {
            string connStr = ConfigurationManager.ConnectionStrings["VehicleMaintenanceDB"].ConnectionString;
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Total vehicles
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM Vehicles WHERE UserID = @UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        lblTotalCount.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Active vehicles
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM Vehicles WHERE UserID = @UserID AND Status = 'Active'", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        lblActiveCount.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Total value
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT ISNULL(SUM(CurrentValue), 0) FROM Vehicles WHERE UserID = @UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        object result = cmd.ExecuteScalar();
                        decimal totalValue = result != DBNull.Value ? Convert.ToDecimal(result) : 0;
                        lblTotalValue.Text = totalValue.ToString("N0");
                    }
                }
            }
            catch (Exception ex)
            {
                lblTotalCount.Text = "0";
                lblActiveCount.Text = "0";
                lblTotalValue.Text = "0";
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadVehicles(txtSearch.Text.Trim());
            LoadStatistics();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            LoadVehicles();
            LoadStatistics();
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = isSuccess ? "message success" : "message error";
            lblMessage.Visible = true;
        }
    }
}