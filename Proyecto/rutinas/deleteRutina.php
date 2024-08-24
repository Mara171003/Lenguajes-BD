<?php
include '../DAL/conexion.php';
$conn = conecta();
// Eliminar RUTINA

if (isset($_POST['idRutina'])) {
    $id = $_POST['idRutina'];
    echo 'eliminar Rutina con ID: ' . $id;

    //preparar consulta para eliminar
    $deleteSQL = "BEGIN SP_DELETE_RUTINA(:P_ID_RUTINA); END;";

    //preparar conexion y consulta
    $stid = oci_parse($conn, $deleteSQL);

    //ligar variables/paremetros
    oci_bind_by_name($stid, ':P_ID_RUTINA', $id);

    //ejecutar
    oci_execute($stid);

    //liberar
    oci_free_statement($stid);
    oci_close($conn);
}
?>