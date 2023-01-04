class ServiceRequest < ApplicationRecord
    enum :status, %i[pending approved rejected]

    belongs_to :client
    belongs_to :plan
end
