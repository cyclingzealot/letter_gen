require 'Qt'
require 'fileutils'
require 'json'

require_relative 'form_field'

# Basic Form class
class Form < Qt::Frame
  attr_accessor :form_fields

  slots 'reset_form()'

  BUTTON_X_SIZE = 80
  BUTTON_Y_SIZE = 20

  def initialize(form_name = 'Default', form_fields = {})
    super()
    @form_name = form_name
    @form_fields = form_fields
    @status_bar = Qt::Label.new(form_name)
    @status_bar.setFont Qt::Font.new(@status_bar.font.family, 12)

    @reset = Qt::PushButton.new(tr('Reset'))
    @reset.setFixedSize(BUTTON_X_SIZE, BUTTON_Y_SIZE)
    connect(@reset, SIGNAL('clicked()'), SLOT('reset_form()'))

    @layout = Qt::VBoxLayout.new
    @layout.addWidget @status_bar
    setFrameStyle(1)

    @form_fields.each_value { |value| @layout.addWidget(value) }
    @layout.addWidget @reset
    setLayout @layout
  end

  def reset_form
    @form_fields.each_value(&:reset)
    @status_bar.text = @form_name
    @status_bar.setFont Qt::Font.new(@status_bar.font.family, 12)
  end
  alias reset reset_form

  def validate_form
    @form_fields.each_value do |value|
      unless value.validate
        @status_bar.text = value.error_message
        @status_bar.setFont Qt::Font.new(@status_bar.font.family, 9)
        return false
      end
    end
    true
  end
  alias validate validate_form

  def print_form
    @form_fields.each_value(&:print)
  end

  def to_dict
    form_dict = {}

    @form_fields.each { |key, value| form_dict[key] = value.to_s }

    form_dict
  end
end

# Company's secretary information
class FormSecretary < Form
  def initialize
    form_fields = {
      secretary_name: TextField.new('Jméno jednatele'),
      secretary_street: TextField.new('Ulice'),
      secretary_city: TextField.new('Město'),
      secretary_zip: TextField.new('PSČ')
    }

    super('Jednatel', form_fields)
  end
end

# Company information
class FormCompany < Form
  def initialize
    form_fields = {
      company_name: TextField.new('Název společnosti'),
      company_street: TextField.new('Sídlo společnosti - ulice'),
      company_city: TextField.new('Sídlo společnosti - město'),
      company_zip: TextField.new('PSČ společnosti'),
      company_id: TextField.new('IČO')
    }

    super('Společnost', form_fields)
  end
end

# Finance bureau information
class FormGov < Form
  def initialize
    form_fields = {
      local_office: TextField.new('Územní pracoviště'),
      finance_address: TextField.new('Sídlo FÚ - ulice'),
      finance_office: TextField.new('Sídlo FÚ - město'),
      finance_zip: TextField.new('PSČ FÚ')
    }

    super('Úřady', form_fields)
  end
end

# Court dates form
class FormDates < Form
    def initialize
    form_fields = {
        date_order: DateField.new('Usnesení ze dne'),
        date_effect: DateField.new('Nabylo moci')
    }

    super('Data', form_fields)
    end
end

# User's profile
class FormUser < Form
  PROFILE_PATH = "#{Dir.home}/.config/letter_gen/profiles".freeze

  slots 'save_profile()', 'load_profile()'

  def initialize
    form_fields = {
      user_name: TextField.new('Jméno'),
      user_address: TextField.new('Adresa - ulice'),
      user_city: TextField.new('Adresa - město'),
      user_zipcode: TextField.new('PSČ'),
      user_phone: TextField.new('Telefon'),
      user_mail: TextField.new('E-mail')
    }

    super('Profil', form_fields)

    saveb = Qt::PushButton.new(tr('Uložit'))
    saveb.setFixedSize(BUTTON_X_SIZE, BUTTON_Y_SIZE)
    connect(saveb, SIGNAL('clicked()'), SLOT('save_profile()'))

    loadb = Qt::PushButton.new(tr('Načíst'))
    loadb.setFixedSize(BUTTON_X_SIZE, BUTTON_Y_SIZE)
    connect(loadb, SIGNAL('clicked()'), SLOT('load_profile()'))

    @layout.addWidget saveb
    @layout.addWidget loadb
  end

  def save_profile
    return unless validate_form

    FileUtils.mkdir_p(PROFILE_PATH)
    File.open("#{PROFILE_PATH}/profile.json", 'w') { |f| f.write(to_dict.to_json) }
    @status_bar.text = 'Uloženo'
  end

  def load_profile
    unless File.exist?("#{PROFILE_PATH}/profile.json")
      @status_bar.text = 'Nenalezen žádný profil'
      return
    end
    data = nil
    File.open("#{PROFILE_PATH}/profile.json", 'r') { |f| data = JSON.parse(f.read) }
    data.each do |key, value|
      @form_fields[key.to_sym].text_field.text = value
    end
    @status_bar.text = 'Načteno'
  end
end
