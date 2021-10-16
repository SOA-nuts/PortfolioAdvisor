# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/google_news_api'

TOPIC = 'business'
START_DATE = '2021-10-01'
END_DATE = '2021-10-12'
RESULT_NUM = 15
CONFIG = YAML.safe_load(File.read('../config/secrets.yml'))
GOOGLENEWS_TOKEN = CONFIG['GOOGLENEWS_TOKEN']
CORRECT = YAML.safe_load(File.read('spec/fixtures/business_results.yml'))

describe 'Tests Google News API library' do
  describe 'News title' do
    it 'HAPPY: should provide correct news article attributes' do
      article = NewsArticle::GoogleNewsApi.new(GOOGLENEWS_TOKEN)
                                     .article(TOPIC, START_DATE, END_DATE, RESULT_NUM)
      _(article.url).must_equal CORRECT['url']
      _(article.title).must_equal CORRECT['title']
    end

    it 'SAD: should raise exception on incorrect project' do
      _(proc do
        CodePraise::GithubApi.new(GOOGLENEWS_TOKEN).article('', '2021-10-01', '2021-10-12', 1)
      end).must_raise CodePraise::GithubApi::Errors::NotFound
    end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        CodePraise::GithubApi.new('BAD_TOKEN').article('', '2021-10-12', '2021-10-12', 1)
      end).must_raise CodePraise::GithubApi::Errors::Unauthorized
    end
  end
end