class TinyMceController < ApplicationController
  include TinyMce

  skip_before_action :verify_authenticity_token, only: :upload

  def upload
    file = params[:file]
    url = helper_tinymce(file: file)
    render json: { "location": url }
  end
end
