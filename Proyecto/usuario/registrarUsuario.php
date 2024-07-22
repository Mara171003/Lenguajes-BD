<?php
include "../DAL/conexion.php";
require_once "../include/functions/recoge.php";
session_start();

if (isset($_POST["correo"])) {
    $nombre = recogePost("nombre");
    $primerApellido = recogePost("apellido1");
    $segundoApellido = recogePost("apellido2");
    $correo = recogePost("correo");
    $password = recogePost("password");
    $password = md5($password); // Encriptar contraseña

    $conn = Conecta();

    // Verificar si el correo ya está registrado
    $verificarCorreo = "SELECT correo FROM usuario WHERE correo = :correo";
    $stid = oci_parse($conn, $verificarCorreo);
    oci_bind_by_name($stid, ':correo', $correo);
    oci_execute($stid);

    if (oci_fetch($stid)) {
        echo 'Este correo ya está registrado';
        oci_free_statement($stid);
        oci_close($conn);
        die();
    }

    oci_free_statement($stid);

    // Insertar nuevo usuario
    $sql = "INSERT INTO usuario (nombre, primer_apellido, segundo_apellido, correo, tipo_suscripcion, id_rol, password)
            VALUES (:nombre, :primer_apellido, :segundo_apellido, :correo, 'basico', 2, :password)";
    $stid = oci_parse($conn, $sql);
    oci_bind_by_name($stid, ':nombre', $nombre);
    oci_bind_by_name($stid, ':primer_apellido', $primerApellido);
    oci_bind_by_name($stid, ':segundo_apellido', $segundoApellido);
    oci_bind_by_name($stid, ':correo', $correo);
    oci_bind_by_name($stid, ':password', $password);

    if (oci_execute($stid)) {
        echo 'Usuario registrado';

        // Validación e inicio de sesión automático
        $validacion = "SELECT * FROM usuario WHERE correo = :correo";
        $stid = oci_parse($conn, $validacion);
        oci_bind_by_name($stid, ':correo', $correo);
        oci_execute($stid);

        if ($datos = oci_fetch_object($stid)) {
            $_SESSION['usuario'] = $datos->CORREO;
            $_SESSION['id'] = $datos->ID_USUARIO;
            $_SESSION['rol'] = $datos->ID_ROL;
            $_SESSION['apellido1'] = $datos->PRIMER_APELLIDO;
            $_SESSION['apellido2'] = $datos->SEGUNDO_APELLIDO;
            $_SESSION['nombre'] = $datos->NOMBRE;
            header("Location: ../index.php");
        }
    } else {
        echo 'Error al registrar';
    }

    oci_free_statement($stid);
    oci_close($conn);
}
?>
