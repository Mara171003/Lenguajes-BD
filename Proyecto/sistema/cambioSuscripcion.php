<?php
include "../DAL/conexion.php";

// Actualización de suscripción
if (isset($_POST['idUser']) && isset($_POST['valor'])) {
    $idUser = intval($_POST['idUser']);
    $valor = $_POST['valor'];

    $conn = Conecta();
    $sql = "UPDATE usuario SET tipo_suscripcion = :valor WHERE id_usuario = :idUser";
    $stmt = oci_parse($conn, $sql);
    oci_bind_by_name($stmt, ':valor', $valor);
    oci_bind_by_name($stmt, ':idUser', $idUser);
    
    if (oci_execute($stmt)) {
        echo 'Suscripción cambiada';
    } else {
        $e = oci_error($stmt);
        echo 'Error al cambiar la suscripción: ' . $e['message'];
    }

    oci_free_statement($stmt);
}

// Inserción de pago
if (isset($_POST['idUser']) && isset($_POST['monto']) && isset($_POST['dia']) && isset($_POST['estado'])) {
    $idUser = intval($_POST['idUser']);
    $monto = floatval($_POST['monto']);
    $dia = intval($_POST['dia']);
    $estado = $_POST['estado'];

    $conn = Conecta();
    
    // Verificar si ya existe un pago para el usuario
    $sql = "SELECT * FROM pagos WHERE id_usuario = :idUser";
    $stmt = oci_parse($conn, $sql);
    oci_bind_by_name($stmt, ':idUser', $idUser);
    oci_execute($stmt);

    if (oci_fetch($stmt)) {
        echo "1"; // Indica que ya existe un pago
    } else {
        // Insertar nuevo pago
        $sql = "INSERT INTO pagos (monto, dia_pago, estado, id_usuario) VALUES (:monto, :dia, :estado, :idUser)";
        $stmt = oci_parse($conn, $sql);
        oci_bind_by_name($stmt, ':monto', $monto);
        oci_bind_by_name($stmt, ':dia', $dia);
        oci_bind_by_name($stmt, ':estado', $estado);
        oci_bind_by_name($stmt, ':idUser', $idUser);

        if (oci_execute($stmt)) {
            echo "2"; // Indica que el pago fue insertado
        } else {
            $e = oci_error($stmt);
            echo 'Error al insertar el pago: ' . $e['message'];
        }
    }

    oci_free_statement($stmt);
}

oci_close($conn);
?>