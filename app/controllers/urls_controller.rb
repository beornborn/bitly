class UrlsController < ApplicationController
  before_action :find_url_by_short_url, only: [:redirect, :stat, :short]

  def index
    @url = Url.new
  end

  def short
  end

  def stat
    respond_to do |format|
      format.csv do
        csv_string = ClicksToCsv.call(url: @url).csv_string
        send_data csv_string,
          type: 'text/csv; charset=utf-8',
          disposition: "attachment; filename=clicks_for_#{@url.short_url}.csv"
      end
      format.html
    end
  end

  def redirect
    CreateClick.call(
      url: @url,
      user_agent: request.user_agent,
      ip: request.remote_ip
    )

    redirect_to @url.original_url
  end

  def create
    result = CreateUrl.call(original_url: url_params[:original_url])

    if result.success?
      redirect_to action: :short, short_url: result.url.short_url
      return
    end

    flash[:error] = 'Check the error below:'
    @url = result.url

    render 'index'
  end

  private

  def find_url_by_short_url
    @url = Url.find_by_short_url(params[:short_url])
  end

  def url_params
    params.require(:url).permit(:original_url)
  end
end
