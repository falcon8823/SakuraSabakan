class HttpingLogParser
  # 抽出に使用する正規表現
  RTT_REGEX = /^.*min\/avg\/max.*= (.*) ms$/
  STAT_REGEX = /^.*ok, (.*)% failed.*$/
  STATUS_REGEX = /^connected.*time=.* ms (\d{3}).*$/

  def initialize(log)
    @raw_log = log
  end

  # RTTの解析
  def rtt
    if rtt_str =  @raw_log.scan(RTT_REGEX).first
      # ping成功
      # 各数値文字列を取り出して，数値型（浮動小数）に変換
      arr = rtt_str.first.split(/\s*\/\s*/).map {|i| i.to_f }

      # Hashに変換
      return { min: arr[0], avg: arr[1], max: arr[2] }
    else
      # ping失敗
      # Hashに変換
      return { min: 0, avg: 0, max: 0 }
    end
  end

  # httping結果の解析
  def stat
    rate = (arr = @raw_log.scan(STAT_REGEX).first) ? arr[0].to_f : 100
    return { failed_rate: rate }
  end

  # statusコードの解析
  def status
    if arr = @raw_log.scan(STATUS_REGEX).flatten
      arr.uniq.sort!

      # 数値的に最も高いステータスコードを返す
      return { status: (arr.last ? arr.last : 'Failed') }
    else
      return { status: 'Failed' }
    end
  end
end
