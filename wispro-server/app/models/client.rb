class Client < ApplicationRecord
    has_secure_password

    validates :username, presence: true
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :password, length: {in: 8..20}, if: -> { new_record? || !password.nil? }
end
