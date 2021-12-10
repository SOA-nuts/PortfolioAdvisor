# frozen_string_literal: true

require 'dry/transaction'

module PortfolioAdvisor
  module Service
    # Transaction to store target from GoogleNews API to database
    class AddTarget
      include Dry::Transaction

      step :validate_input
      step :request_target
      step :reify_target

      private

      def validate_input(input)
        if input.success?
          company_name = input[:company_name]
          Success(company_name: company_name)
        else
          Failure(input.errors.messages.first)
        end
      end

      def request_target(input)
        result = Gateway::Api.new(PortfolioAdvisor::App.config)
          .add_target(input[:company_name])

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError
        Failure('Cannot add target right now; please try again later')
      end

      def reify_target(target_json)
        puts Representer::Target.new(target_json)
        Representer::Target.new(OpenStruct.new)
          .from_json(target_json)
          .then { |target| 
            Success(target) }
      rescue StandardError
        Failure('Error in add target -- please try again')
      end
    end
  end
end