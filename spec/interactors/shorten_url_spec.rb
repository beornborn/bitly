require 'rails_helper'

describe ShortenUrl do
  subject(:service) { described_class.call }

  it 'generate shortened url' do
    service

    expect(service.url.size).to eq 6
    expect(service.url).to match /\A[a-zA-z0-9]{6}\z/
  end
end
