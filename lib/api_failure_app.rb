class ApiFailureApp < Devise::FailureApp
  include ActiveSupport::Rescuable
  include RocketPants::Respondable

  def respond
    # If JSON request will use RocketPants return :unauthenticated
    if request.format == :json or request.content_type == 'application/json'
      warden_options[:recall] = :unauthorized
      super
    else
      # if html request will redirect to signin path.
      # if pure API version you don't neet this section.
      redirect_to "/users/signin"
    end
  end

  def unauthorized
    error! :unauthenticated
  end
end
