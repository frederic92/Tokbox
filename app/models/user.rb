class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum state: { online: 0, offline: 1 } 
  has_one_attached :avatar

  def full_name
    "#{first_name} #{ last_name}"
  end
end
