class IndexUsersProperties < ActiveRecord::Migration
  def up
    execute "CREATE INDEX users_properties ON users USING GIN(properties)"
  end

  def down
    execute "DROP INDEX users_properties"
  end
end
