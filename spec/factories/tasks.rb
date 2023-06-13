FactoryBot.define do
  factory :task do
    user
    titre { 'Test1' }
    content { 'Test est ok' }
    deadline_on { Date.today.since(2.day) }
    priority { 'middle' }
    status { 'todo' }
  end

  factory :second_task, class: Task do
    user
    titre { 'Test2' } 
    content { 'Content2 est ok' }
    deadline_on { Date.today.since(1.day) }
    priority { 'high' }
    status { 'doing' }
  end

  factory :third_task, class: Task do
    user
    titre { 'Test3' } 
    content { 'Content3 est ok' }
    deadline_on { Date.today }
    priority { 'low' }
    status { 'done' }
  end
end
