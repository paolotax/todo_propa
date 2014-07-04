class AddNextIdToLibri < ActiveRecord::Migration
  def change

    add_column :libri, :next_id, :integer
  
  end
end
