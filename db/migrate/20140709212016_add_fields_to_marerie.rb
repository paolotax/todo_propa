class AddFieldsToMarerie < ActiveRecord::Migration
  def change

    add_column :materie, :gruppo, :string
    add_column :materie, :ordine, :integer
    add_column :materie, :prezzo_copertina,   :decimal, :precision => 8, :scale => 2
    add_column :materie, :prezzo_consigliato, :decimal, :precision => 8, :scale => 2

  end
end
