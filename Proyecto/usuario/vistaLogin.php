<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link href="../css/bootstrap.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="../css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Krub:ital,wght@0,200;0,300;0,400;0,500;0,600;0,700&display=swap" rel="stylesheet">
</head>
<body>
    <?php include "../templates/header.php"; ?>
    <script src="..\js\jquery-3.7.1.min.js"></script>
    <div class="card mt-5 m-auto bg-dark align-items-center justify-content-center animation" style="width:520px; height:600px">
        <form method="POST" id="formLogin" action="../usuario/login.php">
            <h1 class="text-success text-center mb-5 pb-2">Iniciar Sesión</h1>
            <span>Correo Electrónico:</span>
            <input type="email" name="correo" class="form-control mb-4" placeholder="******@correo.com" required />

            <span>Contraseña:</span>
            <input type="password" name="password" class="form-control mb-4" placeholder="********" required />

            <div class="text-center mt-5"><br>
                <button type="submit" class="btn btn-success p-2" name="btnIngresar" value="ok">Iniciar Sesión</button>
                <a href="crearUsuario.php" class="nav-link mt-3">Crear cuenta</a>
            </div>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
