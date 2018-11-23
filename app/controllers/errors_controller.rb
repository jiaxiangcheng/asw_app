class ErrorsController < ActionController::Base
  def not_found
    respond_to do |format|
      format.all { render file: "public/404.html", status: 404 }
      format.json { render :json => {:error => "not-found"}.to_json, status: 404 }
    end
  end

  def exception
    respond_to do |format|
      format.html { render file: "public/500.html", status: 500 }
      format.json { render :json => {:error => "internal-server-error"}.to_json, status: 500 }
    end
  end
end
