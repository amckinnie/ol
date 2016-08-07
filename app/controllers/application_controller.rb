class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_not_found
    render status: :not_found,
           json: {
             status: 404,
             message: 'Object not found',
           }
  end
end
