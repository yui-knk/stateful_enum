class CreateBugs < (Rails::VERSION::STRING >= '5' ? ActiveRecord::Migration[5.0] : ActiveRecord::Migration)
  def change
    create_table :bugs do |t|
      t.string :title
      t.string :description
      t.integer :status, default: 0
      t.integer :assigned_to_id
      t.datetime :resolved_at

      t.timestamps null: false
    end
  end
end
