
final class AppValidators {


  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Email boş bırakılamaz.";
    }

    else {
      return null;
    }
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Şifre boş bırakılamaz.";
    } else {
      return null;
    }
  }

  static String? moneyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Eksik bilgileri doldurmalısınız.";
    } else {
      return null;
    }
  }

  static String? confirmPasswordValidator(
      String? password, String? confirmPassword) {
    if (password == null || password.isEmpty) {
      return "Şifre boş bırakılamaz.";
    } else if (password != confirmPassword) {
      return "Şifreler birbiri ile eşleşmiyor.";
    }
    return null;
  }
}