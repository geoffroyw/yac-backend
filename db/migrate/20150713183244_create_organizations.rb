class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.integer :admin_id, index: true

      t.timestamps null: false
    end
  end
end
