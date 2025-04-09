class PagesController < ApplicationController
  def show
    @page = Page.find_by(slug: params[:slug])
    unless @page
      render plain: "Page not found", status: :not_found
    end
  end
end

