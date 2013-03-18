class HttpingLogParser
  # 抽出に使用する正規表現
  RTT_REGEX = /^.*min\/avg\/max.*= (.*) ms$/
  STAT_REGEX = /^.*ok, (.*)% failed.*$/
  STATUS_REGEX = /^connected.*time=.* ms (\d{3}).*$/

  def initialize(log)
    @raw_log = log
  end

  # RTTの解析
  def parse_rtt
    h = Hash.new

    if rtt_str =  @raw_log.scan(RTT_REGEX).first
      # ping成功
      # 各数値文字列を取り出して，数値型（浮動小数）に変換
      arr = rtt_str.first.split(/\s*\/\s*/).map {|i| i.to_f }

      # Hashに変換
      h[:min] = arr[0]
      h[:avg] = arr[1]
      h[:max] = arr[2]
    else
      # ping失敗
      # Hashに変換
      h[:min] = 0
      h[:avg] = 0
      h[:max] = 0
    end

    h
  end

  # httping結果の解析
  def parse_stat
    h = Hash.new

    h[:failed_rate] = (arr = @raw_log.scan(STAT_REGEX).first) ? arr[0].to_f : 100

    h
  end

  # statusコードの解析
  def parse_status
    h = Hash.new

    if arr = @raw_log.scan(STATUS_REGEX).flatten
      arr.uniq!
      arr.sort!

      # 数値的に最も高いステータスコードを返す
      h[:status] = arr.last
    else
      h[:status] = 'Failed'
    end

    h[:status] = 'Failed' unless h[:status]

    h
  end
end
