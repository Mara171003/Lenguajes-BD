<?php

include '../DAL/conexion.php';
$conn = conecta();
// INICIO ELIMINAR FOTO ===========================================================================================

if (isset($_POST['idFoto'])) {
    $idFoto = $_POST['idFoto'];
    $rutaFoto = $_POST['rutaFoto'];

    // Eliminar archivo del sistema de archivos
    if (file_exists($rutaFoto)) {
        unlink($rutaFoto);
    }

    // Preparar y ejecutar la llamada al procedimiento almacenado
    $sql = "BEGIN eliminar_foto(:idFoto); END;";
    $stmt = oci_parse($conn, $sql);
    oci_bind_by_name($stmt, ':idFoto', $idFoto, SQLT_INT);

    $result = oci_execute($stmt);

    if (!$result) {
        $error = oci_error($stmt);
        echo 'Error al eliminar la foto: ' . $error['message'];
    } else {
        include "confirmado_borrar.php";
    }

    // Liberar recursos y cerrar conexión
    oci_free_statement($stmt);
    oci_close($conn);
}

// FIN ELIMINAR FOTO ===========================================================================================
?>