require 'rails_helper'

RSpec.describe Task, type: :model do

  let!(:user) { FactoryBot.create(:user) }

  describe 'Validation test' do
    context 'If the task Title is an empty string' do
      it 'Validation fails' do
        task = Task.create(
          titre: '', 
          content: 'Create a proposal.',
          deadline_on: Date.today,
          priority: 'low',
          status: 'done',
          user_id: user.id
          )
        expect(task).not_to be_valid
      end
    end

    context 'If the task description is empty' do
      it 'Validation fails' do
        task = Task.create(
          titre: 'Test1', 
          content: '',
          deadline_on: 'Date.today',
          priority: 'low',
          status: 'done',
          user_id: user.id
        )
          
        expect(task).not_to be_valid
      end
    end

    context 'If the task description is empty' do
      it 'Validation fails' do
        task = Task.create(
          titre: 'Test1', 
          content: 'content',
          deadline_on: '',
          priority: 'low',
          status: 'done',
          user_id: user.id
        )
          
        expect(task).not_to be_valid
      end
    end

    context 'If the task description is empty' do
      it 'Validation fails' do
        task = Task.create(
          titre: 'Test1', 
          content: 'content',
          deadline_on: 'Date.today',
          priority: '',
          status: 'done',
          user_id: user.id
        )
          
        expect(task).not_to be_valid
      end
    end

    context 'If the task Title and description have values' do
      it 'You can register a task' do
        task = Task.create(
          titre: 'Titre2', 
          content: 'Create a proposal.',
          deadline_on: Date.today,
          priority: 'low',
          status: '',
          user_id: user.id
          )
          expect(task).not_to be_valid
      end
    end

    context 'If the task Title and description have values' do
      it 'You can register a task' do
        task = Task.create(
          titre: 'Titre2', 
          content: 'Create a proposal.',
          deadline_on: Date.today,
          priority: 'low',
          status: 'done',
          user_id: user.id
          )
        expect(task).to be_valid
      end
    end
  end

  describe 'search function' do
    let!(:first_task) { FactoryBot.create(:task, titre: 'first_task_title', user: user) }
    let!(:second_task) { FactoryBot.create(:second_task, titre: "second_task_title", user: user) }
    let!(:third_task) { FactoryBot.create(:third_task, titre: "third_task_title", user: user) }

    context 'If a fuzzy search for a title is performed using the scope method' do
      it "Tasks containing search terms are narrowed down." do
        expect(Task.search_title('first')).to include(first_task)
        expect(Task.search_title('first')).not_to include(second_task)
        expect(Task.search_title('first')).not_to include(third_task)
        expect(Task.search_title('first').count).to eq 1
      end
    end

    context 'If a status search is performed using the scope method' do
      it "Tasks with an exact match to the status are narrowed down." do
        expect(Task.search_status('doing')).not_to include(first_task)
        expect(Task.search_status('doing')).to include(second_task)
        expect(Task.search_status('doing')).not_to include(third_task)
        expect(Task.search_status('doing').count).to eq 1
      end
    end
    
    context 'Ambiguous title and status searches in the scope method' do
      it "Tasks are narrowed down to those that include the search term in the title and match the status exactly." do
        expect(Task.search_title('first').search_status('todo')).to include(first_task)
        expect(Task.search_title('first').search_status('todo')).not_to include(second_task)
        expect(Task.search_title('first').search_status('todo')).not_to include(third_task)
        expect(Task.search_title('first').search_status('todo').count).to eq 1
      end
    end
  end
end
