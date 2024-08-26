<?php
session_start();

if (empty($_SESSION['usuario'])) {
    header("location: usuario/vistaLogin.php");
}

$rol = $_SESSION['rol'];

$id = $_GET['id'];
?>

<!DOCTYPE html>
<html lang="en">

<head
>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Check-In</title>
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
    <script src="..\js\jquery-3.7.1.min.js"></script>


    <div class="container-fluid">
    <div class="text-start mt-3">
    <a href="../usuario/perfilUsuario.php?id=<?php echo htmlspecialchars($id); ?>" class="btn btn-secondary">
    <i class="fas fa-arrow-left"></i> Volver
    </a>
    </div>
        <div class="row content">
            <div class="col-md-4 sidenav mt-5">
                <h1>Check In - Fotos/Notas</h1>
                <form action="check-in.php?id=<?php echo htmlspecialchars($id); ?>" method="POST" id="formFotos">
                    <input type="hidden" name="idUsuario" value="<?= htmlspecialchars($id) ?>">

                    <p>Ingresar año</p>
                    <input name="anno" id="anno" class="form-control" placeholder="Ejemplo: 2024" value="2024"/><br>

                    <p>Ingresar mes</p>
                    <div class="accordion" id="mesSeleccionado">
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#panelsStayOpen-collapseOne" aria-expanded="true"
                                    aria-controls="panelsStayOpen-collapseOne">
                                    Mes
                                </button>
                            </h2>
                            <div id="panelsStayOpen-collapseOne" class="accordion-collapse collapse show">
                                <div class="accordion-body">
                                    <?php
                                    $months = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"];
                                    foreach ($months as $month) {
                                        echo "<div class='form-check'>
                                                <input class='form-check-input' type='radio' name='mes' id='$month' value='$month' required>
                                                <label class='form-check-label' for='$month'>" . ucfirst($month) . "</label>
                                            </div>";
                                    }
                                    ?>
                                </div>
                            </div>
                        </div>
                        <hr class="border-top border-success opacity-25">
                        <div class="text-start my-3">
                            <button class="btn btn-success col me-1 w-100 text-center" type="submit">Buscar</button>
                        </div>
                        <div class="text-start my-3">
                            <button class="btn btn-primary col me-1 w-100 text-center" type="button" data-bs-toggle="modal"
                                data-bs-target="#subirFoto">Subir</button>
                        </div>
                    </div>
                </form> <!-- Cierre del formulario -->
            </div>

            <!-- Listado de fotos -->
            <div class="col-md-8 photo-container mt-5">
                <div class="container mt-3">
                    <div class="card text-center animation" id="header-card">
                        

                        <?php

                        include "../DAL/conexion.php";

                        $conn = conecta();

                        // Verificar si zse reciben los datos del formulario
                        if (isset($_POST['idUsuario']) && isset($_POST['anno']) && isset($_POST['mes'])) {
                            $idUsuario = htmlspecialchars($_POST['idUsuario']);
                            $anno = htmlspecialchars($_POST['anno']);
                            $mes = htmlspecialchars($_POST['mes']);

                            // Preparar llamada al procedimiento almacenado
                            $sql = "BEGIN obtenerFotos(:idUsuario, :anno, :mes, :resultado); END;";

                            // Preparar la llamada al procedimiento
                            $stmt = oci_parse($conn, $sql);

                            // Enlazar parámetros
                            oci_bind_by_name($stmt, ':idUsuario', $idUsuario, -1, SQLT_INT);
                            oci_bind_by_name($stmt, ':anno', $anno, -1, SQLT_CHR);
                            oci_bind_by_name($stmt, ':mes', $mes, -1, SQLT_CHR);

                            // Crear un cursor para recibir el resultado
                            $cursor = oci_new_cursor($conn);
                            oci_bind_by_name($stmt, ':resultado', $cursor, -1, OCI_B_CURSOR);

                            // Ejecutar el procedimiento
                            oci_execute($stmt);

                            // Abrir el cursor
                            oci_execute($cursor);

                            // Obtener el resultado del cursor
                            $resultado = [];
                            while ($row = oci_fetch_assoc($cursor)) {
                                $resultado[] = $row;
                            }

                            // Verificar si hay resultados
                            if (count($resultado) > 0) {
                                // Incluir el listado de fotos si hay resultados
                                include "listado_fotos.php";
                            } else {
                                // Mostrar mensaje de "Sin resultados" si no hay fotos
                                ?>
                                <div class="container mt-3">
                                    <div class="card border-0 m-auto" style="width:400px">
                                        <img class="card-img-top opacity-50" src="../img/noFound.png" alt="Sin resultados" style="width:100%">
                                        <div class="card-body">
                                            <h2 class="card-title text-center">Sin resultados</h2>
                                            <p class="text-center">No hay fotos subidas en este mes</p>
                                        </div>
                                    </div>
                                </div>
                                <?php
                            }

                            // Liberar recursos
                            oci_free_statement($stmt);
                            oci_free_statement($cursor);
                            oci_close($conn);

                            ?>
    
                            <?php } else {?>
                                <div class="container mt-3">
                            <div class="card border-0 m-auto" style="width:400px">
                                <img class="card-img-top opacity-50" src="../img/noFound.png" alt="Sin resultados" style="width:100%">
                                <div class="card-body">
                                    <h2 class="card-title text-center">Sin resultados</h2>
                                    <p class="text-center">No hay fotos subidas en este mes</p>
                                </div>
                            </div>
                        </div>
                        <?php
                        }?>
                    </div>
                </div>
            </div>
        </div>
    </div>

        <!-- The Modal -->
        <div class="modal" id="subirFoto">
            <div class="modal-dialog  modal-lg mb-5 animation">
                <div class="modal-content mb-5">

                    <!-- Modal Header -->
                    <div class="modal-header">
                        <h4 class="modal-title">Subir Foto</h4>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <!-- Modal body -->
                    <div class="modal-body">
                        <div class="text-center">
                            <label for="input-file" id="drop-area">
                                <form action="check.php" method="POST" enctype="multipart/form-data">
                                    <div id="img-view" style="text-align: center;">
                                    <img id="preview" src="../img/icoUpload.png" style="max-width: 100%; height: auto;">
                                        <p style="color: #000000;">Dar click aqui para subir foto</p>
                                        <span style="color: #000000;">Subir foto desde la galeria</span>
                                        <input type="file" name="file" accept="img/*" id="input-file"
                                            style="display: none;">
                                        <input type="hidden" name="id" value="<?php echo htmlspecialchars($id); ?>">
                                        <button type="submit" id="upload" class="btn btn-primary rounded-pill"
                                            data-bs-dismiss="modal">Subir</button>
                                    </div>
                                </form>
                            </label>
                        </div>
                    </div>

                    <!-- Modal footer -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

<!-- JavaScript para previsualizar la imagen -->
<script>
    document.getElementById('input-file').addEventListener('change', function(event) {
        const preview = document.getElementById('preview');
        const file = event.target.files[0];
        const reader = new FileReader();

        reader.onload = function(e) {
            preview.src = e.target.result; 
        };

        if (file) {
            reader.readAsDataURL(file); 
        }
    });

</script>



<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
    integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous">
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js"
    integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous">
</script>

<script src="../js/checkinJS.js"></script>

<?php

// footer
include "../templates/footer.php";
?>
