import I18n from "i18n-js";

$(document).on("turbo:load", function () {
  I18n.locale = document.querySelector("body").getAttribute("data-locale");
  // check room available
  let form = $("#form_check_available");
  if (form) {
    form.submit(function (e) {
      e.preventDefault();

      // check time
      let checkIn = $("#date_check_check_in_date").val();
      let checkOut = $("#date_check_check_out_date").val();

      if (!checkIn) {
        alert(I18n.t("bookings.alerts.enter_check_in"));
        return;
      }

      if (!checkOut) {
        alert(I18n.t("bookings.alerts.enter_check_out"));
        return;
      }

      if (new Date(checkIn) < new Date()) {
        alert(I18n.t("bookings.alerts.check_in_invalid"));
        return;
      }

      if (new Date(checkIn) > new Date(checkOut)) {
        alert(I18n.t("bookings.alerts.check_out_invalid"));
        return;
      }

      $.ajax({
        type: "get",
        url: $(this).attr("action"),
        data: $(this).serialize(),
        dataType: "JSON",
        success: function (response, statusText, xhr) {
          if (xhr.status == 200) {
            $("#btn-book-now").show();
            alert(response.message);
          }
        },
        error: function (xhr, statusText, error) {
          $("#btn-book-now").hide();
          alert(JSON.parse(xhr.responseText).message);
        },
      });
    });
  }
});
