require 'rails_helper'

RSpec.describe 'Task management function', type: :system do
  let!(:user) { FactoryBot.create(:user) }
   describe 'Registration function' do
    before do
      visit new_session_path
      fill_in "email address", with: user.email
      fill_in "(password)", with: "password"
      click_button "login"
    end
    context 'When registering a task' do
      it 'The registered task is displayed' do
        visit new_task_path
        fill_in "Titre", with: "title"
        fill_in "contenu", with: "content"
        fill_in "Date limite", with: Date.today
        
        find("#task_priority").find("option[value='middle']").select_option
        find("#task_status").find("option[value='done']").select_option
        # select "faible", from: "task[priority]"
        # select "未着手", from: "task[status]"
        click_button "Creer"
        expect(page).to have_content "J'ai enregistré une tâche"
      end
    end
  end

  describe 'List display function' do
    let!(:first_task) { FactoryBot.create(:task, titre: "first_task", created_at: Time.zone.now.ago(3.days),priority: :low, status: :todo, user: user) }
    let!(:second_task) { FactoryBot.create(:task, titre: "second_task", created_at: Time.zone.now.ago(2.days),priority: :middle, status: :doing, user: user) }
    let!(:third_task) { FactoryBot.create(:task, titre: "third_task", created_at: Time.zone.now.ago(1.days),priority: :high, status: :done, user: user) }
      before do
        visit new_session_path
        fill_in "email address", with: user.email
        fill_in "(password)", with: "password"
        click_button "login"
        visit tasks_path
      end

      context 'When transitioning to the list screen' do
       it 'The list of created tasks is displayed in descending order of creation date and time.' do
          task_list = all('body tbody tr')
          expect(task_list[0]).to have_content 'third_task'
          expect(task_list[1]).to have_content 'second_task'
          expect(task_list[2]).to have_content 'first_task'
        end
      end
      context 'When creating a new task' do
        it 'New task is displayed at the top' do
          visit new_task_path
          fill_in "Titre", with: "title1"
          fill_in "contenu", with: "content"
          fill_in "Date limite", with: Date.today
          find("#task_priority").find("option[value='middle']").select_option
          find("#task_status").find("option[value='done']").select_option
          # select "high", from: "task[priority]"
          # select "done", from: "task[status]"
          click_button "Creer"
          expect(page).to have_content "title1"
        end
      end
   

      describe 'Detailed display function' do
        context 'When transitioned to any task details screen' do
          let (:task) {FactoryBot.create(:task, titre: 'Test', content: 'Je suis un contenu', user: user)}
          it 'The content of the task is displayed' do
            visit task_path(task)
            expect(page).to have_content 'Je suis un contenu'
          end
        end
     end

      # Omitted
      describe 'sort function' do
        context 'If you click on the link "Exit Deadline.' do
          it "A list of tasks sorted in ascending order of due date is displayed." do
            # Use the all method to check the order of multiple test data
            click_on 'Date limite'
            sleep 2
  
            task_list = all('body tr')
            expect(task_list[1].text).to have_content('third_task')
            expect(task_list[2].text).to have_content('second_task')
            expect(task_list[3].text).to have_content('first_task')
          end
        end
        context '「If you click on the link "Priority"' do
          it "A list of tasks sorted by priority is displayed" do
            # Use the all method to check the order of multiple test data
            click_on 'priorité'
            sleep 2
  
            task_list = all('body tr')
            expect(task_list[1].text).to have_content('High')
            expect(task_list[2].text).to have_content('Middle')
            expect(task_list[3].text).to have_content('Low')
          end
        end
      end
      describe 'search function' do
        context 'If you do a fuzzy search on the title' do
          it "Only tasks that contain the search word will be displayed." do
            # to and not_to matchers to check both what is displayed and what is not
              fill_in 'search[title]',	with: "first_task" 
              click_on 'Search'
    
              expect(page).to have_content('first_task')
              expect(page).not_to have_content('second_task')
              expect(page).not_to have_content('third_task')
            
          end
        end
        context 'Search by status' do
          it "Only tasks matching the searched status will be displayed" do
            # to and not_to matchers to check both what is displayed and what is not
            find("#search_status").find("option[value='todo']").select_option
            click_on 'Search'
  
            expect(page).to have_content('first_task')
            expect(page).not_to have_content('second_task')
            expect(page).not_to have_content('third_task')
          end
        end
        context 'Search by title and status' do
          it "Only tasks that include the search word in the title and match the status will be displayed" do
            # to and not_to matchers to check both what is displayed and what is not
            fill_in 'search[title]',	with: "first_task" 
            find("#search_status").find("option[value='todo']").select_option
            click_on 'Search'
  
            expect(page).to have_content('first_task')
            expect(page).not_to have_content('second_task')
            expect(page).not_to have_content('third_task')
          end
        end
      end
  end  
end