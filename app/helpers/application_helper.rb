module ApplicationHelper
  FLASH_MSG = {
    success: 'alert-success',
    error: 'alert-danger',
    alert: 'alert-danger',
    warning: 'alert-warning',
    notice: 'alert-warning'
  }

  def flash_class_for(flash_type)
    FLASH_MSG[flash_type.to_sym] || flash_type.to_s
  end

  def current_title(page_title)
    if page_title.empty?
      Settings.sitename
    else
      "#{page_title} | #{Settings.sitename}"
    end
  end

  def active_class(current_controller)
    current_controller == controller_path ? 'active' : ''
  end

  def active_parent(name)
    request.path.split('/')[2] == name ? 'active' : ''
  end

  def active_page(page)
    current_page?(page) ? 'active' : ''
  end

  def zip_code_ja(zip_code)
    "〒#{zip_code}" if zip_code.present?
  end

  def hbr(str)
    str = html_escape(str)
    str.gsub(/\r\n|\r|\n/, "<br />").html_safe
  end

  def datetime_ja(d)
    return "" if d.blank?
    d.try(:strftime, "%Y年%m月%d日(#{%w(日 月 火 水 木 金 土)[d.wday]}) %H:%M")
  end

  def date_ja(d)
    return "" if d.blank?
    d.strftime("%Y年%m月%d日(#{%w(日 月 火 水 木 金 土)[d.wday]})")
  end

  def date_short_ja(d)
    return "" if d.blank?
    d.strftime("%m月%d日(#{%w(日 月 火 水 木 金 土)[d.wday]})")
  end

  def time_fmt(t)
    return '' if t.blank?
    t.try(:strftime, '%H:%M')
  end

  def delimiter_price(num)
    num = num ? num : 0
    "#{number_with_delimiter num} 円"
  end

  def key_corporation_select
    KeystationService.sync_corporations
  end

  def ks_room_key_select(corporation)
    Facility.sync_from_api(corporation.ks_corporation_id)
  end
end
