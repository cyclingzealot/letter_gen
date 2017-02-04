#!/usr/bin/env ruby
require 'letter_gen/generator'
require_relative 'spec_helper'
require 'fakefs/spec_helpers'
require 'pp'

describe 'LetterGenerator' do
  include FakeFS::SpecHelpers

  before(:each) do
    @mock_data = {
      user_name: 'Gogo Lejzr',
      user_street: 'U Úlú 321/54',
      user_city: 'Praha 8',
      user_zip: '124 33',
      user_mail: 'gogo.smejzr@sezman.cz',
      user_phone: '123 456 789',
      secretary_name: 'Hana Jana',
      secretary_street: 'Lužánkova 66',
      secretary_city: 'Praha 8',
      secretary_zip: '121 22',
      local_office: 'Územní pracoviště pro Prahu 8',
      finance_street: 'Heleova 55/321',
      finance_city: 'Praha 8',
      finance_zip: '121 44',
      court_mark: 'cm 75/88',
      date_order: '1. 2. 2017',
      date_effect: '31. 12. 2088',
      company_name: 'Hoho s.r.o.', 
      company_street: 'Memeova 1',
      company_city: 'Bruntál',
      company_zip: '552 33',
      company_id: '123456789'
    }

    @mock_paragraph = {
      name: 'test_letter',
      text: 'test text'
    }
   
    @test_root = File.dirname(__FILE__)
    FakeFS::FileSystem.clone("#{LetterGenerator::ROOT_PATH}/templates")
    FakeFS::FileSystem.clone(@test_root)

    @generator = LetterGenerator.new(@mock_data)
  end

  context 'object' do
    subject { LetterGenerator.new(@mock_data)}
    it { is_expected.to be_an_instance_of LetterGenerator }
  end

  context 'has hash table with mock values' do
    it { expect(@generator.gen_data).to be_an_instance_of Hash }
    it { expect(@generator.gen_data[:user_name]).to eq @mock_data[:user_name] }
  end

  context 'it loads .tex template from a file' do
    it { expect(@generator.instance_variable_get(:@template_text).include? '/documentclass')}
  end

  context 'it creates letter from input hash' do
    it 'creates folder with .tex file for a new letter' do
      FakeFS.activate!  
      @generator.generate_letter('test_letter', @mock_paragraph[:text])
      expect(File.exist? "#{LetterGenerator::TARGET_PATH}/test_letter/test_letter.tex").to be true
      FakeFS.deactivate!
    end

    it 'creates .tex file with text from input hash and paragraphs' do
      FakeFS.activate!
      @generator.generate_letter('test_letter', @mock_paragraph[:text])
      letter_text = File.open("#{LetterGenerator::TARGET_PATH}/test_letter/test_letter.tex", 'r', &:read)
      
      expect(letter_text.include? @mock_data[:user_name]).to be true
      expect(letter_text.include? @mock_paragraph[:text]).to be true
      FakeFS.deactivate!
    end
  end

end
