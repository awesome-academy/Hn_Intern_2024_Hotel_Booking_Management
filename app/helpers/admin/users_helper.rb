module Admin::UsersHelper
  def show_status_lock user
    if user.access_locked?
      content_tag(:span, t("inactive"),
                  class: "badge bg-danger rounded-pill fs-5")
    else
      content_tag(:span, t("active"),
                  class: "badge bg-success rounded-pill fs-5")
    end
  end

  def show_button_lock user
    if user.access_locked?
      link_to admin_unlock_user_path(user),
              class: "btn btn-info rounded-pill",
              data: {turbo_method: :post} do
        fa_icon "unlock"
      end
    else
      link_to admin_lock_user_path(user),
              class: "btn btn-danger rounded-pill",
              data: {turbo_method: :post} do
        fa_icon "lock"
      end
    end
  end

  def status_user_options
    [
      [t("active"), "unlocked"],
      [t("inactive"), "locked"]
    ]
  end
end
