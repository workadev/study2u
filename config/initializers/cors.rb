Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource(
      '*',
      headers: :any,
      methods: [:get, :patch, :put, :delete, :post, :options],
      expose: [
        "token",
        "refresh_token",
        "expired",
        "expired_refresh_token",
        "external_user_id",
        "Total",
        "Per-Page",
        "Page",
        "Link",
        "Next",
        "Prev",
        "Last",
        "First"
      ],
      max_age: 0
    )
  end
end
