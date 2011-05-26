class ApplicationController < ActionController::Base
    protect_from_forgery
    helper_method :application_name

    private

    def application_name()
        'Tunerie'
    end
end
