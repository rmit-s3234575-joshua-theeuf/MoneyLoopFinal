require 'test_helper'

class FailuiresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @failuire = failuires(:one)
  end

  test "should get index" do
    get failuires_url
    assert_response :success
  end

  test "should get new" do
    get new_failuire_url
    assert_response :success
  end

  test "should create failuire" do
    assert_difference('Failuire.count') do
      post failuires_url, params: { failuire: {  } }
    end

    assert_redirected_to failuire_url(Failuire.last)
  end

  test "should show failuire" do
    get failuire_url(@failuire)
    assert_response :success
  end

  test "should get edit" do
    get edit_failuire_url(@failuire)
    assert_response :success
  end

  test "should update failuire" do
    patch failuire_url(@failuire), params: { failuire: {  } }
    assert_redirected_to failuire_url(@failuire)
  end

  test "should destroy failuire" do
    assert_difference('Failuire.count', -1) do
      delete failuire_url(@failuire)
    end

    assert_redirected_to failuires_url
  end
end
