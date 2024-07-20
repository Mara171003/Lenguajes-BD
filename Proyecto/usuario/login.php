<?php
include "../DAL/conexion.php";
require_once "../include/functions/recoge.php";
session_start();

if (!empty($_POST["btnIngresar"])) {
    if (!empty($_POST["correo"]) && !empty($_POST["password"])) {
        $correo = recogePost('correo');
        $password = recogePost('password');
        $password = md5($password);

        $conn = Conecta(); // Obtener la conexión a la base de datos

        // Preparar y ejecutar la consulta
        $query = "SELECT * FROM usuario WHERE correo = :correo AND password = :password";
        $stid = oci_parse($conn, $query);
        oci_bind_by_name($stid, ':correo', $correo);
        oci_bind_by_name($stid, ':password', $password);
        oci_execute($stid);

        if ($datos = oci_fetch_object($stid)) { // Si se encuentra un resultado
            $_SESSION['usuario'] = $datos->CORREO; // Extrae el correo
            $_SESSION['id'] = $datos->ID_USUARIO; // Extrae el id del usuario autenticado
            $_SESSION['rol'] = $datos->ID_ROL; // Extrae el rol
            $_SESSION['apellido1'] = $datos->PRIMER_APELLIDO;
            $_SESSION['apellido2'] = $datos->SEGUNDO_APELLIDO;
            $_SESSION['nombre'] = $datos->NOMBRE;
            echo "success";
            header("Location: ../index.php");
        } else {
            echo "<script>alert('Acceso denegado')</script>";
        }

        oci_free_statement($stid);
        oci_close($conn);
    } else {
        echo "<script>alert('Campos vacíos')</script>";
    }
}
?>
