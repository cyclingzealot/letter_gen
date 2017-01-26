require 'Qt'

class FormField < Qt::Widget
    attr_accessor :field_name

    def initialize(field_name = "Default")
        super()

        @field_name = field_name
        @label = Qt::Label.new "#{field_name}:"
        @layout = Qt::VBoxLayout.new
        @layout.addWidget @label
    end

    def error_message
        "Pole #{@field_name} nesmí být prázdné."
    end
end

class TextField < FormField
    attr_accessor :text_field

    def initialize(field_name = "Default")
        super(field_name)

        @text_field = Qt::LineEdit.new

        @layout.addWidget @text_field

        setLayout @layout
    end

    def validate
        @text_field.text.to_s != ''
    end

    def reset
        @text_field.text = ''
    end

    def print
        p @text_field.text
    end
end