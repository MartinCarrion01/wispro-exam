class Api::V1::ClientsController < ApplicationController    
    def create
        client = Client.new(client_params)
        if client.save
            render(json: {client: client}, status: :ok)
        else
            render_errors_response(client)
        end 
    end

    private
    def client_params
        params.require(:client).permit(:username, :password, :password_confirmation, :first_name, :last_name)
    end
end
