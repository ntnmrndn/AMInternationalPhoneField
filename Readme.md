# AMInternationalPhone field.

AMInternationalphoneField is a textfield subclasse to help users input international phone numbers.

The project is still unfinished but 

## Features

- Localized formatting (depends on the selected country)
- Filter input to let only
- Guesses the international code from the user input.


## Usage

Replace an UITextField by an AMInternationalPhoneField (AMInternationalPhoneField is a subclass of uITextfield)

Access the phoneNumber property to get the phone number in a +XXXXXXXXXX form.

## Issues

- Altho we allow user to input the internation identifier, this works poorly in case multiple countries share the same code (Canada and US for exemple)
- No formatting for north american territories outside of US/Canada.
- No translations
- No phone number validation
- No tests
- Customization is a bit akward.
- Formatting breaks if we exceed the number of allowed characters
- Flags are not displayed on iOS 8 (flags emoji not supported)
- Taiwan flag does not display on PRC devices.

## Customization

Your best solution is probably to subclass and override the methods.

## Dependencies

libPhoneNumber-iOS

## License

MIT
