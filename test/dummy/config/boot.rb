# frozen_string_literal: true

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../../Gemfile', __FILE__)
ENV['BUNDLE_GEMFILE'] = File.expand_path(ENV['BUNDLE_GEMFILE'], Dir.pwd)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
$LOAD_PATH.unshift File.expand_path('../../../../lib', __FILE__)
