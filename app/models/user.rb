class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  serialize :type_attributes, JSON
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
