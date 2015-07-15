#!/nas/oemd/mra/apps/bin/ruby

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('./Gemfile')

require 'bundler/setup'
require 'active_record'
require 'mechanize'
require 'safe_attributes'

#Set up DB connection
require File.join('.', 'connection.rb')
require File.join('./lib', 'occurrence.rb')

require File.join('.', 'minloc_scraper.rb')
require File.join('.', 'service.rb')

ms = MinlocScraper.new
ms.proxy = YAML::load(File.open('proxy.yml'))
services = YAML::load(File.open('services.yml'))
ms.create_services(services)