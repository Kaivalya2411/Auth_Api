class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  ROLES = %w[super_admin admin manager]

  has_many :companies

  attribute :role, :string, default: 'admin'

  # before_create :set_default_role

  def jwt_payload
    super
  end

  # meta programming snippet
  ROLES.each do |role_name|
    define_method "#{role_name}?" do
      role == role_name
    end
  end

  # def super_admin?
  #   role == "super_admin"
  # end
  #
  # def admin?
  #   role == "admin"
  # end
  #
  # def manager?
  #   role == "manager"
  # end

  # def set_default_role
  #   self.role = 'admin'
  # end
end
