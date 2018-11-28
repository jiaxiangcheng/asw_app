module SubmissionsHelper
  # NOT NEEDED: use time_ago_in_words(from_time) instead
  # def humanize_time(time)
  # end

  # extracts host from uri
  def shorten_url(url)
    return URI.parse(url).host
  end
end
