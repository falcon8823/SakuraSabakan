# ライブラリの読み込み
google.load 'visualization', '1', {'packages':['corechart']}

# グラフの描画関数
serverPingChart = (server_id, json_path) ->
	# pingログのJSONデータを取得
	json = JSON.parse $.ajax(
		url: json_path + '.json',
		dataType: 'json',
		async: false
	).responseText

	dt = new google.visualization.DataTable
	dt.addColumn('number', 'ID')
	dt.addColumn('datetime', 'Time')
	dt.addColumn('number', 'Average[ms]')

	# JSONデータから必要なデータを抽出し、変換
	data_arr = ([i.id, new Date(i.date), i.avg] for i in json)
	# 描画データに追加
	dt.addRows data_arr

	dv = new google.visualization.DataView dt
	dv.setColumns [1, 2]

	chart = new google.visualization.LineChart document.getElementById 'chart_ping_' + server_id
	chart.draw dv,
		title: 'Ping Round Trip Time',
		legend: 'bottom',
		pointSize: 0

	# 選択時にモーダルで詳細ログを表示する
	selectHandler = (e) ->
		path = json_path + '/' + dt.getValue(chart.getSelection()[0]['row'], 0)

		$('#pingDetailModal > .modal-body').load path, () ->
			$('#pingDetailModal').modal 'show'

	google.visualization.events.addListener chart, 'select', selectHandler

pingChart = () ->
	for key of ping_logs_path
		serverPingChart key, ping_logs_path[key]



serverHttpChart = (server_id, json_path) ->
	# pingログのJSONデータを取得
	json = JSON.parse $.ajax(
		url: json_path,
		dataType: 'json',
		async: false
	).responseText

	dt = new google.visualization.DataTable
	dt.addColumn('number', 'ID')
	dt.addColumn('datetime', 'Time')
	dt.addColumn('number', 'Average[ms]')

	# JSONデータから必要なデータを抽出し、変換
	logs_data = ([i.id, new Date(i.date), i.avg] for i in json)
	# 描画データに追加
	dt.addRows logs_data

	dv = new google.visualization.DataView dt
	dv.setColumns [1, 2]

	chart = new google.visualization.LineChart document.getElementById 'chart_http_' + server_id
	chart.draw dv,
		title: 'HTTP Round Trip Time',
		legend: 'bottom',
		pointSize: 0

	# 選択時にモーダルで詳細ログを表示する
	selectHandler = (e) ->
		path = json_path + '/' + dt.getValue(chart.getSelection()[0]['row'], 0)

		$('#pingDetailModal > .modal-body').load path, () ->
			$('#pingDetailModal').modal 'show'

	google.visualization.events.addListener chart, 'select', selectHandler


httpChart = () ->
	for key of http_logs_path
		serverHttpChart key, http_logs_path[key]

drawAll = () ->
	httpChart()
	pingChart()


# ライブラリのロードコールバックにセット
google.setOnLoadCallback drawAll