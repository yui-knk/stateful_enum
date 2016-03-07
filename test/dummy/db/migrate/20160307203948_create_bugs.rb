class CreateBugs < ActiveRecord::Migration
  def change
    create_table :bugs do |t|
      t.string :title
      t.string :dscription
      t.integer :status, default: 0
      t.integer :assigned_to
      t.datetime :resolved_at

      t.timestamps null: false
    end
  end
end
