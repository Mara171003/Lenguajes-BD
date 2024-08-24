<?php
include '../DAL/conexion.php';
// EDITAR ejercicio
$conn = conecta();

if (isset($_POST['idEjercicio'])) {

    $id = $_POST["idEjercicio"];

    // Definir cursor
    $P_CURSOR_EJERCICIO = oci_new_cursor($conn);

    // Preparar la consulta para llamar el SP de lectura (ejercicio individual, sin "s")
    $readSQL = "BEGIN SP_GET_EJERCICIO(:P_ID_EJERCICIO, :P_CURSOR_EJERCICIO); END;";

    // Preparar conexión y consulta
    $stid = oci_parse($conn, $readSQL);

    // Ligar variable/parámetro
    oci_bind_by_name($stid, ':P_ID_EJERCICIO', $id);
    oci_bind_by_name($stid, ':P_CURSOR_EJERCICIO', $P_CURSOR_EJERCICIO, -1, OCI_B_CURSOR);

    // Ejecutar consulta
    oci_execute($stid);
    oci_execute($P_CURSOR_EJERCICIO);

    // En este caso, se guardan los objetos en un array JSON para después
    // ser consultados con GET de AJAX en FRONTEND
    $json = array();
    while (($row = oci_fetch_assoc($P_CURSOR_EJERCICIO)) !== false) {
        $json[] = array(
            'nombre' => $row['NOMBRE_EJERCICIO'],
            'sets' => $row['SETSE'],
            'maquina' => $row['MAQUINA'],
            'observaciones' => $row['OBSERVACIONES'],
        );
    }

    // Pasar a objeto JSON
    $jsonString = json_encode($json);
    // El echo envía a frontEnd (se recibe en JavaScript de ejercicio)
    echo $jsonString;

    // Liberar
    oci_free_statement($stid);
    oci_free_statement($P_CURSOR_EJERCICIO);
    oci_close($conn);

}
?>