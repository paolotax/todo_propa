require 'test_helper'

class ClassiControllerTest < ActionController::TestCase
  setup do
    @classe = classi(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:classi)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create classe" do
    assert_difference('Classe.count') do
      post :create, classe: @classe.attributes
    end

    assert_redirected_to classe_path(assigns(:classe))
  end

  test "should show classe" do
    get :show, id: @classe
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @classe
    assert_response :success
  end

  test "should update classe" do
    put :update, id: @classe, classe: @classe.attributes
    assert_redirected_to classe_path(assigns(:classe))
  end

  test "should destroy classe" do
    assert_difference('Classe.count', -1) do
      delete :destroy, id: @classe
    end

    assert_redirected_to classi_path
  end
end
