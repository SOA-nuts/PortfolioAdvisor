# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
module VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  GOOGLENEWS_CASSETTE = 'google_news_api'

  def self.setup_vcr
    VCR.configure do |c|
      c.cassette_library_dir = CASSETTES_FOLDER
      c.hook_into :webmock
      c.filter_sensitive_data('<GOOGLENEWS_TOKEN>') { GOOGLENEWS_TOKEN }
      c.filter_sensitive_data('<GOOGLENEWS_TOKEN_ESC>') { CGI.escape(GOOGLENEWS_TOKEN) }
    end
  end

  def self.configure_vcr_for_google_news
    VCR.insert_cassette(
      GOOGLENEWS_CASSETTE,
      record: :new_episodes,
      match_requests_on: [:method, :headers, VCR.request_matchers.uri_without_param(:from, :to, :pageSize)]
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
