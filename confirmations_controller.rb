module Api
  module V1
    module Devise

      class ConfirmationsController < ::Devise::ConfirmationsController
        include RocketPants::Respondable
        include RocketPants::ErrorHandling
        include RocketPants::StrongParameters
        include RocketPants::Versioning
        include SerializerScope

        respond_to :json

        version 1

        def show
          user = User.confirm_by_token(params[:confirmation_token])
          if user.errors.empty?
            sign_in user
            expose user
          else
            error! :invalid_resource, user.errors
          end
        end

        def create
          user = User.send_confirmation_instructions email_params
          if successfully_sent? user
            expose :ok
          else
            error! :not_found
          end
        end

        private

        def email_params
          params.require(:user).permit(:email)
        end
      end

    end
  end
end
