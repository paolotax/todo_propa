require 'test_helper'

class AppuntiControllerTest < ActionController::TestCase
  setup do
    @appunto = appunti(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:appunti)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create appunto" do
    assert_difference('Appunto.count') do
      post :create, appunto: @appunto.attributes
    end

    assert_redirected_to appunto_path(assigns(:appunto))
  end

  test "should show appunto" do
    get :show, id: @appunto.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @appunto.to_param
    assert_response :success
  end

  test "should update appunto" do
    put :update, id: @appunto.to_param, appunto: @appunto.attributes
    assert_redirected_to appunto_path(assigns(:appunto))
  end

  test "should destroy appunto" do
    assert_difference('Appunto.count', -1) do
      delete :destroy, id: @appunto.to_param
    end

    assert_redirected_to appunti_path
  end
end
