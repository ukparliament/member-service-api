module FormatHelper
  def format(data)
    respond_to do |format|
      format.ttl { render :plain => data }
    end
  end
end