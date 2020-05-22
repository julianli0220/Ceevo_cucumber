require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'rspec'
require "selenium-webdriver"
require 'faker'
require 'cucumber'
require 'google_drive'
require 'ruby-oci8'

# # Set the browser for automation, default as Chrome
$browser = (ENV['BROWSER'] || 'Chrome').to_s

#Set default driver as Selenium
Capybara.run_server = false

# VVVVVVVVVVVVVV BROWSER VVVVVVVVVVVVVV
if $browser == "Firefox"
	#######################################
	# Firefox
	#######################################
	Selenium::WebDriver::Firefox::Binary.path='C:\Program Files\Firefox Nightly\firefox.exe'
	caps = Selenium::WebDriver::Remote::Capabilities.firefox
	caps['acceptInsecureCerts'] = true

	Capybara.default_driver = :selenium

	Capybara.register_driver :selenium do |app|
		Capybara::Selenium::Driver.new(app, browser: :firefox, :desired_capabilities => caps)
	end
elsif $browser == "Edge"
	#######################################
	# Edge
	#######################################
	caps = Selenium::WebDriver::Remote::Capabilities.edge
	caps['javascriptEnabled'] = true
	caps['acceptInsecureCerts'] = true
	#caps['enablePopups'] = true

	Capybara.default_driver = :selenium

	Capybara.register_driver :selenium do |app|
		Capybara::Selenium::Driver.new(app, browser: :edge, :desired_capabilities => caps)
	end
elsif $browser == "Safari"
	#######################################
	# Safari
	#######################################
	caps = Selenium::WebDriver::Remote::Capabilities.safari
	caps['acceptInsecureCerts'] = true

	Capybara.register_driver :selenium do |app|
		Capybara::Selenium::Driver.new(app, browser: :safari, :desired_capabilities => caps)
	end

	Capybara.default_driver = :selenium
else
	#######################################
	# Chrome
	#######################################
	Capybara.default_driver = :selenium_chrome
end
# ^^^^^^^^^^^^^^ BROWSER ^^^^^^^^^^^^^^

#Set default selector as css
Capybara.default_selector = :css

#Syncronization related settings
module Helpers
	def without_resynchronize
	    page.driver.options[:resynchronize] = false
	    yield
	    page.driver.options[:resynchronize] = true
	end
end
World(Capybara::DSL, Helpers)