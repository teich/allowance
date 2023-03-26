require "test_helper"

class AllowanceEventsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get allowance_events_create_url
    assert_response :success
  end
end
