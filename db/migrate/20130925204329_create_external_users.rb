class CreateExternalUsers < ActiveRecord::Migration
  def change
    create_table :external_users do |t|
      t.string :opaque_id
      t.integer :user_id
    end
  end
end
