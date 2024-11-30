module GroupHelper
  def format_member(count)
    if count == 0
      "#{count + 1} active member"
    else
      "#{count + 1} active members"
    end
  end
end
