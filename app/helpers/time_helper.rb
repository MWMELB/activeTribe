module TimeHelper
  def format_duration(duration)
    hours = duration / 60
    minutes = duration % 60

    if minutes == 0
      "#{hours} hour#{'s' if hours > 1}"
    elsif hours > 0
      "#{hours} hour#{'s' if hours > 1} #{minutes} minute#{'s' if minutes > 1}"
    else
      "#{minutes} minute#{'s' if minutes > 1}"
    end
  end
end
