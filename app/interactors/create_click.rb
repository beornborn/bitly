require 'geoip'

class CreateClick
  include Interactor

  def call
    location = GeoIP.new("#{Rails.root}/vendor/GeoIP.dat")
    country = location.country(context.ip).country_name

    browser = Browser.new(context.user_agent).name
    platform = Browser.new(context.user_agent).platform.name

    Click.create!(
      url: context.url,
      country: country,
      browser: browser,
      platform: platform,
    )
  rescue StandardError => e
    context.fail!(error: e)
  end
end
