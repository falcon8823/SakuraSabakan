# ライブラリの読み込み
google.load 'visualization', '1', {'packages':['corechart']}

# グラフの描画関数
drawPingLogChart = () ->
	# pingログのJSONデータを取得
	json = JSON.parse $.ajax(
		url: ping_logs_path,
		dataType: 'json',
		async: false
	).responseText

	data = new google.visualization.DataTable
	data.addColumn('datetime', 'Time')
	data.addColumn('number', 'Average[ms]')

	# JSONデータから必要なデータを抽出し、変換
	logs_data = ([new Date(i.date), i.avg] for i in json)
	# 描画データに追加
	data.addRows logs_data

	chart = new google.visualization.LineChart document.getElementById 'ping_logs_chart'
	chart.draw data,
		title: 'Ping Response Time',
		legend: 'bottom',
		pointSize: 0

# ライブラリのロードコールバックにセット
google.setOnLoadCallback drawPingLogChart