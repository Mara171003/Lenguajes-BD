<?php

// EDITAR RUTINA
//este editar a diferencia de read, busca rutina individualmente por id rutina (no de usuario)
//es el que se usa para llenar los cambos de texto al dar boton editar
include '../DAL/conexion.php';
$conn = conecta();

    
if(isset($_POST['idRutina'])){

    $id=$_POST["idRutina"];

    //definir cursor
    $p_cursor_rutina = oci_new_cursor($conn);

    //prepara la consulta para llamar el sp de lectura (rutina individual, sin "s")
    $readSQL = "BEGIN SP_GET_RUTINA(:P_ID_RUTINA, :P_CURSOR_RUTINA); END;";

    //preparar conexion y consulta
    $stid = oci_parse($conn, $readSQL);
        
    //ligar variable/parametro
    oci_bind_by_name($stid, ':P_ID_RUTINA', $id);
    oci_bind_by_name($stid, ':P_CURSOR_RUTINA', $p_cursor_rutina, -1, OCI_B_CURSOR);

    //ejecutar consulta
    oci_execute($stid);
    oci_execute($p_cursor_rutina);

    //en este caso se guardan los objetos en un array JSON para despues
    //ser consultado con GET de AJAX en FRONTEND
    $json = array();
    while (($row = oci_fetch_assoc($p_cursor_rutina)) !== false) {
        $json[] = array(
            'name' => $row['NOMBRE_RUTINA'],
            'day' => $row['DIA_RUTINA']
        );
    }
    //pasar a objeto JSON
    $jsonString = json_encode($json);
    //El echo envia a frotEnd (se recibe en JavaScript de rutina)
    echo $jsonString;

    //liberar
    oci_free_statement($stid);
    oci_free_statement($p_cursor_rutina);
    oci_close($conn);
}

?>