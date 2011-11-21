require 'test_helper'

class ScuoleControllerTest < ActionController::TestCase
  setup do
    @scuola = scuole(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scuole)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create scuola" do
    assert_difference('Scuola.count') do
      post :create, scuola: @scuola.attributes
    end

    assert_redirected_to scuola_path(assigns(:scuola))
  end

  test "should show scuola" do
    get :show, id: @scuola.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @scuola.to_param
    assert_response :success
  end

  test "should update scuola" do
    put :update, id: @scuola.to_param, scuola: @scuola.attributes
    assert_redirected_to scuola_path(assigns(:scuola))
  end

  test "should destroy scuola" do
    assert_difference('Scuola.count', -1) do
      delete :destroy, id: @scuola.to_param
    end

    assert_redirected_to scuole_path
  end
end
