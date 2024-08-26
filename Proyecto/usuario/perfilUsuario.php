<?php
session_start();

//verificar si se accedió con login
if (empty($_SESSION['usuario'])) { // si no hay una sesión usuario
    header("location: usuario/vistaLogin.php"); // devolver al login
    exit();
}
$id = intval($_GET['id']); 

include "../DAL/conexion.php";

// Obtener la conexión
$conn = Conecta();
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
    <?php if($_SESSION['rol']=="1"){
     echo '<div class="text-white justify-content-between" id="headerP">
        <h3 class="col-6 mt-2 mx-3"><?php echo $_SESSION["usuario"];?></h3>
    <a href="../indexAdmin.php" class="btn btn-primary my-2 mx-3 my-auto px-3">Atras</a>
    </div>';
    }else{
    echo '<div class="text-white justify-content-between" id="headerP">
        <h3 class="col-6 mt-2 mx-3"><?php echo $_SESSION["usuario"];?></h3>
        <a href="../index.php" class="btn btn-primary my-2 mx-3 my-auto px-3">Atras</a>
    </div>';}
    ?>

    <!-- Mostrar datos técnicos -->
    <?php
    include "../DAL/usuario.php"; 

    //query
    $queryDetalles = "BEGIN SP_GET_V_USUARIO_DETALLES(:P_ID_USUARIO, :P_CURSOR_USUARIO); END;";

    $stidUsuario = oci_parse($conn, $queryDetalles);

    // Crear un cursor para recibir los resultados tomados del cursor de sistema de oracle
    $p_cursor_usuario = oci_new_cursor($conn);

    // Vincular los parámetros
    oci_bind_by_name($stidUsuario, ':P_ID_USUARIO', $id);
    oci_bind_by_name($stidUsuario, ':P_CURSOR_USUARIO', $p_cursor_usuario, -1, OCI_B_CURSOR);

    // Ejecutar el procedimiento
    oci_execute($stidUsuario);
    // Ejecutar el cursor
    oci_execute($p_cursor_usuario);

    $datosUsuario = [];//el array se usa en el for each para tomar las columnas del objeto encontrado.
    // Recorrer los resultados con while
    while (($row = oci_fetch_assoc($p_cursor_usuario)) !== false) {
        $datosUsuario[] = $row;
    }
        //extraer el dato de cada columna e indroducirla en una variable
    foreach ($datosUsuario as $usuario) {
        $nombre = $usuario['NOMBRE'];
        $primer_apellido = $usuario['PRIMER_APELLIDO'];
        $segundo_apellido = $usuario['SEGUNDO_APELLIDO'];
        $fecha_nacimiento = $usuario['FECHA_NACIMIENTO'];
        $altura_persona = $usuario['ALTURA_PERSONA'];
        $peso_persona = $usuario['PESO_PERSONA'];
        $lesiones = $usuario['LESIONES'];
        $medicamentos = $usuario['MEDICAMENTOS'];
        $embarazo = $usuario['EMBARAZO'];
        $cirugia = $usuario['CIRUGIA'];
        $objetivos = $usuario['OBJETIVOS'];
        
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

               // Query del procedimiento almacenado
                $queryPagos = "BEGIN SP_GET_PAGOS(:P_ID_USUARIO, :P_CURSOR); END;";

                // Preparar la llamada al procedimiento almacenado
                $stidPagos = oci_parse($conn, $queryPagos);

                // Crear un cursor para recibir los resultados
                $p_cursor_pagos = oci_new_cursor($conn);

                // Vincular los parámetros
                oci_bind_by_name($stidPagos, ':P_ID_USUARIO', $id);
                oci_bind_by_name($stidPagos, ':P_CURSOR', $p_cursor_pagos, -1, OCI_B_CURSOR);

                // Ejecutar el procedimiento
                oci_execute($stidPagos);
                // Ejecutar el cursor
                oci_execute($p_cursor_pagos);

                $datosPagos = [];
                while (($row = oci_fetch_assoc($p_cursor_pagos)) !== false) {
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
                <?php 
                //cerrar cursor
                oci_free_statement($p_cursor_pagos);
                oci_free_statement($stidPagos);
                } ?>
            </div>
        </div>
    </div>
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

                    <h2 class="display-6 text-white"><?= edad($fecha_nacimiento); ?> años</h2>
                </div>
            </div>
        </div>
    </div>

    <?php } 
    //cerrar cursor
    oci_free_statement($stidUsuario);
    oci_free_statement($p_cursor_usuario);
    ?>

    <!-- Botón editar datos -->
    <div class="container mt-3">
        <div class="mt-4 p-5">
            <div class="d-flex justify-content-between my-5">
                <div class="mt-4 py-5">
                    <a href="editarDatosUsuario.php?id=<?= $id ?>" class="btn btn-outline-success btn-lg">Editar
                        Información</a>
                </div>
                <div class="mt-4 py-5">
                    <a href="../rutinas/rutinas.php?id=<?= $id ?>" class="btn btn-outline-success btn-lg">Rutinas</a>
                </div>
                <div class="mt-4 py-5">
                    <a href="../checkin/check-in.php?id=<?= $id ?>" class="btn btn-outline-success btn-lg">Check-In</a>
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
oci_close($conn);
?>