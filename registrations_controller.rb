# encoding: utf-8

module Api
  module V1
    module Devise

      class RegistrationsController < ::Devise::RegistrationsController
        include RocketPants::Respondable
        include RocketPants::ErrorHandling
        include RocketPants::StrongParameters
        include RocketPants::Versioning

        respond_to :json

        version 1

        def create
          user = User.new user_params
          if user.save
            expose user, status: :created
          else
            warden.custom_failure!
            error! :invalid_resource, user.errors
          end
        end

        def update
          if current_user.update_attributes user_params
            expose current_user, status: :ok
          else
            warden.custom_failure!
            error! :invalid_resource, current_user.errors
          end
        end

        protected

        def authenticate_user! options = {}
          if request.env['warden'].authenticate(scope: :user).blank?
            error!(:unauthenticated)
          end
        end

        def user_params
          params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :username)
        end

        def default_serializer_options
          super.merge scope: current_user
        end
      end

    end
  end
end