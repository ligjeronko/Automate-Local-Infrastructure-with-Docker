<?php
$servername = "mysql_db";  // This matches your Docker container name on the same network
$username = "user";
$password = "pass";
$dbname = "mydb";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "Connected successfully to MariaDB!";

// Example query (optional)
$sql = "SELECT NOW() as current_time";
$result = $conn->query($sql);
if ($result) {
    $row = $result->fetch_assoc();
    echo "<br>Current time from DB: " . $row['current_time'];
}

$conn->close();
?>
