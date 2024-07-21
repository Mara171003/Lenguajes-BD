<?php

// Create connection to Oracle
$conn = oci_connect("DB_NAME", "DB_PASSWORD", "DB_IP:PORT_NO/DATABASE_NAME");

if (!$conn) {
  
$m = oci_error();
  
echo $m['message'], "\n";
 
exit;

}
else {
  
print "Connected to Oracle DB!";

}

// Close the Oracle connection

oci_close($conn);
?>
