<?php
include "../DAL/conexion.php";

// Actualización de suscripción
if (isset($_POST['idUser']) && isset($_POST['valor'])) {
    $idUser = intval($_POST['idUser']);
    $valor = $_POST['valor'];

    $conn = Conecta();
    $stmt = $conn->prepare("UPDATE usuario SET tipo_suscripcion = ? WHERE id_usuario = ?");
    $stmt->bind_param("si", $valor, $idUser);
    
    if ($stmt->execute()) {
        echo 'Suscripción cambiada';
    } else {
        echo 'Error al cambiar la suscripción';
    }

    $stmt->close();
    $conn->close();
}

// Inserción de pago
if (isset($_POST['idUser']) && isset($_POST['monto']) && isset($_POST['dia']) && isset($_POST['estado'])) {
    $idUser = intval($_POST['idUser']);
    $monto = floatval($_POST['monto']);
    $dia = intval($_POST['dia']);
    $estado = $_POST['estado'];

    $conn = Conecta();
    
    // Verificar si ya existe un pago para el usuario
    $stmt = $conn->prepare("SELECT * FROM pagos WHERE id_usuario = ?");
    $stmt->bind_param("i", $idUser);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        echo "1"; // Indica que ya existe un pago
    } else {
        // Insertar nuevo pago
        $stmt = $conn->prepare("INSERT INTO pagos (monto, dia_pago, estado, id_usuario) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("diss", $monto, $dia, $estado, $idUser);

        if ($stmt->execute()) {
            echo "2"; // Indica que el pago fue insertado
        } else {
            echo 'Error al insertar el pago';
        }
    }

    $stmt->close();
    $conn->close();
}
?>
