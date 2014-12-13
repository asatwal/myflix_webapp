module ApplicationHelper
  def options_for_video_rating(selected=nil)
    options_for_select((1..5).map {|num| [pluralize(num, "Star"), num]}, selected)
  end

  def amount_in_pounds(pence)
    number_to_currency(pence/100.0, :unit => "£")
  end
end
