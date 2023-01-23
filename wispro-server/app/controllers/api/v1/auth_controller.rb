class Api::V1::AuthController < ApplicationController
    skip_before_action :authenticate_user, only: %i[login]
    
    def login
        if user.authenticate(params[:password])
            token = jwt_encode(user_id: user.id)
            render(json: {token: token}, status: :ok)
        else
            render(json: {message: "El nombre de usuario o contraseña ingresados son incorrectos"},
                 status: :unauthorized)
        end
    end

    private
    def user
        @user ||= User.find_by(username: params[:username])
    end
end