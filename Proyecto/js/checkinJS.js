//seleccionar el radio marcado
document.querySelectorAll('input[name="mes"]').forEach((radio) => {
  radio.addEventListener("change", (event) => {
    const mesSeleccionado = event.target.value; // Obtener valor del radio marcado
    $('#mesSeleccionado').val(mesSeleccionado);
  });
});

//PARA BORRAR
$(document).on('click', '.btnBorrarFoto', function BorrarFotos() {
  if (confirm('¿Seguro que desea borrar esta foto?')) {
    let idFoto = $(this).closest('.card-body').find('.id_foto').val();
    let rutaFoto = $(this).closest('.card-body').find('.ruta_foto').val();
    console.log(idFoto);
    $.post('../checkin/checkBorrar.php', { idFoto, rutaFoto }, (respuesta) => {
      console.log(respuesta);

      $('#btnBuscar').click();
    });
  }
});


