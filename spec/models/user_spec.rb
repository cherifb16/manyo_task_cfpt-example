require 'rails_helper'

RSpec.describe 'User Model Functions', type: :model do
  describe 'Validation testing.' do
    context 'If the user\'s name is an empty string' do
      it 'Validation fails.' do
        user = User.create(
          name: "",
          email: "user@user.com",
          password: "password",
          password_confirmation: "password",
        )
        expect(user).not_to be_valid
      end
    end

    context 'If the user\'s email address is blank' do
      it 'Validation fails.' do
        user = User.create(
          name: "user",
          email: "",
          password: "password",
          password_confirmation: "password",
        )
        expect(user).not_to be_valid
      end
    end

    context 'If the user\'s password is an empty string' do
      it 'Validation fails.' do
        user = User.create(
          name: "user",
          email: "user@user.com",
          password: "",
          password_confirmation: "password",
        )
        expect(user).not_to be_valid
      end
    end

    context 'If the user\'s email address was already in use' do
      let!(:user) { FactoryBot.create(:user, email: "user@user.com") }
      it 'Validation fails.' do
        user = User.create(
          name: "user",
          email: "user@user.com",
          password: "password",
          password_confirmation: "password",
        )
        expect(user).not_to be_valid
      end
    end

    context 'If the user\'s password is less than 6 characters.' do
      it 'Validation fails.' do
        user = User.create(
          name: "user",
          email: "user@user.com",
          password: "pass",
          password_confirmation: "pass",
        )
        expect(user).not_to be_valid
      end
    end

    context 'If the user\'s name has a value, the email address is an unused value and the password is at least 6 characters long' do
      it 'Successful validation' do
        user = User.create(
          name: "user",
          email: "user@user.com",
          password: "password",
          password_confirmation: "password",
        )
        expect(user).to be_valid
      end
    end
  end
end