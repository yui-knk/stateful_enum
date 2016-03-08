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

  def test_invalid_transition
    bug = Bug.new
    bug.resolve!
    assert_raises do
      bug.assign!
    end
  end

  def test_can_xxxx?
    bug = Bug.new
    assert bug.can_assign?
    bug.resolve!
    refute bug.can_assign?
  end
end
