<?php

include '../DAL/conexion.php';

if (isset($_POST['id'])) {

    $conn = conecta();
    $id = $_POST['id'];

    //definir cursor
    $P_CURSOR_EJERCICIO = oci_new_cursor($conn);

    $readSQL = "BEGIN SP_GET_EJERCICIOS(:P_ID_RUTINA, :P_CURSOR_EJERCICIO); END;";

    $stid = oci_parse($conn, $readSQL);

    oci_bind_by_name($stid, ':P_ID_RUTINA', $id);

    oci_bind_by_name($stid, ':P_CURSOR_EJERCICIO', $P_CURSOR_EJERCICIO, -1, OCI_B_CURSOR);

    //en este caso se guardan los objetos en un array JSON para despues
    //ser consultado con GET de AJAX en FRONTEND

    oci_execute($stid);
    oci_execute($P_CURSOR_EJERCICIO);

    $json = array();
    while (($row = oci_fetch_assoc($P_CURSOR_EJERCICIO)) !== false) {
        $json[] = array(
            'idEjercicio' => $row['ID_EJERCICIO'],
            'nombre' => $row['NOMBRE_EJERCICIO'],
            'sets' => $row['SETSE'],
            'maquina' => $row['MAQUINA'],
            'observaciones' => $row['OBSERVACIONES']

        );
    }

    $jsonString = json_encode($json);
    echo $jsonString;

    oci_free_statement($stid);
    oci_free_statement($P_CURSOR_EJERCICIO);
    oci_close($conn);
}
?>