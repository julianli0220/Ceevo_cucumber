Feature: Display Demo Data

Scenario: Login ceevo dashboard
	Given I go to ceevo dashboard in "EN"
	Then I should arrive the login page
	Given I login with email "julianli19@gmail.com" and password "Aa12345!"
	Then I should be entered the dashboard

Scenario: Go to user settings
	Given I go to user settings via the top right gear icon
	Then I should arrive the user settings page

Scenario: Change Display Demo Data
	Given I change Display Demo Data to "yes" and update

Scenario: Go to Transactions - Payments
	Given I go to "Payments" from "Transactions"
	Then I should arrive the Payments page
	And there should be "5" transactions, in which "3" SUCCEEDED, "1" RISK and "1" FAILED

Scenario: Go to user settings
	Given I go to user settings via the top right gear icon
	Then I should arrive the user settings page

Scenario: Change Display Demo Data
	Given I change Display Demo Data to "no" and update

Scenario: Go to Transactions - Payments
	Given I go to "Payments" from "Transactions"
	Then I should arrive the Payments page
	And there should be "0" transactions, in which "0" SUCCEEDED, "0" RISK and "0" FAILED

Scenario: Logout
	Given I logout from the dashboard
	Then I should arrive the login page

Scenario: Close tab
	And I close the tab