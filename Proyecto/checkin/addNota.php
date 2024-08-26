<?php
session_start(); // Asegúrate de iniciar la sesión para acceder a $_SESSION

include "../DAL/conexion.php";

$conn = conecta();

// Verifica que el usuario esté autenticado y tenga el rol adecuado
if (!isset($_SESSION['rol']) || $_SESSION['rol'] !== '1') {
    die('Acceso no autorizado.');
}

// Recibe los datos del formulario
$idFoto = isset($_POST['idFoto']) ? intval($_POST['idFoto']) : 0;
$nota = isset($_POST['nota']) ? trim($_POST['nota']) : '';
$idUsuario= $_POST['idUsuario']; 



// Verifica si los datos son válidos\
/*
if ($idFoto <= 0 || empty($nota)) {
    die('Datos inválidos.');
}*/
echo $idFoto;



// Prepara la llamada al procedimiento almacenado
$sql = 'BEGIN UpdateNotaMes(:idFoto, :nota); END;';
$stmt = oci_parse($conn, $sql);

// Asocia los parámetros
oci_bind_by_name($stmt, ':idFoto', $idFoto, -1, SQLT_INT);
oci_bind_by_name($stmt, ':nota', $nota, -1, SQLT_CHR);

// Ejecuta el procedimiento
if (oci_execute($stmt)) {
    header("Location: check-in.php?id=$idUsuario");
} else {
    $e = oci_error($stmt);
    echo 'Error al actualizar la nota: ' . $e['message'];
}

// Cierra la conexión y libera recursos
oci_free_statement($stmt);
oci_close($conn);
?>