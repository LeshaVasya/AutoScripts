Function Test-SQLConn ($Server)
{
$connectionString = "Data Source=$Server;Integrated Security=true;Initial Catalog=master;Connect Timeout=3;"
$sqlConn = new-object ("Data.SqlClient.SqlConnection") $connectionString
trap
{
Write-Error "Cannot connect to $Server.";
continue
}
$sqlConn.Open()
if ($sqlConn.State -eq 'Open')
{
$sqlConn.Close();
"Opened successfully."
}
}