class CreateArmGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :arm_groups do |t|
      t.references :clinical_trial, null: false, foreign_key: true
      t.string :label
      t.string :arm_type
      t.text :description

      t.timestamps
    end
  end
end
