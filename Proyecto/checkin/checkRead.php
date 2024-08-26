<?php

include '../DAL/conexion.php';
$conn = conecta();
session_start();


//recibir solicitud para mostrar la lista de fotos en cada mes
if(isset($_POST['idUser'])){
        $id = intval($_POST['idUser']); // Convertir a entero
    $anno = htmlspecialchars($_POST['anno']); // Escapar caracteres especiales
    $mes = htmlspecialchars($_POST['mes']); // Escapar caracteres especiales

    // Preparar llamada al procedimiento almacenado
    $sql = "BEGIN obtenerFotos(:idUsuario, :anno, :mes, :resultado); END;";

    // Preparar la llamada al procedimiento
    $stmt = oci_parse($conn, $sql);

    // Enlazar parámetros
    oci_bind_by_name($stmt, ':idUsuario', $id, -1, SQLT_INT);
    oci_bind_by_name($stmt, ':anno', $anno, -1, SQLT_CHR);
    oci_bind_by_name($stmt, ':mes', $mes, -1, SQLT_CHR);

    // Crear un cursor para recibir el resultado
    $cursor = oci_new_cursor($conn);
    oci_bind_by_name($stmt, ':resultado', $cursor, -1, OCI_B_CURSOR);

    // Ejecutar el procedimiento
    oci_execute($stmt);

    // Abrir el cursor
    oci_execute($cursor);

    // Inicializar un array para los resultados
    $json = array();
    
// Procesar el resultado
    while (($row = oci_fetch_assoc($cursor)) != false) {
        $json[] = array(
            'id_foto' => $row['ID_FOTO'],
            'mes' => $row['MES'],
            'ruta' => $row['RUTA_FOTO'],
            'anno' => $row['ANNO'],
            'idUser' => $row['ID_USUARIO']
        );
    }

    // Cerrar el cursor
    oci_free_statement($cursor);

    // Devolver el resultado como JSON
    header('Content-Type: application/json');
    $response = ['status' => 'success', 'data' => $json];
    echo json_encode($response);
}

// FIN LISTADO FOTO ===========================================================================================



?>