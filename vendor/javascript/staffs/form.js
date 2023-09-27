// In your Javascript (external .js resource or <script> tag)
$(document).ready(function() {
  $('#institution').select2();

  var ids = ["institution"];
  $.each( ids, function( index, value ) {
    $('#' + value).on('select2:opening', function (e) {
      $("#" + value + " option[value='']").attr('disabled', true);
    });

    $('#' + value).on('select2:closing', function (e) {
      $("#" + value + " option[value='']").attr('disabled', false);
    });

    onEmptySelected(value);
  })
});

function onEmptySelected(id) {
  $("#"+id).on('change', function() {
    var value = $("#"+id).val();

    if (value.length === 0) {
      $("#"+id).val([""]);
    }
  });
}
