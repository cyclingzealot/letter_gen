#!/usr/bin/env ruby
require 'letter_gen/form_field'
require_relative 'spec_helper'
require 'Qt'

describe 'TextField' do

  before(:each) do
  
    app = Qt::Application.new ARGV

    @test_field_name = 'Test Field'
    @test_field_length = 9
    @test_field = FixedNumField.new(@test_field_name, @test_field_length)
    @test_field.text_field.text = '123456789'
  end

  context 'text field interface' do
    it 'has expected methods' do
      expect(@test_field.methods.include?(:reset)).to be true
      expect(@test_field.methods.include?(:validate)).to be true
      expect(@test_field.methods.include?(:to_s)).to be true
    end

    it 'resets and validates' do
      expect(@test_field.validate).to be true
      @test_field.reset
      expect(@test_field.validate).to be false
      expect(@test_field.text_field.text.empty?).to be true
    end

  end

  context 'input validation' do
    it 'allows only numeric input' do
      @test_field.text_field.text = '12345678a'
      expect(@test_field.validate).to be false
    end

    it 'requires number of certain length' do
      @test_field.text_field.text = '12345678'
      expect(@test_field.validate).to be false
    end

    it 'skips spaces in input' do
      @test_field.text_field.text = '123 456 789'
      expect(@test_field.validate).to be true
      @test_field.text_field.text = '    1234 56 7   8 9'
      expect(@test_field.validate).to be true
    end
  end

  context 'to_s formating' do
    it 'removes spaces by default' do
      @test_field.text_field.text = '  12   345 6 78 9  '
      expect(@test_field.to_s).to eq '123456789'
    end

    it 'splits number to bins' do
      @test_field = FixedNumField.new(@test_field_name, @test_field_length, [3,3,3])
      @test_field.text_field.text = '  12   34  567    89    '
      expect(@test_field.to_s).to eq '123 456 789'
    end
  end
end
