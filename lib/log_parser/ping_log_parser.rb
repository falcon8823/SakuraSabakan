# coding: utf-8

class PingLogParser
  # 抽出に使用する正規表現
  RTT_REGEX = /^.*min\/avg\/max.*= (.*) ms$/
  STAT_REGEX = /^(\d*).*transmitted, (\d*).*received, (.*)% packet loss.*$/

    def initialize(ping_log)
      @ping_log = ping_log
    end

  # RTTの解析
  def rtt
    if rtt_str =  @ping_log.scan(RTT_REGEX).first
      # ping成功

      # 各数値文字列を取り出して，数値型（浮動小数）に変換
      arr = rtt_str.first.split(/\s*\/\s*/).map {|i| i.to_f }

      # Hashに変換
      return {min: arr[0], avg: arr[1], max: arr[2], stddev: arr[3]}
    else
      # ping失敗
      return {min: 0, avg: 0, max: 0, stddev: 0}
    end
  end

  # ping結果の解析
  def stat
    if arr = @ping_log.scan(STAT_REGEX).first
      # Hashに変換
      return {
        transmitted: arr[0].to_i,
        received: arr[1].to_i,
        packet_loss: arr[2].to_f
      }
    else
      # ping失敗
      return {transmitted: 0, received: 0, packet_loss: 100.0}
    end
  end
end
