<?php

include '../DAL/conexion.php';
session_start();

$conn = conecta();


// INICIO SUBIR FOTO ===========================================================================================

$fechaActual = date('Y-m-d');
$anno = strftime('%Y', strtotime($fechaActual));
$numero_mes = date('n', strtotime($fechaActual));

$meses_espanol = array(
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
);

$mes = $meses_espanol[$numero_mes - 1];
$id = $_SESSION['id'];
if (isset($_FILES['file'])) {
    $file = $_FILES['file'];
    $nombreImagen = $file['name'];
    $tipoImagen = $file['type'];
    $size = $file['size'];
    $idUsuario = intval($_POST['id']);

    $extensiones = array("image/jpg", "image/jpeg", "image/png");

    if (!in_array($tipoImagen, $extensiones)) {
        header("Location: check-in.php?id=$idUsuario");
        exit();
    }

    if ($size > 5 * 1024 * 1024) {
        echo "El tamaño máximo permitido son 5MB";
        header("Location: check-in.php?id=$idUsuario");
        exit();
    }

    if (!is_dir("uploads")) {
        mkdir("uploads", 0777);
    }

    move_uploaded_file($file['tmp_name'], 'uploads/' . $nombreImagen);
    $rutaFoto = 'uploads/' . $nombreImagen;

    // Validar si el mes ya existe relacionado con alguna nota
    $sql = "BEGIN mesValidacionNotaMes(:idUsuario, :existe); END;";
    $stmt = oci_parse($conn, $sql);
    oci_bind_by_name($stmt, ':idUsuario', $idUsuario);
    oci_bind_by_name($stmt, ':existe', $existeMes, 32);

    if (!oci_execute($stmt)) {
        $error = oci_error($stmt);
        echo "Error en mesValidacionNotaMes: " . $error['message'];
        exit();
    }

    if ($existeMes > 0) {
        // Notas del mes ya están registradas, se inserta la foto
        $sql = "BEGIN insertar_Foto(:mes, :anno, :rutaFoto, :idUsuario); END;";
        $stmt = oci_parse($conn, $sql);
        oci_bind_by_name($stmt, ':mes', $mes);
        oci_bind_by_name($stmt, ':anno', $anno);
        oci_bind_by_name($stmt, ':rutaFoto', $rutaFoto);
        oci_bind_by_name($stmt, ':idUsuario', $idUsuario);
    
        if (oci_execute($stmt)) {
            echo "Foto insertada exitosamente.";
        } else {
            $error = oci_error($stmt);
            echo "Error al insertar la foto: " . $error['message'];
            exit();
        }
    } else {
        $sql = "BEGIN insertar_Foto(:mes, :anno, :rutaFoto, :idUsuario); END;";
        $stmt = oci_parse($conn, $sql);
        oci_bind_by_name($stmt, ':mes', $mes);
        oci_bind_by_name($stmt, ':anno', $anno);
        oci_bind_by_name($stmt, ':rutaFoto', $rutaFoto);
        oci_bind_by_name($stmt, ':idUsuario', $idUsuario);
    
        if (oci_execute($stmt)) {
            echo "Notas del mes creadas e imagen insertada exitosamente.";
        } else {
            $error = oci_error($stmt);
            echo "Error al insertar la foto : " . $error['message'];
            exit();
        }

        // Obtener el ID de la foto insertada
        $sql = "BEGIN obtenerUltimoIdFoto(:idFoto); END;";
        $stmt = oci_parse($conn, $sql);
        oci_bind_by_name($stmt, ':idFoto', $idFoto, 32);
 
        if (!oci_execute($stmt)) {
            $error = oci_error($stmt);
            echo "Error al obtener el ID de la foto: " . $error['message'];
            exit();
        }

        // Crear la nota del mes con el ID de la foto obtenida
        $sql = "BEGIN crearNotaMes(:notaMensual, :idFoto); END;";
        $stmt = oci_parse($conn, $sql);
        $notaMensual = NULL; // Nota nula al principio
        oci_bind_by_name($stmt, ':notaMensual', $notaMensual);
        oci_bind_by_name($stmt, ':idFoto', $idFoto);

        if (oci_execute($stmt)) {
            echo "Notas del mes creadas e imagen insertada exitosamente.";
        } else {
            $error = oci_error($stmt);
            echo "Error al crear las notas del mes después de insertar la foto: " . $error['message'];
            exit();
        }
    }

    header("Location: confirmado_crear.php?id=$idUsuario");
    exit();
} else {
    header("Location: check-in.php?id=$idUsuario");
    exit();
}

// FIN SUBIR FOTO ===========================================================================================

?>