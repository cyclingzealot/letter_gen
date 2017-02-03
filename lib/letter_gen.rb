require 'Qt'
require 'letter_gen/form'
require 'letter_gen/generator'

# Main qtapp class
class LetterGen < Qt::Widget
  slots 'generate_letters()', 'reset_forms()'

  WINDOW_X_SIZE = 950
  WINDOW_Y_SIZE = 600

  BUTTON_X_SIZE = 80
  BUTTON_Y_SIZE = 20

  def initialize(_parent = nil)
    super()

    setWindowTitle 'Generátor dopisů'

    @forms = {
      form_user: FormUser.new,
      form_secretary:  FormSecretary.new,
      form_company: FormCompany.new,
      form_gov: FormGov.new,
      form_dates: FormDates.new
    }

    generate = Qt::PushButton.new('Generovat')
    connect(generate, SIGNAL('clicked()'), SLOT('generate_letters()'))

    reset = Qt::PushButton.new('Reset')
    connect(reset, SIGNAL('clicked()'), SLOT('reset_forms()'))

    @status_bar = Qt::Label.new

    reset.setFixedSize(BUTTON_X_SIZE, BUTTON_Y_SIZE)
    generate.setFixedSize(BUTTON_X_SIZE, BUTTON_Y_SIZE)

    form_layout = Qt::HBoxLayout.new
    control_layout = Qt::HBoxLayout.new
    layout = Qt::VBoxLayout.new

    @forms.each_value { |value| form_layout.addWidget(value) }

    control_layout.addWidget generate
    control_layout.addWidget reset
    control_layout.addWidget @status_bar

    layout.addLayout form_layout
    layout.addLayout control_layout

    setLayout layout

    show
  end

  def forms_to_hash
    data = {}

    @forms.each_value { |value| data = data.merge(value.to_hash) }

    data
  end

  def generate_letters
    valid = true

    @forms.each_value do |value|
      valid = value.validate
    end

    if valid
      generator = LetterGenerator.new(forms_to_hash)
      generator.generate
      @status_bar.text = 'Vygenerováno'
    else
      @status_bar.text = 'Chyba ve formuláři'
    end
  end

  def reset_forms
    @forms.each_value(&:reset)
    @status_bar.text = 'Resetováno'
  end
end
