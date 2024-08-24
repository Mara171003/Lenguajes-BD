<?php
include '../DAL/conexion.php';
$conn = conecta();

// EDITAR EJERCICIO (reemplaza datos/actualiza datos)
$nombre = $_POST['nombre'];
$sets = $_POST['sets'];
$maquina = $_POST['maquina'];
$observaciones = $_POST['observaciones'];
$id = $_POST['idEjercicio'];

// Preparar consulta para actualizar
$updateSQL = "BEGIN SP_UPDATE_EJERCICIO(:P_ID_EJERCICIO, :P_NOMBRE_EJERCICIO, :P_SETS, :P_MAQUINA, :P_OBSERVACIONES); END;";

// Preparar conexión y consulta
$stid = oci_parse($conn, $updateSQL);

// Ligar variables/parámetros
oci_bind_by_name($stid, ':P_ID_EJERCICIO', $id);
oci_bind_by_name($stid, ':P_NOMBRE_EJERCICIO', $nombre);
oci_bind_by_name($stid, ':P_SETS', $sets);
oci_bind_by_name($stid, ':P_MAQUINA', $maquina);
oci_bind_by_name($stid, ':P_OBSERVACIONES', $observaciones);

// Ejecutar
oci_execute($stid);

// Liberar
oci_free_statement($stid);
oci_close($conn);
?>