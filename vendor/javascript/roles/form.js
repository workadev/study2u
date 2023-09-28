$("#role_is_staff").on("change", function(e) {
  $.get("/admin/roles/actions", { is_staff: $("#role_is_staff").is(":checked") });
});
