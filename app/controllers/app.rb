# frozen_string_literal: true

require 'roda'
require 'slim'
require 'yaml'

COMPANY_YAML = 'spec/fixtures/company.yml'
COMPANY_LIST = YAML.safe_load(File.read(COMPANY_YAML))

module PortfolioAdvisor
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing|
      routing.assets # load CSS

      # GET /
      routing.root do
        view 'home'
      end

      routing.on 'target' do
        routing.is do
          # POST /target/
          routing.post do
            company = routing.params['company_name'].downcase
            routing.halt 400 if COMPANY_LIST[0][company].nil?
            routing.redirect "target/#{company}"
          end
        end

        routing.on String do |company|
          # GET /target/company
          routing.get do
            target = GoogleNews::TargetMapper
                     .new(GOOGLENEWS_TOKEN)
                     .find(company)

            view 'target', locals: { target: target }
          end
        end
      end
    end
  end
end
