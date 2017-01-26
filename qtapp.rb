require 'Qt'
require_relative 'form_secretary'

class QtApp < Qt::Widget
    slots 'print_form()', 'reset_form()'

    def initialize(parent = nil)
        super()
        
        setWindowTitle "Generátor dopisů"
        setFixedSize(950,400)

        @form_secretary = FormSecretary.new
        @form_company = FormCompany.new
        @form_gov = FormGov.new

        generate = Qt::PushButton.new(tr("Generovat"))
        connect(generate, SIGNAL('clicked()'), SLOT('print_form()'))

        reset = Qt::PushButton.new(tr("Reset"))
        connect(reset, SIGNAL('clicked()'), SLOT('reset_form()'))

        reset.setFixedSize(80,20)
        generate.setFixedSize(80,20)

        form_layout = Qt::HBoxLayout.new
        layout = Qt::VBoxLayout.new

        form_layout.addWidget @form_secretary
        form_layout.addWidget @form_company
        form_layout.addWidget @form_gov

        layout.addLayout form_layout
        layout.addWidget generate
        layout.addWidget reset

        setLayout layout

        show
    end
    
    def print_form
        unless @form_secretary.validate_form
            p 'chyba'
            return
        end

        @form_secretary.print_form
    end

    def reset_form
        @form_secretary.reset_form
        @form_company.reset_form
        @form_gov.reset_form
    end

end

app = Qt::Application.new ARGV
QtApp.new
app.exec