require 'test_helper'

class PrisonerTest < ActiveSupport::TestCase
  test 'Fixture load' do
    assert(Prisoner.all.count == 2)
  end

  test 'Capture a prisoner' do
    serial_number = '717D2124'
    p = Prisoner.create(
      name: 'Bob Knievel',
      rank: 'Stunt Man',
      serial_number: serial_number)
    assert(p != nil)
    assert(Prisoner.all.count == 3)
    assert(Prisoner.where(serial_number: serial_number).first != nil)
  end
end
