<?php
// Configuración de conexión
function Conecta() {
    $username = 'CPROYECTO';
    $password = 'proyectoSQL';
    $connection_string = 'localhost:1521/orcl'; // Cambia a tu string de conexión

    // Conectar a la base de datos Oracle
    $conn = oci_connect($username, $password, $connection_string);

    if (!$conn) {
        $e = oci_error();
        echo "Error de conexión: " . $e['message'];
        exit;
    }

    return $conn;
}
?>