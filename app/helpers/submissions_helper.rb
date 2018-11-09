module SubmissionsHelper
  # NOT NEEDED: use time_ago_in_words(from_time) instead
  # def humanize_time(time)
  # end

  # return true if is ask
  def is_ask?(submission)
    return submission.url == ''
  end

  # return true if is url
  def is_url?(submission)
    return submission.text == ''
  end
end
