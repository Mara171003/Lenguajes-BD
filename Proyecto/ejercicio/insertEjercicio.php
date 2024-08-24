<?php
//AGREGAR ejercicio

include '../DAL/conexion.php';
$conn = conecta();

if (isset($_POST['nombre'])) { //verifica enviado en JSON desde JS

    $nombre = $_POST['nombre'];
    $sets = $_POST['sets'];
    $maquina = $_POST['maquina'];
    $observaciones = $_POST['observaciones'];
    $idRutina=$_POST['idRutina']; //Foreign key

    $insertSQL = "BEGIN SP_INSERT_EJERCICIO(:P_NOMBRE_EJERCICIO, :P_SETS, :P_MAQUINA, :P_OBSERVACIONES, :P_ID_RUTINA); END;";

    // Preparar conexión y consulta
    $stid = oci_parse($conn, $insertSQL);

    // Ligar variables/parámetros
    oci_bind_by_name($stid, ':P_NOMBRE_EJERCICIO', $nombre);
    oci_bind_by_name($stid, ':P_SETS', $sets);
    oci_bind_by_name($stid, ':P_MAQUINA', $maquina);
    oci_bind_by_name($stid, ':P_OBSERVACIONES', $observaciones);
    oci_bind_by_name($stid, ':P_ID_RUTINA', $idRutina);

    //ejecutar
    oci_execute($stid);

    //liberar
    oci_free_statement($stid);
    oci_close($conn);
}
