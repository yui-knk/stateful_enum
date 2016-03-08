require 'mechanic_machine/active_record_extension'

module MechanicMachine
  class Railtie < ::Rails::Railtie
    ActiveSupport.on_load :active_record do
      ::ActiveRecord::Base.extend MechanicMachine::ActiveRecordEnumExtension
    end
  end
end
