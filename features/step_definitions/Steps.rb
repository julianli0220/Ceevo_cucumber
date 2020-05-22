Given(/^I go to ceevo dashboard in "([^"]*)"$/) do |lang|
	page.driver.browser.manage.window.maximize
	# # 
	# $ceevopage = windows.last

	visit 'http://dashboard.ceevo.com/'

	# simple verification: Welcome
	expect(page).to have_xpath("//h3[text()='Welcome!']", wait: 60)

	# make lang global
	$lang = lang
	if lang == "DE"
		page.find(:xpath, "//div[@class='el-input el-input--suffix']", wait: 60).click
		page.find(:xpath, "//span[text()='DE']", wait: 60).click

		# simple verification: Willkommen Sie
		expect(page).to have_xpath("//h3[text()='Willkommen!']", wait: 60)
	end
end

Then(/^I should arrive the login page$/) do
	if $lang == "EN"
		expect(page).to have_xpath("//input[@placeholder='Email']", wait: 60)
		expect(page).to have_xpath("//input[@placeholder='Password']", wait: 60)
	elsif $lang == "DE"
		expect(page).to have_xpath("//input[@placeholder='E-Mail']", wait: 60)
		expect(page).to have_xpath("//input[@placeholder='Passwort']", wait: 60)
	end
end

Given(/^I login with email "([^"]*)" and password "([^"]*)"$/) do |email, pw|
	if $lang == "EN"
		page.find(:xpath, "//input[@placeholder='Email']", wait: 60).send_keys(email)
		page.find(:xpath, "//input[@placeholder='Password']", wait: 60).send_keys(pw)
	elsif $lang == "DE"
		page.find(:xpath, "//input[@placeholder='E-Mail']", wait: 60).send_keys(email)
		page.find(:xpath, "//input[@placeholder='Passwort']", wait: 60).send_keys(pw)
	end

	page.find(:xpath, "//button[@type='submit']", wait: 60).click
end

Then(/^I should be entered the dashboard$/) do
	# default language: EN
	expect(page).to have_xpath("//p[text()='PLEASE NOTE: Your account is in test mode. To put your account live, please complete account activation.']", wait: 60)

	# make sure the loading spin go away
	expect(page.has_no_xpath?("//div[@class='el-loading-mask is-fullscreen']")).to eq(true)

	if $lang == "DE"
		page.find(:xpath, "//div[@class='nav-item ceevo__nav-language-dropdown el-dropdown']/..", wait: 60).click
		page.find(:xpath, "//li[text()='DE']", wait: 60).click

		expect(page).to have_xpath("//p[text()='BITTE BEACHTEN: Sie müssen ihr Konto aktivieren, um ihre Einstellungen zu ändern']", wait: 60)
	end
end

Given(/^I go to user settings via the top right gear icon$/) do
	page.find(:xpath, "//a[@class='dropdown-toggle nav-link']/i[@class='nc-icon nc-settings-gear-65']", wait: 60).click

	# ensure there is enough delay
	sleep(1)

	# User settings / Benutzereinstellungen
	page.find(:xpath, "//span[@class='py-2 d-block']", wait: 60).click
end

Then(/^I should arrive the user settings page$/) do
	# make sure the loading spin go away
	expect(page.has_no_xpath?("//div[@class='el-loading-mask is-fullscreen']")).to eq(true)

	# simple verification: Settings / Einstellungen
	if $lang == "EN"
		expect(page).to have_xpath("//h4[text()='Settings']", wait: 60)
	elsif $lang == "DE"
		expect(page).to have_xpath("//h4[text()='Einstellungen']", wait: 60)
	end
end

Given(/^I change Display Demo Data to "([^"]*)" and update$/) do |target_option|
	# make sure there is enough time for the animation going away
	sleep(2)

	# Get current option
	if $lang == "EN"
		if page.has_xpath?("//label[text()='Display Demo Data']/../div/div/div/span[@class='el-switch__label el-switch__label--right is-active']")
			current_option = "yes"
		elsif page.has_xpath?("//label[text()='Display Demo Data']/../div/div/div/span[@class='el-switch__label el-switch__label--left is-active']")
			current_option = "no"
		end
	elsif $lang == "DE"
		if page.has_xpath?("//label[text()='Demo-Daten anzeigen']/../div/div/div/span[@class='el-switch__label el-switch__label--right is-active']")
			current_option = "yes"
		elsif page.has_xpath?("//label[text()='Demo-Daten anzeigen']/../div/div/div/span[@class='el-switch__label el-switch__label--left is-active']")
			current_option = "no"
		end
	end

	puts "current option is: #{current_option}"
	puts "target option is: #{target_option}"
	# switch if current_option isn't the target option
	if target_option != current_option
		if $lang == "EN"
			page.find(:xpath, "//label[text()='Display Demo Data']/../div/div/div/span[@class='el-switch__core']", wait: 60).click
		elsif $lang == "DE"
			page.find(:xpath, "//label[text()='Demo-Daten anzeigen']/../div/div/div/span[@class='el-switch__core']", wait: 60).click
		end
	end

	# verify the latest status
	if target_option == "yes"
		if $lang == "EN"
			expect(page).to have_xpath("//label[text()='Display Demo Data']/../div/div/div/span[@class='el-switch__label el-switch__label--left']", wait: 60)
			expect(page).to have_xpath("//label[text()='Display Demo Data']/../div/div/div/span[@class='el-switch__label el-switch__label--right is-active']", wait: 60)
		elsif $lang == "DE"
			expect(page).to have_xpath("//label[text()='Demo-Daten anzeigen']/../div/div/div/span[@class='el-switch__label el-switch__label--left']", wait: 60)
			expect(page).to have_xpath("//label[text()='Demo-Daten anzeigen']/../div/div/div/span[@class='el-switch__label el-switch__label--right is-active']", wait: 60)
		end
	elsif target_option == "no"
		if $lang == "EN"
			expect(page).to have_xpath("//label[text()='Display Demo Data']/../div/div/div/span[@class='el-switch__label el-switch__label--left is-active']", wait: 60)
			expect(page).to have_xpath("//label[text()='Display Demo Data']/../div/div/div/span[@class='el-switch__label el-switch__label--right']", wait: 60)
		elsif $lang == "DE"
			expect(page).to have_xpath("//label[text()='Demo-Daten anzeigen']/../div/div/div/span[@class='el-switch__label el-switch__label--left is-active']", wait: 60)
			expect(page).to have_xpath("//label[text()='Demo-Daten anzeigen']/../div/div/div/span[@class='el-switch__label el-switch__label--right']", wait: 60)
		end
	end
	
	# update
	if target_option != current_option
		if $lang == "EN"
			page.find(:xpath, "//h4[text()='Settings']/../div/form/div[@class='py-2 px-4 d-flex justify-content-end']/button", wait: 60).click
		elsif $lang == "DE"
			page.find(:xpath, "//h4[text()='Einstellungen']/../div/form/div[@class='py-2 px-4 d-flex justify-content-end']/button", wait: 60).click
		end

		# simple verification: update successful message
		expect(page).to have_xpath("//p[text()='update successful.']", wait: 60)

		# make sure the loading spin go away
		expect(page.has_no_xpath?("//div[@class='el-loading-mask is-fullscreen']")).to eq(true)
	end
