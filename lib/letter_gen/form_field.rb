require 'Qt'

# Basic form field class (label)
class FormField < Qt::Widget
  attr_accessor :field_name

  def initialize(field_name = 'Default')
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

# Class for text field in form (label + text field)
class TextField < FormField
  attr_accessor :text_field

  def initialize(field_name = 'Default Text')
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

  def to_s
    @text_field.text.force_encoding('UTF-8')
  end
end

# Class for court dates
class DateField < FormField
  attr_accessor :data_field

  DATE_FORMAT = 'd. M. yyyy'.freeze

  def initialize(field_name = 'Default Date')
    super(field_name)

    @date_field = Qt::CalendarWidget.new
    @today = @date_field.selectedDate
    @layout.addWidget @date_field

    setLayout @layout
  end

  def validate
    true
  end

  def reset
    @date_field.selectedDate = @today
  end

  def to_s
    @date_field.selectedDate.toString(DATE_FORMAT)
  end
end
