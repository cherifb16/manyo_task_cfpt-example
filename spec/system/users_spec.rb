require 'rails_helper'

RSpec.describe 'user management functions', type: :system do
  def log_in
    FactoryBot.create(:user, name: 'test_user', email: 'test1@ex.com', password: 'password', password_confirmation: 'password', admin: false)
    visit new_session_path
    fill_in "session[email]",	with: "test1@ex.com" 
    fill_in "session[password]",	with: "password" 
    click_on 'create-session'
  end

  def admin_log_in
    FactoryBot.create(:user, name: 'admin_user', email: 'admin@ex.com', password: 'password', password_confirmation: 'password', admin: true)
    visit new_session_path
    fill_in "session[email]",	with: "admin@ex.com" 
    fill_in "session[password]",	with: "password" 
    click_on 'create-session'
  end

  describe 'registration function' do
    context 'If a user is registered' do
      before do
        visit new_user_path
        fill_in "user[name]",	with: "aki" 
        fill_in "user[email]",	with: "aki@ex.com" 
        fill_in "user[password]",	with: "password" 
        fill_in "user[password_confirmation]",	with: "password" 
        click_on 'Creer'
      end

      it 'Transition to the task list screen.' do
        expect(current_path).to eq '/tasks'
      end
    end
    context 'If you have moved to the Task List screen without logging in' do
      before { visit tasks_path }

      it 'You are redirected to the login screen and the message \'Please log in\' is displayed.' do
        expect(current_path).to eq '/sessions/new'
        expect(page).to have_content 'Please log in.'
      end
    end
  end

  describe 'Login Function' do
    context 'When logged in as a registered user.' do
      let!(:other_user) { FactoryBot.create(:user) }
      before { log_in }

      it 'You will be redirected to the task list screen and the message \'You are logged in\' will be displayed.' do
        expect(current_path).to eq '/tasks'
        expect(page).to have_content 'Logged in as'
      end

      it 'Access to your own detail screen.' do
        click_on 'Account details.'
        expect(page).to have_content 'Account details page'
      end

      it 'Accessing someone else\'s details screen will take you to the task list screen.' do
        visit user_path(other_user)
        expect(current_path).to eq '/tasks'
      end

      it 'When logging out, the user is taken to the login screen and the message \'You have logged out\' is displayed.' do
        click_on 'logout'
        expect(page).to have_content 'You have logged out.'
      end
    end
  end

  describe 'Administrator Functions' do
    let!(:other_user) { FactoryBot.create(:user, name: 'aki', email: 'test2@ex.com') }

    context 'When the administrator logs in.' do
      before { admin_log_in }

      it 'Access to the user list screen.' do
        click_on 'List of users'
        expect(page).to have_content 'User list page'
      end
  
      it 'Can register administrators.' do
        click_on 'Registering users'
        fill_in "user[name]",	with: "aki" 
        fill_in "user[email]",	with: "aki@ex.com" 
        fill_in "user[password]",	with: "password" 
        fill_in "user[password_confirmation]",	with: "password" 
        click_on 'Creer'

        expect(page).to have_content 'user has been registered' 
        expect(page).to have_content 'aki'
      end

      it 'Access to the user details screen.' do
        click_on 'List of users'
        click_on 'détail', match: :first
        sleep 2
        expect(page).to have_content 'User details page' 
        expect(page).to have_content 'aki' 
      end

      it 'You can edit users other than yourself from the user edit screen.' do
        click_on 'List of users'
        click_on 'Éditer', match: :first
        sleep 2
        expect(page).to have_content 'User edit page' 
        fill_in "user[email]",	with: "testttt@ex.com"
        fill_in "user[password]",	with: "password" 
        fill_in "user[password_confirmation]",	with: "password" 
        click_on 'Mettre à jour'

        expect(page).to have_content 'testttt@ex.com'
      end

      it 'Users can be deleted.' do
        click_on 'List of users'
      
        accept_alert do
          click_on 'suppression', match: :first
        end 
        
        expect(page).to have_content 'User deleted.'
      end
    end
    context 'When a general user accesses the user list screen' do
      before { log_in }

      it 'Transition to the task list screen, with an error message \'Only administrators can access.\'' do
        visit admin_users_path
        expect(page).to have_content 'Only administrators can access this screen'
      end
    end
  end
end