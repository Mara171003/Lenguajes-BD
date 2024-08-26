<?php

// Verifica si el usuario tiene el rol de administrador
$esAdmin = isset($_SESSION['rol']) && $_SESSION['rol'] === '1';

foreach ($resultado as $row): ?>
    <div class="card-header animation">
        <h2 class="text-success"><?= ucfirst(htmlspecialchars($row['MES'])) ?> del <?= htmlspecialchars($row['ANNO']) ?></h2>
        <hr class="border-top border-success opacity-50">
        <h3>Nota:</h3>
        <h4><?= htmlspecialchars($row['NOTA_MENSUAL'] ?? 'Sin nota')  ?></h4>
    </div>
    <div class="card-body" id="canvas-img">
        <input type="hidden" class="id_foto" value="<?= htmlspecialchars($row['ID_FOTO']) ?>">
        <input type="hidden" class="ruta_foto" value="<?= htmlspecialchars($row['RUTA_FOTO']) ?>">
        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3">
            <div class="col m-auto">
                <div class="card img-fluid border-0">
                    <div class="card-img-container" style="max-width: 100%; max-height: 450px; min-width: 150px; min-height: 150px; overflow: hidden;">
                        <img src="<?= htmlspecialchars($row['RUTA_FOTO']) ?>" class="rounded img-fluid" style="width: 100%; height: auto;">
                    </div>
                    <div class="card-footer" style="display: flex; flex-direction: column; align-items: center;">
                        <!-- Formulario para borrar la foto -->
                        <form method="POST" action="checkBorrar.php" style="width: 100%; margin-bottom: 10px;">
                            <input type="hidden" name="idFoto" value="<?= htmlspecialchars($row['ID_FOTO']) ?>">
                            <input type="hidden" name="rutaFoto" value="<?= htmlspecialchars($row['RUTA_FOTO']) ?>">
                            <button type="submit" class="btnBorrarFoto btn btn-danger btn-sm" style="width: 100%;">
                                <i class="fa-solid fa-trash"></i> Borrar
                            </button>
                        </form>
                        <!-- Formulario para añadir una nota, visible solo para administradores -->
                        <?php if ($esAdmin): ?>
                        <form method="POST" action="addNota.php" style="width: 100%;">
                            <input type="hidden" name="idFoto" value="<?= htmlspecialchars($row['ID_FOTO']) ?>">
                            <input type="hidden" name="idUsuario" value="<?= htmlspecialchars($row['ID_USUARIO']) ?>">
                            <input type="text" name="nota" placeholder="Añadir nota" class="form-control mb-2" style="width: 100%;">
                            <button type="submit" class="btn btn-primary btn-sm" style="width: 100%;">
                                <i class="fa-solid fa-plus"></i> Actualizar Nota
                            </button>
                        </form>
                        <?php endif; ?>
                    </div>
                </div>
            </div>
        </div>
    </div>
<?php endforeach; ?>



