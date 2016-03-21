class CreateUsers < (Rails::VERSION::STRING >= '5' ? ActiveRecord::Migration[5.0] : ActiveRecord::Migration)
  def change
    create_table :users do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
