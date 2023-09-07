# frozen_string_literal: true

devise_for :admin, controllers: {
  sessions: "admin/sessions"
}, skip: [:passwords, :registrations]

devise_scope :admin do
  get   "admin/edit",  to: "admin/registrations#edit"
  put   "admin",       to: "admin/registrations#update", as: "admin_registration"
  patch "admin",       to: "admin/registrations#update"

  namespace :admin do
    concerns :admin_feature
  end
end
