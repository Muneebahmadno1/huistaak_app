// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get GREENBRIDGELOGIN;

  String get Voiceofusers;

//forgot_password
  String get FORGOTPASSWORD;

  String get EMAILADDRESS;

  String get SENDLINKTORESETPASSWORD;

  String get ANEMAILHASBEENSENTTOYOUREMAILADRESSWITHINSTRUCTIONSTORESETPASSWORD;

  String get THEREISNORECORDOFTHISEMAIL;

//login_screen
  String get WELCOMEBACK;

  String get LOGINTOYOURACCOUNT;

  String get PASSWORD;

  String get DONTHAVEANACCOUNT;

  String get LOGIN;

  String get SIGNUP;

//reset_verification
  String get RESENDVERIFICATIONEMAIL;

  String get ENTERYOUREMAILWEWILLSENDYOULINKTOVERIFYYOUREMAIL;

  String get RESETPASSWORD;

  String get CREATEANEWPASSWORDFORYOURACCOUNT;

  String get NEWPASSWORD;

  String get CONFIRMPASSWORD;

  String get CONFIRM;
//sign_up_screen
  String get SETUPNEWPROFILE;
  String get CREATEYOURACCOUNTTOGETSTARTED;
  String get GALLERY;
  String get FULLNAME;
  String get POSTALCODE;
  String get POSTALCODEOFHOUSE;
  String get ALREADYHAVEANACCOUNT;
  String get REQUIREDPROFILEIMAGE;
}
