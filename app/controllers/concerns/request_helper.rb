module RequestHelper
  def request_path
    request.path.split("/")
  end

  def path_last
    request_path.last.split("?").first
  end
end
