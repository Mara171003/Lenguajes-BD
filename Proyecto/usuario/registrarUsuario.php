<?php
include "../DAL/conexion.php";
require_once "../include/functions/recoge.php";
$conn = Conecta();
session_start();

if (isset($_POST["correo"])) {
    $nombre = recogePost("nombre");
    $primerApellido = recogePost("apellido1");
    $segundoApellido = recogePost("apellido2");
    $correo = recogePost("correo");
    $idRol=2;
    $tipoSuscripcion="basico";
    $password = recogePost("password");
    $password = md5($password); // Encriptar contraseña

    

    // Verificar si el correo ya está registrado
    $verificarCorreo = "BEGIN SP_GET_CORREO(:P_CORREO, :P_EXISTE); END;";
    $stidV = oci_parse($conn, $verificarCorreo);

    oci_bind_by_name($stidV, ':P_CORREO', $correo);
    oci_bind_by_name($stidV, ':P_EXISTE', $existe, 32);

    oci_execute($stidV);

    //verifica si el correo existe
    $v = false; //booleano existe correo o no
    if ($existe > 0) {
        $v = false;//si hay concidencia de correo
        echo $v;
        oci_free_statement($stidV);
        session_destroy();
        exit();//detener
        
    }else{//Si no hay coincidencia, prosigue
        $v = true;
        echo $v;
    }








    die();
    // Insertar nuevo usuario
    
    $insertSQL = "BEGIN sp_insert_usuario(:p_nombre, :p_primer_apellido, :p_segundo_apellido, :p_correo, :p_tipo_suscripcion, :p_id_rol, :p_password); END;";
    $stid = oci_parse($conn, $insertSQL);
    
    // Ligar las variables/paremetros
    oci_bind_by_name($stid, ':p_nombre', $nombre);
    oci_bind_by_name($stid, ':p_primer_apellido', $primerApellido);
    oci_bind_by_name($stid, ':p_segundo_apellido', $segundoApellido);
    oci_bind_by_name($stid, ':p_correo', $correo);
    oci_bind_by_name($stid, ':p_tipo_suscripcion', $tipoSuscripcion);
    oci_bind_by_name($stid, ':p_id_rol', $idRol);
    oci_bind_by_name($stid, ':p_password', $password);

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
