require 'test_helper'

class MechanicMachineTest < Minitest::Test
  def test_transition
    bug = Bug.new
    assert_equal 'unassigned', bug.status
    bug.assign
    assert_equal 'assigned', bug.status
  end

  def test_transition!
    bug = Bug.new
    bug.assign!
    assert_equal 'assigned', bug.status
    bug.resolve!
    assert_equal 'resolved', bug.status
  end
end
