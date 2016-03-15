require 'test_helper'

class StatefulEnumTest < ActiveSupport::TestCase
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
  end

  def test_transition_from_all
    bug = Bug.new
    bug.close
    assert_equal 'closed', bug.status

    bug = Bug.new
    bug.assign!
    bug.close
    assert_equal 'closed', bug.status

    bug = Bug.new
    bug.resolve!
    bug.close
    assert_equal 'closed', bug.status
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

  def test_xxxx_transition
    bug = Bug.new
    assert({unassigned: :assigned}, bug.assign_transition)
  end

  def test_non_verb_methods_are_undefined
    bug = Bug.new
    refute bug.respond_to? :assigned!
  end

  def test_before_transition_hook
    bug = Bug.new
    assert_nil bug.resolved_at
    bug.resolve
    refute_nil bug.resolved_at
  end

  def test_after_transition_hook
    bug = Bug.new
    assert_difference 'Bug::Notifier.messages.count' do
      bug.close
    end
  end
end
