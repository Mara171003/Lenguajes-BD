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

// usuario
$queryViewUsuario = "SELECT * FROM V_USUARIOS_DETALLES WHERE ID_USUARIO = :ID_USUARIO";
$stidUsuario = oci_parse($conn, $queryViewUsuario);
oci_bind_by_name($stidUsuario, ':ID_USUARIO', $id);
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Usuario</title>
    <link href="../css/bootstrap.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
        integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="../css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Krub:ital,wght@0,200;0,300;0,400;0,500;0,600;0,700;1,200;1,300;1,400;1,500;1,600;1,700&display=swap"
        rel="stylesheet">
</head>

<body>
    <!-- Mostrar datos técnicos -->
    <?php
    include '../templates/header.php';

    oci_execute($stidUsuario);
    while (($datos = oci_fetch_assoc($stidUsuario)) !=false) { 
        $nombre = $datos['NOMBRE'];
        $primer_apellido = $datos['PRIMER_APELLIDO'];
        $segundo_apellido = $datos['SEGUNDO_APELLIDO'];
        $fecha_nacimiento = $datos['FECHA_NACIMIENTO'];
        $altura_persona = $datos['ALTURA_PERSONA'];
        $peso_persona = $datos['PESO_PERSONA'];
        $lesiones = $datos['LESIONES'];
        $medicamentos = $datos['MEDICAMENTOS'];
        $embarazo = $datos['EMBARAZO'];
        $cirugia = $datos['CIRUGIA'];
        $objetivos = $datos['OBJETIVOS'];
        ?>

    <div class="container mt-3 animation">
        <div class="mt-4 p-5 bg-dark text-white">
            <h1 class="text-center text-success">
                <?=$nombre . " " . $primer_apellido . " " . $segundo_apellido ?>
            </h1><br>
            <hr class="border-top border-success opacity-25 my-2">
            <div class="text-center">

                <?php 
                //-------------------------- PAGOS -----------------------------

               // Consulta para llamar al procedimiento almacenado
                $queryPagos = "BEGIN SP_GET_PAGOS(:P_ID_USUARIO, :P_CURSOR); END;";

                // Preparar la llamada al procedimiento almacenado
                $stidPagos = oci_parse($conn, $queryPagos);

                // Crear un cursor para recibir los resultados
                $p_cursor = oci_new_cursor($conn);

                // Vincular los parámetros
                oci_bind_by_name($stidPagos, ':P_ID_USUARIO', $id);
                oci_bind_by_name($stidPagos, ':P_CURSOR', $p_cursor, -1, OCI_B_CURSOR);

                // Ejecutar el procedimiento
                oci_execute($stidPagos);

                // Ejecutar el cursor
                oci_execute($p_cursor);

                $datosPagos = [];
                while (($row = oci_fetch_assoc($p_cursor)) !== false) {
                    $datosPagos[] = $row;
                }
                    
                foreach ($datosPagos as $Pago) {
                    $dia_pago = $Pago['DIA_PAGO'];
                    $monto = $Pago['MONTO'];
                    $estado = $Pago['ESTADO'];
                ?>

                <h4 class="text-success">Día de Pago:</h4>
                <span>
                    <h4><?= $dia_pago ?> de cada mes</h4>
                </span>
                <h4 class="text-success">Monto: </h4>
                <span>
                    <h4>CRC <?= $monto ?></h4>
                </span>
                <h4 class="text-success">Estado: </h4>
                <span>
                    <h4><span class="badge bg-primary"><?= $estado ?></span></h4>
                </span>
                <?php } ?>
            </div>
        </div>
    </div>

    <?php //} ?>
    </div>
    </div>
    </div>

    <div class="container mt-2 container-fluid animation">
        <div class="mt-4 p-5 bg-dark">
            <div class="row justify-content-center">
                <div class="col-sm-5 mb-5">
                    <h2 class="display-6 text-success">Altura: </h2>
                    <h2 class="display-6 text-white"><?= $altura_persona ?> m</h2>
                </div>
                <div class="col-sm-5 mb-5">
                    <h2 class="display-6 text-success">Peso: </h2>
                    <h2 class="display-6 text-white"><?= $peso_persona ?> Kg</h2>
                </div>
                <div class="col-sm-5 mb-5">
                    <h2 class="display-6 text-success">Lesiones: </h2>
                    <h2 class="display-6 text-white"><?= $lesiones ?></h2>
                </div>
                <div class="col-sm-5 mb-5">
                    <h2 class="display-6 text-success">Medicamentos: </h2>
                    <h2 class="display-6 text-white"><?= $medicamentos ?></h2>
                </div>
            </div>
            <div class="row justify-content-center">
                <div class="col-sm-5 mb-5">
                    <h2 class="display-6 text-success">Embarazo: </h2>
                    <h2 class="display-6 text-white"><?= $embarazo ?></h2>
                </div>
                <div class="col-sm-5 mb-5">
                    <h2 class="display-6 text-success">Cirugía: </h2>
                    <h2 class="display-6 text-white"><?= $cirugia ?></h2>
                </div>
                <div class="col-sm-5 mb-5">
                    <h2 class="display-6 text-success">Objetivo: </h2>
                    <h2 class="display-6 text-white"><?=$objetivos ?></h2>
                </div>
                <div class="col-sm-5 mb-5">
                    <h2 class="display-6 text-success">Edad: </h2>
                    <?= 
                    include "../DAL/usuario.php"; 
                    ?>
                    <h2 class="display-6 text-white"><?= edad($fecha_nacimiento); ?> años</h2>
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
                    <a href="editarDatosUsuario.php?id=<?= htmlspecialchars($id) ?>"
                        class="btn btn-outline-success btn-lg">Editar Información</a>
                </div>
                <div class="mt-4 py-5">
                    <a href="../rutinas/rutinas.php?id=<?= htmlspecialchars($id) ?>"
                        class="btn btn-outline-success btn-lg">Rutinas</a>
                </div>
                <div class="mt-4 py-5">
                    <a href="../checkin/check-in.php?id=<?= htmlspecialchars($id) ?>"
                        class="btn btn-outline-success btn-lg">Check-In</a>
                </div>
            </div>
        </div>
    </div>

    <script>
    document.addEventListener("DOMContentLoaded", function() {});
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous">
    </script>

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