class CreatePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.string :image
      t.text :caption
      t.integer :owner_id
      t.integer :likes_count
      t.integer :comments_count

      t.timestamps
    end
  end
end

rails g draft:resource Like fan_id:integer photo_id:integer
rails g draft:resource Comment author_id:integer body:text photo_id:integer
rails g draft:resource User comments_count:integer email:string likes_count:integer password_digest:string private:boolean username:string
rails g draft:resource FollowRequest recipient_id:integer sender_id:integer status:string
rails generate draft:resource photo image:string caption:text owner_id:integer likes_count:integer comments_count:integer