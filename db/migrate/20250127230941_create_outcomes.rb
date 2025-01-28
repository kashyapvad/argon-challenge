class CreateOutcomes < ActiveRecord::Migration[7.2]
  def change
    create_table :outcomes do |t|
      t.references :clinical_trial, null: false, foreign_key: true
      t.string :measure
      t.text :description
      t.string :time_frame
      t.string :outcome_type

      t.timestamps
    end
  end
end
