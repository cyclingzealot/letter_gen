require 'fileutils'
require 'json'

# Class for generating .tex files from templates and form input
class LetterGenerator
  attr_reader :gen_data

  ROOT_PATH = File.dirname(__FILE__).freeze
  TEMPLATE_PATH = "#{ROOT_PATH}/templates/letter_template.tex".freeze
  LETTER_CLASS_PATH = "#{ROOT_PATH}/templates/myletter.cls".freeze
  TARGET_PATH = 'letters'.freeze
  PARA_PATH = "#{ROOT_PATH}/templates/paragraphs.json".freeze

  def initialize(data)
    @gen_data = data

    @template_text = File.open(TEMPLATE_PATH, 'r', &:read)
  end

  def generate_letter(letter_name, paragraph)
    letter_text = @template_text
    
    letter_text = letter_text.gsub('$paragraph$', paragraph)

    @gen_data.each do |key, value|
      letter_text = letter_text.gsub("$#{key}$", value.to_s)
    end

    FileUtils.mkdir_p("#{TARGET_PATH}/#{letter_name}")
    File.open("#{TARGET_PATH}/#{letter_name}/#{letter_name}.tex",
              'w') { |f| f.write(letter_text) }
  end

  def generate
    FileUtils.mkdir_p("#{TARGET_PATH}/static")
    FileUtils.cp(LETTER_CLASS_PATH, "#{TARGET_PATH}/static")

    paragraphs = File.open(PARA_PATH, 'r', &:read)
    paragraphs = JSON.parse(paragraphs)

    paragraphs.each { |para| generate_letter(para['name'], para['text']) }
  end
end
