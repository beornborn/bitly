require 'rails_helper'

describe CreateUrl do
  context 'valid url basic scenario' do
    let(:valid_url) { 'https://google.com' }
    subject(:service) { described_class.call(original_url: valid_url) }

    it 'saves record with shortened url' do
      service

      stored_url = Url.find_by(original_url: valid_url)
      expect(service.url).to eq stored_url
      expect(stored_url.short_url.size).to eq 6
    end

    context 'generated url already present' do
      let(:existing_short_url) { '111111' }
      let!(:existing_url) { create :url, original_url: valid_url, short_url: existing_short_url }
      let(:context) { double }

      before do
        allow(ShortenUrl).to receive(:call).and_return(context, ShortenUrl.call)
        allow(context).to receive(:url).and_return(existing_short_url)
      end

      it 'saves record with shortened url' do
        service

        expect(service.url.short_url.size).to eq 6
        expect(service.url.short_url).to_not eq existing_short_url
      end
    end

    context 'invalid url provided or just something else went wrong' do
      let(:invalid_url) { 'invalid_url' }

      subject(:service) { described_class.call(original_url: invalid_url) }

      it 'doesnt save record' do
        service

        expect(Url.all).to be_empty
      end

      it 'provides error' do
        service

        expect(service.error.message).to eq 'Validation failed: Original url is invalid'
      end
    end
  end
end
