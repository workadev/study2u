// In your Javascript (external .js resource or <script> tag)
$(document).ready(function() {
  $('#staff').select2();
  $('#interest').select2();
  $('#study_level').select2();

  var ids = ["staff", "interest", "study_level"];
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
