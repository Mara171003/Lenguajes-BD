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
        $query = "BEGIN SP_USUARIO_LOGIN(:P_CORREO,:P_PASSWORD,:P_CURSOR); END;";
        $P_CURSOR = oci_new_cursor($conn);

        $stid = oci_parse($conn, $query);

        oci_bind_by_name($stid, ':P_CURSOR', $P_CURSOR, -1, OCI_B_CURSOR);
        oci_bind_by_name($stid, ':P_CORREO', $correo);
        oci_bind_by_name($stid, ':P_PASSWORD', $password);

        oci_execute($stid);
        oci_execute($P_CURSOR);

        while (($datos = oci_fetch_assoc($P_CURSOR)) !== false) {
            $_SESSION['usuario'] = $datos['CORREO']; // Extrae el correo
            $_SESSION['id'] = $datos['ID_USUARIO']; // Extrae el id del usuario autenticado
            $_SESSION['rol'] = $datos['ID_ROL']; // Extrae el rol
            $_SESSION['apellido1'] = $datos['PRIMER_APELLIDO'];
            $_SESSION['apellido2'] = $datos['SEGUNDO_APELLIDO'];
            $_SESSION['nombre'] = $datos['NOMBRE'];
            $_SESSION['filtro']=false;
            echo "success";

            if ($_SESSION['rol'] == 1) { // Si rol es 1 (admin)
                header("Location: ../indexAdmin.php"); // Redirigir al index de admin
            }else{
                header("Location: ../index.php");
            }

        }
    }
}

?>