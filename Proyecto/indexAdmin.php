    <?php
    session_start();
    if ($_SESSION['rol'] == 2) {
        header("Location: usuario/vistaLogin.php");
    }
    // Verificar si se accedió con login
    if (empty($_SESSION['usuario'])) { // Si no hay una sesión usuario
        header("location: usuario/vistaLogin.php"); // Devolver al login
        exit();
    }
    ?>

    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Index</title>
        <link href="css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
            integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA=="
            crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="stylesheet" href="css/style.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link
            href="https://fonts.googleapis.com/css2?family=Krub:ital,wght@0,200;0,300;0,400;0,500;0,600;0,700&display=swap"
            rel="stylesheet">
    </head>

    <body>
        <!--SESSION-->
        <nav class="navbar navbar-expand-sm navbar-dark bg-dark">
            <div class="container-fluid">
                <h4 class="col-3 mt-2 mx-3"><?php echo $_SESSION["usuario"];?></h4>

                <div class="collapse navbar-collapse mx-auto">
                    <form class="d-flex container-fluid justify-content-center align-items-center" method="POST"
                        action="indexAdmin.php">
                        <div class="col-3">
                            <label class="form-check-label ms-5 ps-5">
                                <input class="form-check-input" type="checkbox" name="activo" value="activo"> Activos
                            </label>
                        </div>
                        <input type="text" class="form-control ms-1" placeholder="Nombre" name="filtro_nombre">
                        <input type="text" class="form-control mx-2" placeholder="Apellido" name="filtro_apellido">
                        <button class="btn btn-primary" type="submit" name="btnBuscar">Buscar</button>
                    </form>
                    <div class="col-4"></div>
                    <form method="POST">
                        <button type="submit" name="btnLimpiar" class="btn btn-primary mx-1 px-3">Limpiar</button>
                    </form>
                    <a href="usuario/cerrarSesion.php" class="btn btn-primary my-2 mx-3 px-3"><i
                            class="fa-solid fa-right-from-bracket"></i></a>

                </div>
            </div>
        </nav>
        <!-- listado clientes -->
        <label class="p-5"> </label>
        <div class="container-sm">
            <table class="table table-dark table-hover display-6 animation">
                <thead class="table-dark">
                    <tr>
                        <th scope="col" class="text-success opac">Id</th>
                        <th scope="col" class="text-success">Nombre</th>
                        <th scope="col" class="text-success">Apellido</th>
                        <th scope="col" class="text-success">Suscripción</th>
                        <th scope="col"></th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    include "DAL/conexion.php";
                    $conn = conecta();

                    $adminId = $_SESSION['id'];

                    if (isset($_POST['btnBuscar'])) {
                        // Activa modo filtro
                        $_SESSION['filtro'] = true;
                        $_SESSION['filtro_nombre'] = isset($_POST['filtro_nombre']) ? $_POST['filtro_nombre'] : null;
                        $_SESSION['filtro_apellido'] = isset($_POST['filtro_apellido']) ? $_POST['filtro_apellido'] : null;
                        $_SESSION['activo'] = isset($_POST['activo']) ? 'activo' : null;

                        header('Location: indexAdmin.php');
                    }

                    if (isset($_POST['btnLimpiar'])) {
                        // Activa modo filtro
                        unset($_SESSION['filtro_nombre']);
                        unset($_SESSION['filtro_apellido']);
                        unset($_SESSION['activo']);
                        $_SESSION['filtro'] = false;
                        header('Location: indexAdmin.php');
                    }

                    //VER VARIABLES DE SESION (DEBUG)
                    /*
                    echo "<pre>";
                    print_r($_SESSION);
                    echo "</pre>";
                    */


                    $p_cursor_usuario = oci_new_cursor($conn);
                    //$p_cursor_usuario = oci_new_cursor($conn);

                    // si algun filtro esta siendo utilizado
                    if($_SESSION['filtro']===true){

                        //usar el procedimiento almacenado con filtros
                        $queryUsuario = "BEGIN SP_GET_USUARIO_FILTER(:P_ID_USUARIO, :P_ESTADO, :P_NOMBRE, :P_APELLIDO, :P_CURSOR_USUARIO); END;";
                        $stid = oci_parse($conn, $queryUsuario);

                        oci_bind_by_name($stid, ':P_ID_USUARIO', $_SESSION['id']);//es el id de admin, para indicar !=admin en la consulta
                        oci_bind_by_name($stid, ':P_ESTADO', $_SESSION['activo']);//mostrar los que tienen pago activo
                        oci_bind_by_name($stid, ':P_NOMBRE', $_SESSION['filtro_nombre']);//resultado por nombre
                        oci_bind_by_name($stid, ':P_APELLIDO', $_SESSION['filtro_apellido']);//resultado por apellidos
                        oci_bind_by_name($stid, ':P_CURSOR_USUARIO', $p_cursor_usuario, -1, OCI_B_CURSOR);

                        oci_execute($stid);
                        oci_execute($p_cursor_usuario);

                    }
                    
                    if($_SESSION['filtro']===false) {
                        // procedimiento almacenado sin filtros (listado completo)
                        $queryUsuario = "BEGIN SP_GET_USUARIO_ADMIN(:P_ID_USUARIO, :P_CURSOR_USUARIO); END;";
                        $stid = oci_parse($conn, $queryUsuario);
                        oci_bind_by_name($stid, ':P_ID_USUARIO', $_SESSION['id']);
                        oci_bind_by_name($stid, ':P_CURSOR_USUARIO', $p_cursor_usuario, -1, OCI_B_CURSOR);

                        oci_execute($stid);
                        oci_execute($p_cursor_usuario);
                    }
                    
                    
                    $datosUsuario = [];
                    while (($row = oci_fetch_assoc($p_cursor_usuario)) !== false) {
                        $datosUsuario [] = $row;
                    }
                    foreach ($datosUsuario as $datos) {
                        $id_usuario = $datos['ID_USUARIO'];
                        $nombre = $datos['NOMBRE'];
                        $apellido = $datos['PRIMER_APELLIDO'];
                        $suscripcion = $datos['TIPO_SUSCRIPCION'];

                        // Verificar el tipo de suscripción y mostrar etiquetas correspondientes
                        if ($suscripcion === 'basico') {
                            $suscripcion = '<span class="badge bg-primary">Básico</span>';
                        } elseif ($suscripcion === 'plus') {
                            $suscripcion = '<span class="badge badge-plus">Plus</span>';
                        } elseif ($suscripcion === 'premium') {
                            $suscripcion = '<span class="badge badge-premium">PREMIUM</span>';
                        }
                    ?>
                    <tr>
                        <td><?= $id_usuario ?></td>
                        <td><?= $nombre ?></td>
                        <td><?= $apellido ?></td>
                        <td><?= $suscripcion ?></td>
                        <td>
                            <a href="usuario/perfilUsuario.php?id=<?= $datos['ID_USUARIO'] ?>"
                                class="btn btn-success"><i class="fa-solid fa-dumbbell ms-2 me-3"></i>Perfil</a>
                            <a href="sistema/administracion.php?id=<?= $datos['ID_USUARIO'] ?>"
                                class="btn btn-warning"><i class="fa-solid fa-desktop ms-2 me-3"></i>Sistema</a>
                        </td>
                    </tr>
                    <?php
                    }
                    
                    oci_free_statement($stid);
                    oci_free_statement($p_cursor_usuario);
                    oci_close($conn);
                    ?>
                </tbody>
            </table>
        </div>

        <script>
        document.addEventListener("DOMContentLoaded", function() {});
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous">
        </script>
        </script>
        <?php
        // footer
        include "templates/footer.php";
        ?>
    </body>

    </html>