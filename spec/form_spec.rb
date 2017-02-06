#!/usr/bin/env ruby
require 'letter_gen/form'
require 'letter_gen/form_field'
require_relative 'spec_helper'
require 'Qt'

describe 'Form' do

  before(:each) do
  
    @mock_data = {
      user_name: 'Gogo Lejzr',
      user_street: 'Náhodná 28/541',
      user_city: 'Praha 6',
      user_zip: '123 34',
      user_mail: 'some_mail@gmail.com',
      user_phone: '123 456 789'   
    }
    
    app = Qt::Application.new ARGV

    @test_form = FormUser.new
    @test_form.form_fields.each { |key, value| value.text_field.text = @mock_data[key]}
  
  end

  context 'object' do
    subject { FormUser.new }
    it { is_expected.to be_an_instance_of FormUser }
  end

  context 'form interface' do
    it 'has expected text fields' do
      expect(@test_form.form_fields[:user_name]).to be_an_instance_of TextField
      expect(@test_form.form_fields[:user_name].field_name).to eq 'Jméno'
    end

    it 'has expected status bar' do
      expect(@test_form.instance_variable_get(:@status_bar)).to be_an_instance_of Qt::Label
      expect(@test_form.instance_variable_get(:@status_bar).text).to eq 'Profil'
    end
    
    it 'has validate, reset and to_hash methods' do
      expect(@test_form.methods.include?(:validate_form)).to be true
      expect(@test_form.methods.include?(:reset_form)).to be true
      expect(@test_form.methods.include?(:to_hash)).to be true
    end 
  end

  context 'form methods' do
    it 'validates and resets input (not empty)' do
      expect(@test_form.validate_form).to be true
      @test_form.reset_form
      expect(@test_form.validate_form).to be false
    end

    it 'convert user input to hash' do
      expect(@test_form.to_hash).to eq @mock_data
    end
  end
end

