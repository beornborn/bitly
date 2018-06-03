class CreateUrl
  include Interactor

  def call
    url = Url.new(original_url: context.original_url)

    while url.short_url.blank? || Url.find_by_short_url(url.short_url).present?
      url.short_url = ShortenUrl.call.url
    end

    url.save!
    context.url = url
  rescue StandardError => e
    context.fail!(error: e)
  end
end
