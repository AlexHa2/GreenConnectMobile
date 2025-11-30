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
  /// **'Location'**
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
  /// **'View Details'**
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

  /// No description provided for @cannot_get_uploadurl.
  ///
  /// In en, this message translates to:
  /// **'Cannot get upload URL'**
  String get cannot_get_uploadurl;

  /// No description provided for @error_occurred_while_updating_avatar.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while updating avatar'**
  String get error_occurred_while_updating_avatar;

  /// No description provided for @avatar_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Avatar updated successfully'**
  String get avatar_updated_successfully;

  /// No description provided for @upgrade_to_collector.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Collector'**
  String get upgrade_to_collector;

  /// No description provided for @account_verification.
  ///
  /// In en, this message translates to:
  /// **'Account Verification'**
  String get account_verification;

  /// No description provided for @cccd_guide_text.
  ///
  /// In en, this message translates to:
  /// **'Please upload high-quality images of your ID card for verification.'**
  String get cccd_guide_text;

  /// No description provided for @front_image.
  ///
  /// In en, this message translates to:
  /// **'Front Side'**
  String get front_image;

  /// No description provided for @back_image.
  ///
  /// In en, this message translates to:
  /// **'Back Side'**
  String get back_image;

  /// No description provided for @upload_image.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get upload_image;

  /// No description provided for @submit_verification.
  ///
  /// In en, this message translates to:
  /// **'Submit Verification'**
  String get submit_verification;

  /// No description provided for @cccd_upload_warning.
  ///
  /// In en, this message translates to:
  /// **'Please upload both sides of your ID!'**
  String get cccd_upload_warning;

  /// No description provided for @cccd_submit_success.
  ///
  /// In en, this message translates to:
  /// **'Submitting verification request...'**
  String get cccd_submit_success;

  /// No description provided for @cccd_warning_rules.
  ///
  /// In en, this message translates to:
  /// **'Do not cover your face, avoid blur, and do not take angled shots.\nVerification time: 24 - 48 hours.'**
  String get cccd_warning_rules;

  /// No description provided for @buyer_type.
  ///
  /// In en, this message translates to:
  /// **'Buyer type'**
  String get buyer_type;

  /// No description provided for @buyer_type_individual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get buyer_type_individual;

  /// No description provided for @buyer_type_business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get buyer_type_business;

  /// No description provided for @update_verification.
  ///
  /// In en, this message translates to:
  /// **'Update Verification'**
  String get update_verification;

  /// No description provided for @verification_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Verification updated successfully'**
  String get verification_updated_successfully;

  /// No description provided for @update_account_type.
  ///
  /// In en, this message translates to:
  /// **'Update Account Type'**
  String get update_account_type;

  /// No description provided for @switch_account_type.
  ///
  /// In en, this message translates to:
  /// **'Switch Account Type'**
  String get switch_account_type;

  /// No description provided for @send_verification_info.
  ///
  /// In en, this message translates to:
  /// **'send verification info successfully'**
  String get send_verification_info;

  /// No description provided for @login_error.
  ///
  /// In en, this message translates to:
  /// **'Login unsuccessful, try it again'**
  String get login_error;

  /// No description provided for @individual_collector.
  ///
  /// In en, this message translates to:
  /// **'Individual Collector'**
  String get individual_collector;

  /// No description provided for @business_collector.
  ///
  /// In en, this message translates to:
  /// **'Business Collector'**
  String get business_collector;

  /// No description provided for @household_role.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get household_role;

  /// No description provided for @view_offers.
  ///
  /// In en, this message translates to:
  /// **'View offers'**
  String get view_offers;

  /// No description provided for @all_offers.
  ///
  /// In en, this message translates to:
  /// **'All Offers'**
  String get all_offers;

  /// No description provided for @post_offers.
  ///
  /// In en, this message translates to:
  /// **'Post Offers'**
  String get post_offers;

  /// No description provided for @no_offers_found.
  ///
  /// In en, this message translates to:
  /// **'No Offers Found'**
  String get no_offers_found;

  /// No description provided for @no_offers_yet.
  ///
  /// In en, this message translates to:
  /// **'No {status} offers yet'**
  String no_offers_yet(Object status);

  /// No description provided for @no_offers_available.
  ///
  /// In en, this message translates to:
  /// **'No offers available at the moment'**
  String get no_offers_available;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get try_again;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @items_count.
  ///
  /// In en, this message translates to:
  /// **'{count} Item'**
  String items_count(Object count);

  /// No description provided for @items_count_plural.
  ///
  /// In en, this message translates to:
  /// **'{count} Items'**
  String items_count_plural(Object count);

  /// No description provided for @schedules_count.
  ///
  /// In en, this message translates to:
  /// **'{count} Schedule'**
  String schedules_count(Object count);

  /// No description provided for @schedules_count_plural.
  ///
  /// In en, this message translates to:
  /// **'{count} Schedules'**
  String schedules_count_plural(Object count);

  /// No description provided for @pricing_details.
  ///
  /// In en, this message translates to:
  /// **'Pricing Details:'**
  String get pricing_details;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @more_items.
  ///
  /// In en, this message translates to:
  /// **'+{count} more items'**
  String more_items(Object count);

  /// No description provided for @minutes_short.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutes_short(Object count);

  /// No description provided for @hours_short.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hours_short(Object count);

  /// No description provided for @days_short.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String days_short(Object count);

  /// No description provided for @per_unit.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get per_unit;

  /// No description provided for @offer_details.
  ///
  /// In en, this message translates to:
  /// **'Offer Details'**
  String get offer_details;

  /// No description provided for @collector_information.
  ///
  /// In en, this message translates to:
  /// **'Collector Information'**
  String get collector_information;

  /// No description provided for @pricing_information.
  ///
  /// In en, this message translates to:
  /// **'Pricing Information'**
  String get pricing_information;

  /// No description provided for @schedule_proposals.
  ///
  /// In en, this message translates to:
  /// **'Schedule Proposals'**
  String get schedule_proposals;

  /// No description provided for @post_information.
  ///
  /// In en, this message translates to:
  /// **'Post Information'**
  String get post_information;

  /// No description provided for @no_pricing_info.
  ///
  /// In en, this message translates to:
  /// **'No pricing information available'**
  String get no_pricing_info;

  /// No description provided for @no_schedules.
  ///
  /// In en, this message translates to:
  /// **'No schedule proposals'**
  String get no_schedules;

  /// No description provided for @no_post_info.
  ///
  /// In en, this message translates to:
  /// **'Post information not available'**
  String get no_post_info;

  /// No description provided for @contact_collector.
  ///
  /// In en, this message translates to:
  /// **'Contact Collector'**
  String get contact_collector;

  /// No description provided for @accept_offer.
  ///
  /// In en, this message translates to:
  /// **'Accept Offer'**
  String get accept_offer;

  /// No description provided for @reject_offer.
  ///
  /// In en, this message translates to:
  /// **'Reject Offer'**
  String get reject_offer;

  /// No description provided for @cancel_offer.
  ///
  /// In en, this message translates to:
  /// **'Cancel Offer'**
  String get cancel_offer;

  /// No description provided for @restore_offer.
  ///
  /// In en, this message translates to:
  /// **'Restore Offer'**
  String get restore_offer;

  /// No description provided for @confirm_accept.
  ///
  /// In en, this message translates to:
  /// **'Confirm Accept'**
  String get confirm_accept;

  /// No description provided for @confirm_reject.
  ///
  /// In en, this message translates to:
  /// **'Confirm Reject'**
  String get confirm_reject;

  /// No description provided for @confirm_cancel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cancel'**
  String get confirm_cancel;

  /// No description provided for @accept_offer_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to accept this offer?'**
  String get accept_offer_message;

  /// No description provided for @reject_offer_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this offer?'**
  String get reject_offer_message;

  /// No description provided for @cancel_offer_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this offer?'**
  String get cancel_offer_message;

  /// No description provided for @restore_offer_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore this offer?'**
  String get restore_offer_message;

  /// No description provided for @offer_accepted_success.
  ///
  /// In en, this message translates to:
  /// **'Offer accepted successfully'**
  String get offer_accepted_success;

  /// No description provided for @offer_rejected_success.
  ///
  /// In en, this message translates to:
  /// **'Offer rejected successfully'**
  String get offer_rejected_success;

  /// No description provided for @offer_canceled_success.
  ///
  /// In en, this message translates to:
  /// **'Offer canceled successfully'**
  String get offer_canceled_success;

  /// No description provided for @offer_restored_success.
  ///
  /// In en, this message translates to:
  /// **'Offer restored successfully'**
  String get offer_restored_success;

  /// No description provided for @action_failed.
  ///
  /// In en, this message translates to:
  /// **'Action failed'**
  String get action_failed;

  /// No description provided for @member_since.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String member_since(Object date);

  /// No description provided for @response_message.
  ///
  /// In en, this message translates to:
  /// **'Response'**
  String get response_message;

  /// No description provided for @no_response.
  ///
  /// In en, this message translates to:
  /// **'No response yet'**
  String get no_response;

  /// No description provided for @total_amount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get total_amount;

  /// No description provided for @estimated_total.
  ///
  /// In en, this message translates to:
  /// **'Estimated: {amount} VND'**
  String estimated_total(Object amount);

  /// No description provided for @post_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get post_description;

  /// No description provided for @posted_at.
  ///
  /// In en, this message translates to:
  /// **'Posted at'**
  String get posted_at;

  /// No description provided for @offer_created_at.
  ///
  /// In en, this message translates to:
  /// **'Offer created'**
  String get offer_created_at;

  /// No description provided for @scheduleListTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get scheduleListTitle;

  /// No description provided for @scheduleStatusAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get scheduleStatusAll;

  /// No description provided for @scheduleStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get scheduleStatusPending;

  /// No description provided for @scheduleStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get scheduleStatusAccepted;

  /// No description provided for @scheduleStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get scheduleStatusRejected;

  /// No description provided for @scheduleStatusCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get scheduleStatusCanceled;

  /// No description provided for @scheduleEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No schedules found'**
  String get scheduleEmptyMessage;

  /// No description provided for @scheduleCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get scheduleCreatedAt;

  /// No description provided for @scheduleDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule Details'**
  String get scheduleDetailTitle;

  /// No description provided for @scheduleProposedTime.
  ///
  /// In en, this message translates to:
  /// **'Proposed Time'**
  String get scheduleProposedTime;

  /// No description provided for @scheduleResponseMessage.
  ///
  /// In en, this message translates to:
  /// **'Response Message'**
  String get scheduleResponseMessage;

  /// No description provided for @scheduleNoResponse.
  ///
  /// In en, this message translates to:
  /// **'No response'**
  String get scheduleNoResponse;

  /// No description provided for @scheduleAcceptButton.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get scheduleAcceptButton;

  /// No description provided for @scheduleRejectButton.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get scheduleRejectButton;

  /// No description provided for @scheduleCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get scheduleCancelButton;

  /// No description provided for @scheduleRestoreButton.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get scheduleRestoreButton;

  /// No description provided for @scheduleRescheduleButton.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get scheduleRescheduleButton;

  /// No description provided for @scheduleConfirmAccept.
  ///
  /// In en, this message translates to:
  /// **'Confirm Accept Schedule'**
  String get scheduleConfirmAccept;

  /// No description provided for @scheduleConfirmReject.
  ///
  /// In en, this message translates to:
  /// **'Confirm Reject Schedule'**
  String get scheduleConfirmReject;

  /// No description provided for @scheduleConfirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cancel Schedule'**
  String get scheduleConfirmCancel;

  /// No description provided for @scheduleAcceptMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to accept this schedule?'**
  String get scheduleAcceptMessage;

  /// No description provided for @scheduleRejectMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this schedule?'**
  String get scheduleRejectMessage;

  /// No description provided for @scheduleCancelMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this schedule?'**
  String get scheduleCancelMessage;

  /// No description provided for @scheduleAcceptSuccess.
  ///
  /// In en, this message translates to:
  /// **'Schedule accepted successfully'**
  String get scheduleAcceptSuccess;

  /// No description provided for @scheduleRejectSuccess.
  ///
  /// In en, this message translates to:
  /// **'Schedule rejected successfully'**
  String get scheduleRejectSuccess;

  /// No description provided for @scheduleAcceptNote.
  ///
  /// In en, this message translates to:
  /// **'Use \'Accept Offer\' button below to accept schedule'**
  String get scheduleAcceptNote;

  /// No description provided for @scheduleRejectShort.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get scheduleRejectShort;

  /// No description provided for @scheduleCancelSuccess.
  ///
  /// In en, this message translates to:
  /// **'Schedule canceled successfully'**
  String get scheduleCancelSuccess;

  /// No description provided for @scheduleRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Schedule restored successfully'**
  String get scheduleRestoreSuccess;

  /// No description provided for @scheduleUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Schedule updated successfully'**
  String get scheduleUpdateSuccess;

  /// No description provided for @schedule_hint_swipe_to_reject.
  ///
  /// In en, this message translates to:
  /// **'Use the \'Accept Proposal\' button below to accept the schedule'**
  String get schedule_hint_swipe_to_reject;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @my_transactions.
  ///
  /// In en, this message translates to:
  /// **'My Transactions'**
  String get my_transactions;

  /// No description provided for @transaction_details.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transaction_details;

  /// No description provided for @transaction_id.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transaction_id;

  /// No description provided for @transaction_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get transaction_status;

  /// No description provided for @scheduled_time.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Time'**
  String get scheduled_time;

  /// No description provided for @check_in_time.
  ///
  /// In en, this message translates to:
  /// **'Check-in Time'**
  String get check_in_time;

  /// No description provided for @completed_time.
  ///
  /// In en, this message translates to:
  /// **'Completed Time'**
  String get completed_time;

  /// No description provided for @collector_info.
  ///
  /// In en, this message translates to:
  /// **'Collector Information'**
  String get collector_info;

  /// No description provided for @household_info.
  ///
  /// In en, this message translates to:
  /// **'Household Information'**
  String get household_info;

  /// No description provided for @transaction_items.
  ///
  /// In en, this message translates to:
  /// **'Transaction Items'**
  String get transaction_items;

  /// No description provided for @total_weight.
  ///
  /// In en, this message translates to:
  /// **'Total Weight'**
  String get total_weight;

  /// No description provided for @total_value.
  ///
  /// In en, this message translates to:
  /// **'Total Value'**
  String get total_value;

  /// No description provided for @collector_note.
  ///
  /// In en, this message translates to:
  /// **'Collector Note'**
  String get collector_note;

  /// No description provided for @household_note.
  ///
  /// In en, this message translates to:
  /// **'Household Note'**
  String get household_note;

  /// No description provided for @check_in.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get check_in;

  /// No description provided for @input_details.
  ///
  /// In en, this message translates to:
  /// **'Input Details'**
  String get input_details;

  /// No description provided for @process_transaction.
  ///
  /// In en, this message translates to:
  /// **'Process Transaction'**
  String get process_transaction;

  /// No description provided for @cancel_transaction.
  ///
  /// In en, this message translates to:
  /// **'Cancel Transaction'**
  String get cancel_transaction;

  /// No description provided for @provide_feedback.
  ///
  /// In en, this message translates to:
  /// **'Provide Feedback'**
  String get provide_feedback;

  /// No description provided for @transaction_feedbacks.
  ///
  /// In en, this message translates to:
  /// **'Feedbacks'**
  String get transaction_feedbacks;

  /// No description provided for @in_progress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get in_progress;

  /// No description provided for @awaiting_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Confirmation'**
  String get awaiting_confirmation;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @check_in_success.
  ///
  /// In en, this message translates to:
  /// **'Checked in successfully'**
  String get check_in_success;

  /// No description provided for @check_in_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Check-in'**
  String get check_in_confirm;

  /// No description provided for @check_in_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to check in at this location?'**
  String get check_in_message;

  /// No description provided for @input_details_title.
  ///
  /// In en, this message translates to:
  /// **'Input Transaction Details'**
  String get input_details_title;

  /// No description provided for @enter_weight.
  ///
  /// In en, this message translates to:
  /// **'Enter Weight (kg)'**
  String get enter_weight;

  /// No description provided for @enter_value.
  ///
  /// In en, this message translates to:
  /// **'Enter Value (\$)'**
  String get enter_value;

  /// No description provided for @enter_note.
  ///
  /// In en, this message translates to:
  /// **'Enter Note (Optional)'**
  String get enter_note;

  /// No description provided for @details_saved.
  ///
  /// In en, this message translates to:
  /// **'Details saved successfully'**
  String get details_saved;

  /// No description provided for @approve_confirm.
  ///
  /// In en, this message translates to:
  /// **'Approve Transaction'**
  String get approve_confirm;

  /// No description provided for @reject_confirm.
  ///
  /// In en, this message translates to:
  /// **'Reject Transaction'**
  String get reject_confirm;

  /// No description provided for @approve_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to approve this transaction?'**
  String get approve_message;

  /// No description provided for @reject_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this transaction?'**
  String get reject_message;

  /// No description provided for @transaction_approved.
  ///
  /// In en, this message translates to:
  /// **'Transaction approved successfully'**
  String get transaction_approved;

  /// No description provided for @transaction_rejected.
  ///
  /// In en, this message translates to:
  /// **'Transaction rejected successfully'**
  String get transaction_rejected;

  /// No description provided for @cancel_confirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel Transaction'**
  String get cancel_confirm;

  /// No description provided for @cancel_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this transaction?'**
  String get cancel_message;

  /// No description provided for @transaction_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Transaction cancelled successfully'**
  String get transaction_cancelled;

  /// No description provided for @feedback_submitted.
  ///
  /// In en, this message translates to:
  /// **'Feedback submitted successfully'**
  String get feedback_submitted;

  /// No description provided for @no_transactions_found.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get no_transactions_found;

  /// No description provided for @pull_to_refresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pull_to_refresh;

  /// No description provided for @refreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get refreshing;

  /// No description provided for @scrap_type.
  ///
  /// In en, this message translates to:
  /// **'Scrap Type'**
  String get scrap_type;

  /// No description provided for @price_per_unit.
  ///
  /// In en, this message translates to:
  /// **'Price per Unit'**
  String get price_per_unit;

  /// No description provided for @total_price.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get total_price;

  /// No description provided for @provided_by.
  ///
  /// In en, this message translates to:
  /// **'Provided by'**
  String get provided_by;

  /// No description provided for @at_time.
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get at_time;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @error_weight_required.
  ///
  /// In en, this message translates to:
  /// **'Weight is required'**
  String get error_weight_required;

  /// No description provided for @error_value_required.
  ///
  /// In en, this message translates to:
  /// **'Value is required'**
  String get error_value_required;

  /// No description provided for @error_check_in_failed.
  ///
  /// In en, this message translates to:
  /// **'Check-in failed'**
  String get error_check_in_failed;

  /// No description provided for @error_input_details_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to input details'**
  String get error_input_details_failed;

  /// No description provided for @error_process_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to process transaction'**
  String get error_process_failed;

  /// No description provided for @error_cancel_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel transaction'**
  String get error_cancel_failed;

  /// No description provided for @error_feedback_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit feedback'**
  String get error_feedback_failed;

  /// No description provided for @transaction_info.
  ///
  /// In en, this message translates to:
  /// **'Transaction Information'**
  String get transaction_info;

  /// No description provided for @transaction_information.
  ///
  /// In en, this message translates to:
  /// **'Transaction Information'**
  String get transaction_information;

  /// No description provided for @transaction_created_time.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get transaction_created_time;

  /// No description provided for @transaction_updated_time.
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get transaction_updated_time;

  /// No description provided for @offer_info.
  ///
  /// In en, this message translates to:
  /// **'Offer Information'**
  String get offer_info;

  /// No description provided for @post_address.
  ///
  /// In en, this message translates to:
  /// **'Collection Address'**
  String get post_address;

  /// No description provided for @no_feedbacks_yet.
  ///
  /// In en, this message translates to:
  /// **'No feedbacks yet'**
  String get no_feedbacks_yet;

  /// No description provided for @my_feedbacks.
  ///
  /// In en, this message translates to:
  /// **'My Feedbacks'**
  String get my_feedbacks;

  /// No description provided for @all_feedbacks.
  ///
  /// In en, this message translates to:
  /// **'All Feedbacks'**
  String get all_feedbacks;

  /// No description provided for @feedback_list.
  ///
  /// In en, this message translates to:
  /// **'Feedback List'**
  String get feedback_list;

  /// No description provided for @sort_feedbacks.
  ///
  /// In en, this message translates to:
  /// **'Sort Feedbacks'**
  String get sort_feedbacks;

  /// No description provided for @no_feedbacks_found.
  ///
  /// In en, this message translates to:
  /// **'No feedbacks available at the moment'**
  String get no_feedbacks_found;

  /// No description provided for @no_feedbacks_available.
  ///
  /// In en, this message translates to:
  /// **'No feedbacks available at the moment'**
  String get no_feedbacks_available;

  /// No description provided for @rated_by.
  ///
  /// In en, this message translates to:
  /// **'Rated by'**
  String get rated_by;

  /// No description provided for @rated_for.
  ///
  /// In en, this message translates to:
  /// **'Rated for'**
  String get rated_for;

  /// No description provided for @transaction_ref.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction_ref;

  /// No description provided for @stars.
  ///
  /// In en, this message translates to:
  /// **'stars'**
  String get stars;

  /// No description provided for @feedback_details.
  ///
  /// In en, this message translates to:
  /// **'Feedback Details'**
  String get feedback_details;

  /// No description provided for @feedback_information.
  ///
  /// In en, this message translates to:
  /// **'Feedback Information'**
  String get feedback_information;

  /// No description provided for @reviewer_information.
  ///
  /// In en, this message translates to:
  /// **'Reviewer Information'**
  String get reviewer_information;

  /// No description provided for @reviewee_information.
  ///
  /// In en, this message translates to:
  /// **'Reviewee Information'**
  String get reviewee_information;

  /// No description provided for @given_rating.
  ///
  /// In en, this message translates to:
  /// **'Given Rating'**
  String get given_rating;

  /// No description provided for @feedback_comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get feedback_comment;

  /// No description provided for @no_comment.
  ///
  /// In en, this message translates to:
  /// **'No comment provided'**
  String get no_comment;

  /// No description provided for @feedback_date.
  ///
  /// In en, this message translates to:
  /// **'Feedback Date'**
  String get feedback_date;

  /// No description provided for @edit_feedback.
  ///
  /// In en, this message translates to:
  /// **'Edit Feedback'**
  String get edit_feedback;

  /// No description provided for @delete_feedback.
  ///
  /// In en, this message translates to:
  /// **'Delete Feedback'**
  String get delete_feedback;

  /// No description provided for @confirm_delete_feedback.
  ///
  /// In en, this message translates to:
  /// **'Delete Feedback'**
  String get confirm_delete_feedback;

  /// No description provided for @delete_feedback_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this feedback? This action cannot be undone.'**
  String get delete_feedback_message;

  /// No description provided for @feedback_deleted_success.
  ///
  /// In en, this message translates to:
  /// **'Feedback deleted successfully'**
  String get feedback_deleted_success;

  /// No description provided for @feedback_updated_success.
  ///
  /// In en, this message translates to:
  /// **'Feedback updated successfully'**
  String get feedback_updated_success;

  /// No description provided for @update_feedback_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update feedback'**
  String get update_feedback_failed;

  /// No description provided for @delete_feedback_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete feedback'**
  String get delete_feedback_failed;

  /// No description provided for @view_transaction.
  ///
  /// In en, this message translates to:
  /// **'View Transaction'**
  String get view_transaction;

  /// No description provided for @member_info.
  ///
  /// In en, this message translates to:
  /// **'Member Information'**
  String get member_info;

  /// No description provided for @contact_info.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contact_info;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @sort_by.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sort_by;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @newest_first.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get newest_first;

  /// No description provided for @oldest_first.
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get oldest_first;

  /// No description provided for @sort_by_last_updated.
  ///
  /// In en, this message translates to:
  /// **'Sort by last updated'**
  String get sort_by_last_updated;

  /// No description provided for @sort_by_creation_date.
  ///
  /// In en, this message translates to:
  /// **'Sort by creation date'**
  String get sort_by_creation_date;

  /// No description provided for @most_recent_at_top.
  ///
  /// In en, this message translates to:
  /// **'Most recent at the top'**
  String get most_recent_at_top;

  /// No description provided for @earliest_at_top.
  ///
  /// In en, this message translates to:
  /// **'Earliest at the top'**
  String get earliest_at_top;

  /// No description provided for @emergency_cancel.
  ///
  /// In en, this message translates to:
  /// **'Emergency Cancel'**
  String get emergency_cancel;

  /// No description provided for @emergency_cancel_confirm.
  ///
  /// In en, this message translates to:
  /// **'Emergency Cancellation'**
  String get emergency_cancel_confirm;

  /// No description provided for @emergency_cancel_message.
  ///
  /// In en, this message translates to:
  /// **'This will cancel the transaction due to emergency reasons (vehicle breakdown, unable to contact, etc.). Are you sure?'**
  String get emergency_cancel_message;

  /// No description provided for @emergency_cancel_note.
  ///
  /// In en, this message translates to:
  /// **'For emergency situations only: vehicle breakdown, unable to contact customer, extreme weather, etc.'**
  String get emergency_cancel_note;

  /// No description provided for @transaction_emergency_canceled.
  ///
  /// In en, this message translates to:
  /// **'Transaction cancelled due to emergency'**
  String get transaction_emergency_canceled;

  /// No description provided for @resume_transaction.
  ///
  /// In en, this message translates to:
  /// **'Resume Transaction'**
  String get resume_transaction;

  /// No description provided for @resume_confirm.
  ///
  /// In en, this message translates to:
  /// **'Resume Transaction'**
  String get resume_confirm;

  /// No description provided for @resume_message.
  ///
  /// In en, this message translates to:
  /// **'This will resume the transaction and change status back to In Progress. Are you sure?'**
  String get resume_message;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @transaction_resumed.
  ///
  /// In en, this message translates to:
  /// **'Transaction resumed successfully'**
  String get transaction_resumed;

  /// No description provided for @operation_failed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed. Please try again.'**
  String get operation_failed;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedbacks'**
  String get feedback;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @for_transaction.
  ///
  /// In en, this message translates to:
  /// **'For'**
  String get for_transaction;

  /// No description provided for @delete_feedback_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this feedback? This action cannot be undone.'**
  String get delete_feedback_confirm;

  /// No description provided for @feedback_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Feedback deleted successfully'**
  String get feedback_delete_success;

  /// No description provided for @feedback_delete_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete feedback'**
  String get feedback_delete_failed;

  /// No description provided for @feedback_not_found.
  ///
  /// In en, this message translates to:
  /// **'Feedback Not Found'**
  String get feedback_not_found;

  /// No description provided for @feedback_may_deleted.
  ///
  /// In en, this message translates to:
  /// **'This feedback may have been deleted'**
  String get feedback_may_deleted;

  /// No description provided for @feedback_may_have_been_deleted.
  ///
  /// In en, this message translates to:
  /// **'feedback may have been deleted'**
  String get feedback_may_have_been_deleted;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @update_feedback.
  ///
  /// In en, this message translates to:
  /// **'Update Feedback'**
  String get update_feedback;

  /// No description provided for @edit_your_feedback.
  ///
  /// In en, this message translates to:
  /// **'Edit Your Feedback'**
  String get edit_your_feedback;

  /// No description provided for @update_rating.
  ///
  /// In en, this message translates to:
  /// **'Update Rating'**
  String get update_rating;

  /// No description provided for @update_comment.
  ///
  /// In en, this message translates to:
  /// **'Update Comment'**
  String get update_comment;

  /// No description provided for @enter_your_comment.
  ///
  /// In en, this message translates to:
  /// **'Enter your comment'**
  String get enter_your_comment;

  /// No description provided for @rating_required.
  ///
  /// In en, this message translates to:
  /// **'Rating is required'**
  String get rating_required;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @complain.
  ///
  /// In en, this message translates to:
  /// **'Complain'**
  String get complain;

  /// No description provided for @write_review.
  ///
  /// In en, this message translates to:
  /// **'Write Review'**
  String get write_review;

  /// No description provided for @file_complaint.
  ///
  /// In en, this message translates to:
  /// **'File Complaint'**
  String get file_complaint;

  /// No description provided for @create_feedback.
  ///
  /// In en, this message translates to:
  /// **'Create Feedback'**
  String get create_feedback;

  /// No description provided for @rate_transaction.
  ///
  /// In en, this message translates to:
  /// **'Rate Transaction'**
  String get rate_transaction;

  /// No description provided for @your_rating.
  ///
  /// In en, this message translates to:
  /// **'Your Rating'**
  String get your_rating;

  /// No description provided for @tap_to_rate.
  ///
  /// In en, this message translates to:
  /// **'Tap to rate'**
  String get tap_to_rate;

  /// No description provided for @write_comment.
  ///
  /// In en, this message translates to:
  /// **'Write your comment'**
  String get write_comment;

  /// No description provided for @comment_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Share your experience with this transaction...'**
  String get comment_placeholder;

  /// No description provided for @rating_description.
  ///
  /// In en, this message translates to:
  /// **'How would you rate your experience?'**
  String get rating_description;

  /// No description provided for @comment_required.
  ///
  /// In en, this message translates to:
  /// **'Please provide a comment'**
  String get comment_required;

  /// No description provided for @feedback_created_success.
  ///
  /// In en, this message translates to:
  /// **'Feedback created successfully'**
  String get feedback_created_success;

  /// No description provided for @create_feedback_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create feedback'**
  String get create_feedback_failed;

  /// No description provided for @poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// No description provided for @fair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get fair;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @veryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get veryGood;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @ai_cannot_analyze.
  ///
  /// In en, this message translates to:
  /// **'AI cannot analyze. Please enter information manually (image will be uploaded when creating post).'**
  String get ai_cannot_analyze;

  /// No description provided for @ai_cannot_analyze_update.
  ///
  /// In en, this message translates to:
  /// **'AI cannot analyze. Please enter information manually (image will be uploaded when updating post).'**
  String get ai_cannot_analyze_update;

  /// No description provided for @error_analyze_image.
  ///
  /// In en, this message translates to:
  /// **'Error analyzing image. Please enter information manually.'**
  String get error_analyze_image;

  /// No description provided for @ai_recognition.
  ///
  /// In en, this message translates to:
  /// **'AI Recognition'**
  String get ai_recognition;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @recyclable.
  ///
  /// In en, this message translates to:
  /// **'Recyclable'**
  String get recyclable;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @estimated.
  ///
  /// In en, this message translates to:
  /// **'Estimated'**
  String get estimated;

  /// No description provided for @advice.
  ///
  /// In en, this message translates to:
  /// **'Advice'**
  String get advice;

  /// No description provided for @info_auto_filled.
  ///
  /// In en, this message translates to:
  /// **'Information has been automatically filled. You can edit before adding.'**
  String get info_auto_filled;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @please_select_image.
  ///
  /// In en, this message translates to:
  /// **'Please select an image'**
  String get please_select_image;

  /// No description provided for @please_select_category.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get please_select_category;

  /// No description provided for @item_added_success.
  ///
  /// In en, this message translates to:
  /// **'Item added successfully'**
  String get item_added_success;

  /// No description provided for @error_get_upload_url.
  ///
  /// In en, this message translates to:
  /// **'Failed to get upload URL'**
  String get error_get_upload_url;

  /// No description provided for @error_upload_image.
  ///
  /// In en, this message translates to:
  /// **'Error uploading image: {error}'**
  String error_upload_image(Object error);

  /// No description provided for @ai_will_auto_recognize.
  ///
  /// In en, this message translates to:
  /// **'AI will automatically recognize after selecting image'**
  String get ai_will_auto_recognize;

  /// No description provided for @ai_will_auto_analyze.
  ///
  /// In en, this message translates to:
  /// **'AI will automatically analyze the image'**
  String get ai_will_auto_analyze;

  /// No description provided for @ai_analyzing.
  ///
  /// In en, this message translates to:
  /// **'AI is analyzing the image and automatically filling information...'**
  String get ai_analyzing;

  /// No description provided for @image_will_upload.
  ///
  /// In en, this message translates to:
  /// **'Image will be uploaded when creating post. Please enter information manually.'**
  String get image_will_upload;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// No description provided for @ai_connect_error.
  ///
  /// In en, this message translates to:
  /// **'AI connection error. You can enter information manually, image will be uploaded when updating post.'**
  String get ai_connect_error;

  /// No description provided for @complaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get complaints;

  /// No description provided for @feedbacks.
  ///
  /// In en, this message translates to:
  /// **'Feedbacks'**
  String get feedbacks;
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
