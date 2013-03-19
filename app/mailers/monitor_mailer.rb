# encoding: utf-8

class MonitorMailer < ActionMailer::Base
  STATUS_MSG = {
    no_log: 'ログがありません',
    danger: '×異常',
    warning: '△注意',
    success: '○正常'
  }

  default from: "sabakan@falconsrv.net"

  def status_changed(server)
    @server = server
    @server_status = STATUS_MSG[@server.status_before(1.day)]

    mail to: @server.account.email,
      subject: '【さくらの鯖缶】サーバ監視通知'
  end
end
