# == Schema Information
#
# Table name: tweets
#
#  id         :bigint(8)        not null, primary key
#  body       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint(8)        not null
#

class Tweet < ApplicationRecord
  belongs_to :user, inverse_of: :tweets

  validates :body, presence: true
  validates :user_id, presence: true
  validates :body, length: { maximum: 120 }
end

