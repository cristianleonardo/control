if (document.getElementById("payment_withholdings_form")) {
  $('form').on('click', '.remove_row', function(e) {
    $(this).prev('input[type=hidden]').val(true);
    $(this).closest('tr').hide();
    e.preventDefault();
  });

  $('form').on('click', '.add_fields', function(e) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $('tbody').prepend($(this).data('fields').replace(regexp, time));
    $('.select2-tags').select2({
      placeholder: 'Seleccione una opción',
      tags: true,
    });

    $('.select2').select2({
      placeholder: 'Seleccione una opción',
      allowClear: true,
      width: '100%',
      "language": {
        "noResults": function(){
          return "No se encontraron resultados";
        }
      }
    }).on("select2:close", function (e) {
      $(this).focus();
    });
    e.preventDefault();
  });
}
