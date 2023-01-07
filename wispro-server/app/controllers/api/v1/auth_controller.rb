class Api::V1::AuthController < ApplicationController
    def login
        client = Client.find_by(username: params[:username])
        if client && client.authenticate(params[:password])
            token = jwt_encode(client_id: client.id)
            render(json: {token: token}, status: :ok)
        else
            error = client ? "Contraseña incorrecta" : "El cliente ingresado no existe"
            render(json: {message: error}, status: :unauthorized)
        end
    end
end