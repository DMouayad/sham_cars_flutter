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

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! we hope you are well'**
  String get homeGreeting;

  /// No description provided for @homeSearchBarHint.
  ///
  /// In en, this message translates to:
  /// **'search for a doctor, hospital or any medical care facility'**
  String get homeSearchBarHint;

  /// No description provided for @homeSpecialtiesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical specialties'**
  String get homeSpecialtiesSectionTitle;

  /// No description provided for @homeFacilitiesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Facilities near you'**
  String get homeFacilitiesSectionTitle;

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

  /// No description provided for @doctorSearchFilter.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctorSearchFilter;

  /// No description provided for @facilitySearchFilter.
  ///
  /// In en, this message translates to:
  /// **'Medical Facilities'**
  String get facilitySearchFilter;

  /// No description provided for @allSearchFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allSearchFilter;

  /// No description provided for @searchFiltersSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get searchFiltersSectionTitle;

  /// No description provided for @citySearchFilterPopupLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get citySearchFilterPopupLabel;

  /// No description provided for @specialtySearchFilterPopupLabel.
  ///
  /// In en, this message translates to:
  /// **'Medical specialty'**
  String get specialtySearchFilterPopupLabel;

  /// No description provided for @categorySearchFilterPopupLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categorySearchFilterPopupLabel;

  /// No description provided for @editFiltersBtnLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editFiltersBtnLabel;

  /// No description provided for @applyFiltersBtnLabel.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyFiltersBtnLabel;

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
  /// **'Please verify your phone number'**
  String get phoneVerificationScreenTitle;

  /// No description provided for @phoneVerificationErrorDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to verify your phone'**
  String get phoneVerificationErrorDialogTitle;

  /// The main title in the screen
  ///
  /// In en, this message translates to:
  /// **'This help us confirm your identity & protect your account'**
  String get phoneVerificationScreenSubtitle;

  /// No description provided for @phoneVerificationCodeWasSent.
  ///
  /// In en, this message translates to:
  /// **'Please enter the verification code sent to '**
  String get phoneVerificationCodeWasSent;

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
  /// **'Wrong number?'**
  String get wrongNumberToVerify;

  /// The label of a text button for changing the phone number in verification screen
  ///
  /// In en, this message translates to:
  /// **'go back to change it'**
  String get changeNumberToVerify;

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

  /// No description provided for @sheetDragUpHint.
  ///
  /// In en, this message translates to:
  /// **'Swap up to view full information'**
  String get sheetDragUpHint;

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

  /// No description provided for @ophthalmology.
  ///
  /// In en, this message translates to:
  /// **'Ophthalmology'**
  String get ophthalmology;

  /// No description provided for @neurology.
  ///
  /// In en, this message translates to:
  /// **'Neurology'**
  String get neurology;

  /// No description provided for @dentistry.
  ///
  /// In en, this message translates to:
  /// **'Dentistry'**
  String get dentistry;

  /// No description provided for @cardiology.
  ///
  /// In en, this message translates to:
  /// **'Cardiology'**
  String get cardiology;

  /// No description provided for @familyMedicine.
  ///
  /// In en, this message translates to:
  /// **'Family Medicine'**
  String get familyMedicine;

  /// No description provided for @prosthetics.
  ///
  /// In en, this message translates to:
  /// **'Prosthetics'**
  String get prosthetics;

  /// Message shown on signup method selection screen
  ///
  /// In en, this message translates to:
  /// **'Please choose how you would like to create your account'**
  String get chooseSignupMethodMessage;

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
