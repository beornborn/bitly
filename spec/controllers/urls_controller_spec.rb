require 'rails_helper'

describe UrlsController do
  describe '#index' do
    before { get :index }

    it 'assigns a new Url instance to @url' do
      expect(assigns(:url)).to be_a_new(Url)
    end

    it 'has a 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'renders the index template' do
      expect(response).to render_template :index
    end
  end

  describe '#create' do
    let(:context) { double }
    let(:url) { double(short_url: 'short_url') }
    let(:invalid_url) { '' }
    let(:valid_url) { 'https://www.google.com' }

    context 'link is successfully created' do
      before do
        allow(CreateUrl).to receive(:call).with(original_url: valid_url).and_return(context)
        allow(context).to receive(:success?).and_return(true)
        allow(context).to receive(:url).and_return(url)
        post :create, params: { url: { original_url: valid_url } }
      end

      it 'redirects to created short url' do
        expect(response).to redirect_to(action: :short, short_url: url.short_url)
      end
    end

    context 'link is not successfully created' do
      let(:url) { create :url }
      before do
        allow(CreateUrl).to receive(:call).with({original_url: invalid_url}).and_return(context)
        allow(context).to receive(:success?).and_return(false)
        allow(context).to receive(:url).and_return(url)
        post :create, params: { url: { original_url: invalid_url } }
      end

      it 'assigns a new Url instance' do
        expect(assigns(:url)).to eq url
      end

      it 'has a 200 status code' do
        expect(response.status).to eq(200)
      end

      it 'renders the index template' do
        expect(response).to render_template :index
      end

      it 'assigns a flash message' do
        expect(flash[:error]).to match(/Check the error below:/)
      end
    end
  end

  describe '#redirect' do
    let(:original_url) { 'https://google.com' }
    let!(:url) { create :url, short_url: '111111', original_url: original_url }

    before do
      expect(CreateClick).to receive(:call)
      get :redirect, params: { short_url: url.short_url }
    end

    it 'redirects to the original url' do
      expect(response).to redirect_to(url.original_url)
    end

    it 'has a 302 status code' do
      expect(response.status).to eq(302)
    end
  end

  describe '#stat' do
    let(:url) { create :url, short_url: 'short_url' }
    let!(:clicks) { create_list :click, 5, url: url }

    context 'html' do
      before { get :stat, params: { short_url: url.short_url } }

      it 'has a 200 status code' do
        expect(response.status).to eq(200)
      end

      it 'has returns correct payload' do
        expect(assigns(:url)).to eq(url)
      end
    end

    context 'csv' do
      let(:context) { double(csv_string: 'csv_string') }

      it 'has a 200 status code' do
        get :stat, params: { short_url: url.short_url }, format: :csv
        expect(response.status).to eq(200)
      end

      it 'has returns correct payload' do
        allow(ClicksToCsv).to receive(:call).and_return(context)
        expect(@controller).to receive(:send_data)

        get :stat, params: { short_url: url.short_url }, format: :csv
      end
    end
  end

  describe '#short' do
    let(:url) { create(:url, short_url: 'short_url') }

    before { get :short, params: { short_url: url.short_url } }

    it 'assigns a new Url instance to @url' do
      expect(assigns(:url)).to eq(url)
    end

    it 'has a 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'renders the short template' do
      expect(response).to render_template :short
    end
  end
end
