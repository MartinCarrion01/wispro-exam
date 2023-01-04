class Provider < ApplicationRecord
    validates :name, presence: true

    has_many :plans, dependent: :delete_all
end
