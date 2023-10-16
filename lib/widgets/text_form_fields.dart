import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../constants/global_variables.dart';

/// Text Field Auth Screens Only
class AuthTextField extends StatefulWidget {
  final String hintText;
  final Widget? suffixIcon;
  final String? prefixIcon;
  final bool? isObscure;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  const AuthTextField(
      {Key? key,
      required this.hintText,
      this.controller,
      this.suffixIcon,
      this.isObscure,
      this.prefixIcon,
      this.validator})
      : super(key: key);

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFormField(
        validator: widget.validator,
        obscureText: widget.isObscure ?? false,
        controller: widget.controller,
        cursorColor: Colors.black,
        style: bodyNormal.copyWith(fontFamily: "MontserratSemiBold"),
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            border: InputBorder.none,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: Colors.black26, // Make the border transparent
                width: 1, // Set the width to 0 to make it disappear
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: Colors.black26, // Make the border transparent
                width: 1, // Set the width to 0 to make it disappear
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: Colors.black26, // Make the border transparent
                width: 1, // Set the width to 0 to make it disappear
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: Colors.black26, // Make the border transparent
                width: 1, // Set the width to 0 to make it disappear
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: Colors.black26, // Make the border transparent
                width: 1, // Set the width to 0 to make it disappear
              ),
            ),
            hintText: widget.hintText,
            hintStyle: bodyNormal.copyWith(
                color: Colors.black54, fontFamily: "MontserratSemiBold"),
            suffixIcon: widget.suffixIcon,
            suffixIconColor: Colors.black,
            prefixIcon: widget.prefixIcon == null
                ? Padding(
                    padding: EdgeInsets.only(left: 26.0),
                    child: SizedBox(),
                  )
                : Padding(
                    padding: EdgeInsets.only(left: 26.0, right: 10),
                    child: SizedBox(
                      width: 16,
                      child: Image.asset(
                        widget.prefixIcon!,
                      ),
                    ),
                  ),
            prefixIconColor: Colors.white,
            prefixIconConstraints: const BoxConstraints(
              maxHeight: 30,
              minHeight: 30,
            )),
      ),
    );
  }
}

/// Text Field
class CustomTextField extends StatefulWidget {
  final String hintText;
  final Widget? suffixIcon;
  final String? prefixIcon;
  final bool? isObscure;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final onChanged;
  final String? suffixText;
  final String? prefixText;

  const CustomTextField(
      {Key? key,
      required this.hintText,
      this.suffixIcon,
      this.isObscure,
      this.prefixIcon,
      this.validator,
      this.keyboardType,
      this.suffixText,
      this.prefixText,
      this.onChanged,
      this.controller})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFormField(
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        obscureText: widget.isObscure ?? false,
        controller: widget.controller ?? null,
        cursorColor: Colors.black,
        onChanged: widget.onChanged ?? null,
        style: bodyNormal.copyWith(fontFamily: "MontserratSemiBold"),
        decoration: InputDecoration(
            suffixText: widget.suffixText ?? '',
            prefixText: widget.prefixText ?? '',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: Colors.black26, // Make the border transparent
                width: 1, // Set the width to 0 to make it disappear
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: Colors.black26, // Make the border transparent
                width: 1, // Set the width to 0 to make it disappear
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: Colors.black26, // Make the border transparent
                width: 1, // Set the width to 0 to make it disappear
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: Colors.black26, // Make the border transparent
                width: 1, // Set the width to 0 to make it disappear
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: Colors.black26, // Make the border transparent
                width: 1, // Set the width to 0 to make it disappear
              ),
            ),
            hintText: widget.hintText,
            hintStyle: bodyNormal.copyWith(
                color: Colors.black54, fontFamily: "MontserratSemiBold"),
            suffixIcon: widget.suffixIcon,
            suffixIconColor: Colors.black,
            prefixIcon: widget.prefixIcon == null
                ? Padding(
                    padding: EdgeInsets.only(left: 26.0),
                    child: SizedBox(),
                  )
                : Padding(
                    padding: EdgeInsets.only(left: 26.0, right: 10),
                    child: SizedBox(
                      width: 16,
                      child: Image.asset(
                        widget.prefixIcon!,
                      ),
                    ),
                  ),
            prefixIconColor: Colors.white,
            prefixIconConstraints: const BoxConstraints(
              maxHeight: 30,
              minHeight: 30,
            )),
      ),
    );
  }
}

///Otp Fields
class OtpField extends StatefulWidget {
  const OtpField({
    Key? key,
  }) : super(key: key);

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: OtpTextField(
        numberOfFields: 4,
        fieldWidth: 56,
        borderWidth: 1.2,
        margin: const EdgeInsets.fromLTRB(12, 2, 12, 0),
        keyboardType: TextInputType.number,
        borderRadius: BorderRadius.circular(15),
        borderColor: Colors.black26,
        focusedBorderColor: AppColors.buttonColor,
        enabledBorderColor: Colors.black26,
        disabledBorderColor: Colors.black26,
        cursorColor: AppColors.buttonColor,
        showFieldAsBox: true,
        textStyle:
            bodyNormal.copyWith(fontSize: 22, fontFamily: "InterSemiBold"),
        //runs when a code is typed in
        onCodeChanged: (String code) {
          //handle validation or checks here
        },
        //runs when every textField is filled
        onSubmit: (String verificationCode) {
          // showCustomDialog(context, 'OTP Verified!', 'Continue', '');
          // Get.to(() => ResetPassword(controller: TextEditingController()));
        }, // end onSubmit
      ),
    );
  }
}
