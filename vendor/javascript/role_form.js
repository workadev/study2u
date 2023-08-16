function form() {
  //clicking the Select All checkbox should check or uncheck all parent of the child checkboxes
  $(".selectAll").change(
    function() {
      $(this).parents('fieldset:eq(0)').find('.parentCheckBox').prop('checked', this.checked)
      $(this).parents('fieldset:eq(0)').find('.subchildCheckBox').prop('checked', this.checked)
    }
  )

  //clicking the last unchecked or checked checkbox should check or uncheck the select all checkbox
  $('.parentCheckBox').change(
    function() {
      $(this).parents('fieldset:eq(0)').find('.subchildCheckBox').prop('checked', this.checked)
      if ($(this).parents('fieldset').find('.selectAll').prop('checked') == true && this.checked == false)
      $(this).parents('fieldset').find('.selectAll').prop('checked', false)
      if (this.checked == true) {
        var flag = true
        $(this).parents('fieldset').find('.parentCheckBox').each(
          function() {
            if (this.checked == false)
              flag = false
            }
          )
        $(this).parents('fieldset').find('.selectAll').prop('checked', flag)
      }
    }
  )

  //clicking the last unchecked or checked checkbox should check or uncheck the parent checkbox
  $('.subchildCheckBox').change(
    function() {
      if ($(this).parents('fieldset').find('.selectAll').prop('checked') == true && this.checked == false)
      $(this).parents('fieldset').find('.selectAll').prop('checked', false)
      if (this.checked == true) {
        var flag = true
        $(this).parents('fieldset').find('.subchildCheckBox').each(
          function() {
            if (this.checked == false)
              flag = false
            }
          )
        $(this).parents('fieldset').find('.selectAll').prop('checked', flag)
      }

      if ($(this).parents('fieldset:eq(0)').find('.parentCheckBox').prop('checked') == true && this.checked == false)
      $(this).parents('fieldset:eq(0)').find('.parentCheckBox').prop('checked', false)
      if (this.checked == true) {
        var flag = true
        $(this).parents('fieldset:eq(0)').find('.subchildCheckBox').each(
          function() {
            if (this.checked == false)
              flag = false
            }
          )
        $(this).parents('fieldset:eq(0)').find('.parentCheckBox').prop('checked', flag)
      }
    }
  )

  $('fieldset').each(function(){
    var $childCheckBox = $(this).find('input.subchildCheckBox'),
    no_checked_child = $childCheckBox.filter(':checked').length
    if($childCheckBox.length == no_checked_child){
      $(this).find('.selectAll').prop('checked',true)
      $(this).find('.parentCheckBox').prop('checked',true)
    } else {
      $(this).find('.selectAll').prop('checked',false)
    }
  })
}

form();
