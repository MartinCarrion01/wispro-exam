class Api::V1::ClientsController < ApplicationController    
    def create
        client = Client.new(client_params)
        if client.save
            render(json: {client: client}, status: :ok)
        else
            render(json: {client: client.errors}, status: :bad_request)
        end 
    end

    private
    def client_params
        params.require(:client).permit(:username, :password, :password_confirmation, :first_name, :last_name)
    end
end
