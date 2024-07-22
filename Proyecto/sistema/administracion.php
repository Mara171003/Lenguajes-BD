<?php
session_start();

// Verificar si se accedió con login
if (empty($_SESSION['usuario'])) { // Si no hay una sesión usuario
    header("location: usuario/vistaLogin.php"); // Devolver al login
    exit();
}

include "../DAL/conexion.php";
$adminId = $_SESSION['id'];
$conexion = conecta();

if ($_SESSION['rol'] === '1') {
    // Para admin
    $sql = "SELECT id_usuario, nombre, primer_apellido, tipo_suscripcion FROM usuario WHERE id_usuario != :adminId";
} else {
    // Para usuarios
    $UserId = $_SESSION['id'];
    $sql = "SELECT id_usuario, nombre, primer_apellido, tipo_suscripcion FROM usuario WHERE id_usuario = :UserId";
}

$stid = oci_parse($conexion, $sql);

if ($_SESSION['rol'] === '1') {
    oci_bind_by_name($stid, ':adminId', $adminId);
} else {
    oci_bind_by_name($stid, ':UserId', $UserId);
}

oci_execute($stid);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Index</title>
    <link href="../css/bootstrap.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="../css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Krub:ital,wght@0,200;0,300;0,400;0,500;0,600;0,700;1,200;1,300;1,400;1,500;1,600;1,700&display=swap" rel="stylesheet">
