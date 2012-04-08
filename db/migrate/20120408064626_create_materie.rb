class CreateMaterie < ActiveRecord::Migration
  def change
    create_table :materie do |t|
      t.string :materia
    end
  end
end
