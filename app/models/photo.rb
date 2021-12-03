# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  caption        :text
#  comments_count :integer
#  image          :string
#  image2         :string
#  likes_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
class Photo < ApplicationRecord
  belongs_to(:user, {
      :class_name => "User", 
      :foreign_key => "owner_id"})

      # to fix the robohashes not loading, change :image back to :image2
      mount_uploader :image, ImageUploader
end
