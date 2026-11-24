# SiHello: files under /brand-assets are not fingerprinted, so the default
# one-year static cache would pin outdated logos in browsers for a year.
# Shorten the cache lifetime for brand assets to one day.
class BrandAssetsCacheControl
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    headers["Cache-Control"] = "public, max-age=86400" if env["PATH_INFO"].start_with?("/brand-assets/")
    [status, headers, body]
  end
end

if defined?(ActionDispatch::Static)
  Rails.application.config.middleware.insert_before ActionDispatch::Static, BrandAssetsCacheControl
end
