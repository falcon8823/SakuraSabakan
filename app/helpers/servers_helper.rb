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

  # ステータス表示付きのアコーディオンヘッダタグ
  def status_accordion_toggle_tag(status, href, &block)
    content_tag :a,
      class: "accordion-toggle #{ALERT[status]}",
      href: href,
      data: {toggle: 'collapse'},
      &block
  end

  # pingの稼働率の色つきタグ
  def ping_rate_tag(server)
    rate = server.recent_ping_rate 1.day
    status = server.ping_status_before 1.day

    content_tag :span, "#{rate}%", class: "label #{LABEL[status]}"
  end

  # pingの状態アイコンタグ
  def ping_status_icon_tag(server)
    status = server.ping_status_before 1.day

    icon_tag "icon-#{ICON[status]}"
  end

  # httpの稼働率の色つきタグ
  def http_rate_tag(server)
    rate = server.recent_http_rate 1.day
    status = server.http_status_before 1.day

    content_tag :span, "#{rate}%", class: "label #{LABEL[status]}"
  end

  # httpの状態アイコンタグ
  def http_status_icon_tag(server)
    status = server.http_status_before 1.day

    icon_tag "icon-#{ICON[status]}"
  end

  def server_status_icon_tag(server)
    status = server.status_before 1.day

    icon_tag "icon-#{ICON[status]}"
  end
end
