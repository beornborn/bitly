require 'rails_helper'

describe CreateClick do
  context 'valid url basic scenario' do
    let(:url) { create :url }
    subject(:service) { described_class.call(
      url: url,
      ip: '173.194.112.35',
      user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36'
    ) }

    it 'saves record' do
      service

      click = Click.last
      expect(click.url_id).to eq url.id
      expect(click.country).to eq 'United States'
      expect(click.browser).to eq 'Chrome'
      expect(click.platform).to eq 'Macintosh'
    end
  end
end
