require 'test_helper'

class StatefulEnumTest < ActiveSupport::TestCase
  def test_transition
    bug = Bug.new
    assert_equal 'unassigned', bug.status
    bug.assigned_to = User.create!(name: 'user 1')
    bug.assign
    assert_equal 'assigned', bug.status
  end

  def test_transition!
    bug = Bug.new
    bug.assigned_to = User.create!(name: 'user 1')
    bug.assign!
    assert_equal 'assigned', bug.status
  end

  def test_transition_from_all
    bug = Bug.new
    bug.close
    assert_equal 'closed', bug.status

    bug = Bug.new
    bug.assigned_to = User.create!(name: 'user 1')
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
    assert_equal false, bug.assign
    assert_equal 'resolved', bug.status
  end

  def test_invalid_transition!
    bug = Bug.new
    bug.resolve!
    assert_raises do
      bug.assign!
    end
    assert_equal 'resolved', bug.status
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

  def test_if_condition
    bug = Bug.new
    assert_raises do
      bug.assign!
    end
    bug.assigned_to = User.create!(name: 'user 1')
    assert_nothing_raised do
      bug.assign!
    end
  end

  def test_unless_condition
    bug = Bug.new
    assert_raises do
      bug.assign_with_unless!
    end
    bug.assigned_to = User.create!(name: 'user 1')
    assert_nothing_raised do
      bug.assign_with_unless!
    end
  end

  def test_enum_definition_with_array
    ActiveRecord::Migration.create_table(:array_enum_test) {|t| t.integer :col }
    tes = Class.new(ActiveRecord::Base) do
      self.table_name = 'array_enum_test'
      enum(col: [:foo, :bar]) { event(:e) { transition(foo: :bar) } }
    end.new col: 'foo'
    tes.e
    assert 'bar', tes.col
  end

  def test_duplicate_from_in_one_event
    assert_raises do
      Class.new(ActiveRecord::Base) do
        enum status: {unassigned: 0, assigned: 1, resolved: 2, closed: 3} do
          event :assign do
            transition :unassigned => :assigned
            transition :unassigned => :resolved
          end
        end
      end
    end
  end

  def test_not_duplicate_from_in_one_event
    assert_nothing_raised do
      Class.new(ActiveRecord::Base) do
        enum status: {unassigned: 0, assigned: 1, resolved: 2, closed: 3} do
          event :toggle do
            transition :unassigned => :assigned
            transition :assigned => :unassigned
          end
        end
      end
    end
  end
end
