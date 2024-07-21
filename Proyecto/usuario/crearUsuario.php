<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta id="viewport" content="width=device-width, initial-scale=1.0">

    <title>Crear Cuenta</title>
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
<?php include "../templates/header.php";?>
    <script src="..\js\jquery-3.7.1.min.js"></script>
    <!--- -->
    <div>
        <div class="card mt-5 m-auto bg-dark align-items-center justify-content-center animation"
            style="width:520px; height:700px">

            <div class=" col-lg-6 m-auto">
                <div class="card-body">
                    <form method="POST" id="formAddUsuario">
                        <h3 class="text-success text-center my-5">Crear Usuario</h3>

                        <input type="text" id="nombre" class="form-control my-4 py-2" placeholder="Nombre" />

                        <input type="text" id="primerApellido" class="form-control my-4 py-2"
                            placeholder="Primer Apellido" />

                        <input type="text" id="segundoApellido" class="form-control my-4 py-2"
                            placeholder="Segundo Apellido" />

                        <input type="email" id="correo" class="form-control my-4 py-2"
                            placeholder="Correo Electronico" />

                        <input type="password" id="password" class="form-control my-4 py-2" placeholder="Contraseña" />

                        <input type="password" id="passwordConfirm" class="form-control my-4 py-2"
                            placeholder="Confirmar contraseña" />

                        <div class="text-center mt-5"><br>
                            <button class="btn btn-success p-2" id="btnRegistrar" value="ok">Registrarse</button>
                            <a href="vistaLogin.php" class="nav-link text-primary my-3 mb-5">Ya tengo una cuenta</a>
                        </div>

                    </form>
                </div>
            </div>

        </div>
    </div><br>

    <script>
    document.addEventListener("DOMContentLoaded", function() {});
    </script>
    <script src="../js/loginJS.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous">
    </script>
</body>

</html>

<?php
// footer
include "../templates/footer.php";
?>