class ExternalUsersGroupsCascadeDelete < ActiveRecord::Migration
  def up
    execute "alter table external_groups ADD CONSTRAINT external_groups_groups_fk FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE;"
    execute "alter table external_users ADD CONSTRAINT external_users_users_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;"
  end

  def down
    execute "alter table external_groups DROP CONSTRAINT external_groups_groups_fk;"
    execute "alter table external_users DROP CONSTRAINT external_users_users_fk;"
  end
end
