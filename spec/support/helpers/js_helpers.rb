module JsHelper
  def fill_in_with_script(selector, val)
    page.execute_script("$('#{selector}').val('#{val}')")
  end
end
