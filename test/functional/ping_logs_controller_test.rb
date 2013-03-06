require 'test_helper'

class PingLogsControllerTest < ActionController::TestCase
  setup do
    @ping_log = ping_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ping_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ping_log" do
    assert_difference('PingLog.count') do
      post :create, ping_log: { date: @ping_log.date, ping_detail: @ping_log.ping_detail, server_id: @ping_log.server_id, status: @ping_log.status }
    end

    assert_redirected_to ping_log_path(assigns(:ping_log))
  end

  test "should show ping_log" do
    get :show, id: @ping_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ping_log
    assert_response :success
  end

  test "should update ping_log" do
    put :update, id: @ping_log, ping_log: { date: @ping_log.date, ping_detail: @ping_log.ping_detail, server_id: @ping_log.server_id, status: @ping_log.status }
    assert_redirected_to ping_log_path(assigns(:ping_log))
  end

  test "should destroy ping_log" do
    assert_difference('PingLog.count', -1) do
      delete :destroy, id: @ping_log
    end

    assert_redirected_to ping_logs_path
  end
end
