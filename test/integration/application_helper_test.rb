require 'test_helper'

class ApplicationHelperTest < ActionDispatch::IntegrationTest
  test "full title helper" do
    assert_equal full_title,         'Typo on Rails Tutorial Sample App'
    assert_equal full_title("Help"), 'Typo | Ruby on Rails Tutorial Sample App'
  end
end
