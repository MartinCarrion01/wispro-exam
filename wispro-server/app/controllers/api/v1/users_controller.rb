class Api::V1::UsersController < ApplicationController
    skip_before_action :authenticate_user, only: %i[create]
    before_action :set_provider, only: %i[create], if: -> {params[:provider_id].present?}

    def create
        user = User.new(create_user_params)
        user.provider = @provider if @provider.present?
        user.save!
        render(json: {user: user}, status: :created)
    end

    private
    def set_provider
        @provider = Provider.find_by(id: params[:provider_id])
        if @provider.nil?
            raise ActiveRecord::RecordNotFound.new "El proveedor solicitado no existe" 
        end
    end

    def create_user_params
        params.require(:user).permit(:username,
                                    :password,
                                    :password_confirmation,
                                    :first_name,
                                    :last_name,
                                    :email,
                                    :user_type)
    end
end
