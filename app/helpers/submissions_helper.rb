module SubmissionsHelper
  # makes string with seconds/minutes/hours/days indication
  def humanize_time(time)
    case # time since submission
    when time < 60
      return time.round.to_s + " seconds ago"
    when time < 60*60
      return (time/60).round.to_s + " minutes ago"
    when time < 60*60*24
      return (time/(60*60)).round.to_s + " hours ago"
    else
      return (time/(60*60*24)).round.to_s + " days ago"
    end
  end

  # return true if is ask
  def is_ask?(submission)
    return submission.url == ''
  end

  # return true if is url
  def is_url?(submission)
    return submission.text == ''
  end
end
