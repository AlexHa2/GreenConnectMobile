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

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

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
  /// **'notifications'**
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
  /// **'Step 1 of 3'**
  String get profile_setup_step1;

  /// No description provided for @profile_setup_step2.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 3'**
  String get profile_setup_step2;

  /// No description provided for @profile_setup_step3.
  ///
  /// In en, this message translates to:
  /// **'Step 3 of 3'**
  String get profile_setup_step3;

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

  /// No description provided for @street_address_location_hint.
  ///
  /// In en, this message translates to:
  /// **'600 Brasher Rd, Morgan City, St. Mary Parish, Louisiana, 70380 United States'**
  String get street_address_location_hint;

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

  /// No description provided for @are_you_sure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this post? This action cannot be undone.'**
  String get are_you_sure;

  /// No description provided for @reason_delete.
  ///
  /// In en, this message translates to:
  /// **'Reason for deletion (Optional)'**
  String get reason_delete;

  /// No description provided for @delete_hint.
  ///
  /// In en, this message translates to:
  /// **'Why are you deleting this post?'**
  String get delete_hint;

  /// No description provided for @search_by_name.
  ///
  /// In en, this message translates to:
  /// **'search by name'**
  String get search_by_name;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @posted.
  ///
  /// In en, this message translates to:
  /// **'Posted'**
  String get posted;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @network_error.
  ///
  /// In en, this message translates to:
  /// **'Network connection error'**
  String get network_error;

  /// No description provided for @server_error.
  ///
  /// In en, this message translates to:
  /// **'Server is not responding'**
  String get server_error;

  /// No description provided for @cache_error.
  ///
  /// In en, this message translates to:
  /// **'Cache read/write error'**
  String get cache_error;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized'**
  String get unauthorized;

  /// No description provided for @not_found.
  ///
  /// In en, this message translates to:
  /// **'Requested resource not found'**
  String get not_found;

  /// No description provided for @unexpected_error.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpected_error;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @theme_light.
  ///
  /// In en, this message translates to:
  /// **'Theme light'**
  String get theme_light;

  /// No description provided for @theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Theme dark'**
  String get theme_dark;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @help_center.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get help_center;

  /// No description provided for @change_your_phone.
  ///
  /// In en, this message translates to:
  /// **'Change your phone'**
  String get change_your_phone;

  /// No description provided for @faq_and_support.
  ///
  /// In en, this message translates to:
  /// **'FAQs and support'**
  String get faq_and_support;

  /// No description provided for @fullname.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullname;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @vi.
  ///
  /// In en, this message translates to:
  /// **'vietnamess'**
  String get vi;

  /// No description provided for @en.
  ///
  /// In en, this message translates to:
  /// **'english'**
  String get en;

  /// No description provided for @reward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get reward;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @keep_making_difference.
  ///
  /// In en, this message translates to:
  /// **'Keep making a difference'**
  String get keep_making_difference;

  /// No description provided for @this_week.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get this_week;

  /// No description provided for @rank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rank;

  /// No description provided for @achievement.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievement;

  /// No description provided for @view_all.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get view_all;

  /// No description provided for @redeem_rewards.
  ///
  /// In en, this message translates to:
  /// **'Redeem Rewards'**
  String get redeem_rewards;

  /// No description provided for @recent_activity.
  ///
  /// In en, this message translates to:
  /// **'Revent Activity'**
  String get recent_activity;

  /// No description provided for @view_all_history.
  ///
  /// In en, this message translates to:
  /// **'View All History'**
  String get view_all_history;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'value'**
  String get value;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @transaction_history.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transaction_history;

  /// No description provided for @reward_store.
  ///
  /// In en, this message translates to:
  /// **'Reward Store'**
  String get reward_store;

  /// No description provided for @your_point.
  ///
  /// In en, this message translates to:
  /// **'Your points'**
  String get your_point;

  /// No description provided for @cart_total.
  ///
  /// In en, this message translates to:
  /// **'Cart Total'**
  String get cart_total;

  /// No description provided for @redeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get redeem;

  /// No description provided for @items_redeemed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Items redeemed successfully!'**
  String get items_redeemed_successfully;

  /// No description provided for @accept_proposed_time.
  ///
  /// In en, this message translates to:
  /// **'Accept Proposed Time'**
  String get accept_proposed_time;

  /// No description provided for @by_complete_transaction.
  ///
  /// In en, this message translates to:
  /// **'By completing this transaction, you’re helping reduce waste'**
  String get by_complete_transaction;

  /// No description provided for @proposed_time.
  ///
  /// In en, this message translates to:
  /// **'Proposed Time'**
  String get proposed_time;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @select_meeting_time.
  ///
  /// In en, this message translates to:
  /// **'Select Meeting Time'**
  String get select_meeting_time;

  /// No description provided for @value_hint.
  ///
  /// In en, this message translates to:
  /// **'30'**
  String get value_hint;

  /// No description provided for @approve_transaction.
  ///
  /// In en, this message translates to:
  /// **'Approve Transaction'**
  String get approve_transaction;

  /// No description provided for @slogan_confirm_detail_1.
  ///
  /// In en, this message translates to:
  /// **'Both parties must confirm the weight and price'**
  String get slogan_confirm_detail_1;

  /// No description provided for @slogan_confirm_detail_2.
  ///
  /// In en, this message translates to:
  /// **'Together we’re making a difference'**
  String get slogan_confirm_detail_2;

  /// No description provided for @confirm_details.
  ///
  /// In en, this message translates to:
  /// **'Confirm Details'**
  String get confirm_details;

  /// No description provided for @how_was_your_transaction.
  ///
  /// In en, this message translates to:
  /// **'How was your transaction'**
  String get how_was_your_transaction;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @your_review.
  ///
  /// In en, this message translates to:
  /// **'Your Review'**
  String get your_review;

  /// No description provided for @your_review_hint.
  ///
  /// In en, this message translates to:
  /// **'Write your feedback...'**
  String get your_review_hint;

  /// No description provided for @report_an_issue.
  ///
  /// In en, this message translates to:
  /// **'Report an issue'**
  String get report_an_issue;

  /// No description provided for @attach_photo.
  ///
  /// In en, this message translates to:
  /// **'Attach Photo'**
  String get attach_photo;

  /// No description provided for @tap_to_upload_photo.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload photo'**
  String get tap_to_upload_photo;

  /// No description provided for @decribe_your_issue_hint.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue....'**
  String get decribe_your_issue_hint;

  /// No description provided for @submit_feedback.
  ///
  /// In en, this message translates to:
  /// **'Submi Feedback'**
  String get submit_feedback;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @message_hint.
  ///
  /// In en, this message translates to:
  /// **'Message .....'**
  String get message_hint;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @invalid_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalid_phone_number;

  /// No description provided for @invalid_otp_message.
  ///
  /// In en, this message translates to:
  /// **'OTP is not invalid'**
  String get invalid_otp_message;

  /// No description provided for @invalid_phone_number_length.
  ///
  /// In en, this message translates to:
  /// **'phone number must be lager 9 numbers'**
  String get invalid_phone_number_length;

  /// No description provided for @resend_otp.
  ///
  /// In en, this message translates to:
  /// **'Resend otp'**
  String get resend_otp;

  /// No description provided for @enter_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enter_phone_number;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @enter_the_code.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to the number'**
  String get enter_the_code;

  /// No description provided for @didnt_get_code.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code?'**
  String get didnt_get_code;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @state_province.
  ///
  /// In en, this message translates to:
  /// **'State province'**
  String get state_province;

  /// No description provided for @state_province_hint.
  ///
  /// In en, this message translates to:
  /// **'California'**
  String get state_province_hint;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @country_hint.
  ///
  /// In en, this message translates to:
  /// **'vietnam'**
  String get country_hint;

  /// No description provided for @ward_commune.
  ///
  /// In en, this message translates to:
  /// **'Ward / Commune'**
  String get ward_commune;

  /// No description provided for @ward_commune_hint.
  ///
  /// In en, this message translates to:
  /// **'ward'**
  String get ward_commune_hint;

  /// No description provided for @personal_information.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_information;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'FullName'**
  String get fullName;

  /// No description provided for @fullName_hint.
  ///
  /// In en, this message translates to:
  /// **'Alex ha'**
  String get fullName_hint;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get date_of_birth;

  /// No description provided for @date_of_birth_hint.
  ///
  /// In en, this message translates to:
  /// **'2025-11-19'**
  String get date_of_birth_hint;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @street_address_error.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get street_address_error;

  /// No description provided for @ward_commune_error.
  ///
  /// In en, this message translates to:
  /// **'Enter ward commune'**
  String get ward_commune_error;

  /// No description provided for @state_province_error.
  ///
  /// In en, this message translates to:
  /// **'Enter state province'**
  String get state_province_error;

  /// No description provided for @zip_code_error.
  ///
  /// In en, this message translates to:
  /// **'Enter zip code'**
  String get zip_code_error;

  /// No description provided for @country_error.
  ///
  /// In en, this message translates to:
  /// **'Enter country error'**
  String get country_error;

  /// No description provided for @street_address_length_error.
  ///
  /// In en, this message translates to:
  /// **'Must be less than 50 charactors'**
  String get street_address_length_error;

  /// No description provided for @ward_commune_length_error.
  ///
  /// In en, this message translates to:
  /// **'Must be less than 50 charactors'**
  String get ward_commune_length_error;

  /// No description provided for @state_province_length_error.
  ///
  /// In en, this message translates to:
  /// **'Must be less than 50 charactors'**
  String get state_province_length_error;

  /// No description provided for @zip_code_format_error.
  ///
  /// In en, this message translates to:
  /// **'Zip code invalid format ex: 12345-6789'**
  String get zip_code_format_error;

  /// No description provided for @country_length_error.
  ///
  /// In en, this message translates to:
  /// **'Must be less than 50 charactors'**
  String get country_length_error;

  /// No description provided for @an_error_occurred_please_try_again.
  ///
  /// In en, this message translates to:
  /// **'an error occurred please try again'**
  String get an_error_occurred_please_try_again;

  /// No description provided for @fullName_error.
  ///
  /// In en, this message translates to:
  /// **'Enter fullname please!'**
  String get fullName_error;

  /// No description provided for @fullName_length_error.
  ///
  /// In en, this message translates to:
  /// **'Must be larger than 2 charactors'**
  String get fullName_length_error;

  /// No description provided for @gender_error.
  ///
  /// In en, this message translates to:
  /// **'Choose gender'**
  String get gender_error;

  /// No description provided for @date_of_birth_error.
  ///
  /// In en, this message translates to:
  /// **'Choose date of birth'**
  String get date_of_birth_error;

  /// No description provided for @fullname_required.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullname_required;

  /// No description provided for @max_length_255.
  ///
  /// In en, this message translates to:
  /// **'Must not exceed 255 characters'**
  String get max_length_255;

  /// No description provided for @phone_required.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phone_required;

  /// No description provided for @phone_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get phone_invalid;

  /// No description provided for @phone_invalid_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number format'**
  String get phone_invalid_format;

  /// No description provided for @address_required.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get address_required;

  /// No description provided for @gender_required.
  ///
  /// In en, this message translates to:
  /// **'Please select a gender'**
  String get gender_required;

  /// No description provided for @prefer_not_to_say.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get prefer_not_to_say;

  /// No description provided for @dob_required.
  ///
  /// In en, this message translates to:
  /// **'Please select a date of birth'**
  String get dob_required;

  /// No description provided for @dob_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid date of birth'**
  String get dob_invalid;

  /// No description provided for @age_must_be_13.
  ///
  /// In en, this message translates to:
  /// **'Age must be at least 13'**
  String get age_must_be_13;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @please_wait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get please_wait;

  /// No description provided for @profile_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profile_updated_successfully;

  /// No description provided for @error_occurred_while_updating_profile.
  ///
  /// In en, this message translates to:
  /// **'error occurred while updating profile'**
  String get error_occurred_while_updating_profile;

  /// No description provided for @error_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get error_required;

  /// No description provided for @error_invalid_length.
  ///
  /// In en, this message translates to:
  /// **'Too short'**
  String get error_invalid_length;

  /// No description provided for @error_post_title_min.
  ///
  /// In en, this message translates to:
  /// **'Title must be at least 3 characters'**
  String get error_post_title_min;

  /// No description provided for @error_description_min.
  ///
  /// In en, this message translates to:
  /// **'Description must be at least 10 characters'**
  String get error_description_min;

  /// No description provided for @error_pickup_address_min.
  ///
  /// In en, this message translates to:
  /// **'Address must be at least 5 characters'**
  String get error_pickup_address_min;

  /// No description provided for @error_number_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get error_number_invalid;

  /// No description provided for @error_quantity_invalid.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be greater than 0'**
  String get error_quantity_invalid;

  /// No description provided for @error_weight_invalid.
  ///
  /// In en, this message translates to:
  /// **'Weight must be greater than 0'**
  String get error_weight_invalid;

  /// No description provided for @error_select_category.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get error_select_category;

  /// No description provided for @error_scrap_item_empty.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one scrap item to continue'**
  String get error_scrap_item_empty;

  /// No description provided for @success_post_created.
  ///
  /// In en, this message translates to:
  /// **'Post created successfully!'**
  String get success_post_created;

  /// No description provided for @too_many_request_error.
  ///
  /// In en, this message translates to:
  /// **'You have sent too many requests. Please try again later.'**
  String get too_many_request_error;

  /// No description provided for @network_error_message.
  ///
  /// In en, this message translates to:
  /// **'Network error, please check your connection.'**
  String get network_error_message;

  /// No description provided for @unknown_error.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred. Please try again.'**
  String get unknown_error;

  /// No description provided for @error_general.
  ///
  /// In en, this message translates to:
  /// **'Unsuccessful!'**
  String get error_general;

  /// No description provided for @error_invalid_address.
  ///
  /// In en, this message translates to:
  /// **'Please search and confirm address!'**
  String get error_invalid_address;

  /// No description provided for @take_all.
  ///
  /// In en, this message translates to:
  /// **'Must take all'**
  String get take_all;

  /// No description provided for @take_all_description.
  ///
  /// In en, this message translates to:
  /// **'Collector must take all items'**
  String get take_all_description;

  /// No description provided for @address_not_found.
  ///
  /// In en, this message translates to:
  /// **'Address not found!!!'**
  String get address_not_found;

  /// No description provided for @address_invalid.
  ///
  /// In en, this message translates to:
  /// **'Address is invalid'**
  String get address_invalid;

  /// No description provided for @address_found.
  ///
  /// In en, this message translates to:
  /// **'Address was found'**
  String get address_found;

  /// No description provided for @error_invalid_number.
  ///
  /// In en, this message translates to:
  /// **'Must be large than 0'**
  String get error_invalid_number;

  /// No description provided for @error_no_internet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get error_no_internet;

  /// No description provided for @error_session_expired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please log in again.'**
  String get error_session_expired;

  /// No description provided for @error_server_error.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get error_server_error;

  /// No description provided for @error_unknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get error_unknown;

  /// No description provided for @error_category_exists.
  ///
  /// In en, this message translates to:
  /// **'Category is existed, choose another'**
  String get error_category_exists;

  /// No description provided for @no_post_found.
  ///
  /// In en, this message translates to:
  /// **'no post found'**
  String get no_post_found;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @partially_booked.
  ///
  /// In en, this message translates to:
  /// **'Partially Booked'**
  String get partially_booked;

  /// No description provided for @fully_booked.
  ///
  /// In en, this message translates to:
  /// **'Fully Booked'**
  String get fully_booked;

  /// No description provided for @canceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get canceled;

  /// No description provided for @unknown_status.
  ///
  /// In en, this message translates to:
  /// **'Unknown Status'**
  String get unknown_status;

  /// No description provided for @you_have_no_recycling_posts.
  ///
  /// In en, this message translates to:
  /// **'You have no posts yet'**
  String get you_have_no_recycling_posts;

  /// No description provided for @start_sharing_recycling_posts.
  ///
  /// In en, this message translates to:
  /// **'Start sharing recycling posts'**
  String get start_sharing_recycling_posts;

  /// No description provided for @view_details.
  ///
  /// In en, this message translates to:
  /// **'View detail'**
  String get view_details;

  /// No description provided for @go_to_transaction.
  ///
  /// In en, this message translates to:
  /// **'Go transaction'**
  String get go_to_transaction;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @error_scrap_category.
  ///
  /// In en, this message translates to:
  /// **'Only one material type per post'**
  String get error_scrap_category;

  /// No description provided for @just_now.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get just_now;

  /// No description provided for @minutes_ago.
  ///
  /// In en, this message translates to:
  /// **'minutes ago'**
  String get minutes_ago;

  /// No description provided for @hours_ago.
  ///
  /// In en, this message translates to:
  /// **'hours ago'**
  String get hours_ago;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get yesterday;

  /// No description provided for @days_ago.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get days_ago;

  /// No description provided for @booked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get booked;

  /// No description provided for @collected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get collected;

  /// No description provided for @successfully.
  ///
  /// In en, this message translates to:
  /// **'successfully'**
  String get successfully;

  /// No description provided for @error_delete_post.
  ///
  /// In en, this message translates to:
  /// **'This post cannot be deleted(processing or completed).'**
  String get error_delete_post;

  /// No description provided for @must_take_all.
  ///
  /// In en, this message translates to:
  /// **'Must take all'**
  String get must_take_all;

  /// No description provided for @must_take_all_desc.
  ///
  /// In en, this message translates to:
  /// **'Collectors must take all items listed below.'**
  String get must_take_all_desc;
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
