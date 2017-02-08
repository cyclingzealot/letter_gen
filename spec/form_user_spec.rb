#!/usr/bin/env ruby
require 'letter_gen/form'
require 'letter_gen/form_field'
require_relative 'spec_helper'
require 'fakefs/spec_helpers'
require 'json'

require 'Qt'

describe 'FormUser' do
  include FakeFS::SpecHelpers

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
    @test_form.form_fields.each { |key, value| value.text_field.text = @mock_data[key] }
  
  end

  context 'form interface' do
    it 'has load_profile and save_profile methods' do
      expect(@test_form.methods.include?(:load_profile)).to be true
      expect(@test_form.methods.include?(:save_profile)).to be true
    end 
  end

  context 'save/load profile' do
    it 'saves and loads profile from input' do
      expect(@test_form.to_hash).to eq @mock_data
      
      FakeFS.activate!
      
      @test_form.save_profile
      expect(File.exist? "#{FormUser::PROFILE_PATH}/profile.json" ).to be true

      @test_form.reset
      expect(@test_form.validate_form).to be false

      @test_form.load_profile
      expect(@test_form.validate_form).to be true
      expect(@test_form.to_hash).to eq @mock_data

      FakeFS.deactivate!  
    end
  end
end

