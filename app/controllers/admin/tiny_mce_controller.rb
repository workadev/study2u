class Admin::TinyMceController < AdminController
  include Admin::TinyMce

  skip_before_action :verify_authenticity_token, only: :upload
  skip_before_action :authorize!, only: :upload

  def upload
    file = params[:file]
    url = helper_tinymce(file: file)
    render json: { "location": url }
  end
end
