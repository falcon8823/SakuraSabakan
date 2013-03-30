module ServersHelper
  LABEL = {
    no_log: 'label-info',
    success: 'label-success',
    warning: 'label-warning',
    danger: 'label-important'
  }
  ALERT = {
    no_log: 'alert-info',
    success: 'alert-success',
    warning: 'alert-warning',
    danger: 'alert-error'
  }
  ICON = {
    no_log: 'question-sign',
    success: 'ok-sign',
    warning: 'info-sign',
    danger: 'exclamation-sign'
  }

  def status_icon_tag(status)
    icon_tag "icon-#{ICON[status]}"
  end

  def rate_tag(rate, status)
    content_tag :span, "#{rate}%", class: "label #{LABEL[status]}"
  end

  # ステータス表示付きのアコーディオンヘッダタグ
  def status_accordion_toggle_tag(status, href, &block)
    content_tag :a,
      class: "accordion-toggle #{ALERT[status]}",
      href: href,
      data: {toggle: 'collapse'},
      &block
  end


end
