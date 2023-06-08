require 'rails_helper'

RSpec.describe 'user management functions', type: :system do
  describe 'registration function' do
    context 'If a user is registered' do
      it 'Transition to the task list screen.' do
        visit new_user_path
        fill_in "Nom", with: "user"
        fill_in "Adresse email", with: "user@user.com"
        fill_in "Mot de passe", with: "password"
        fill_in "Mot de passe (confirmation)", with: "password"
        click_button "Creer"
        expect(page).to have_content "Account registered."
        expect(page).to have_content "Logged in as Mr. "
      end
    end

    context 'If you have moved to the Task List screen without logging in' do
      it 'You are redirected to the login screen and the message \'Please log in\' is displayed.' do
        visit tasks_path
        expect(page).to have_content "Please log in."
        expect(page).to have_content "Login page"
      end
    end
  end

  describe 'Login Function' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:another_user) { FactoryBot.create(:user) }

    context 'When logged in as a registered user.' do
      before do
        visit new_session_path
        fill_in "email address", with: user.email
        fill_in "(password)", with: "password"
        click_button "login"
      end

      it 'You will be redirected to the task list screen and the message \'You are logged in\' will be displayed.' do
        expect(page).to have_content "Logged in"
        expect(page).to have_content "Page de la liste des tâches"
      end

      it 'Access to your own detail screen.' do
        click_link "Account details."
        expect(page).to have_content "Account details page"
        expect(page).to have_content user.name
      end

      it 'Accessing someone else\'s details screen will take you to the task list screen.' do
        visit user_path(another_user)
        expect(page).to have_content "You have no access rights."
        expect(page).to have_content "Page de la liste des tâches"
      end

      it 'When logging out, the user is taken to the login screen and the message \'You have logged out\' is displayed.' do
        click_link "logout"
        sleep 2
        expect(page).to have_content "You have logged out."
        expect(page).to have_content "Login page"
      end
    end
  end

  describe 'Administrator Functions' do
    let!(:admin_user) { FactoryBot.create(:admin_user) }
    let!(:user) { FactoryBot.create(:user) }

    context 'When the administrator logs in.' do
      before do
        visit new_session_path
        fill_in "email address", with: admin_user.email
        fill_in "(password)", with: "password"
        click_button "login"
      end

      it 'Access to the user list screen.' do
        click_link "List of users"
        expect(page).to have_content "User list page"
      end

      it 'Can register administrators.' do
        visit new_admin_user_path
        fill_in "Nom", with: "user"
        fill_in "Adresse email", with: "user@user.com"
        fill_in "Mot de passe", with: "password"
        fill_in "Mot de passe (confirmation)", with: "password"
        click_button "Creer"
        sleep 2
        expect(page).to have_content "user has been registered"
        expect(page).to have_content "User list page"
      end

      it 'Access to the user details screen.' do
        visit admin_user_path(user)
        sleep 2
        expect(page).to have_content "User details page"
        expect(page).to have_content user.name
      end

      it 'You can edit users other than yourself from the user edit screen.' do
        visit edit_admin_user_path(user)
        sleep 2
        expect(page).to have_content "User edit page"
      end

      it 'Users can be deleted.' do
        visit admin_users_path
        find("a[data-destroy_user='#{user.id}']").click
        sleep 2
        expect(page).to have_content 'User deleted.'
        expect(page).to have_content "User list page"
      end
    end

    context 'When a general user accesses the user list screen' do
      before do
        visit new_session_path
        fill_in "email address", with: user.email
        fill_in "(password)", with: "password"
        click_button "login"
      end

      it 'Transition to the task list screen with error message \'Only administrators have access.\'' do
        visit admin_users_path
        expect(page).to have_content 'Only administrators can access this screen'
        expect(page).to have_content "Page de la liste des tâches"
      end
    end
  end
end