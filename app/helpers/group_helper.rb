module GroupHelper
  def format_member(count)
    if count == 1
      "#{count} active member"
    else
      "#{count} active members"
    end
  end
end
