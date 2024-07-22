<?php
include "conexion.php";

function obtenerDatosUsuario($userId) {
    $conn = Conecta();

    // Preparar y ejecutar la consulta
    $query = "SELECT * FROM usuario WHERE id_usuario = :user_id";
    $stid = oci_parse($conn, $query);
    oci_bind_by_name($stid, ':user_id', $userId);
    oci_execute($stid);

    // Recoger los resultados
    $result = [];
    while ($row = oci_fetch_assoc($stid)) {
        $result[] = $row;
    }

    oci_free_statement($stid);
    oci_close($conn);

    return $result;
}

?>
