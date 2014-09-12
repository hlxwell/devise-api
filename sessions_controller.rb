# encoding: utf-8

module Api
  module V1
    module Devise

      class SessionsController < ::Devise::SessionsController
        include RocketPants::Respondable
        include RocketPants::ErrorHandling
        include RocketPants::StrongParameters
        include RocketPants::Versioning

        respond_to :json

        version 1

        def show
          if signed_in?
            expose current_user
          else
            error! :unauthenticated
          end
        end

        def create
          user = warden.authenticate!({ scope: :user, recall: "#{controller_path}#failure" })
          sign_in :user, user
          expose current_user, status: :created
        end

        def destroy
          sign_out
          expose status: :ok
        end

        def failure
          error! :unauthenticated
        end
      end

    end
  end
end
