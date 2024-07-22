<?php
session_start();

//verificar si se accedió con login
if (empty($_SESSION['usuario'])) { // si no hay una sesión usuario
    header("location: usuario/vistaLogin.php"); // devolver al login
    exit();
}

$id = intval($_GET['id']); // Asegúrate de que el ID sea un entero

include "../DAL/conexion.php";

// Obtener la conexión
$conn = Conecta();

// Consultas
$queryDetalles = "SELECT * FROM detalles_usuario WHERE id_usuario = :id_usuario";
$queryUsuario = "SELECT id_usuario, nombre, primer_apellido, segundo_apellido FROM usuario WHERE id_usuario = :id_usuario";
$queryRutina = "SELECT id_rutina, nombre_rutina, dia_rutina FROM rutina WHERE id_usuario = :id_usuario";
$queryPagos = "SELECT * FROM pagos WHERE id_usuario = :id_usuario";

// Preparar y ejecutar las consultas
$stidDetalles = oci_parse($conn, $queryDetalles);
$stidUsuario = oci_parse($conn, $queryUsuario);
$stidRutina = oci_parse($conn, $queryRutina);
$stidPagos = oci_parse($conn, $queryPagos);

oci_bind_by_name($stidDetalles, ':id_usuario', $id);
oci_bind_by_name($stidUsuario, ':id_usuario', $id);
oci_bind_by_name($stidRutina, ':id_usuario', $id);
oci_bind_by_name($stidPagos, ':id_usuario', $id);

oci_execute($stidDetalles);
oci_execute($stidUsuario);
oci_execute($stidRutina);
oci_execute($stidPagos);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Usuario</title>
    <link href="../css/bootstrap.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="../css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Krub:ital,wght@0,200;0,300;0,400;0,500;0,600;0,700;1,200;1,300;1,400;1,500;1,600;1,700&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Mostrar datos técnicos -->
    <?php
    include '../templates/header.php';

    $datosU = oci_fetch_object($stidUsuario);
    $pagos = oci_fetch_object($stidPagos);

    while ($datos = oci_fetch_object($stidDetalles)) { ?>

    <div class="container mt-3 animation">
        <div class="mt-4 p-5 bg-dark text-white">
            <h1 class="text-center text-success">
                <?= htmlspecialchars($datosU->nombre . " " . $datosU->primer_apellido . " " . $datosU->segundo_apellido) ?></h1><br>
            <hr class="border-top border-success opacity-25 my-2">
            <div class="text-center">
                <?php if ($pagos && isset($pagos->dia_pago) && isset($pagos->monto)) { ?>
                <h4 class="text-success">Día de Pago:</h4>
                <span>
                    <h4><?= htmlspecialchars($pagos->dia_pago) ?> de cada mes</h4>
                </span>
                <h4 class="text-success">Monto: </h4>
                <span>
                    <h4>CRC <?= htmlspecialchars($pagos->monto) ?></h4>
                </span>
                <h4 class="text-success">Estado: </h4>
                <span>
                    <h4><span class="badge bg-primary"><?= htmlspecialchars($pagos->estado) ?></span></h4>
                </span>
                <?php } ?>
            </div>
        </div>
    </div>

    <div class="container mt-2 container-fluid animation">
        <div class="mt-4 p-5 bg-dark">
            <div class="row justify-content-center">
                <div class="col-sm-5 mb-5">
                    <h2 class="display-6 text-success">Altura: </h2>
                    <h2 class="display-6 text-white"><?= htmlspecialchars($datos->altura_persona) ?> m</h2>
                </div>
                <div class="col-sm-5 mb-5">
                    <h2 class="display-6 text-success">Peso: </h2>
                    <h2 class="display-6 text-white"><?= htmlspecialchars($datos->peso_persona) ?> Kg</h2>
                </div>
                <div class="col-sm-5 mb-5">
                    <h2 class="display-6 text-success">Lesiones: </h2>
                    <h2 class="display-6 text-white"><?= htmlspecialchars($datos->lesiones) ?></h2>
                </div>
                <div class="col-sm-5 mb-5">
                    <h2 class="display-6 text-success">Medicamentos: </h2>
                    <h2 class="display-6 text-white"><?= htmlspecialchars($datos->medicamentos) ?></h2>
                </div>
            </div>
            <div class="row justify-content-center">
                <div class="col-sm-5 mb-5">
                    <h2 class="display-6 text-success">Embarazo: </h2>
                    <h2 class="display-6 text-white"><?= htmlspecialchars($datos->embarazo) ?></h2>
                </div>
                <div class="col-sm-5 mb-5">
                    <h2 class="display-6 text-success">Cirugía: </h2>
                    <h2 class="display-6 text-white"><?= htmlspecialchars($datos->cirugia) ?></h2>
                </div>
                <div class="col-sm-5 mb-5">
                    <h2 class="display-6 text-success">Objetivo: </h2>
                    <h2 class="display-6 text-white"><?= htmlspecialchars($datos->objetivos) ?></h2>
                </div>
                <div class="col-sm-5 mb-5">
                    <h2 class="display-6 text-success">Edad: </h2>
                    <?= include "../DAL/usuario.php"; ?>
                    <h2 class="display-6 text-white"><?= edad($datos->fecha_nacimiento); ?> años</h2>
                </div>
            </div>
        </div>
    </div>

    <?php } ?>
    <!-- Botón editar datos -->
    <div class="container mt-3">
        <div class="mt-4 p-5">
            <div class="d-flex justify-content-between my-5">
                <div class="mt-4 py-5">
                    <a href="editarDatosUsuario.php?id=<?= htmlspecialchars($datosU->id_usuario) ?>" class="btn btn-outline-success btn-lg">Editar Información</a>
                </div>
                <div class="mt-4 py-5">
                    <a href="../rutinas/rutinas.php?id=<?= htmlspecialchars($datosU->id_usuario) ?>" class="btn btn-outline-success btn-lg">Rutinas</a>
                </div>
                <div class="mt-4 py-5">
                    <a href="../checkin/check-in.php?id=<?= htmlspecialchars($id) ?>" class="btn btn-outline-success btn-lg">Check-In</a>
                </div>
            </div>
        </div>
    </div>

    <script>
    document.addEventListener("DOMContentLoaded", function() {});
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

    <?php
    // footer
    include "../templates/footer.php";
    ?>
</body>
</html>

<?php
// Liberar recursos y cerrar conexión
oci_free_statement($stidDetalles);
oci_free_statement($stidUsuario);
oci_free_statement($stidRutina);
oci_free_statement($stidPagos);
oci_close($conn);
?>
