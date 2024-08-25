<?php
//AGREGAR RUTINA

include '../DAL/conexion.php';
$conn = conecta();

if(isset($_POST['name'])){ //obtener el objeto enviado en JSON desde JS
    
    $idUser=$_POST['idUser']; //de la misma manera con descripcion
    $name = $_POST['name'];  //almacenar el parametro nombre en variable 
    $day=$_POST['day']; //de la misma manera con descripcion

    //preparar consulta para eliminar
    $insertSQL = "BEGIN SP_INSERT_RUTINA(:P_NOMBRE_RUTINA,:P_DIA_RUTINA,:P_ID_USUARIO); END;";

    //preparar conexion y consulta
    $stid = oci_parse($conn, $insertSQL);

    //ligar variables/paremetros
    oci_bind_by_name($stid, ':P_NOMBRE_RUTINA', $name);
    oci_bind_by_name($stid, ':P_DIA_RUTINA', $day);
    oci_bind_by_name($stid, ':P_ID_USUARIO', $idUser);

    //ejecutar
    oci_execute($stid);

    //liberar
    oci_free_statement($stid);
    oci_close($conn);
}

?>