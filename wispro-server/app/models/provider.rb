class Provider < ApplicationRecord
    has_many :plans, dependent: :delete_all
end
