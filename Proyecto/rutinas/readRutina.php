<?php
//Este lista las rutinas vinculadas por ID USUARIO
include '../DAL/conexion.php';
$conn = conecta();
    if(isset($_POST['id'])){

    $id=$_POST['id'];

    //definir cursor
    $P_CURSOR_RUTINAS = oci_new_cursor($conn);

    $readSQL = "BEGIN SP_GET_RUTINAS(:P_ID_USUARIO, :P_CURSOR_RUTINAS); END;";

    $stid = oci_parse($conn, $readSQL);

    oci_bind_by_name($stid, ':P_ID_USUARIO', $id);

    oci_bind_by_name($stid, ':P_CURSOR_RUTINAS', $P_CURSOR_RUTINAS, -1, OCI_B_CURSOR);

    //en este caso se guardan los objetos en un array JSON para despues
    //ser consultado con GET de AJAX en FRONTEND

    oci_execute($stid);
    oci_execute($P_CURSOR_RUTINAS);

    $json = array();
    while (($row = oci_fetch_assoc($P_CURSOR_RUTINAS)) !== false) {
        $json[] = array(
            'idRutina' => $row['ID_RUTINA'],
            'name' => $row['NOMBRE_RUTINA'],
            'day' => $row['DIA_RUTINA'],
            'idUser' => $row['ID_USUARIO']
        );
    }

    
    $jsonString = json_encode($json);
    echo $jsonString;

    oci_free_statement($stid);
    oci_free_statement($P_CURSOR_RUTINAS);
    oci_close($conn);
    }


?>