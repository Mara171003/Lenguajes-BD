<?php
include '../DAL/conexion.php';
$conn = conecta();
// Eliminar ejercicio

if (isset($_POST['idEjercicio'])) {
    $id = $_POST['idEjercicio'];
    echo 'Eliminar Ejercicio con ID: ' . $id;

    // Preparar consulta para eliminar
    $deleteSQL = "BEGIN SP_DELETE_EJERCICIO(:P_ID_EJERCICIO); END;";

    // Preparar conexión y consulta
    $stid = oci_parse($conn, $deleteSQL);

    // Ligadura de variables/parámetros
    oci_bind_by_name($stid, ':P_ID_EJERCICIO', $id);

    // Ejecutar
    oci_execute($stid);

    // Liberar
    oci_free_statement($stid);
    oci_close($conn);
}

?>