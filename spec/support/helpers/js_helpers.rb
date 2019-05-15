module JsHelper
  def fill_in_with_script(selector, val)
    page.execute_script("$('#{selector}').val('#{val}')")
  end
  
  def move_to_target_date(selector, date)
    page.execute_script("$('#{selector}').fullCalendar('gotoDate', '#{date}')")
  end
end
