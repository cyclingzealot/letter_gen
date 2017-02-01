Gem::Specification.new do |s|
	s.name = 'letter_gen'
	s.version = '0.1.0'
	s.date = '2017-02-01'
	s.executables << 'letter_gen'
	s.summary = 'Generate letters from templates.'
	s.description = 'GUI (QT) application for generating bussiness mail from given input parameters and templates.'
	s.authors = ['Ondřej Červenka']
	s.email = 'gogo.lejzr@gmail.com'
        s.files = ['lib/letter_gen.rb', 
                   'lib/letter_gen/form.rb', 
                   'lib/letter_gen/generator.rb', 
                   'lib/letter_gen/form_field.rb', 
                   'lib/letter_gen/templates/letter_template.tex', 
                   'lib/letter_gen/templates/paragraphs.xml']
	s.homepage = 'https://github.com/ggljzr/letter-gen'
	s.license =  'MIT'
	s.add_dependency 'qtbindings', '4.8.6.3'
end
