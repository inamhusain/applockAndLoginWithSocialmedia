import 'package:fingerprint_auth_example/services/auth_service.dart';

class AuthHandler {
  static handleException(e) {
    var _ex_status;
    switch (e.code) {
      case "wrong-password":
        _ex_status = AuthResultStatus.wrongPassword;
        break;
      case "user-not-found":
        _ex_status = AuthResultStatus.userNotFound;
        break;
      case "invalid-email":
        _ex_status = AuthResultStatus.invalidEmail;
        break;
      case "email-already-in-use":
        _ex_status = AuthResultStatus.emailAlredyInUse;
        break;
      case "weak-password":
        _ex_status = AuthResultStatus.weakpassword;
        break;
      default:
        _ex_status = AuthResultStatus.unknownError;
        break;
    }
    return _ex_status;
  }

  static exceptionMessage({authStatus}) {
    String errorMessage;
    switch (authStatus) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this email doesn't exist.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Your password is wrong.";
        break;
      case AuthResultStatus.unknownError:
        errorMessage = "An undefined Error happened.";
        break;
      case AuthResultStatus.emailAlredyInUse:
        errorMessage = "Email Is already in use";
        break;
      case AuthResultStatus.weakpassword:
        errorMessage = "Weak Password";
        break;
      default:
        errorMessage = "Somthing went wrong";
        break;
    }
    return errorMessage;
  }
}
