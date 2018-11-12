module ApplicationHelper

  def goto_url(anchor_id = '')
    if anchor_id == ''
      return request.original_url
    else
      return request.original_url + "#" + anchor_id.to_s
    end
  end
end
