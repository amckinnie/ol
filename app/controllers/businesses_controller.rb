class BusinessesController < ApplicationController
  before_action :setup_paging, only: [:index]
  before_action :lookup_business, only: [:show]

  DEFAULT_PAGE_SIZE = 50

  def index
    businesses = Business.order(:id)
                         .offset(@offset)
                         .limit(@page_size)
    render json: {
      businesses: businesses.map(&:to_json),
      pages: @page_json,
    }
  end

  def show
    render json: @business
  end

  private

  def setup_paging
    @page_size = params[:page_size].to_i
    @page_size = DEFAULT_PAGE_SIZE if @page_size <= 0

    total_pages = (Business.count / @page_size.to_f).ceil
    @page = params[:page].to_i
    @page = 1 if @page <= 0 || @page > total_pages

    pathsize = {}
    pathsize[:page_size] = @page_size if @page_size != DEFAULT_PAGE_SIZE
    @page_json = { current: businesses_url( pathsize.merge(page: @page) ) }
    if total_pages > 1
      @page_json.merge!({
        first: businesses_url( pathsize ),
        last: businesses_url( pathsize.merge(page: total_pages) )
        })
      if @page > 1
        @page_json[:previous] = businesses_url( pathsize.merge(page: (@page - 1)) )
      end
      if @page < total_pages
        @page_json[:next] = businesses_url( pathsize.merge(page: (@page + 1)))
      end
    end
  end

  def lookup_business
    @business = Business.where(id: params[:id]).first
    render_not_found and return false unless @business
  end

end
