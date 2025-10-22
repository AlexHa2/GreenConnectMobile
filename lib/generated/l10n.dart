import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
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
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

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
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @hello_first.
  ///
  /// In en, this message translates to:
  /// **'Connect to'**
  String get hello_first;

  /// No description provided for @hello_second.
  ///
  /// In en, this message translates to:
  /// **'Green Future'**
  String get hello_second;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Green Connect'**
  String get welcome;

  /// No description provided for @welcome_login_primary.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcome_login_primary;

  /// No description provided for @welcome_login_secondary.
  ///
  /// In en, this message translates to:
  /// **'Login to continue your green journey'**
  String get welcome_login_secondary;

  /// No description provided for @welcome_register_primary.
  ///
  /// In en, this message translates to:
  /// **'Join Green Connect'**
  String get welcome_register_primary;

  /// No description provided for @welcome_register_secondary.
  ///
  /// In en, this message translates to:
  /// **'Start your sustainable journey today'**
  String get welcome_register_secondary;

  /// No description provided for @register_complete.
  ///
  /// In en, this message translates to:
  /// **'Register Complete'**
  String get register_complete;

  /// No description provided for @register_here.
  ///
  /// In en, this message translates to:
  /// **'Register here'**
  String get register_here;

  /// No description provided for @login_complete.
  ///
  /// In en, this message translates to:
  /// **'Login Complete'**
  String get login_complete;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @login_here.
  ///
  /// In en, this message translates to:
  /// **'Login here'**
  String get login_here;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have account ?'**
  String get already_have_account;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account ?'**
  String get dont_have_account;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @select_role.
  ///
  /// In en, this message translates to:
  /// **'Select Your Role'**
  String get select_role;

  /// No description provided for @select_image.
  ///
  /// In en, this message translates to:
  /// **'Select Your Image'**
  String get select_image;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @error_occurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error_occurred;

  /// No description provided for @error_all_field.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get error_all_field;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'upload'**
  String get upload;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @username_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get username_hint;

  /// No description provided for @phone_number_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phone_number_hint;

  /// No description provided for @otp_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your OTP'**
  String get otp_hint;

  /// No description provided for @house_hold.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get house_hold;

  /// No description provided for @collector.
  ///
  /// In en, this message translates to:
  /// **'Collector'**
  String get collector;

  /// No description provided for @profile_setup_primary.
  ///
  /// In en, this message translates to:
  /// **'Your green tree is growing'**
  String get profile_setup_primary;

  /// No description provided for @profile_setup.
  ///
  /// In en, this message translates to:
  /// **'Profile Setup'**
  String get profile_setup;

  /// No description provided for @profile_setup_step1.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 2'**
  String get profile_setup_step1;

  /// No description provided for @profile_setup_step2.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 2'**
  String get profile_setup_step2;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get location;

  /// No description provided for @street_address.
  ///
  /// In en, this message translates to:
  /// **'Street Address'**
  String get street_address;

  /// No description provided for @street_address_hint.
  ///
  /// In en, this message translates to:
  /// **'123 Green Street'**
  String get street_address_hint;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @city_hint.
  ///
  /// In en, this message translates to:
  /// **'Ho Chi Minh'**
  String get city_hint;

  /// No description provided for @zip_code.
  ///
  /// In en, this message translates to:
  /// **'Zip Code'**
  String get zip_code;

  /// No description provided for @zip_code_hint.
  ///
  /// In en, this message translates to:
  /// **'12345'**
  String get zip_code_hint;

  /// No description provided for @all_set.
  ///
  /// In en, this message translates to:
  /// **'All Set!'**
  String get all_set;

  /// No description provided for @all_set_message.
  ///
  /// In en, this message translates to:
  /// **'Your profile is ready. Let’s start making a difference together!'**
  String get all_set_message;

  /// No description provided for @make_an_impact.
  ///
  /// In en, this message translates to:
  /// **'Make an impact!'**
  String get make_an_impact;

  /// No description provided for @your_impact.
  ///
  /// In en, this message translates to:
  /// **'Your impact'**
  String get your_impact;

  /// No description provided for @keep_your_tree.
  ///
  /// In en, this message translates to:
  /// **'Keep recycling to grow your tree'**
  String get keep_your_tree;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get points;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @create_new.
  ///
  /// In en, this message translates to:
  /// **'Create New'**
  String get create_new;

  /// No description provided for @my_recycling_post.
  ///
  /// In en, this message translates to:
  /// **'My Recycling Post'**
  String get my_recycling_post;

  /// No description provided for @transaction_detail.
  ///
  /// In en, this message translates to:
  /// **'Transaction detail'**
  String get transaction_detail;

  /// No description provided for @see_all_posts.
  ///
  /// In en, this message translates to:
  /// **'List post'**
  String get see_all_posts;

  /// No description provided for @recycling.
  ///
  /// In en, this message translates to:
  /// **'Recycling'**
  String get recycling;

  /// No description provided for @post_title.
  ///
  /// In en, this message translates to:
  /// **'Post Title'**
  String get post_title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @pickup_address.
  ///
  /// In en, this message translates to:
  /// **'Pickup Address'**
  String get pickup_address;

  /// No description provided for @pickup_time.
  ///
  /// In en, this message translates to:
  /// **'Pickup Time'**
  String get pickup_time;

  /// No description provided for @add_scrap_items.
  ///
  /// In en, this message translates to:
  /// **'Add Scrap Items'**
  String get add_scrap_items;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weight;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @post_title_hint.
  ///
  /// In en, this message translates to:
  /// **'plastic package'**
  String get post_title_hint;

  /// No description provided for @description_hint.
  ///
  /// In en, this message translates to:
  /// **'container for used plastic bottles'**
  String get description_hint;

  /// No description provided for @pickup_addres_hint.
  ///
  /// In en, this message translates to:
  /// **'123 green street'**
  String get pickup_addres_hint;

  /// No description provided for @pickup_time_hint.
  ///
  /// In en, this message translates to:
  /// **'monday to friday 5 PM'**
  String get pickup_time_hint;

  /// No description provided for @quantity_hint.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get quantity_hint;

  /// No description provided for @weight_hint.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get weight_hint;

  /// No description provided for @scrap_item.
  ///
  /// In en, this message translates to:
  /// **'scrap item'**
  String get scrap_item;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'image'**
  String get image;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'vi':
      return SVi();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
