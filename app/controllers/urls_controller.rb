class UrlsController < ApplicationController
  before_action :find_url, only: [:show, :redirect]

  def index
    @url = Url.new
    @all_urls = Url.order(id: :desc).all.to_a
  end

  def redirect
    redirect_to @url.original_url
  end

  def show
  end

  def create
    result = CreateUrl.call(original_url: url_params[:original_url])

    if result.success?
      @url = Url.new
    else
      flash[:error] = "Check the error below:"
      @url = result.url
    end

    @all_urls = Url.order(id: :desc).all.to_a

    render 'index'
  end

  private

  def find_url
    @url = Url.find_by_short_url(params[:short_url])
  end

  def url_params
    params.require(:url).permit(:original_url)
  end
end
