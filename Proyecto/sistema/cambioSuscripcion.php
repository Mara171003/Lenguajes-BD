<?php
include "../DAL/conexion.php";

// Actualización de suscripción
if (isset($_POST['idUser']) && isset($_POST['valor'])) {

    $idUser = $_POST['idUser'];
    $valor = $_POST['valor'];

    $conn = Conecta();
    $updatePagoUpdateSuscripcion = "BEGIN SP_UPDATE_USUARIO(:P_VALOR, :P_ID_USUARIO); END;";
    $stmtS = oci_parse($conn, updatePagoUpdateSuscripcion);
    oci_bind_by_name($stmtS, ':P_VALOR', $valor);
    oci_bind_by_name($stmtS, ':P_ID_USUARIO', $idUser);
    
    if (oci_execute($stmtS)) {
        echo 'Suscripción cambiada';
    } else {
        $e = oci_error($stmtS);
        echo 'Error al cambiar la suscripción: ' . $e['message'];
    }

    oci_free_statement($stmtS);
}

// Inserción de pago
if (isset($_POST['idUser']) && isset($_POST['monto']) && isset($_POST['dia']) && isset($_POST['estado'])) {
    $idUser = $_POST['idUser'];
    $monto = floatval($_POST['monto']);
    $dia = $_POST['dia'];
    $estado = $_POST['estado'];

    $conn = Conecta();
    
    // Verificadr si ya existe un pago para el usuario
    $verificarPago = "BEGIN SP_VERIFICAR_PAGOS(:P_ID_USUARIO, :P_EXISTE); END;";
    $stidV = oci_parse($conn, $verificarPago);

    oci_bind_by_name($stidV, ':P_ID_USUARIO', $idUser);
    oci_bind_by_name($stidV, ':P_EXISTE', $existe, 32);

    oci_execute($stidV);

    // Verifica si ya existe un pago
    $v = false; // booleano que indica si existe un pago o no
    if ($existe > 0) {
        $v = true; // Si hay coincidencia, 1
        echo $v;
        oci_free_statement($stidV);
        echo "Hay pago con esta misma id: ".$idUser.", actualizar";

        //*************** funcion actualizar **************************
        $sqlU = "BEGIN sp_update_pagos(:P_ID_USUARIO, :P_MONTO, :P_DIA_PAGO, :P_ESTADO); END;";
        $stmtU = oci_parse($conn, $sqlU);
        oci_bind_by_name($stmtU, ':P_ID_USUARIO', $idUser);
        oci_bind_by_name($stmtU, ':P_MONTO', $monto);
        oci_bind_by_name($stmtU, ':P_DIA_PAGO', $dia);
        oci_bind_by_name($stmtU, ':P_ESTADO', $estado);

        //Ejecutar
        oci_execute($stmtU);

        //Liberar
        oci_free_statement($stmtU);
        oci_close($conn);
    } else {
        oci_close($conn);
        $conn = Conecta();

        $v = false; // No hay coincidencia, 0
        echo $v;

        //INSERTAR NUEVO PAGO
        $insertPago = "BEGIN SP_INSERT_PAGOS(:P_ID_USUARIO, :P_MONTO, :P_DIA_PAGO, :P_ESTADO); END;";
        $stmt = oci_parse($conn, $insertPago);

        oci_bind_by_name($stmt, ':P_ID_USUARIO', $idUser);
        oci_bind_by_name($stmt, ':P_MONTO', $monto);
        oci_bind_by_name($stmt, ':P_DIA_PAGO', $dia);
        oci_bind_by_name($stmt, ':P_ESTADO', $estado);

        //ejecutar
        oci_execute($stmt);

        //liberar
        oci_free_statement($stmt);
        oci_close($conn);
    }
}
?>