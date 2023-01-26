class User < ApplicationRecord
    has_secure_password

    enum :user_type, %i[client provider_admin], default: :client

    belongs_to :provider, autosave: true, optional: true

    has_one :client

    validates :username, presence: true, uniqueness: true
    validates :password, length: {in: 8..20}, if: -> { new_record? || password.present? }
    validates :email, presence: true, uniqueness: true
    validates :first_name, presence: true
    validates :last_name, presence: true

    before_create -> { user_type = provider_admin }, if: -> { provider.present? }

    after_create -> { create_client! }, if: :client?
end
