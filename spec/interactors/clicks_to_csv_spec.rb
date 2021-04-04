require 'rails_helper'

describe ClicksToCsv do
  let(:url) { create(:url) }
  let!(:click) do
    create(
      :click,
      url: url,
      country: 'Ukraine',
      browser: 'Chrome',
      platform: 'macOS',
      created_at: '2021-04-04T17:07:49+03:00'
    )
  end

  subject(:service) { described_class.call(url: url) }

  it 'generates csv' do
    expect(service.csv_string).to eq "Ukraine,Chrome,macOS,2021-04-04 14:07:49 UTC\n"
  end
end
