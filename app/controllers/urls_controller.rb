class UrlsController < ApplicationController
  before_action :find_url_by_short_url, only: :redirect
  before_action :find_url_by_id, only: :statistics
  before_action :set_all_urls, only: [:index, :create]

  def index
    @url = Url.new
  end

  def redirect
    CreateClick.call(
      url: @url,
      user_agent: request.user_agent,
      ip: request.remote_ip
    )

    redirect_to @url.original_url
  end

  def statistics
    render json: @url
  end

  def create
    result = CreateUrl.call(original_url: url_params[:original_url])

    if result.success?
      @url = Url.new
    else
      flash[:error] = 'Check the error below:'
      @url = result.url
    end

    render 'index'
  end

  private

  def set_all_urls
    @all_urls = Url.includes(:clicks).order(id: :desc).all.to_a
  end

  def find_url_by_short_url
    @url = Url.find_by_short_url(params[:short_url])
  end

  def find_url_by_id
    @url = Url.find(params[:id])
  end

  def url_params
    params.require(:url).permit(:original_url)
  end
end
