# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require 'date'

# require_relative 'publish'
module PortfolioAdvisor
  module Entity
    # Domain entity for any article
    class Article < Dry::Struct
      include Dry.Types

      attribute :title,             Strict::String
      attribute :url,               Strict::String
      attribute :published_at,      Strict::DateTime # Publish
      # attribute :publish_date, Strict::String
      # attribute :publish_time, Strict::String
    end
  end
end
