class CreateInterventions < ActiveRecord::Migration[7.2]
  def change
    create_table :interventions do |t|
      t.string :name
      t.text :description
      t.string :intervention_type

      t.timestamps
    end
  end
end
