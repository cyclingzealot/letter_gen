
class LetterGenerator
	TEMPLATE_PATH = 'templates/letter_template.tex'
	TARGET_PATH = 'dopisy'
	PARA_PATH = 'templates/odstavce.xml'


	def initialize(secretary_dict, company_dict, gov_dict)
		@gen_data = {}
		@gen_data = @gen_data.merge(secretary_dict)
		@gen_data = @gen_data.merge(company_dict)
		@gen_data = @gen_data.merge(gov_dict)

		File.open(TEMPLATE_PATH, 'r') do |f|
			@template_text = f.read()
		end
	end

	def generate_letter(letter_name)
		letter_text = @template_text
		@gen_data.each do |key, value|
			letter_text = letter_text.gsub("--#{key.to_s}--", value.to_s)
		end
		
		Dir.mkdir("#{TARGET_PATH}/#{letter_name}")
		File.open("#{TARGET_PATH}/#{letter_name}/#{letter_name}.tex", 'w') { |f| f.write(letter_text)}
	end

	def generate
		generate_letter("pokus")
	end
end