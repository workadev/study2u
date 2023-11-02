# frozen_string_literal: true

devise_for :staff, controllers: {
  sessions: "staff/sessions"
}, skip: [:passwords, :registrations]

devise_scope :staff do
  get   "staff/edit",  to: "admin/registrations#edit"
  put   "staff",       to: "admin/registrations#update", as: "staff_registration"
  patch "staff",       to: "admin/registrations#update"

  namespace :staff do
    concerns :admin_feature

    get "authentications", to: "authentications#show"
  end
end
