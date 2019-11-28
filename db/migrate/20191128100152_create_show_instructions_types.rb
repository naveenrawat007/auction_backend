class CreateShowInstructionsTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :show_instructions_types do |t|

      t.timestamps
    end
  end
end
