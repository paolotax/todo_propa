require 'test_helper'

class ComuniControllerTest < ActionController::TestCase
  setup do
    @comune = comuni(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:comuni)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create comune" do
    assert_difference('Comune.count') do
      post :create, comune: @comune.attributes
    end

    assert_redirected_to comune_path(assigns(:comune))
  end

  test "should show comune" do
    get :show, id: @comune.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @comune.to_param
    assert_response :success
  end

  test "should update comune" do
    put :update, id: @comune.to_param, comune: @comune.attributes
    assert_redirected_to comune_path(assigns(:comune))
  end

  test "should destroy comune" do
    assert_difference('Comune.count', -1) do
      delete :destroy, id: @comune.to_param
    end

    assert_redirected_to comuni_path
  end
end
