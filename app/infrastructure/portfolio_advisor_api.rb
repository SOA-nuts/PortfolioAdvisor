# frozen_string_literal: true

require_relative 'list_request'
require 'http'

module PortfolioAdvisor
  module Gateway
    # Infrastructure to call PortfolioAdvisor API
    class Api
      def initialize(config)
        @config = config
        @request = Request.new(@config)
      end

      def alive?
        @request.get_root.success?
      end

      def target_list(list)
        @request.target_list(list)
      end

      def add_target(company_name)
        @request.add_target(company_name)
      end

      # Gets company's history and results

      def result_history(req)
        @request.result_history(req)
      end

      def result_rank
        @request.result_rank
      end

      def result_target(req)
        @request.result_target(req)
      end

      # HTTP request transmitter
      class Request
        def initialize(config)
          @api_host = config.API_HOST
          @api_root = "#{config.API_HOST}/api/v1"
        end

        def get_root # rubocop:disable Naming/AccessorMethodName
          call_api('get')
        end

        def target_list(list)
          call_api('get', ['target'],
                   'list' => Value::WatchedList.to_encoded(list))
        end

        def add_target(company_name)
          call_api('post', ['target', company_name])
        end

        def result_history(company_name)
          call_api('get', ['history', company_name])
        end

        def result_rank
          call_api('get', ['rank'])
        end

        def result_target(company_name)
          call_api('get', ['target', company_name])
        end

        private

        def params_str(params)
          params.map { |key, value| "#{key}=#{value}" }.join('&')
            .then { |str| str ? "?#{str}" : '' }
        end

        def call_api(method, resources = [], params = {})
          api_path = resources.empty? ? @api_host : @api_root
          url = [api_path, resources].flatten.join('/') + params_str(params)
          HTTP.headers('Accept' => 'application/json').send(method, url)
            .then { |http_response| Response.new(http_response) }
        rescue StandardError
          raise "Invalid URL request: #{url}"
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        SUCCESS_CODES = (200..299)

        def success?
          code.between?(SUCCESS_CODES.first, SUCCESS_CODES.last)
        end

        def failure?
          !success?
        end

        def ok?
          code == 200
        end

        def added?
          code == 201
        end

        def processing?
          code == 202
        end

        def message
          JSON.parse(payload)['message']
        end

        def payload
          body.to_s
        end
      end
    end
  end
end
