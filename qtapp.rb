require 'Qt'
require_relative 'form'
require_relative 'generator'

class QtApp < Qt::Widget
    slots 'generate_letters()', 'reset_forms()'

    def initialize(parent = nil)
        super()
        
        setWindowTitle "Generátor dopisů"
        setFixedSize(950,600)

        @forms = {
            :form_secretary => FormSecretary.new,
            :form_company => FormCompany.new,
            :form_gov => FormGov.new,
        }

        generate = Qt::PushButton.new(tr("Generovat"))
        connect(generate, SIGNAL('clicked()'), SLOT('generate_letters()'))

        reset = Qt::PushButton.new(tr("Reset"))
        connect(reset, SIGNAL('clicked()'), SLOT('reset_forms()'))

        @status_bar = Qt::Label.new

        reset.setFixedSize(80,20)
        generate.setFixedSize(80,20)

        form_layout = Qt::HBoxLayout.new
        control_layout = Qt::HBoxLayout.new
        layout = Qt::VBoxLayout.new

        @forms.each { |key, value| form_layout.addWidget(value)}

        control_layout.addWidget generate
        control_layout.addWidget reset
        control_layout.addWidget @status_bar

        layout.addLayout form_layout
        layout.addLayout control_layout

        setLayout layout

        show
    end
    
    def generate_letters
        valid = true

        @forms.each do |key, value|
            valid = value.validate
        end
        
        if valid
            generator = LetterGenerator.new(@forms[:form_secretary].to_dict, 
                                        @forms[:form_company].to_dict, 
                                        @forms[:form_gov].to_dict)
            generator.generate
            @status_bar.text = "Vygenerováno"
        else
            @status_bar.text = "Chyba ve formuláři"
        end  
    end

    def reset_forms
        @forms.each { |key, value| value.reset}
        @status_bar.text = "Resetováno"
    end

end

app = Qt::Application.new ARGV
QtApp.new
app.exec