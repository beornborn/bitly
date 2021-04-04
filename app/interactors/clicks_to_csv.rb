require 'csv'

class ClicksToCsv
  include Interactor

  def call
    context.csv_string = CSV.generate do |csv|
      context.url.clicks.each do |click|
        csv << [
          click.country,
          click.browser,
          click.platform,
          click.created_at
        ]
      end
    end
  rescue StandardError => e
    context.fail!(error: e, url: url)
  end
end
