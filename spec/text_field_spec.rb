#!/usr/bin/env ruby
require 'letter_gen/form_field'
require_relative 'spec_helper'
require 'Qt'

describe 'TextField' do

  before(:each) do
  
    app = Qt::Application.new ARGV

    @test_field_name = 'Test Field'
    @test_field = TextField.new(@test_field_name)
    @test_field.text_field.text = 'test text'

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

    it 'sets error message' do
      @test_field.reset
      @test_field.validate
      expect(@test_field.error_message).to match /Pole #{@test_field_name} ne*./
    end

    it 'returns utf-8 string with to_s' do
      @test_field.text_field.text = 'žluťoučký kůň'
      expect(@test_field.to_s).to eq 'žluťoučký kůň'
      expect(@test_field.to_s.encoding.to_s).to eq 'UTF-8' 
    end
  end
end
