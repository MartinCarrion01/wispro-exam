module SetPlan
    extend ActiveSupport::Concern

    included do
        def set_plan
            @plan = Plan.find_by(id: params[:plan_id])
            if @plan.nil?
                render(json: {message: "El proveedor solicitado no existe"}, status: :not_found)
            end
        end
    end
end