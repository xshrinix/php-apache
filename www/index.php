<?php 
  
  $servername = "mysql.xtreme-signage-app.svc.cluster.local"; 
  $username = "root"; 
  $password = "Admin@1234"; 
  $databasename = "signage"; 
  
  // CREATE CONNECTION 
  $conn = new mysqli($servername, 
    $username, $password, $databasename); 
  
  // GET CONNECTION ERRORS 
  if ($conn->connect_error) { 
      die("Connection failed: " . $conn->connect_error); 
  } 
  
  // SQL QUERY 
  $query = "SELECT * FROM `user`;"; 
  
  // FETCHING DATA FROM DATABASE 
  $result = $conn->query($query); 
  
    if ($result->num_rows > 0)  
    { 
        // OUTPUT DATA OF EACH ROW 
        while($row = $result->fetch_assoc()) 
        { 
            echo "Hello, " . $row["first_name"]. " " . $row["last_name"]. "<br>"; 
        } 
    }  
    else { 
        echo "0 results"; 
    } 
  
   $conn->close(); 
  
?>