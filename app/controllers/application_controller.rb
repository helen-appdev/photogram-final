class ApplicationController < ActionController::Base
  def index
    render({:template => "/index.html.erb"})
  end
end
