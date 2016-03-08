class Bug < ActiveRecord::Base
  enum status: {unassigned: 0, assigned: 1, resolved: 2, closed: 3} do
    event :assign do
      transition :unassigned => :assigned
    end
  end
end
