require 'test_helper'

class AdozioniControllerTest < ActionController::TestCase
  setup do
    @adozione = adozioni(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:adozioni)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create adozione" do
    assert_difference('Adozione.count') do
      post :create, adozione: @adozione.attributes
    end

    assert_redirected_to adozione_path(assigns(:adozione))
  end

  test "should show adozione" do
    get :show, id: @adozione
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @adozione
    assert_response :success
  end

  test "should update adozione" do
    put :update, id: @adozione, adozione: @adozione.attributes
    assert_redirected_to adozione_path(assigns(:adozione))
  end

  test "should destroy adozione" do
    assert_difference('Adozione.count', -1) do
      delete :destroy, id: @adozione
    end

    assert_redirected_to adozioni_path
  end
end
