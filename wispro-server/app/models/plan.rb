class Plan < ApplicationRecord
    validates :description, presence: true
end
