import 'package:timetracker/ui/sign_in/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidation {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.submitted = false,
    this.formType = EmailSignInFormType.signIn,
  });
  final String email;
  final String password;
  final bool isLoading;
  final bool submitted;
  final EmailSignInFormType formType;
  String get primaryText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get submitEnabled {
    return emailValidator.isValid(email) &&
        emailValidator.isValid(password) &&
        !isLoading;
  }

  String? get passwordErrorText {
    bool passwordValid = submitted && passwordValidator.isValid(password);
    return passwordValid ? invalidEmailErrorText : null;
  }

  String? get emailErrorText {
    bool emailValid = submitted && emailValidator.isValid(email);
    return emailValid ? invalidPasswordErrorText : null;
  }

  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
