class CustomValidator {
  static String? email(String? value) {
    if (value!.isEmpty) {
      return ' Email is required';
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return ' Please enter valid email';
    }
    return null;
  }

  static String? postalCode(String? value) {
    if (value!.isEmpty) {
      return ' Postal Code is required';
    } else if (value.length <= 3) {
      return ' Postal Code should be greater than 3 digits';
    }
    return null;
  }

  static String? password(String? value) {
    if (value!.isEmpty) {
      return ' Password is required';
    } else if (value.length < 6) {
      return ' Password should be greater than or equal to 6 digits';
    }
    return null;
  }

  static String? confirmPassword(String? value, String oldPassword) {
    if (value!.isEmpty) {
      return ' Confirm Password is required';
    } else if (value.length < 6) {
      return ' Password should be greater than or equal to 6 digits';
    } else if (value != oldPassword) {
      return ' Confirm Password is not matched';
    }
    return null;
  }

  static String? isEmpty(String? value) {
    if (value!.isEmpty) {
      return ' Field cannot not be empty';
    }
    return null;
  }

  static String? isEmptyTitle(String? value) {
    if (value!.isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  static String? isEmptyUserName(String? value) {
    if (value!.isEmpty) {
      return ' Name is required';
    }
    return null;
  }
}
