# coding: utf-8

class PingLogParser
  # 抽出に使用する正規表現
  TIME_REGEX = /^.*min\/avg\/max.*= (.*) ms$/
    STAT_REGEX = /^(\d*).*transmitted, (\d*).*received, (.*)% packet loss.*$/

    def initialize(ping_log)
      @ping_log = ping_log
    end

  # ping時間の解析
  def parse_time
    if time_str =  @ping_log.scan(TIME_REGEX).first
      # ping成功

      # 各数値文字列を取り出して，数値型（浮動小数）に変換
      arr = time_str.first.split(/\s*\/\s*/).map {|i| i.to_f }

      # Hashに変換
      h = Hash.new
      h[:min] = arr[0]
      h[:avg] = arr[1]
      h[:max] = arr[2]
      h[:stddev] = arr[3]

      h
    else
      # ping失敗
      raise 'Time parsing Exception'
    end
  end

  # ping結果の解析
  def parse_stat
    if arr = @ping_log.scan(STAT_REGEX).first
      # Hashに変換
      h = Hash.new
      h[:transmitted] = arr[0].to_i
      h[:received] = arr[1].to_i
      h[:packet_loss] = arr[2].to_f
      h
    else
      # ping失敗
      raise 'Statistics parsing Exception'
    end
  end
end
