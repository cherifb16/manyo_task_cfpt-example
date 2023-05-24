require 'rails_helper'

RSpec.describe 'Task management function', type: :system do
   describe 'Registration function' do
    context 'When registering a task' do
      it 'The registered task is displayed' do
        visit new_task_path
        fill_in "Titre", with: "title"
        fill_in "contenu", with: "content"
        click_button "Creer"
        expect(page).to have_content "J'ai enregistré une tâche"
      end
    end
  end

  describe 'List display function' do
    let!(:first_task) { FactoryBot.create(:task, titre: "first_task", created_at: Time.zone.now.ago(3.days)) }
    let!(:second_task) { FactoryBot.create(:task, titre: "second_task", created_at: Time.zone.now.ago(2.days)) }
    let!(:third_task) { FactoryBot.create(:task, titre: "third_task", created_at: Time.zone.now.ago(1.days)) }
      before do
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
        click_button "Creer"
        expect(page).to have_content "title1"
        end
      end
    end

  describe 'Detailed display function' do
        
     context 'When transitioned to any task details screen' do
        let (:task) {FactoryBot.create(:task, titre: 'Test', content: 'Je suis un contenu')}
        it 'The content of the task is displayed' do
         
          visit task_path(task)
          visit task_path(task)
          expect(page).to have_content 'Je suis un contenu'
        end
     end
  end
end