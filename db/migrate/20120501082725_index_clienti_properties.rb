class IndexClientiProperties < ActiveRecord::Migration
  def up
    execute "CREATE INDEX clienti_properties ON clienti USING GIN(properties)"
  end

  def down
    execute "DROP INDEX clienti_properties"
  end
end