end

Given(/^I go to "([^"]*)" from "([^"]*)"$/) do |subitem, item|
	if $lang == "DE"
		case subitem
		when "Payments"
			subitem = "Zahlungen"
		when "Disputes"
			subitem = "Dispute"
		when "Balance"
			subitem = "Kontostand"
		when "Business settings"
			subitem = "Geschäftseinstellungen"
		when "Payout settings"
			subitem = "Auszahlungseinstellungen"
		when "Payments settings"
			subitem = "Zahlungseinstellungen"
		when "User management"
			subitem = "Team"
		end

		case item
		when "Transactions"
			item = "Transaktionen"
		when "Balance"
			item = "Kontostand"
		when "Settings"
			item = "Einstellungen"
		end
	end

	# click item if the menu is not opened
	if page.has_xpath?("//p[text()='\n      #{item}\n      ']/b[@class='caret']")
		page.find(:xpath, "//p[text()='\n      #{item}\n      ']", wait: 60).click
	end
	
	page.find(:xpath, "//span[@class='sidebar-normal none-text-transform'][text()='#{subitem}']", wait: 60).click
end

Then(/^I should arrive the Payments page$/) do
	# make sure the loading spin go away
	expect(page.has_no_xpath?("//div[@class='el-loading-mask is-fullscreen']")).to eq(true)

	# simple verification: Transactions / Transaktionen
	if $lang == "EN"
		expect(page).to have_xpath("//h4[text()='Transactions']", wait: 60)
	elsif $lang == "DE"
		expect(page).to have_xpath("//h4[text()='Transaktionen']", wait: 60)
	end

	# verify the transaction table
	expect(page).to have_xpath("//div[@class='card-body table-full-width table-nowrap transaction-table ceevo__table-thead-warp']", wait: 60)
end

Given(/^there should be "([^"]*)" transactions, in which "([^"]*)" SUCCEEDED, "([^"]*)" RISK and "([^"]*)" FAILED$/) do |num_trans, num_succeeded, num_risk, num_failed|
	# string to integer
	num_trans = num_trans.to_i
	num_succeeded = num_succeeded.to_i
	num_risk = num_risk.to_i
	num_failed = num_failed.to_i

	# create array of transactions
	transactions = page.all(:xpath, "//div[@class='card-body table-full-width table-nowrap transaction-table ceevo__table-thead-warp']/div/div[1]/div/div[3]/table/tbody/tr")
	expect(transactions.length).to eq(num_trans)
	if transactions.length == num_trans
		puts "expected number of transactions: #{transactions.length}"
	else
		puts "please confirm the number of transactions"
	end

	# create arrays of succeeded, risk, failed transactions, respectively
	succeeded_trans = []
	risk_trans = []
	failed_trans = []
	
	transactions[0..(transactions.length-1)].each do |a|
		if a.find(:xpath, "td[9]").text == "SUCCEEDED"
			succeeded_trans.append(a)
		elsif a.find(:xpath, "td[9]").text == "RISK"
			risk_trans.append(a)
		elsif a.find(:xpath, "td[9]").text == "FAILED"
			failed_trans.append(a)
		end
	end
	
	# verification messages
	if succeeded_trans.length == num_succeeded
		puts "expected number of succeeded transactions: #{succeeded_trans.length}"
	else
		puts "please confirm the number of succeeded transactions"
	end

	if risk_trans.length == num_risk
		puts "expected number of risk transactions: #{risk_trans.length}"
	else
		puts "please confirm the number of risk transactions"
	end

	if failed_trans.length == num_failed
		puts "expected number of failed transactions: #{failed_trans.length}"
	else
		puts "please confirm the number of failed transactions"
	end
end

Given(/^I logout from the dashboard$/) do
	page.find(:xpath, "//a[@class='nav-link btn-rotate none-text-transform']", wait: 60).click
end

Given(/^I close the tab$/) do
	Capybara.current_session.driver.quit
end