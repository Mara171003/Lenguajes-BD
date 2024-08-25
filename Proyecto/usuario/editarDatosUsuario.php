<?php 
$id=$_GET["id"];
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Editar Informacion</title>
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
    <!--  --->
    <?php
        include "../DAL/conexion.php";
        $conn=conecta();
        include "../templates/header.php";
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

    <div class="container mt-3">
        <div class="mt-4 p-5 bg-dark text-white">
            <h1 class="text-center text-success">
                <?= $nombre . " " . $primer_apellido . " " . $segundo_apellido?></h1><br>
        </div>
    </div>

    </div>
    <div class="container mt-3 container-fluid m-auto">
        <div class="mt-4 p-5 bg-dark">
            <form method="POST">
                <input type="hidden" name="id_detalle" value="<?= $id ?>">
                <div class="row justify-content-center m-auto">
                    <!-- columna -->

                    <div class="col-sm-5 mb-5">
                        <h3 class="text-success">Altura: </h3>
                        <input type="text" class="form-control" name="altura" value="<?= $altura_persona ?>">
                    </div>

                    <div class="col-sm-5 mb-5">
                        <h3 class=" text-success">Peso: </h3>
                        <input type="text" class="form-control" name="peso" value="<?= $peso_persona ?>">
                    </div>

                    <div class="col-sm-5 mb-5">
                        <h3 class=" text-success">Lesiones: </h3>
                        <input type="text" class="form-control" name="lesiones" value="<?= $lesiones ?>">
                    </div>

                    <div class="col-sm-5 mb-5">
                        <h3 class=" text-success">Medicamentos: </h3>
                        <input type="text" class="form-control" name="medicamentos" value="<?= $medicamentos ?>">
                    </div>
                </div>

                <div class="row justify-content-center m-auto">
                    <!-- columna  -->

                    <div class="col-sm-5 mb-5">
                        <h3 class=" text-success">Embarazo: </h3>
                        <input type="text" class="form-control" name="embarazo" value="<?= $embarazo ?>">
                    </div>

                    <div class="col-sm-5 mb-5">
                        <h3 class=" text-success">Cirugia: </h3>
                        <input type="text" class="form-control" name="cirugia" value="<?= $cirugia ?>">
                    </div>

                    <div class="col-sm-5 mb-5">
                        <h3 class=" text-success">Objetivo: </h3>
                        <input type="text" class="form-control" name="objetivos" value="<?= $objetivos ?>">
                    </div>

                    <?php 
                    // Convertir la fecha al formato correcto
                    $date = DateTime::createFromFormat('d/m/y', $fecha_nacimiento);
                    $fecha_formateada = $date->format('Y-m-d');
                    ?>

                    <div class="col-sm-5 mb-5">
                        <h3 class="text-success">Edad: </h3>
                        <input type="date" class="form-control" name="edad" value="<?= $fecha_formateada ?>">
                    </div>

                </div>

                <div class="text-center mt-3"><br>
                    <button class="btn btn-success py-2 px-4 btn-lg" name="btnActualizarDatos"
                        value="ok">Guardar</button>
                </div>
            </form>
        </div>
    </div>
    <?php }?>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous">
    </script>
</body>

</html>