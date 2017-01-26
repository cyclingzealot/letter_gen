require 'Qt'
require_relative 'form_field'

class Form < Qt::Widget
	attr_accessor :form_fields

	slots 'reset_form()'

	def initialize(form_name = "Default")
		super()
		@form_name = form_name
		@form_fields = {}
		@status_bar = Qt::Label.new(form_name)

		@reset = Qt::PushButton.new(tr("Reset"))
		@reset.setFixedSize(80,20)
        connect(@reset, SIGNAL('clicked()'), SLOT('reset_form()'))

        @layout = Qt::VBoxLayout.new
        @layout.addWidget @status_bar
        @layout.addWidget @reset
	end

	def reset_form
        @form_fields.each { |key, value| value.reset }
        @status_bar.text = @form_name
    end

    def validate_form
    	@form_fields.each do |key, value|
    		unless value.validate
    			@status_bar.text = value.error_message
    			return false
    		end
    	end
    	true
    end

    def print_form
    	@form_fields.each { |key, value| value.print }
    end
end

class FormSecretary < Form

	def initialize
		super(form_name = "Jednatel")

		@form_fields = {
            :secretary_name => TextField.new("Jméno jednatele"),
            :secretary_address => TextField.new("Adresa"),
            :secretary_zipcode => TextField.new("PSČ")
        }

        @form_fields.each { |key, value| @layout.addWidget(value)}
        setLayout @layout

	end
end

class FormCompany < Form
	def initialize
		super(form_name = "Společnost")

		@form_fields = {
			:company_name => TextField.new("Název společnosti"),
			:company_address => TextField.new("Sídlo společnosti"),
			:company_id => TextField.new("IČO"),
		}

		@form_fields.each { |key, value| @layout.addWidget(value)}
        setLayout @layout
    end
end

class FormGov < Form
	def initialize
		super(form_name = "Úřady")

		@form_fields = {
			:local_office => TextField.new("Územní pracoviště"),
			:finance_office => TextField.new("Sídlo FÚ")
		}

		@form_fields.each { |key, value| @layout.addWidget(value)}
        setLayout @layout
	end
end