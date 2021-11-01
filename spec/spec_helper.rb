# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require 'vcr'
require 'webmock'
require 'date'
require_relative '../init'

TOPIC = 'apple'
RESULT_NUM = 15
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
GOOGLENEWS_TOKEN = CONFIG['GOOGLENEWS_TOKEN']
CORRECT = YAML.safe_load(File.read('spec/fixtures/apple_results.yml'))
