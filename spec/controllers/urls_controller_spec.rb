require 'rails_helper'

describe UrlsController do
  describe 'GET #index' do
    before { get :index }

    it 'assigns a new Url instance to @url' do
      expect(assigns(:url)).to be_a_new(Url)
    end

    it 'assigns a all Urls instances to @all_url' do
      expect(assigns(:all_urls)).to eq (Url.all)
    end

    it 'has a 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'renders the index template' do
      expect(response).to render_template :index
    end
  end

  describe 'POST #index' do
    let(:context) { double }
    let(:invalid_url) { '' }
    let(:valid_url) { 'https://www.google.com' }

    context 'link is successfully created' do
      before do
        allow(CreateUrl).to receive(:call).with({original_url: valid_url}).and_return(context)
        allow(context).to receive(:success?).and_return(true)
        post :create, params: { url: { original_url: valid_url } }
      end

      it 'assigns a new Url instance' do
        expect(assigns(:url)).to be_a_new(Url)
      end

      it 'has a 200 status code' do
        expect(response.status).to eq(200)
      end

      it 'renders the index template' do
        expect(response).to render_template :index
      end

      it 'assigns a all Urls instances to @all_url' do
        expect(assigns(:all_urls)).to eq (Url.all)
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

      it 'assigns a all Urls instances to @all_url' do
        expect(assigns(:all_urls)).to eq (Url.all)
      end

      it 'assigns a flash message' do
        expect(flash[:error]).to match(/Check the error below:/)
      end
    end
  end

  describe 'GET #redirect' do
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

  describe 'GET #statistics' do
    let(:url) { create :url }
    let!(:clicks) { create_list :click, 5, url: url }

    before { get :statistics, params: { id: url.id } }

    it 'has a 302 status code' do
      expect(response.status).to eq(200)
    end

    it 'has returns correct payload' do
      data = JSON.parse(response.body)

      expect(data.keys).to match_array ['id', 'original_url', 'short_url', 'updated_at', 'clicks']
      expect(data['clicks'].size).to eq 5
      expect(data['clicks'].first.keys).to match_array ['id', 'url_id', 'country', 'browser', 'platform', 'created_at']
    end
  end
end
