class ServiceChangeRequest < ApplicationRecord
    enum :status, %i[pending approved rejected]

    belongs_to :service_request
    belongs_to :plan
end
