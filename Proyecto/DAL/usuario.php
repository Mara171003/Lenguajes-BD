<?php

function edad($fecha_nacimiento) {

    // Convierte la fecha de nacimiento a DateTime
    $fecha_nacimiento_obj = new DateTime($fecha_nacimiento);

    // Calcular la diferencia entre la fecha de nacimiento y la fecha actual
    $diferencia = date_diff(new DateTime(), $fecha_nacimiento_obj);

    // Obtiene la edad
    $edad = $diferencia->y;

    return $edad;
}



/*
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
*/
?>
