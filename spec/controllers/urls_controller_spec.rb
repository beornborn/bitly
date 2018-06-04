require 'rails_helper'

describe UrlsController do
  describe 'GET #index' do
    it 'assigns a new Url instance to @url' do
      get :index
      expect(assigns(:url)).to be_a_new(Url)
    end

    it 'assigns a all Urls instances to @all_url' do
      get :index
      expect(assigns(:all_urls)).to eq (Url.all)
    end

    it 'has a 200 status code' do
      get :index
      expect(response.status).to eq(200)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #redirect' do
    let(:original_url) { 'https://google.com' }
    let!(:url) { create :url, short_url: '111111', original_url: original_url }

    it 'redirects to the original url' do
      expect(CreateClick).to receive(:call)
      get :redirect, params: { short_url: url.short_url }
      expect(response).to redirect_to(url.original_url)
    end

    it 'has a 302 status code' do
      get :redirect, params: { short_url: url.short_url }
      expect(response.status).to eq(302)
    end
  end
end
