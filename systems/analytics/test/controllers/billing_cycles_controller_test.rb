require "test_helper"

class BillingCyclesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @billing_cycle = billing_cycles(:one)
  end

  test "should get index" do
    get billing_cycles_url
    assert_response :success
  end

  test "should get new" do
    get new_billing_cycle_url
    assert_response :success
  end

  test "should create billing_cycle" do
    assert_difference('BillingCycle.count') do
      post billing_cycles_url, params: { billing_cycle: {  } }
    end

    assert_redirected_to billing_cycle_url(BillingCycle.last)
  end

  test "should show billing_cycle" do
    get billing_cycle_url(@billing_cycle)
    assert_response :success
  end

  test "should get edit" do
    get edit_billing_cycle_url(@billing_cycle)
    assert_response :success
  end

  test "should update billing_cycle" do
    patch billing_cycle_url(@billing_cycle), params: { billing_cycle: {  } }
    assert_redirected_to billing_cycle_url(@billing_cycle)
  end

  test "should destroy billing_cycle" do
    assert_difference('BillingCycle.count', -1) do
      delete billing_cycle_url(@billing_cycle)
    end

    assert_redirected_to billing_cycles_url
  end
end
