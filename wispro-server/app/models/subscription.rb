class Subscription < ApplicationRecord
    belongs_to :client
    belongs_to :plan
end
