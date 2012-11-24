require 'test_helper'

class AppuntoEventsControllerTest < ActionController::TestCase
  setup do
    @appunto_event = appunto_events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:appunto_events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create appunto_event" do
    assert_difference('AppuntoEvent.count') do
      post :create, appunto_event: @appunto_event.attributes
    end

    assert_redirected_to appunto_event_path(assigns(:appunto_event))
  end

  test "should show appunto_event" do
    get :show, id: @appunto_event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @appunto_event
    assert_response :success
  end

  test "should update appunto_event" do
    put :update, id: @appunto_event, appunto_event: @appunto_event.attributes
    assert_redirected_to appunto_event_path(assigns(:appunto_event))
  end

  test "should destroy appunto_event" do
    assert_difference('AppuntoEvent.count', -1) do
      delete :destroy, id: @appunto_event
    end

    assert_redirected_to appunto_events_path
  end
end
