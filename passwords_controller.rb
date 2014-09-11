module Api
  module V1
    module Devise

      class PasswordsController < ::Devise::PasswordsController
        # Respondable has 'resource' method conflict with Devise
        include RocketPants::Respondable
        include RocketPants::ErrorHandling
        include RocketPants::StrongParameters
        include RocketPants::Versioning
        include SerializerScope

        respond_to :json

        version 1

        def create
          user = User.send_reset_password_instructions email_params
          if user.persisted?
            expose user.email
          else
            error! :not_found
          end
        end

        def update
          user = User.reset_password_by_token password_params
          if user.errors.empty?
            sign_in(:user, user)
            expose user
          else
            error!(:invalid_resource, user.errors)
          end
        end

        private

        def password_params
          params.require(:user).permit(:reset_password_token, :password, :password_confirmation)
        end

        def email_params
          params.require(:user).permit(:email)
        end
      end

    end
  end
end
