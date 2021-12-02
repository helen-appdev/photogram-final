class AddImage2ToPhoto < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :image2, :string
  end
end
