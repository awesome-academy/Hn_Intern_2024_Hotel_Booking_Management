import I18n from "i18n-js";

$(document).on("turbo:load", function () {
  I18n.locale = document.querySelector("body").getAttribute("data-locale");
  const mutationObserver = new MutationObserver(function (mutations) {
    mutations.forEach(function (mutation) {
      const starItems = $(".star-item");
      const formReview = $("#form-review");
      const btnEdit = $("#btn-edit");

      if (btnEdit) {
        btnEdit.click(function () {
          $("#review_comment").removeAttr("disabled");
          $("#btn-update").removeClass("d-none");
        });
      }

      starItems.each(function () {
        $(this).click(function () {
          let index = $(this).attr("id").replace("_", "");
          for (let i = 0; i < 5; i++) {
            if (i < index) {
              starItems
                .eq(i)
                .removeClass("text-secondary")
                .addClass("text-primary");
            } else {
              starItems
                .eq(i)
                .removeClass("text-primary")
                .addClass("text-secondary");
            }
          }
          $("#review_rating").val(index);
        });
      });

      if (formReview) {
        formReview.submit(function (e) {
          e.preventDefault();
          let comment = $("#review_comment").val().trim();
          if (comment == "") {
            alert(I18n.t("reviews.please_enter_comment"));
            return;
          }
          $.ajax({
            type: $(this).attr("method"),
            url: $(this).attr("action"),
            data: $(this).serialize(),
            dataType: "JSON",
            success: function (response, statusText, xhr) {
              if (xhr.status >= 200 && xhr.status < 300) {
                alert(response.message);
                let bid = $("#review_booking_id").val();
                $(`#detail-booking-${bid} span`).trigger("click");
              }
            },
            error: function (xhr, statusText, error) {
              alert(JSON.parse(xhr.responseText).message);
            },
          });
        });
      }
    });
  });

  const detailBooking = document.querySelector("#detail-booking");
  if (detailBooking) {
    mutationObserver.observe(detailBooking, {
      childList: true,
    });
  }
});
