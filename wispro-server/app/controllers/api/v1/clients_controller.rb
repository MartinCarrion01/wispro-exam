class Api::V1::ClientsController < ApplicationController    
    before_action :authenticate_client, only: %i[current]

    def create
        client = Client.create!(client_params)
        
        render(json: {client: client}, status: :ok)
    end

    def current
        render(json: {client: @current_client}, status: :ok)
    end

    private
    def client_params
        params.require(:client).permit(:username, :password, :password_confirmation, :first_name, :last_name)
    end
end