</head>
<body>
    <script src="..\js\jquery-3.7.1.min.js"></script>
    <!--SESSION-->
    <div class="text-white justify-content-between" id="headerP">
        <a href="../" class="btn btn-primary my-2 mx-3 px-3">Atras</a>
    </div>
    <!-- listado clientes -->
    <label class="p-5"> </label>
    <div class="container-sm">
        <table class="table table-dark table-hover display-6 animation">
            <thead class="table-dark">
                <tr>
                    <th scope="col" class="text-success">Nombre</th>
                    <th scope="col" class="text-success">Apellido</th>
                    <th scope="col" class="text-success">Suscripcion</th>
                    <th scope="col"></th>
                </tr>
            </thead>
            <tbody>
                <?php
                while ($datos = oci_fetch_object($stid)) { 
                    $id_usuario = $datos->ID_USUARIO;
                    $nombre = $datos->NOMBRE;
                    $apellido = $datos->PRIMER_APELLIDO;
                    $suscripcion = $datos->TIPO_SUSCRIPCION;

                    // Verificar el tipo de suscripción y mostrar etiquetas correspondientes
                    if ($suscripcion === 'basico') {
                        $suscripcion = '<span class="badge bg-primary">Básico</span>';
                        $sus = 'basico';
                    } elseif ($suscripcion === 'plus') {
                        $suscripcion = '<span class="badge badge-plus ">Plus</span>';
                        $sus = 'plus';
                    } elseif ($suscripcion === 'premium') {
                        $suscripcion = '<span class="badge badge-premium">PREMIUM</span>';
                        $sus = 'premium';
                    }

                    // Cambiar el botón de suscripciones y pago dependiendo del rol de la sesión
                    if ($_SESSION['rol'] === '1') {
                        // Para admin - abrir modal
                        $btnSuscripcion = "<button class='btn btn-primary btn-suscripcion' data-bs-toggle='modal' data-bs-target='#adminSuscripcion' data-suscripcion='$sus' data-id='$id_usuario'>Suscripciones</button>";
                        $btnPago = "<button class='btn btn-success btn-pago' data-bs-toggle='modal' data-bs-target='#adminPagos' data-id='$id_usuario'>Pago</button>";
                    } else {
                        // Para usuarios
                        $btnSuscripcion = "<a href='pago.php' class='btn btn-primary'>Suscripciones</a>";
                        $btnPago = "<a href='pago.php' class='btn btn-success'>Pago</a>";
                    }
                ?>
                <tr>
                    <td><?= htmlspecialchars($nombre) ?></td>
                    <td><?= htmlspecialchars($apellido) ?></td>
                    <td><?= $suscripcion ?></td>
                    <td>
                        <?php echo $btnSuscripcion ?>
                        <!-- Botón de suscripción cambia según el rol -->
                        <!-- dropdown dentro de un modal para cambiar suscripción (admin) -->
                        <!-- vista de tarjetas de suscripción, que redirige a métodos de pagos (user) -->
                        <?php echo $btnPago ?>
                        <!-- Cambiar fecha de pago con input string, día del mes con modal. (botón editar solo lo ve admin) -->
                        <!-- El usuario ve estos datos en la vista de perfil usuario -->
                    </td>
                </tr>
                <?php } ?>

            </tbody>
        </table>
    </div>

    <!---------------------- MODAL ADMIN (cambiar suscripción) ---------------------------->
    <div class="modal fade animation" id="adminSuscripcion">
        <div class="modal-dialog">
            <div class="modal-content">
                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">Gestionar de suscripciones</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <!-- Modal body -->
                <div class="modal-body">
                    <p>Cambiar el nivel de suscripción</p>
                    <form>
                        <div class="form-check" id="form-sus">
                            <input type="radio" class="form-check-input" id="basico" name="sus" value="basico" checked>
                            <h4 class="form-check-label" for="radio1"><span class="badge bg-primary">Básico</span></h4>
                        </div>
                        <div class="form-check my-3">
                            <input type="radio" class="form-check-input" id="plus" name="sus" value="plus">
                            <h4 class="form-check-label" for="radio2"><span class="badge badge-plus">Plus</span></h4>
                        </div>
                        <div class="form-check">
                            <input type="radio" class="form-check-input" id="premium" name="sus" value="premium">
                            <h4 class="form-check-label" for="radio3"><span class="badge badge-premium">PREMIUM</span></h4>
                        </div>
                        <div class="my-w">
                            <button class="btn btn-success my-2" onclick="recargar()">Guardar</button>
                        </div>
                        </form>
                    </div>
                    <!-- Modal footer -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="container animation">
            <h1>Selecciona tu suscripción</h1>
            <div class="row">
                <div class="col-md-6 animation">
                    <div class="card mb-4">
                        <div class="card-header badge-plus text-white">
                            <a href="pago.php" class="text-decoration-none text-white">
                                <h2>Suscripción Plus</h2>
                            </a>
                        </div>
                        <div class="card-body">
                            <h3>Beneficios:</h3>
                            <ul>
                                <li>Acceso a rutina personalizada</li>
                                <li>Videos de entrenamiento</li>
                            </ul>
                            <form action="procesar_suscripcion.php" method="post">
                                <input type="hidden" name="tipo_suscripcion" value="plus">
                                <button type="submit" class="btn btn-primary">Seleccionar Plus</button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 animation">
                    <div class="card mb-4">
                        <div class="card-header badge-premium text-white">
                            <a href="pago.php" class="text-decoration-none text-white">
                                <h2>Suscripción Premium</h2>
                            </a>
                        </div>
                        <div class="card-body">
                            <h3>Beneficios:</h3>
                            <ul>
                                <li>2 sesiones de entrenamiento presenciales</li>
                                <li>Servicios de terapia física</li>
                            </ul>
                            <form action="procesar_suscripcion.php" method="post">
                                <input type="hidden" name="tipo_suscripcion" value="premium">
                                <button type="submit" class="btn btn-primary">Seleccionar Premium</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Admin (cambiar pagos) -->
        <div class="modal fade animation" id="adminPagos">
            <div class="modal-dialog">
                <div class="modal-content">
                    <!-- Modal Header -->
                    <div class="modal-header">
                        <h4 class="modal-title">Gestionar Pagos</h4>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <!-- Modal body -->
                    <div class="modal-body">
                        <form id="formAddPago">
                            <div class="col-5 mb-4">
                                <span>Monto:</span>
                                <input id="monto" type="number" class="form-control" placeholder="CRC" step="0.01">
                            </div>
                            <div class="col-5 mb-4">
                                <span>Día:</span>
                                <input id="dia" type="number" class="form-control" placeholder="Día del mes">
                            </div>
                            <div class="col-5 mb-4">
                                <span>Estado:</span>
                                <input id="estado" type="text" class="form-control" placeholder="Activo o Congelado">
                            </div>
                            <hr class="border-top border-success opacity-25 my-2">
                            <button type="submit" class="btn btn-success my-2">Guardar</button>
                        </form>
                    </div>
                    <!-- Modal footer -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Cerrar</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS (si lo necesitas) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-NUiUNB1wlFl0J+JJ2anR1+SwMZPWQ+nLaUvysvRf7C3g7OId+KtXiq+A5yT8+Kq6" crossorigin="anonymous"></script>
        <script src="../js/adminJS.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <?php
        // Footer
        include "../templates/footer.php";
        ?>
    </body>
    </html>
