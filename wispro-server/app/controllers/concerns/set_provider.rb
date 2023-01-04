module SetProvider
    extend ActiveSupport::Concern

    included do
        def set_provider
            @provider = Provider.find_by(id: params[:id])
            if @provider.nil?
                render(json: {message: "El proveedor solicitado no existe"}, status: :not_found)
            end
        end
    end
end