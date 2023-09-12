# frozen_string_literal: true

devise_for :staff, controllers: {
  sessions: "staff/sessions"
}, skip: [:passwords, :registrations]

devise_scope :staff do
  get   "staff/edit",  to: "staff/registrations#edit"
  put   "staff",       to: "staff/registrations#update", as: "staff_registration"
  patch "staff",       to: "staff/registrations#update"

  namespace :staff do
    concerns :admin_feature
  end
end
