class User < ApplicationRecord
  has_secure_password
  has_many :comments, dependent: :nullify

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, 
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end