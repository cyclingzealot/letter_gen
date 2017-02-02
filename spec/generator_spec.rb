#!/usr/bin/env ruby
require 'letter_gen/generator'
require_relative 'spec_helper'

describe 'LetterGenerator' do

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

  context '' do

  end

end
