class HttpingLogParser
  # 抽出に使用する正規表現
  RTT_REGEX = /^.*min\/avg\/max.*= (.*) ms$/
  STAT_REGEX = /^.*ok, (.*)% failed.*$/

  def initialize(log)
    @raw_log = log
  end

  # RTTの解析
  def parse_rtt
    if rtt_str =  @raw_log.scan(RTT_REGEX).first
      # ping成功

      # 各数値文字列を取り出して，数値型（浮動小数）に変換
      arr = rtt_str.first.split(/\s*\/\s*/).map {|i| i.to_f }

      # Hashに変換
      h = Hash.new
      h[:min] = arr[0]
      h[:avg] = arr[1]
      h[:max] = arr[2]

      h
    else
      # ping失敗
      # Hashに変換
      h = Hash.new
      h[:min] = 0
      h[:avg] = 0
      h[:max] = 0

      h
    end
  end

  # httping結果の解析
  def parse_stat
    if arr = @raw_log.scan(STAT_REGEX).first
      # Hashに変換
      h = Hash.new
      h[:failed_rate] = arr[0].to_f
      h
    else
      # httping失敗
      # Hashに変換
      h = Hash.new
      h[:failed_rate] = 100
      h
    end
  end
end