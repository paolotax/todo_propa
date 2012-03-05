class AddSlugToFatture < ActiveRecord::Migration

  def up
    add_column :fatture, :slug, :string
    remove_column :fatture, :integer
    remove_index :fatture, :name => 'index_fatture_per_utente_and_causale'
  end

  def down
    remove_column :fatture, :slug
    add_column  :fatture, :integer, :integer
    add_index   :fatture, [:user_id, :causale_id, :numero, :data], {:name => 'index_fatture_per_utente_and_causale',  :unique => true }
  end

end
