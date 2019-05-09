class Room < ApplicationRecord

  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'

  def self.between(user1_id, user2_id)
    where(sender_id: user1_id, recipient_id: user2_id).or(
      where(sender_id: user2_id, recipient_id: user1_id)
    )
  end

  def opposed_user(user)
    user == recipient ? sender : recipient
  end

end
