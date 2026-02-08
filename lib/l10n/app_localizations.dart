import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The name of our app
  ///
  /// In en, this message translates to:
  /// **'Sham Cars'**
  String get appName;

  /// No description provided for @navbarExploreLabel.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navbarExploreLabel;

  /// No description provided for @navbarVehiclesLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get navbarVehiclesLabel;

  /// No description provided for @navbarCommunityLabel.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get navbarCommunityLabel;

  /// The title for the appearance section in the drawer
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get drawerAppearanceTitle;

  /// The display name for a user who is not logged in
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get userGuestTitle;

  /// The subtitle prompting a guest user to log in
  ///
  /// In en, this message translates to:
  /// **'Sign in to view profile'**
  String get userGuestSubtitle;

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// A default message displayed over the loading barrier
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get loadingBarrierDefaultText;

  /// `cancel` English word
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// `ok` English word
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// `or` English word
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// `sec` English word
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get sec;

  /// `min` English word
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// The label of the paste button in a form
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get pasteBtnLabel;

  /// The label of the continue button in a form
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtnLabel;

  /// No description provided for @viewAllBtnLabel.
  ///
  /// In en, this message translates to:
  /// **'view all'**
  String get viewAllBtnLabel;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'You\'re signed in as'**
  String get signedInAs;

  /// No description provided for @signedInWith.
  ///
  /// In en, this message translates to:
  /// **'You\'re signed in with'**
  String get signedInWith;

  /// No description provided for @logoutBtnLabel.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutBtnLabel;

  /// No description provided for @drawerThemeModeSwitchTitle.
  ///
  /// In en, this message translates to:
  /// **'Color mode'**
  String get drawerThemeModeSwitchTitle;

  /// No description provided for @enableDarkModeBtnLabel.
  ///
  /// In en, this message translates to:
  /// **'Enable dark mode'**
  String get enableDarkModeBtnLabel;

  /// No description provided for @disableDarkModeBtnLabel.
  ///
  /// In en, this message translates to:
  /// **'Disable dark mode'**
  String get disableDarkModeBtnLabel;

  /// No description provided for @darkThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkThemeMode;

  /// No description provided for @lightThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightThemeMode;

  /// No description provided for @systemThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get systemThemeMode;

  /// No description provided for @drawerLanguageBtnLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get drawerLanguageBtnLabel;

  /// No description provided for @supportBtnLabel.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get supportBtnLabel;

  /// No description provided for @fAQTileLabel.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get fAQTileLabel;

  /// No description provided for @contactUsTileLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUsTileLabel;

  /// No description provided for @termsTileLabel.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsTileLabel;

  /// No description provided for @userProfileScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get userProfileScreenTitle;

  /// No description provided for @accountSettingsTileLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettingsTileLabel;

  /// No description provided for @deleteAccountBtnLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteAccountBtnLabel;

  /// No description provided for @changePasswordBtnLabel.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordBtnLabel;

  /// No description provided for @logoutFailureDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout Failed!'**
  String get logoutFailureDialogTitle;

  /// No description provided for @publicProfileSettingsTileLabel.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get publicProfileSettingsTileLabel;

  /// No description provided for @drawerAboutTheAppTile.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get drawerAboutTheAppTile;

  /// No description provided for @searchScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Search in Sham Cars'**
  String get searchScreenTitle;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyFilters;

  /// No description provided for @removeFilters.
  ///
  /// In en, this message translates to:
  /// **'Remove all'**
  String get removeFilters;

  /// No description provided for @aboutDoctorSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'About the doctor'**
  String get aboutDoctorSectionTitle;

  /// No description provided for @aboutFacilitySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'About the facility'**
  String get aboutFacilitySectionTitle;

  /// No description provided for @locationOnMap.
  ///
  /// In en, this message translates to:
  /// **'Location on map'**
  String get locationOnMap;

  /// The title of the `ErrorDialog` shown after a failed login attempt
  ///
  /// In en, this message translates to:
  /// **'Login Failed!'**
  String get loginFailureDialogTitle;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// The label of a login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginBtnLabel;

  /// The label of a registration button
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerBtnLabel;

  /// An error message displayed if an email or phone number field was left empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your email or phone number'**
  String get emailOrPhoneIsRequired;

  /// An error message displayed if the value of an email or phone number field is not a valid email or phone number
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email or phone number'**
  String get emailOrPhoneIsInvalid;

  /// The label of the email or phone form field
  ///
  /// In en, this message translates to:
  /// **'Email or phone'**
  String get emailOrPhoneFieldLabel;

  /// The hint of the email or phone form field
  ///
  /// In en, this message translates to:
  /// **'johnDoe@example.com or 0912345678'**
  String get emailOrPhoneFieldHint;

  /// An error message displayed if a username field was left empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get usernameIsRequired;

  /// An error message displayed if a password field was left empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordIsRequired;

  /// No description provided for @passwordValidationError.
  ///
  /// In en, this message translates to:
  /// **'Password must be, at lease, 8 characters and have one or more non-alphanumeric character and one or more uppercase letter'**
  String get passwordValidationError;

  /// An error message displayed if a password field was left empty
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get passwordConfirmationIsRequired;

  /// An error message displayed if the password confirmation doesn't match the original one.
  ///
  /// In en, this message translates to:
  /// **'The two passwords don\'t match!'**
  String get passwordConfirmationMismatch;

  /// No description provided for @passwordRuleLength.
  ///
  /// In en, this message translates to:
  /// **'Have 8 characters at least'**
  String get passwordRuleLength;

  /// No description provided for @passwordRuleUppercase.
  ///
  /// In en, this message translates to:
  /// **'Have an uppercase letter'**
  String get passwordRuleUppercase;

  /// No description provided for @passwordRuleLowercase.
  ///
  /// In en, this message translates to:
  /// **'Have a lowercase letter'**
  String get passwordRuleLowercase;

  /// No description provided for @passwordRuleNumber.
  ///
  /// In en, this message translates to:
  /// **'Have a number'**
  String get passwordRuleNumber;

  /// No description provided for @passwordRuleSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'Have one or more special characters'**
  String get passwordRuleSpecialChar;

  /// An error message displayed if a phoneNumber field was left empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get phoneNumberIsRequired;

  /// An error message displayed if the value of a phoneNumber field is not valid
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneNumberIsInvalid;

  /// No description provided for @createPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Create your password'**
  String get createPasswordMessage;

  /// An error message displayed if an email field was left empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get emailIsRequired;

  /// An error message displayed if the value of an email field is not a valid email address
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailIsInvalid;

  /// The label of the email form field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailFieldLabel;

  /// The hint of the email form field
  ///
  /// In en, this message translates to:
  /// **'johnDoe@example.com'**
  String get emailFieldHint;

  /// The label of the password form field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordFieldLabel;

  /// The label of the password-confirmation form field
  ///
  /// In en, this message translates to:
  /// **'Password confirmation'**
  String get passwordConfirmationFieldLabel;

  /// The hint of the password-confirmation form field
  ///
  /// In en, this message translates to:
  /// **'Enter the same password as in the previous field'**
  String get passwordConfirmationFieldHint;

  /// The label of the phone number text field
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberFieldLabel;

  /// A message shown inside the phone number text field when it's empty
  ///
  /// In en, this message translates to:
  /// **'start with 09'**
  String get phoneNumberFieldHint;

  /// The label of the username text field
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get usernameFieldLabel;

  /// A message shown inside the username text field when it's empty
  ///
  /// In en, this message translates to:
  /// **'First and last name'**
  String get usernameFieldHint;

  /// The text to be displayed when a login attempt is in progress
  ///
  /// In en, this message translates to:
  /// **'Login in progress...'**
  String get loginInProgress;

  /// A message to display as a greeting to the user
  ///
  /// In en, this message translates to:
  /// **'Welcome to Sham Cars'**
  String get appGreeting;

  /// The text to be displayed under the title
  ///
  /// In en, this message translates to:
  /// **'Login to your account'**
  String get loginScreenSubtitle;

  /// The text to ask the user if he want to create an account
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountQuestion;

  /// The text to ask the user if he want to login to an existing account
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccountQuestion;

  /// The label of the button to create an account
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccountBtnLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'male'**
  String get maleGender;

  ///
  ///
  /// In en, this message translates to:
  /// **'female'**
  String get femaleGender;

  ///
  ///
  /// In en, this message translates to:
  /// **'Your gender'**
  String get genderInputTitle;

  /// The main title in the screen
  ///
  /// In en, this message translates to:
  /// **'Please verify your email address'**
  String get emailVerificationScreenTitle;

  /// No description provided for @emailVerificationErrorDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to verify your email'**
  String get emailVerificationErrorDialogTitle;

  /// The main title in the screen
  ///
  /// In en, this message translates to:
  /// **'This help us confirm your identity & protect your account'**
  String get emailVerificationScreenSubtitle;

  /// No description provided for @emailVerificationCodeWasSent.
  ///
  /// In en, this message translates to:
  /// **'Please enter the verification code sent to '**
  String get emailVerificationCodeWasSent;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Did not receive a code?'**
  String get didNotReceiveCode;

  /// No description provided for @resendVerificationCodeIn.
  ///
  /// In en, this message translates to:
  /// **'You can request a new code in'**
  String get resendVerificationCodeIn;

  /// No description provided for @resendVerificationCodeBtnLabel.
  ///
  /// In en, this message translates to:
  /// **'send me a new code'**
  String get resendVerificationCodeBtnLabel;

  /// No description provided for @verifyBtnLabel.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyBtnLabel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Wrong email?'**
  String get wrongEmailToVerify;

  /// The label of a text button for changing the phone number in verification screen
  ///
  /// In en, this message translates to:
  /// **'go back to change it'**
  String get changeEmailToVerify;

  /// The message of `AppError.noInternetConnection`
  ///
  /// In en, this message translates to:
  /// **'You are not connected! Please check your internet connection and try again.'**
  String get noInternetConnection;

  /// The message of `AppError.cannotConnectToServer`
  ///
  /// In en, this message translates to:
  /// **'Cannot connect to server, please try again later.'**
  String get cannotConnectToServer;

  /// The message of `AppError.unauthorized`
  ///
  /// In en, this message translates to:
  /// **'You are unauthorized to proceed.'**
  String get unauthorized;

  /// The message of `AppError.unauthenticated`
  ///
  /// In en, this message translates to:
  /// **'Please login before to preform this action.'**
  String get unauthenticated;

  /// The message of `AppError.accountAlreadyExist`
  ///
  /// In en, this message translates to:
  /// **'An account with your credentials already exists'**
  String get accountAlreadyExist;

  /// The message of `AppError.invalidLoginCredential`
  ///
  /// In en, this message translates to:
  /// **'Incorrect email and\\or password.'**
  String get invalidLoginCredential;

  /// The message of `AppError.undefined`
  ///
  /// In en, this message translates to:
  /// **'An error occurred, please try again.'**
  String get undefinedException;

  /// The message of `AppError.serverError`
  ///
  /// In en, this message translates to:
  /// **'Unexpected error!\nIn case of receiving this error repeatedly, please wait some time until we fix the issue.'**
  String get serverError;

  /// The message of `AppError.notFound`
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found.'**
  String get notFound;

  /// The message of `AppError.decodingJsonFailed`
  ///
  /// In en, this message translates to:
  /// **'Failed to decode the JSON response.'**
  String get decodingJsonFailed;

  /// The message of `AppError.badRequest`
  ///
  /// In en, this message translates to:
  /// **'The request was invalid. Please check your input and try again.'**
  String get badRequest;

  /// The message of `AppError.routeNotFound`
  ///
  /// In en, this message translates to:
  /// **'The requested route was not found.'**
  String get routeNotFound;

  /// The message of `AppError.emptyRequestBody`
  ///
  /// In en, this message translates to:
  /// **'The request body was empty. Please check your input and try again.'**
  String get emptyRequestBody;

  /// The message of `AppError.invalidContentType`
  ///
  /// In en, this message translates to:
  /// **'The content type of the request was invalid. Please check your input and try again.'**
  String get invalidContentType;

  /// The message of `AppError.wrongLoginCreds`
  ///
  /// In en, this message translates to:
  /// **'The email and password combination is incorrect. Please check your credentials and try again.'**
  String get wrongLoginCreds;

  /// The message of `AppError.locationServiceDisabled`
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Please enable them in your device settings to view nearby medical facilities.'**
  String get locationServiceDisabled;

  /// The message of `AppError.locationPermissionDenied`
  ///
  /// In en, this message translates to:
  /// **'Location permission is denied. Please grant the app permission to access your location to find nearby doctors and hospitals.'**
  String get locationPermissionDenied;

  /// The message of `AppError.locationPermissionDeniedPermanently`
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied. Please go to your device settings and grant the app permission to access your location.'**
  String get locationPermissionDeniedPermanently;

  /// The message of `AppError.validation`
  ///
  /// In en, this message translates to:
  /// **'The request was invalid. Please check your input and try again.'**
  String get validation;

  /// The message of `AppError.accountAlreadyExists`
  ///
  /// In en, this message translates to:
  /// **'An account with your credentials already exists, please login or reset your password'**
  String get accountAlreadyExists;

  /// The label of the forgot password button
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordBtnLabel;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @forgotPasswordOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you an OTP to reset your password.'**
  String get forgotPasswordOtpSubtitle;

  /// No description provided for @sendOtpBtnLabel.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtpBtnLabel;

  /// No description provided for @otpSentMessage.
  ///
  /// In en, this message translates to:
  /// **'An OTP has been sent to your email.'**
  String get otpSentMessage;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordBtnLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordBtnLabel;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password has been reset successfully. Please login with your new password.'**
  String get passwordResetSuccess;

  /// No description provided for @passwordResetExpired.
  ///
  /// In en, this message translates to:
  /// **'Your password reset token has expired, please request a new one.'**
  String get passwordResetExpired;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmPasswordLabel;

  /// No description provided for @invalidToken.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired token.'**
  String get invalidToken;

  /// No description provided for @otpPasswordResetScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your identity'**
  String get otpPasswordResetScreenTitle;

  /// No description provided for @otpPasswordResetScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit code sent to your email to verify your identity and reset your password.'**
  String get otpPasswordResetScreenSubtitle;

  /// No description provided for @otpVerificationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Identity verified. You can now reset your password.'**
  String get otpVerificationSuccess;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmail;

  /// The label of the exit button in the signup process
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitSignupProcessBtnLabel;

  /// The label of the continue button in the signup process
  ///
  /// In en, this message translates to:
  /// **'Continue signing up'**
  String get continueSignupBtnLabel;

  /// No description provided for @confirmExitingSignupDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the signup process?'**
  String get confirmExitingSignupDialogTitle;

  /// No description provided for @confirmExitingSignupDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'The entered information will be lost'**
  String get confirmExitingSignupDialogMessage;

  /// The message of `AppError.signupFailed`
  ///
  /// In en, this message translates to:
  /// **'Signup failed. Please try again.'**
  String get signupFailed;

  /// The message of `AppError.invalidOTP`
  ///
  /// In en, this message translates to:
  /// **'The OTP is invalid. Please make sure you have entered the correct code.'**
  String get invalidOTP;

  /// The message of `AppError.expiredOTP`
  ///
  /// In en, this message translates to:
  /// **'The OTP has expired. Please request a new one.'**
  String get expiredOTP;

  /// The message of `AppError.confirmIdentity`
  ///
  /// In en, this message translates to:
  /// **'Please confirm your identity.'**
  String get confirmIdentity;

  /// The message of `AppError.emailAlreadyVerified`
  ///
  /// In en, this message translates to:
  /// **'The email address has already been verified.'**
  String get emailAlreadyVerified;

  /// The message of `AppError.phoneAlreadyVerified`
  ///
  /// In en, this message translates to:
  /// **'The phone number has already been verified.'**
  String get phoneAlreadyVerified;

  /// The message of `AppError.forbidden`
  ///
  /// In en, this message translates to:
  /// **'The request is forbidden. You are not authorized to access this resource.'**
  String get forbidden;

  /// The message of `AppError.resourceAlreadyExists`
  ///
  /// In en, this message translates to:
  /// **'The resource already exists.'**
  String get resourceAlreadyExists;

  /// The message of `AppError.rateLimitExceeded`
  ///
  /// In en, this message translates to:
  /// **'You have sent too many requests. Please wait a while before trying again.'**
  String get rateLimitExceeded;

  /// The label of the complete signup button
  ///
  /// In en, this message translates to:
  /// **'Complete registration'**
  String get completeSignupBtnLabel;

  /// The label of the signup action button in a form
  ///
  /// In en, this message translates to:
  /// **'Create my account'**
  String get signupBtnLabel;

  /// No description provided for @signupScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Registering'**
  String get signupScreenTitle;

  /// No description provided for @completeSignupFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please fill your information'**
  String get completeSignupFormSubtitle;

  /// No description provided for @completeSignupFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Success'**
  String get completeSignupFormTitle;

  /// The text to be displayed when a signup attempt is in progress
  ///
  /// In en, this message translates to:
  /// **'Creating your account, please wait...'**
  String get signupInProgress;

  /// The text to be displayed when a signup attempt is in progress
  ///
  /// In en, this message translates to:
  /// **'Sending signup code, please wait...'**
  String get sendingSignupCodeInProgress;

  /// The title of an `ErrorDialog` displayed after a failed signup attempt
  ///
  /// In en, this message translates to:
  /// **'Signup failure'**
  String get signupFailureDialogTitle;

  /// Message shown on signup method selection screen
  ///
  /// In en, this message translates to:
  /// **'We will send a verification code to your email address:'**
  String get signupWithEmailMessage;

  /// Message shown on signup method selection screen
  ///
  /// In en, this message translates to:
  /// **'We will send a verification code to your phone number:'**
  String get signupWithPhoneMessage;

  /// Label for email signup button
  ///
  /// In en, this message translates to:
  /// **'I want to receive the code via email'**
  String get signupWithEmail;

  /// Label for phone signup button
  ///
  /// In en, this message translates to:
  /// **'I want to receive the code via SMS'**
  String get signupWithPhone;

  /// Error message shown when signup confirmation code field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter the confirmation code you recieved'**
  String get signupCodeIsRequired;

  /// Message shown when a signup code is sent to an email address
  ///
  /// In en, this message translates to:
  /// **'We have sent a signup code to your email address:'**
  String get signupCodeSentToEmail;

  /// Message shown when a signup code is sent to a phone number
  ///
  /// In en, this message translates to:
  /// **'We have sent a signup code to your phone number:'**
  String get signupCodeSentToPhone;

  /// Error message shown when the signup code is not the correct length
  ///
  /// In en, this message translates to:
  /// **'Signup code must be {length} characters long'**
  String signupCodeLengthIsInvalid(Object length);

  /// The label of the signup code field
  ///
  /// In en, this message translates to:
  /// **'Signup code'**
  String get signupCodeFieldLabel;

  /// The hint of the signup code field
  ///
  /// In en, this message translates to:
  /// **'Enter the code you received via email or phone'**
  String get signupCodeFieldHint;

  /// The title of the confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to go back?'**
  String get popConfirmationDialogTitle;

  /// The label of the stay on page button
  ///
  /// In en, this message translates to:
  /// **'Stay on page'**
  String get stayOnPageBtnLabel;

  /// The label of the go back button
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBackBtnLabel;

  /// The label of the open profile button
  ///
  /// In en, this message translates to:
  /// **'Open profile'**
  String get openProfileBtnLabel;

  /// No description provided for @nameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameFieldLabel;

  /// No description provided for @nameFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get nameFieldHint;

  /// No description provided for @nameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameIsRequired;

  /// No description provided for @timeNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get timeNow;

  /// No description provided for @timeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get timeYesterday;

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String timeHoursAgo(int hours);

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String timeDaysAgo(int days);

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get commonPublish;

  /// No description provided for @commonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get commonSubmit;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// No description provided for @commonResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get commonResults;

  /// No description provided for @commonViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get commonViewAll;

  /// No description provided for @commonLoadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more...'**
  String get commonLoadingMore;

  /// No description provided for @commonHotTopics.
  ///
  /// In en, this message translates to:
  /// **'Hot topics'**
  String get commonHotTopics;

  /// No description provided for @vechilesListFilterButton.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get vechilesListFilterButton;

  /// No description provided for @communityTitle.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get communityTitle;

  /// No description provided for @communityJoinToContribute.
  ///
  /// In en, this message translates to:
  /// **'Join to contribute'**
  String get communityJoinToContribute;

  /// No description provided for @communityAskQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get communityAskQuestion;

  /// No description provided for @communityAddReview.
  ///
  /// In en, this message translates to:
  /// **'Add a review'**
  String get communityAddReview;

  /// No description provided for @communityFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get communityFilterAll;

  /// No description provided for @communityFilterQuestions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get communityFilterQuestions;

  /// No description provided for @communityFilterReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get communityFilterReviews;

  /// No description provided for @communityNoContentTitle.
  ///
  /// In en, this message translates to:
  /// **'No content yet'**
  String get communityNoContentTitle;

  /// No description provided for @communityNoContentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start the conversation!'**
  String get communityNoContentSubtitle;

  /// No description provided for @communityNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get communityNoResultsTitle;

  /// No description provided for @communityNoResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords.'**
  String get communityNoResultsSubtitle;

  /// No description provided for @communitySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search the community'**
  String get communitySearchHint;

  /// No description provided for @communityQuestionsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get communityQuestionsCountLabel;

  /// No description provided for @communityReviewsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get communityReviewsCountLabel;

  /// No description provided for @trimCommunityReviewsTab.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get trimCommunityReviewsTab;

  /// No description provided for @trimCommunityQaTab.
  ///
  /// In en, this message translates to:
  /// **'Q&A'**
  String get trimCommunityQaTab;

  /// No description provided for @trimCommunityNoReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get trimCommunityNoReviews;

  /// No description provided for @trimCommunityNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No questions yet'**
  String get trimCommunityNoQuestions;

  /// No description provided for @sheetAskQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get sheetAskQuestionTitle;

  /// No description provided for @sheetAskQuestionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask the community and get help from owners.'**
  String get sheetAskQuestionSubtitle;

  /// No description provided for @sheetAddReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your review'**
  String get sheetAddReviewTitle;

  /// No description provided for @sheetAddReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your experience to help others.'**
  String get sheetAddReviewSubtitle;

  /// No description provided for @authRequiredToPostQuestion.
  ///
  /// In en, this message translates to:
  /// **'You must be signed in to ask a question.'**
  String get authRequiredToPostQuestion;

  /// No description provided for @authRequiredToPostReview.
  ///
  /// In en, this message translates to:
  /// **'You must be signed in to add a review.'**
  String get authRequiredToPostReview;

  /// No description provided for @authRequiredToPostAnswer.
  ///
  /// In en, this message translates to:
  /// **'You must be signed in to answer.'**
  String get authRequiredToPostAnswer;

  /// No description provided for @fieldTrimLabelRequired.
  ///
  /// In en, this message translates to:
  /// **'Car (trim) *'**
  String get fieldTrimLabelRequired;

  /// No description provided for @fieldTrimLabelOptional.
  ///
  /// In en, this message translates to:
  /// **'Car (trim)'**
  String get fieldTrimLabelOptional;

  /// No description provided for @fieldTrimTapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get fieldTrimTapToSelect;

  /// No description provided for @fieldQuestionTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Question title *'**
  String get fieldQuestionTitleLabel;

  /// No description provided for @fieldQuestionBodyLabel.
  ///
  /// In en, this message translates to:
  /// **'Question details *'**
  String get fieldQuestionBodyLabel;

  /// No description provided for @fieldReviewTitleLabelOptional.
  ///
  /// In en, this message translates to:
  /// **'Review title (optional)'**
  String get fieldReviewTitleLabelOptional;

  /// No description provided for @fieldReviewBodyLabel.
  ///
  /// In en, this message translates to:
  /// **'Review details *'**
  String get fieldReviewBodyLabel;

  /// No description provided for @fieldCityLabelOptional.
  ///
  /// In en, this message translates to:
  /// **'City (optional)'**
  String get fieldCityLabelOptional;

  /// No description provided for @buttonPublishQuestion.
  ///
  /// In en, this message translates to:
  /// **'Post question'**
  String get buttonPublishQuestion;

  /// No description provided for @buttonPublishReview.
  ///
  /// In en, this message translates to:
  /// **'Post review'**
  String get buttonPublishReview;

  /// No description provided for @buttonPostAnswer.
  ///
  /// In en, this message translates to:
  /// **'Post answer'**
  String get buttonPostAnswer;

  /// No description provided for @validationSelectTrim.
  ///
  /// In en, this message translates to:
  /// **'Please select a trim.'**
  String get validationSelectTrim;

  /// No description provided for @validationQuestionTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title.'**
  String get validationQuestionTitleRequired;

  /// No description provided for @validationQuestionTitleTooShort.
  ///
  /// In en, this message translates to:
  /// **'Title is too short.'**
  String get validationQuestionTitleTooShort;

  /// No description provided for @validationQuestionBodyRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter details.'**
  String get validationQuestionBodyRequired;

  /// No description provided for @validationQuestionBodyTooShort.
  ///
  /// In en, this message translates to:
  /// **'Details are too short.'**
  String get validationQuestionBodyTooShort;

  /// No description provided for @validationReviewBodyRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter review details.'**
  String get validationReviewBodyRequired;

  /// No description provided for @validationReviewBodyTooShort.
  ///
  /// In en, this message translates to:
  /// **'Details are too short.'**
  String get validationReviewBodyTooShort;

  /// No description provided for @reviewTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewTypeLabel;

  /// No description provided for @questionTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get questionTypeLabel;

  /// No description provided for @answerTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answerTypeLabel;

  /// No description provided for @reviewsRatingFormat.
  ///
  /// In en, this message translates to:
  /// **'{rating}/5'**
  String reviewsRatingFormat(int rating);

  /// No description provided for @trimPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a trim'**
  String get trimPickerTitle;

  /// No description provided for @trimPickerSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search trims...'**
  String get trimPickerSearchHint;

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by model or brand'**
  String get homeSearchHint;

  /// No description provided for @homeTrendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Trending now'**
  String get homeTrendingTitle;

  /// No description provided for @homeLatestQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest questions'**
  String get homeLatestQuestionsTitle;

  /// No description provided for @homeLatestReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest reviews'**
  String get homeLatestReviewsTitle;

  /// No description provided for @homeSearchResultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} results'**
  String homeSearchResultsCount(int count);

  /// No description provided for @commonFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get commonFeatured;

  /// No description provided for @vehiclesSearchNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get vehiclesSearchNoResultsTitle;

  /// No description provided for @vehiclesSearchNoResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term.'**
  String get vehiclesSearchNoResultsSubtitle;

  /// No description provided for @homeErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get homeErrorTitle;

  /// No description provided for @homeErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please try again.'**
  String get homeErrorSubtitle;

  /// No description provided for @vehicleDetailsRange.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get vehicleDetailsRange;

  /// No description provided for @vehicleDetailsBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get vehicleDetailsBattery;

  /// No description provided for @vehicleDetailsPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get vehicleDetailsPrice;

  /// No description provided for @vehicleDetailsSimilarTitle.
  ///
  /// In en, this message translates to:
  /// **'Similar cars'**
  String get vehicleDetailsSimilarTitle;

  /// No description provided for @vehicleDetailsAlsoLikedTitle.
  ///
  /// In en, this message translates to:
  /// **'People also liked'**
  String get vehicleDetailsAlsoLikedTitle;

  /// No description provided for @vehicleDetailsSpecsTitle.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get vehicleDetailsSpecsTitle;

  /// No description provided for @vehicleDetailsDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get vehicleDetailsDescriptionTitle;

  /// No description provided for @cityDamascus.
  ///
  /// In en, this message translates to:
  /// **'Damascus'**
  String get cityDamascus;

  /// No description provided for @cityAleppo.
  ///
  /// In en, this message translates to:
  /// **'Aleppo'**
  String get cityAleppo;

  /// No description provided for @cityHoms.
  ///
  /// In en, this message translates to:
  /// **'Homs'**
  String get cityHoms;

  /// No description provided for @cityHama.
  ///
  /// In en, this message translates to:
  /// **'Hama'**
  String get cityHama;

  /// No description provided for @cityLatakia.
  ///
  /// In en, this message translates to:
  /// **'Latakia'**
  String get cityLatakia;

  /// No description provided for @cityTartus.
  ///
  /// In en, this message translates to:
  /// **'Tartus'**
  String get cityTartus;

  /// No description provided for @profileMyActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'My activity'**
  String get profileMyActivityTitle;

  /// No description provided for @profileMyReviewsTab.
  ///
  /// In en, this message translates to:
  /// **'My reviews'**
  String get profileMyReviewsTab;

  /// No description provided for @profileMyQuestionsTab.
  ///
  /// In en, this message translates to:
  /// **'My questions'**
  String get profileMyQuestionsTab;

  /// No description provided for @profileMyAnsweredQuestionsTab.
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get profileMyAnsweredQuestionsTab;

  /// No description provided for @profileEmptyMyReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get profileEmptyMyReviewsTitle;

  /// No description provided for @profileEmptyMyReviewsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write your first review to help others.'**
  String get profileEmptyMyReviewsSubtitle;

  /// No description provided for @profileEmptyMyQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'No questions yet'**
  String get profileEmptyMyQuestionsTitle;

  /// No description provided for @profileEmptyMyQuestionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask your first question and get help from the community.'**
  String get profileEmptyMyQuestionsSubtitle;

  /// No description provided for @profileEmptyMyAnsweredTitle.
  ///
  /// In en, this message translates to:
  /// **'No answered questions yet'**
  String get profileEmptyMyAnsweredTitle;

  /// No description provided for @profileEmptyMyAnsweredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Answer questions to support the community.'**
  String get profileEmptyMyAnsweredSubtitle;

  /// No description provided for @profileBrowseCarsCta.
  ///
  /// In en, this message translates to:
  /// **'Browse cars'**
  String get profileBrowseCarsCta;

  /// No description provided for @profileAskQuestionCta.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get profileAskQuestionCta;

  /// No description provided for @profileBrowseCommunityCta.
  ///
  /// In en, this message translates to:
  /// **'Browse community'**
  String get profileBrowseCommunityCta;

  /// No description provided for @specGroupBatteryRange.
  ///
  /// In en, this message translates to:
  /// **'Battery & Range'**
  String get specGroupBatteryRange;

  /// No description provided for @specGroupCharging.
  ///
  /// In en, this message translates to:
  /// **'Charging'**
  String get specGroupCharging;

  /// No description provided for @specGroupPerformanceDrive.
  ///
  /// In en, this message translates to:
  /// **'Performance & Drivetrain'**
  String get specGroupPerformanceDrive;

  /// No description provided for @specGroupDimensionsPractical.
  ///
  /// In en, this message translates to:
  /// **'Dimensions & Practicality'**
  String get specGroupDimensionsPractical;

  /// No description provided for @specGroupEngineFuel.
  ///
  /// In en, this message translates to:
  /// **'Engine & Fuel'**
  String get specGroupEngineFuel;

  /// No description provided for @specGroupChassisTransmission.
  ///
  /// In en, this message translates to:
  /// **'Chassis & Transmission'**
  String get specGroupChassisTransmission;

  /// No description provided for @specGroupOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get specGroupOther;

  /// No description provided for @hotTopicsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No hot topics right now.'**
  String get hotTopicsEmpty;

  /// No description provided for @hotTopicsScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Most asked about models'**
  String get hotTopicsScreenSubtitle;

  /// No description provided for @hotTopicsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by make or model'**
  String get hotTopicsSearchHint;

  /// No description provided for @hotTopicsAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get hotTopicsAll;

  /// No description provided for @hotTopicsHotOnly.
  ///
  /// In en, this message translates to:
  /// **'Hot only'**
  String get hotTopicsHotOnly;

  /// No description provided for @modelQuestionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No questions for this model yet.'**
  String get modelQuestionsEmpty;

  /// No description provided for @hotTopicsTop3Label.
  ///
  /// In en, this message translates to:
  /// **'Top trending'**
  String get hotTopicsTop3Label;

  /// No description provided for @hotLabel.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get hotLabel;

  /// No description provided for @drawerAccountSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get drawerAccountSectionTitle;

  /// No description provided for @drawerSupportSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get drawerSupportSectionTitle;

  /// No description provided for @drawerPreferencesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get drawerPreferencesSectionTitle;

  /// No description provided for @drawerMyActivityTileLabel.
  ///
  /// In en, this message translates to:
  /// **'My Activity'**
  String get drawerMyActivityTileLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
