require 'test_helper'

class PrisonersControllerTest < ActionDispatch::IntegrationTest
  test 'retrieve a prisoner' do
    @prisoner = Prisoner.first
    assert(@prisoner != nil)
    get prisoner_url(@prisoner)
    assert_response :success
  end

  test 'take a prisoner' do
    serial_number = '354Q9846'
    post prisoners_url params: {
      prisoner: {
        name: 'Jerry Lewis',
        rank: 'Comedian',
        serial_number: serial_number
      }
    }
    assert_response :success
    assert(Prisoner.where(serial_number: serial_number).first != nil)
  end
end
