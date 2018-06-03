class ShortenUrl
  include Interactor

  def call
    chars = ['0'..'9','A'..'Z','a'..'z'].map(&:to_a).flatten
    context.url = 6.times.map { chars.sample }.join
  end
end
