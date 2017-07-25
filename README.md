# LetterGen

This application generates letters from predefined templates and user input.

## Basic Idea

This particular application generates letters that are required in insolvency proceedings. For each insolvency case you need to send different letters to different parties involved (like company representatives, courts etc.).

In each case these letters are the same, only differences are things like company name or address. Letters also don't differ very much from each other, usually there is some kind of introduction (same in each letter), then paragraph or two about what exactly you want, then some closure and contact information. There is quite a lot of letters you have to send and editing them manually can be tedious.

So idea is that you fill out a form with the case information/contact info and application will use predefined templates to generate letters for you.

### Note about language

This application's GUI is written in Czech. Generated letters are also in Czech.

## Installation

Application is packaged as ``gem``, so you can install it with:

```
$ git clone https://github.com/ggljzr/letter_gen
$ cd letter_gen
$ gem build letter_gen.gemspec
$ gem install letter_gen-0.1.0.gem
```

Then you can run it with:

```
$ ./bin/letter_gen
```

Application is built with [Qt](https://www.qt.io/https://www.qt.io/), and it requires [qtbindings](https://github.com/ryanmelt/qtbindings) gem. This gem should be collected automatically, however you have to have Qt4 installed.

## Usage

Simply run ``./bin/letter_gen`` executable. For the first time you'll have to fill out your contact information, which can be saved in ``$HOME/.config/letter_gen/profiles/profile.json``.

When you fill out the forms and click on *Generovat*, application will create a folder called ``letters`` in your working directory. This folder will contain a folder with ``.tex`` file for each generated letter (as well as folder named ``static`` with TeX class file).

## How are the letters generated

As mentioned in [here](#Basic Idea), each letter contains some common intro, unique section and common closure/contact info. Common parts are defined in ``lib/letter_gen/templates/letter_template.tex`` with placeholders in format ``$placeholder$``. There is also a placeholder for unique section (``$paragraph$``).

Unique sections are defined in ``lib/letter_gen/templates/paragraphs.json``. Json file has following format:

```javascript
[
  {
    "name" : "first_unique_letter",
    "text" : "some text (wtih possible TeX markup)"
  },
  {
    "name" : "second_unique_letter",
    "text" : "some different text"
  }
]
```

Attribute ``name`` is used for name of folders in ``letters`` folder. Attribute ``text`` is inserted in place of ``$paragraph$`` placeholder in  TeX template. So far this file is hardcoded within gem package, in the future I plan to add an option to edit it via GUI. It now also contains only two items (so only two letters are generated) for demonstration purposes.

## Testing

This repository also contains set of unit test for the application. Tests use [rspec](http://rspec.info/) framework and can be run with ``rspec`` command.

Because application generates folders and files, [fakefs](https://github.com/fakefs/fakefs) gem is used in tests to mock file system (so you don't have to worry about created files when you run tests). This gem however is not included in basic dependencies. To install testing dependecies use

```
$ gem install --dev letter_gen-0.1.0.gem
```

