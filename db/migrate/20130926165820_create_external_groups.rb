class CreateExternalGroups < ActiveRecord::Migration
  def change
    create_table :external_groups do |t|
      t.string :opaque_id
      t.integer :group_id
    end
  end
end
