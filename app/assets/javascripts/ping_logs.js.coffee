# ライブラリの読み込み
google.load 'visualization', '1', {'packages':['corechart']}

# グラフの描画関数
pingLogChart = () ->
	# pingログのJSONデータを取得
	json = JSON.parse $.ajax(
		url: ping_logs_path + '.json',
		dataType: 'json',
		async: false
	).responseText

	data = new google.visualization.DataTable
	data.addColumn('number', 'ID')
	data.addColumn('datetime', 'Time')
	data.addColumn('number', 'Average[ms]')

	# JSONデータから必要なデータを抽出し、変換
	logs_data = ([i.id, new Date(i.date), i.avg] for i in json)
	# 描画データに追加
	data.addRows logs_data

	dv = new google.visualization.DataView data
	dv.setColumns [1, 2]

	chart = new google.visualization.LineChart document.getElementById 'ping_logs_chart'
	chart.draw dv,
		title: 'Ping Round Trip Time',
		legend: 'bottom',
		pointSize: 0

	selectHandler = (e) ->
		window.location = ping_logs_path + '/' + data.getValue(chart.getSelection()[0]['row'], 0)

	google.visualization.events.addListener chart, 'select', selectHandler

httpingLogChart = () ->
	# pingログのJSONデータを取得
	json = JSON.parse $.ajax(
		url: httping_logs_path,
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

	chart = new google.visualization.LineChart document.getElementById 'httping_logs_chart'
	chart.draw data,
		title: 'HTTP Round Trip Time',
		legend: 'bottom',
		pointSize: 0


drawAll = () ->
	httpingLogChart() if httping_logs_path?
	pingLogChart() if ping_logs_path?


# ライブラリのロードコールバックにセット
google.setOnLoadCallback drawAll