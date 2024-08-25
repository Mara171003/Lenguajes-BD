<?php
include "../DAL/conexion.php";
require_once "../include/functions/recoge.php";
$conn = Conecta();
session_start();

function insertUsuario($conn, $nombre, $primerApellido, $segundoApellido, $correo, $password) {

    $insertSQL = "BEGIN sp_insert_usuario(:p_nombre, :p_primer_apellido, :p_segundo_apellido, :p_correo, :p_password); END;";
    $stid = oci_parse($conn, $insertSQL);
    
    // Ligar las variables/paremetros
    oci_bind_by_name($stid, ':p_nombre', $nombre);
    oci_bind_by_name($stid, ':p_primer_apellido', $primerApellido);
    oci_bind_by_name($stid, ':p_segundo_apellido', $segundoApellido);
    oci_bind_by_name($stid, ':p_correo', $correo);
    oci_bind_by_name($stid, ':p_password', $password);

    //ejecutar
    oci_execute($stid);

    //liberar
    oci_free_statement($stid);
    oci_close($conn);

    // extraer el usuario recien creado para guardar variables de sesion
    $validacion = 'BEGIN sp_get_usuario_X_correo(:p_correo, :p_cursor); END;';

    $stid_D = oci_parse($conn, $validacion);
    $p_cursor = oci_new_cursor($conn);

    oci_bind_by_name($stid_D, ':p_correo', $correo);
    oci_bind_by_name($stid, ':p_cursor', $p_cursor, -1, OCI_B_CURSOR);

    oci_execute($stid_D);
    oci_execute($p_cursor);
    
    if ($datos = oci_fetch_object($stid_D)) {
        $_SESSION['usuario'] = $datos->CORREO;
        $_SESSION['id'] = $datos->ID_USUARIO;
        $_SESSION['rol'] = $datos->ID_ROL;
        $_SESSION['apellido1'] = $datos->PRIMER_APELLIDO;
        $_SESSION['apellido2'] = $datos->SEGUNDO_APELLIDO;
        $_SESSION['nombre'] = $datos->NOMBRE;
        
    } else {
        echo 'Error al registrar';
    }

    //liberar
    oci_free_statement($stid_D);
    oci_free_statement($p_cursor);
    oci_close($conn);
}

if (isset($_POST["correo"])) {
    $nombre = recogePost("nombre");
    $primerApellido = recogePost("apellido1");
    $segundoApellido = recogePost("apellido2");
    $correo = recogePost("correo");
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

        //funcion insert usuario
        insertUsuario($conn, $nombre, $primerApellido, $segundoApellido, $correo, $password);

        //funcion insert detalles usuario
    }

    


}
?>
