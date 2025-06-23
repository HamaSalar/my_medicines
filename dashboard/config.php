<?php
// Database configuration
$host = 'localhost';
$dbname = 'u739214395_mymedicines';
$username = 'root'; // Change this to your database username
$password = ''; // Change this to your database password

try {
    // Create PDO instance
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    
    // Set the PDO error mode to exception
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Set default fetch mode to associative array
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    
} catch(PDOException $e) {
    // If there is an error with the connection, stop the script and display the error
    die("Connection failed: " . $e->getMessage());
}
?>
