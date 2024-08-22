<?php
include '../DAL/conexion.php';
$conn = conecta();
// EDITAR RUTINA (remplaza datos/update de datos)
$name = $_POST['name'];
$day = $_POST['day'];
$id = $_POST['id'];

//preparar consulta para actualizar
$updateSQL = "BEGIN SP_UPDATE_RUTINA(:P_ID_RUTINA,:P_NOMBRE_RUTINA,:P_DIA_RUTINA); END;";

//preparar conexion y consulta
$stid = oci_parse($conn, $updateSQL);

//ligar variables/paremetros
oci_bind_by_name($stid, ':P_ID_RUTINA', $id);
oci_bind_by_name($stid, ':P_NOMBRE_RUTINA', $name);
oci_bind_by_name($stid, ':P_DIA_RUTINA', $day);

//ejecutar
oci_execute($stid);

//liberar
oci_free_statement($stid);
oci_close($conn);