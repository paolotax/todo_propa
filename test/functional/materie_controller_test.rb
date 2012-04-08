require 'test_helper'

class MaterieControllerTest < ActionController::TestCase
  setup do
    @materia = materie(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:materie)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create materia" do
    assert_difference('Materia.count') do
      post :create, materia: @materia.attributes
    end

    assert_redirected_to materia_path(assigns(:materia))
  end

  test "should show materia" do
    get :show, id: @materia
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @materia
    assert_response :success
  end

  test "should update materia" do
    put :update, id: @materia, materia: @materia.attributes
    assert_redirected_to materia_path(assigns(:materia))
  end

  test "should destroy materia" do
    assert_difference('Materia.count', -1) do
      delete :destroy, id: @materia
    end

    assert_redirected_to materie_path
  end
end
