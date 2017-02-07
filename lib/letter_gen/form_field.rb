require 'Qt'

# Basic form field class (label)
class FormField < Qt::Widget
  attr_accessor :field_name, :error_message

  def initialize(field_name)
    super()

    @field_name = field_name
    @label = Qt::Label.new @field_name
    @layout = Qt::VBoxLayout.new
    @layout.addWidget @label
    @error_message = "Pole #{@field_name} nesmí být prázdné."
  end
end

# Class for text field in form (label + text field)
class TextField < FormField
  attr_accessor :text_field

  def initialize(field_name)
    super(field_name)

    @text_field = Qt::LineEdit.new

    @layout.addWidget @text_field

    setLayout @layout
  end

  def validate
    !@text_field.text.empty?
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
  attr_accessor :date_field

  DATE_FORMAT = 'd. M. yyyy'.freeze

  def initialize(field_name)
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

class FixedNumField < TextField
  def initialize(field_name, length, bins=[length])
    super(field_name)
    @req_length = length
    @bins = bins
  end
    
  def validate
    if @text_field.text.empty?
      @error_message = "Pole #{@field_name} nesmí být prázdné."
      return false
    end

    stripped = @text_field.text.delete(' ')

    if stripped.length != @req_length
      @error_message = "Číslo musí mít #{@req_length} číslic."
      return false
    end

    if stripped[/[0-9]+/] != stripped
      @error_message = 'Číslo musí obsahovat pouze číslice.'
      return false
    end

    true
  end

  def to_s
    stripped = @text_field.text.delete(' ')

    formated_string = ''

    @bins.each do |bin|
      formated_string += "#{stripped[0...bin]} "
      stripped = stripped[bin..-1]
    end

    formated_string.strip
  end
end
