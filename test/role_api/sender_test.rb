require 'test_helper'

class RoleApiSenderTest < ActiveSupport::TestCase
  test 'adds to the prison role' do
    sender = RoleApi::Sender.new
    serial = '485A5673'
    result = sender.add_to_role('Ronald McDonald', serial)
    assert_equal(result, serial)
  end
end
