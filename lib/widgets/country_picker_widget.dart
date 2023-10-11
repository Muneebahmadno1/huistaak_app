import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../constants/custom_validators.dart';

class CountryCodePicker extends StatefulWidget {
  final TextEditingController? controller;

  const CountryCodePicker({super.key, this.controller});

  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  String _countryCode = '';
  String initialCountry = 'PK';
  PhoneNumber number = PhoneNumber(isoCode: 'PK');

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(45.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(45.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(45.0),
          ),
        ),
      ),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {
          print(number.phoneNumber);
          print(number);
          if (widget.controller!.text.isNotEmpty &&
              widget.controller!.text.startsWith('0')) {
            print('_PHONECONTROLLER: ${widget.controller!.text}');
            widget.controller!.clear();
            setState(() {});
            return;
          }

          setState(() {
            _countryCode = number.dialCode.toString();
          });
        },
        onInputValidated: (bool value) {},
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          setSelectorButtonAsPrefixIcon: true,
        ),
        ignoreBlank: true,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: const TextStyle(color: Colors.black),
        hintText: 'Phone Number',
        initialValue: number,
        inputDecoration: InputDecoration(
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            hintText: 'Phone Number',
            hintStyle: const TextStyle(color: Colors.grey)),
        textStyle: const TextStyle(
          color: Colors.black,
        ),
        cursorColor: Colors.black,
        spaceBetweenSelectorAndTextField: 0,
        validator: (String? value) => CustomValidator.number(value),
        textFieldController: widget.controller,
        formatInput: true,
        keyboardType: const TextInputType.numberWithOptions(
            signed: false, decimal: false),
        inputBorder: InputBorder.none,
        onSaved: (PhoneNumber number) {
          print('On Saved: $number');
        },
      ),
    );
  }
}
