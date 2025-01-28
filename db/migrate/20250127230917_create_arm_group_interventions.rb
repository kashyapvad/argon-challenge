class CreateArmGroupInterventions < ActiveRecord::Migration[7.2]
  def change
    create_table :arm_group_interventions do |t|
      t.references :arm_group, null: false, foreign_key: true
      t.references :intervention, null: false, foreign_key: true

      t.timestamps
    end
  end
end
