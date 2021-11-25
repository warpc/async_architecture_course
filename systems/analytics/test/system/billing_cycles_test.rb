require "application_system_test_case"

class BillingCyclesTest < ApplicationSystemTestCase
  setup do
    @billing_cycle = billing_cycles(:one)
  end

  test "visiting the index" do
    visit billing_cycles_url
    assert_selector "h1", text: "Billing Cycles"
  end

  test "creating a Billing cycle" do
    visit billing_cycles_url
    click_on "New Billing Cycle"

    click_on "Create Billing cycle"

    assert_text "Billing cycle was successfully created"
    click_on "Back"
  end

  test "updating a Billing cycle" do
    visit billing_cycles_url
    click_on "Edit", match: :first

    click_on "Update Billing cycle"

    assert_text "Billing cycle was successfully updated"
    click_on "Back"
  end

  test "destroying a Billing cycle" do
    visit billing_cycles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Billing cycle was successfully destroyed"
  end
end
