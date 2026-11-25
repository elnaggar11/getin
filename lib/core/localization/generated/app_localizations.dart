import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('tr')
  ];

  /// No description provided for @hights_points.
  ///
  /// In en, this message translates to:
  /// **'Highest Points'**
  String get hights_points;

  /// No description provided for @hights_stars.
  ///
  /// In en, this message translates to:
  /// **'Highest Stars'**
  String get hights_stars;

  /// No description provided for @qr_code_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR Code'**
  String get qr_code_invalid;

  /// No description provided for @find_nearest_branches.
  ///
  /// In en, this message translates to:
  /// **'Find the nearest branches for you'**
  String get find_nearest_branches;

  /// No description provided for @time_must_be_at_least_10_minutes.
  ///
  /// In en, this message translates to:
  /// **'time must be at least 10 minutes'**
  String get time_must_be_at_least_10_minutes;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Get In Coffee'**
  String get app_name;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @good_morning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get good_morning;

  /// No description provided for @good_afternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get good_afternoon;

  /// No description provided for @good_evening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get good_evening;

  /// No description provided for @good_night.
  ///
  /// In en, this message translates to:
  /// **'Good Night'**
  String get good_night;

  /// No description provided for @go_to_home.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get go_to_home;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password;

  /// No description provided for @remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get remember_me;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_in;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get sign_up;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get already_have_account;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dont_have_account;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

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

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get recent;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @new_item.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get new_item;

  /// No description provided for @sale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get sale;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @coffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get coffee;

  /// No description provided for @espresso.
  ///
  /// In en, this message translates to:
  /// **'Espresso'**
  String get espresso;

  /// No description provided for @cappuccino.
  ///
  /// In en, this message translates to:
  /// **'Cappuccino'**
  String get cappuccino;

  /// No description provided for @latte.
  ///
  /// In en, this message translates to:
  /// **'Latte'**
  String get latte;

  /// No description provided for @americano.
  ///
  /// In en, this message translates to:
  /// **'Americano'**
  String get americano;

  /// No description provided for @mocha.
  ///
  /// In en, this message translates to:
  /// **'Mocha'**
  String get mocha;

  /// No description provided for @macchiato.
  ///
  /// In en, this message translates to:
  /// **'Macchiato'**
  String get macchiato;

  /// No description provided for @frappuccino.
  ///
  /// In en, this message translates to:
  /// **'Frappuccino'**
  String get frappuccino;

  /// No description provided for @cold_brew.
  ///
  /// In en, this message translates to:
  /// **'Cold Brew'**
  String get cold_brew;

  /// No description provided for @iced_coffee.
  ///
  /// In en, this message translates to:
  /// **'Iced Coffee'**
  String get iced_coffee;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @small.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get small;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// No description provided for @extra_large.
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get extra_large;

  /// No description provided for @add_to_cart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart ({price})'**
  String add_to_cart(String price);

  /// No description provided for @add_to_favorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get add_to_favorites;

  /// No description provided for @remove_from_favorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get remove_from_favorites;

  /// No description provided for @buy_now.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buy_now;

  /// No description provided for @view_details.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get view_details;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total:'**
  String get total;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal:'**
  String get subtotal;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax:'**
  String get tax;

  /// No description provided for @delivery_fee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get delivery_fee;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @coupon.
  ///
  /// In en, this message translates to:
  /// **'Coupon'**
  String get coupon;

  /// No description provided for @apply_coupon.
  ///
  /// In en, this message translates to:
  /// **'Apply Coupon'**
  String get apply_coupon;

  /// No description provided for @remove_coupon.
  ///
  /// In en, this message translates to:
  /// **'Remove Coupon'**
  String get remove_coupon;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get payment_method;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @cash_on_delivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on delivery'**
  String get cash_on_delivery;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @credit_card.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get credit_card;

  /// No description provided for @debit_card.
  ///
  /// In en, this message translates to:
  /// **'Debit Card'**
  String get debit_card;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// No description provided for @delivery_address.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get delivery_address;

  /// No description provided for @pickup_location.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickup_location;

  /// No description provided for @delivery_time.
  ///
  /// In en, this message translates to:
  /// **'Enter delivery time'**
  String get delivery_time;

  /// No description provided for @estimated_time.
  ///
  /// In en, this message translates to:
  /// **'Estimated Time'**
  String get estimated_time;

  /// No description provided for @free_delivery.
  ///
  /// In en, this message translates to:
  /// **'Free delivery'**
  String get free_delivery;

  /// No description provided for @order_status.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get order_status;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get pending;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get preparing;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @on_the_way.
  ///
  /// In en, this message translates to:
  /// **'Out for Delivery'**
  String get on_the_way;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @refunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get refunded;

  /// No description provided for @order_number.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get order_number;

  /// No description provided for @order_date.
  ///
  /// In en, this message translates to:
  /// **'Order Date'**
  String get order_date;

  /// No description provided for @order_time.
  ///
  /// In en, this message translates to:
  /// **'Order Time'**
  String get order_time;

  /// No description provided for @order_total.
  ///
  /// In en, this message translates to:
  /// **'Order Total'**
  String get order_total;

  /// No description provided for @track_order.
  ///
  /// In en, this message translates to:
  /// **'Track order'**
  String get track_order;

  /// No description provided for @reorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get reorder;

  /// No description provided for @rate_order.
  ///
  /// In en, this message translates to:
  /// **'Rate Order'**
  String get rate_order;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @stars.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get stars;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// No description provided for @terrible.
  ///
  /// In en, this message translates to:
  /// **'Terrible'**
  String get terrible;

  /// No description provided for @write_review.
  ///
  /// In en, this message translates to:
  /// **'Write Review'**
  String get write_review;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @building.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get building;

  /// No description provided for @floor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floor;

  /// No description provided for @apartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get apartment;

  /// No description provided for @landmark.
  ///
  /// In en, this message translates to:
  /// **'Landmark'**
  String get landmark;

  /// No description provided for @postal_code.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postal_code;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

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

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @continue_action.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_action;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @load_more.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get load_more;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @please_wait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get please_wait;

  /// No description provided for @no_data.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get no_data;

  /// No description provided for @no_results.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get no_results;

  /// No description provided for @no_internet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get no_internet;

  /// No description provided for @connection_error.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get connection_error;

  /// No description provided for @server_error.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get server_error;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get try_again;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light_theme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get light_theme;

  /// No description provided for @dark_theme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get dark_theme;

  /// No description provided for @auto_theme.
  ///
  /// In en, this message translates to:
  /// **'Auto Theme'**
  String get auto_theme;

  /// No description provided for @notifications_settings.
  ///
  /// In en, this message translates to:
  /// **'Notifications Settings'**
  String get notifications_settings;

  /// No description provided for @privacy_settings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacy_settings;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// No description provided for @terms_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_conditions;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @welcome_message.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {app_name}'**
  String welcome_message(Object appName, Object app_name);

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcome_back;

  /// No description provided for @thank_you.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get thank_you;

  /// No description provided for @thank_you_for_order.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your order'**
  String get thank_you_for_order;

  /// No description provided for @order_confirmed.
  ///
  /// In en, this message translates to:
  /// **'Your order has been confirmed'**
  String get order_confirmed;

  /// No description provided for @order_delivered.
  ///
  /// In en, this message translates to:
  /// **'Your order has been delivered'**
  String get order_delivered;

  /// No description provided for @enjoy_your_coffee.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your coffee'**
  String get enjoy_your_coffee;

  /// No description provided for @empty_cart.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty'**
  String get empty_cart;

  /// No description provided for @empty_favorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites'**
  String get empty_favorites;

  /// No description provided for @empty_orders.
  ///
  /// In en, this message translates to:
  /// **'No orders'**
  String get empty_orders;

  /// No description provided for @empty_notifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get empty_notifications;

  /// No description provided for @add_item_to_cart.
  ///
  /// In en, this message translates to:
  /// **'Add item to cart'**
  String get add_item_to_cart;

  /// No description provided for @remove_item_from_cart.
  ///
  /// In en, this message translates to:
  /// **'Remove item from cart'**
  String get remove_item_from_cart;

  /// No description provided for @clear_cart.
  ///
  /// In en, this message translates to:
  /// **'Clear cart'**
  String get clear_cart;

  /// No description provided for @update_cart.
  ///
  /// In en, this message translates to:
  /// **'Update cart'**
  String get update_cart;

  /// No description provided for @select_size.
  ///
  /// In en, this message translates to:
  /// **'Select size'**
  String get select_size;

  /// No description provided for @select_quantity.
  ///
  /// In en, this message translates to:
  /// **'Select quantity'**
  String get select_quantity;

  /// No description provided for @select_payment_method.
  ///
  /// In en, this message translates to:
  /// **'Select payment method'**
  String get select_payment_method;

  /// No description provided for @select_delivery_time.
  ///
  /// In en, this message translates to:
  /// **'Select delivery time'**
  String get select_delivery_time;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enter_email;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enter_password;

  /// No description provided for @enter_phone.
  ///
  /// In en, this message translates to:
  /// **'Enter phone'**
  String get enter_phone;

  /// No description provided for @enter_name.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enter_name;

  /// No description provided for @enter_address.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get enter_address;

  /// No description provided for @enter_coupon_code.
  ///
  /// In en, this message translates to:
  /// **'Enter the coupon code'**
  String get enter_coupon_code;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalid_email;

  /// No description provided for @invalid_phone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone'**
  String get invalid_phone;

  /// No description provided for @password_too_short.
  ///
  /// In en, this message translates to:
  /// **'Password too short'**
  String get password_too_short;

  /// No description provided for @passwords_dont_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwords_dont_match;

  /// No description provided for @field_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get field_required;

  /// No description provided for @invalid_coupon.
  ///
  /// In en, this message translates to:
  /// **'Invalid coupon'**
  String get invalid_coupon;

  /// No description provided for @coupon_expired.
  ///
  /// In en, this message translates to:
  /// **'Coupon expired'**
  String get coupon_expired;

  /// No description provided for @coupon_used.
  ///
  /// In en, this message translates to:
  /// **'Coupon already used'**
  String get coupon_used;

  /// No description provided for @order_minimum.
  ///
  /// In en, this message translates to:
  /// **'Order minimum'**
  String get order_minimum;

  /// No description provided for @free_delivery_minimum.
  ///
  /// In en, this message translates to:
  /// **'Free delivery minimum'**
  String get free_delivery_minimum;

  /// No description provided for @delivery_available.
  ///
  /// In en, this message translates to:
  /// **'Delivery available'**
  String get delivery_available;

  /// No description provided for @delivery_not_available.
  ///
  /// In en, this message translates to:
  /// **'Delivery not available'**
  String get delivery_not_available;

  /// No description provided for @pickup_available.
  ///
  /// In en, this message translates to:
  /// **'Pickup available'**
  String get pickup_available;

  /// No description provided for @pickup_not_available.
  ///
  /// In en, this message translates to:
  /// **'Pickup not available'**
  String get pickup_not_available;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @this_week.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get this_week;

  /// No description provided for @last_week.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get last_week;

  /// No description provided for @next_week.
  ///
  /// In en, this message translates to:
  /// **'Next Week'**
  String get next_week;

  /// No description provided for @this_month.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get this_month;

  /// No description provided for @last_month.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get last_month;

  /// No description provided for @next_month.
  ///
  /// In en, this message translates to:
  /// **'Next Month'**
  String get next_month;

  /// No description provided for @this_year.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get this_year;

  /// No description provided for @last_year.
  ///
  /// In en, this message translates to:
  /// **'Last Year'**
  String get last_year;

  /// No description provided for @next_year.
  ///
  /// In en, this message translates to:
  /// **'Next Year'**
  String get next_year;

  /// No description provided for @confirm_your_location.
  ///
  /// In en, this message translates to:
  /// **'Confirm Your Location!'**
  String get confirm_your_location;

  /// No description provided for @delivery_location_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Your delivery will be made exactly to the point you marked on the map. Are you sure your location mark is correct?'**
  String get delivery_location_confirmation;

  /// No description provided for @i_confirm_my_location.
  ///
  /// In en, this message translates to:
  /// **'I Confirm My Location'**
  String get i_confirm_my_location;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @enter_delivery_locations.
  ///
  /// In en, this message translates to:
  /// **'Enter delivery locations'**
  String get enter_delivery_locations;

  /// No description provided for @enter_location_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your location to make your delivery convenient.'**
  String get enter_location_description;

  /// No description provided for @add_location.
  ///
  /// In en, this message translates to:
  /// **'Add Location'**
  String get add_location;

  /// No description provided for @address_information.
  ///
  /// In en, this message translates to:
  /// **'Address Information'**
  String get address_information;

  /// No description provided for @deliver_to_home.
  ///
  /// In en, this message translates to:
  /// **'Deliver to Home'**
  String get deliver_to_home;

  /// No description provided for @forgot_your_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgot_your_password;

  /// No description provided for @enter_phone_linked_account.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone number linked to your account'**
  String get enter_phone_linked_account;

  /// No description provided for @phone_number_required.
  ///
  /// In en, this message translates to:
  /// **'Phone Number *'**
  String get phone_number_required;

  /// No description provided for @enter_your_number_here.
  ///
  /// In en, this message translates to:
  /// **'Enter your number here'**
  String get enter_your_number_here;

  /// No description provided for @get_code_now.
  ///
  /// In en, this message translates to:
  /// **'Get the code now'**
  String get get_code_now;

  /// No description provided for @terms_conditions_must_accepted.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions must be accepted.'**
  String get terms_conditions_must_accepted;

  /// No description provided for @sign_up_now.
  ///
  /// In en, this message translates to:
  /// **'Sign up now'**
  String get sign_up_now;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @confirm_location.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirm_location;

  /// No description provided for @location_details.
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get location_details;

  /// No description provided for @select_delivery_method.
  ///
  /// In en, this message translates to:
  /// **'Select Delivery Method'**
  String get select_delivery_method;

  /// No description provided for @home_delivery.
  ///
  /// In en, this message translates to:
  /// **'Home Delivery'**
  String get home_delivery;

  /// No description provided for @pickup_from_branch.
  ///
  /// In en, this message translates to:
  /// **'Pick up from nearest branch'**
  String get pickup_from_branch;

  /// No description provided for @no_notifications_yet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get no_notifications_yet;

  /// No description provided for @notification_title.
  ///
  /// In en, this message translates to:
  /// **'Notification Title'**
  String get notification_title;

  /// No description provided for @notification_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Subtitle'**
  String get notification_subtitle;

  /// No description provided for @profile_settings.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profile_settings;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @language_settings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get language_settings;

  /// No description provided for @support_center.
  ///
  /// In en, this message translates to:
  /// **'Support Center'**
  String get support_center;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @order_history.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get order_history;

  /// No description provided for @current_orders.
  ///
  /// In en, this message translates to:
  /// **'Current Orders'**
  String get current_orders;

  /// No description provided for @completed_orders.
  ///
  /// In en, this message translates to:
  /// **'Completed Orders'**
  String get completed_orders;

  /// No description provided for @cancelled_orders.
  ///
  /// In en, this message translates to:
  /// **'Cancelled Orders'**
  String get cancelled_orders;

  /// No description provided for @shopping_cart.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get shopping_cart;

  /// No description provided for @cart_items.
  ///
  /// In en, this message translates to:
  /// **'Cart Items'**
  String get cart_items;

  /// No description provided for @total_amount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get total_amount;

  /// No description provided for @proceed_to_checkout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get proceed_to_checkout;

  /// No description provided for @rate_your_experience.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Experience'**
  String get rate_your_experience;

  /// No description provided for @how_was_your_order.
  ///
  /// In en, this message translates to:
  /// **'How was your order?'**
  String get how_was_your_order;

  /// No description provided for @write_your_review.
  ///
  /// In en, this message translates to:
  /// **'Write Your Review'**
  String get write_your_review;

  /// No description provided for @submit_review.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submit_review;

  /// No description provided for @my_points.
  ///
  /// In en, this message translates to:
  /// **'My Points'**
  String get my_points;

  /// No description provided for @earned_points.
  ///
  /// In en, this message translates to:
  /// **'Earned Points'**
  String get earned_points;

  /// No description provided for @available_points.
  ///
  /// In en, this message translates to:
  /// **'Available Points'**
  String get available_points;

  /// No description provided for @points_history.
  ///
  /// In en, this message translates to:
  /// **'Points History'**
  String get points_history;

  /// No description provided for @search_branches.
  ///
  /// In en, this message translates to:
  /// **'Search your branches'**
  String get search_branches;

  /// No description provided for @select_branch.
  ///
  /// In en, this message translates to:
  /// **'Select Branch'**
  String get select_branch;

  /// No description provided for @branch_location.
  ///
  /// In en, this message translates to:
  /// **'Branch Location'**
  String get branch_location;

  /// No description provided for @branch_hours.
  ///
  /// In en, this message translates to:
  /// **'Branch Hours'**
  String get branch_hours;

  /// No description provided for @welcome_to_app.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the App'**
  String get welcome_to_app;

  /// No description provided for @get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get get_started;

  /// No description provided for @next_step.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get next_step;

  /// No description provided for @previous_step.
  ///
  /// In en, this message translates to:
  /// **'Previous Step'**
  String get previous_step;

  /// No description provided for @loading_please_wait.
  ///
  /// In en, this message translates to:
  /// **'Loading, please wait...'**
  String get loading_please_wait;

  /// No description provided for @try_again_later.
  ///
  /// In en, this message translates to:
  /// **'Try again later'**
  String get try_again_later;

  /// No description provided for @network_error.
  ///
  /// In en, this message translates to:
  /// **'Network Error'**
  String get network_error;

  /// No description provided for @server_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Server Unavailable'**
  String get server_unavailable;

  /// No description provided for @error_occurred.
  ///
  /// In en, this message translates to:
  /// **'Error Occurred'**
  String get error_occurred;

  /// No description provided for @operation_failed.
  ///
  /// In en, this message translates to:
  /// **'Operation Failed'**
  String get operation_failed;

  /// No description provided for @operation_successful.
  ///
  /// In en, this message translates to:
  /// **'Operation Successful'**
  String get operation_successful;

  /// No description provided for @yes_confirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Confirm'**
  String get yes_confirm;

  /// No description provided for @no_cancel.
  ///
  /// In en, this message translates to:
  /// **'No, Cancel'**
  String get no_cancel;

  /// No description provided for @are_you_sure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get are_you_sure;

  /// No description provided for @this_action_cannot_undone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get this_action_cannot_undone;

  /// No description provided for @search_here.
  ///
  /// In en, this message translates to:
  /// **'Search here'**
  String get search_here;

  /// No description provided for @no_results_found.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get no_results_found;

  /// No description provided for @search_suggestions.
  ///
  /// In en, this message translates to:
  /// **'Search Suggestions'**
  String get search_suggestions;

  /// No description provided for @filter_results.
  ///
  /// In en, this message translates to:
  /// **'Filter Results'**
  String get filter_results;

  /// No description provided for @sort_by.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sort_by;

  /// No description provided for @price_low_to_high.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get price_low_to_high;

  /// No description provided for @price_high_to_low.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get price_high_to_low;

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

  /// No description provided for @favorite_added.
  ///
  /// In en, this message translates to:
  /// **'Added to Favorites'**
  String get favorite_added;

  /// No description provided for @favorite_removed.
  ///
  /// In en, this message translates to:
  /// **'Removed from Favorites'**
  String get favorite_removed;

  /// No description provided for @quantity_increased.
  ///
  /// In en, this message translates to:
  /// **'Quantity Increased'**
  String get quantity_increased;

  /// No description provided for @quantity_decreased.
  ///
  /// In en, this message translates to:
  /// **'Quantity Decreased'**
  String get quantity_decreased;

  /// No description provided for @item_added_to_cart.
  ///
  /// In en, this message translates to:
  /// **'Item Added to Cart'**
  String get item_added_to_cart;

  /// No description provided for @item_removed_from_cart.
  ///
  /// In en, this message translates to:
  /// **'Item Removed from Cart'**
  String get item_removed_from_cart;

  /// No description provided for @order_placed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Order Placed Successfully'**
  String get order_placed_successfully;

  /// No description provided for @order_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Order Cancelled'**
  String get order_cancelled;

  /// No description provided for @order_preparing.
  ///
  /// In en, this message translates to:
  /// **'Order Preparing'**
  String get order_preparing;

  /// No description provided for @order_ready.
  ///
  /// In en, this message translates to:
  /// **'Order Ready'**
  String get order_ready;

  /// No description provided for @payment_successful.
  ///
  /// In en, this message translates to:
  /// **'Payment successful'**
  String get payment_successful;

  /// No description provided for @payment_failed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get payment_failed;

  /// No description provided for @payment_pending.
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get payment_pending;

  /// No description provided for @refund_processed.
  ///
  /// In en, this message translates to:
  /// **'Refund Processed'**
  String get refund_processed;

  /// No description provided for @delivery_estimated_time.
  ///
  /// In en, this message translates to:
  /// **'Estimated Delivery Time'**
  String get delivery_estimated_time;

  /// No description provided for @free_delivery_available.
  ///
  /// In en, this message translates to:
  /// **'Free Delivery Available'**
  String get free_delivery_available;

  /// No description provided for @minimum_order_amount.
  ///
  /// In en, this message translates to:
  /// **'Minimum Order Amount'**
  String get minimum_order_amount;

  /// No description provided for @contact_support.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contact_support;

  /// No description provided for @report_issue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get report_issue;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @rate_app.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rate_app;

  /// No description provided for @terms_of_service.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get terms_of_service;

  /// No description provided for @about_us.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get about_us;

  /// No description provided for @version_info.
  ///
  /// In en, this message translates to:
  /// **'Version Info'**
  String get version_info;

  /// No description provided for @my_stars.
  ///
  /// In en, this message translates to:
  /// **'My Stars'**
  String get my_stars;

  /// No description provided for @delivery_locations.
  ///
  /// In en, this message translates to:
  /// **'Delivery Locations'**
  String get delivery_locations;

  /// No description provided for @schedule_order.
  ///
  /// In en, this message translates to:
  /// **'Schedule an order'**
  String get schedule_order;

  /// No description provided for @discount_coupons.
  ///
  /// In en, this message translates to:
  /// **'Discount coupons'**
  String get discount_coupons;

  /// No description provided for @invite_friends.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get invite_friends;

  /// No description provided for @clear_all.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clear_all;

  /// No description provided for @my_rewards_points.
  ///
  /// In en, this message translates to:
  /// **'My Rewards Points'**
  String get my_rewards_points;

  /// No description provided for @buy_points.
  ///
  /// In en, this message translates to:
  /// **'Buy Points'**
  String get buy_points;

  /// No description provided for @total_points.
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get total_points;

  /// No description provided for @buy_product_now.
  ///
  /// In en, this message translates to:
  /// **'Buy a Product Now'**
  String get buy_product_now;

  /// No description provided for @history_points.
  ///
  /// In en, this message translates to:
  /// **'History Points'**
  String get history_points;

  /// No description provided for @how_receive_order.
  ///
  /// In en, this message translates to:
  /// **'How would you like to receive your order?'**
  String get how_receive_order;

  /// No description provided for @price_range.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get price_range;

  /// No description provided for @milk_tea.
  ///
  /// In en, this message translates to:
  /// **'Milk Tea'**
  String get milk_tea;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @its_time_for_getin.
  ///
  /// In en, this message translates to:
  /// **'IT\'S TIME FOR Getin'**
  String get its_time_for_getin;

  /// No description provided for @coffee_experience.
  ///
  /// In en, this message translates to:
  /// **'Coffee Experience.'**
  String get coffee_experience;

  /// No description provided for @onboarding_description.
  ///
  /// In en, this message translates to:
  /// **'Order your favorite brew with the GETIN COFFEE app and enjoy a rich, flavorful experience delivered right to you.'**
  String get onboarding_description;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @no_orders_yet.
  ///
  /// In en, this message translates to:
  /// **'No Orders Yet'**
  String get no_orders_yet;

  /// No description provided for @no_orders_description.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t placed any orders yet.\nStart exploring and make your first one!'**
  String get no_orders_description;

  /// No description provided for @order_deletion_notice.
  ///
  /// In en, this message translates to:
  /// **'Order Deletion Notice'**
  String get order_deletion_notice;

  /// No description provided for @order_deletion_warning.
  ///
  /// In en, this message translates to:
  /// **'Attention: If the product is deleted, we will deduct the order fee from you.'**
  String get order_deletion_warning;

  /// No description provided for @irreversible_action.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible!'**
  String get irreversible_action;

  /// No description provided for @your_comment.
  ///
  /// In en, this message translates to:
  /// **'Your comment...'**
  String get your_comment;

  /// No description provided for @no_name.
  ///
  /// In en, this message translates to:
  /// **'No Name'**
  String get no_name;

  /// No description provided for @no_description.
  ///
  /// In en, this message translates to:
  /// **'No Description'**
  String get no_description;

  /// No description provided for @driver_vehicle.
  ///
  /// In en, this message translates to:
  /// **'Drive - BMW i8'**
  String get driver_vehicle;

  /// No description provided for @rating_driver.
  ///
  /// In en, this message translates to:
  /// **'Rating Driver'**
  String get rating_driver;

  /// No description provided for @rating_branch.
  ///
  /// In en, this message translates to:
  /// **'Rating Branch'**
  String get rating_branch;

  /// No description provided for @verify_mobile_number.
  ///
  /// In en, this message translates to:
  /// **'Verify Mobile Number'**
  String get verify_mobile_number;

  /// No description provided for @enter_code_sent_mobile.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your mobile number.'**
  String get enter_code_sent_mobile;

  /// No description provided for @didnt_receive_code.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didnt_receive_code;

  /// No description provided for @resend_code.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resend_code;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @verification_successful.
  ///
  /// In en, this message translates to:
  /// **'Verification successful'**
  String get verification_successful;

  /// No description provided for @choose_location_delivery.
  ///
  /// In en, this message translates to:
  /// **'Choose your location to delivery!'**
  String get choose_location_delivery;

  /// No description provided for @add_new_location.
  ///
  /// In en, this message translates to:
  /// **'add new location'**
  String get add_new_location;

  /// No description provided for @add_coupon.
  ///
  /// In en, this message translates to:
  /// **'Add Coupon'**
  String get add_coupon;

  /// No description provided for @coupon_required.
  ///
  /// In en, this message translates to:
  /// **'Coupon *'**
  String get coupon_required;

  /// No description provided for @want_more_coupons.
  ///
  /// In en, this message translates to:
  /// **'Want to get more coupons? Follow us on'**
  String get want_more_coupons;

  /// No description provided for @social_media_platforms.
  ///
  /// In en, this message translates to:
  /// **'X, Instagram, Facebook'**
  String get social_media_platforms;

  /// No description provided for @you_saved_percentage.
  ///
  /// In en, this message translates to:
  /// **'You saved: {percentage}'**
  String you_saved_percentage(String percentage);

  /// No description provided for @discount_applied_checkout.
  ///
  /// In en, this message translates to:
  /// **'Discount will be applied at checkout.'**
  String get discount_applied_checkout;

  /// No description provided for @add_payment_methods.
  ///
  /// In en, this message translates to:
  /// **'Add payment methods'**
  String get add_payment_methods;

  /// No description provided for @master_card.
  ///
  /// In en, this message translates to:
  /// **'Master Card'**
  String get master_card;

  /// No description provided for @enter_your_name_here.
  ///
  /// In en, this message translates to:
  /// **'Enter your Name here'**
  String get enter_your_name_here;

  /// No description provided for @cardholder_name_required.
  ///
  /// In en, this message translates to:
  /// **'Cardholder Name *'**
  String get cardholder_name_required;

  /// No description provided for @enter_card_number_here.
  ///
  /// In en, this message translates to:
  /// **'Enter your Card number here'**
  String get enter_card_number_here;

  /// No description provided for @card_number_required.
  ///
  /// In en, this message translates to:
  /// **'Card number *'**
  String get card_number_required;

  /// No description provided for @protection_code_required.
  ///
  /// In en, this message translates to:
  /// **'Protection code *'**
  String get protection_code_required;

  /// No description provided for @month_year.
  ///
  /// In en, this message translates to:
  /// **'Month/Year'**
  String get month_year;

  /// No description provided for @expiration_date_required.
  ///
  /// In en, this message translates to:
  /// **'Expiration Date *'**
  String get expiration_date_required;

  /// No description provided for @save_payment_info_future.
  ///
  /// In en, this message translates to:
  /// **'Save payment information in my account for future purchases.'**
  String get save_payment_info_future;

  /// No description provided for @place_order_now.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get place_order_now;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Password!'**
  String get reset_password;

  /// No description provided for @choose_strong_password.
  ///
  /// In en, this message translates to:
  /// **'Choose a strong password to ensure security.'**
  String get choose_strong_password;

  /// No description provided for @enter_new_password_here.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password here'**
  String get enter_new_password_here;

  /// No description provided for @set_new_password_required.
  ///
  /// In en, this message translates to:
  /// **'Set a New Password *'**
  String get set_new_password_required;

  /// No description provided for @enter_password_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Enter the new password confirmation'**
  String get enter_password_confirmation;

  /// No description provided for @confirm_new_password_required.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password *'**
  String get confirm_new_password_required;

  /// No description provided for @save_new_password.
  ///
  /// In en, this message translates to:
  /// **'Save New Password'**
  String get save_new_password;

  /// No description provided for @address_added_successfully.
  ///
  /// In en, this message translates to:
  /// **'Address added successfully'**
  String get address_added_successfully;

  /// No description provided for @sample_address.
  ///
  /// In en, this message translates to:
  /// **'Barbaros Hayrettin Paşa Kavaklı-Yolu...'**
  String get sample_address;

  /// No description provided for @enter_your_location.
  ///
  /// In en, this message translates to:
  /// **'Enter your Location'**
  String get enter_your_location;

  /// No description provided for @enter_name_address.
  ///
  /// In en, this message translates to:
  /// **'Enter your name addres'**
  String get enter_name_address;

  /// No description provided for @name_address.
  ///
  /// In en, this message translates to:
  /// **'Name address'**
  String get name_address;

  /// No description provided for @building_number.
  ///
  /// In en, this message translates to:
  /// **'Building Number'**
  String get building_number;

  /// No description provided for @address_description.
  ///
  /// In en, this message translates to:
  /// **'Address Description *'**
  String get address_description;

  /// No description provided for @address_title_examples.
  ///
  /// In en, this message translates to:
  /// **'(My Home Address, My Work Address)'**
  String get address_title_examples;

  /// No description provided for @address_title_required.
  ///
  /// In en, this message translates to:
  /// **'Address Description *'**
  String get address_title_required;

  /// No description provided for @mobile_phone.
  ///
  /// In en, this message translates to:
  /// **'Mobile Phone'**
  String get mobile_phone;

  /// No description provided for @save_my_address.
  ///
  /// In en, this message translates to:
  /// **'Save My Address'**
  String get save_my_address;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get first_name;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get last_name;

  /// No description provided for @my_rewards_stars.
  ///
  /// In en, this message translates to:
  /// **'My Rewards Stars'**
  String get my_rewards_stars;

  /// No description provided for @total_stars.
  ///
  /// In en, this message translates to:
  /// **'Total stars'**
  String get total_stars;

  /// No description provided for @my_orders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get my_orders;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @order_id.
  ///
  /// In en, this message translates to:
  /// **'ID Order'**
  String get order_id;

  /// No description provided for @order_receipt_time.
  ///
  /// In en, this message translates to:
  /// **'Order receipt time'**
  String get order_receipt_time;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @back_to_branch.
  ///
  /// In en, this message translates to:
  /// **'Back to branch'**
  String get back_to_branch;

  /// No description provided for @rating_now.
  ///
  /// In en, this message translates to:
  /// **'Rating now'**
  String get rating_now;

  /// No description provided for @rate_driver.
  ///
  /// In en, this message translates to:
  /// **'Rate Driver'**
  String get rate_driver;

  /// No description provided for @rate_product.
  ///
  /// In en, this message translates to:
  /// **'Rate Product'**
  String get rate_product;

  /// No description provided for @rate_branch.
  ///
  /// In en, this message translates to:
  /// **'Rate Branch'**
  String get rate_branch;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @skip_all_ratings.
  ///
  /// In en, this message translates to:
  /// **'Skip all ratings'**
  String get skip_all_ratings;

  /// No description provided for @delivery_type_required.
  ///
  /// In en, this message translates to:
  /// **'Type delivery *'**
  String get delivery_type_required;

  /// No description provided for @delivery_to_place.
  ///
  /// In en, this message translates to:
  /// **'delivery to place'**
  String get delivery_to_place;

  /// No description provided for @delivery_time_required.
  ///
  /// In en, this message translates to:
  /// **'Delivery time *'**
  String get delivery_time_required;

  /// No description provided for @enter_delivery_time_here.
  ///
  /// In en, this message translates to:
  /// **'Enter your Delivery time here'**
  String get enter_delivery_time_here;

  /// No description provided for @please_remove_products_first.
  ///
  /// In en, this message translates to:
  /// **'please remove products first'**
  String get please_remove_products_first;

  /// No description provided for @choose_branch_required.
  ///
  /// In en, this message translates to:
  /// **'Choose branch *'**
  String get choose_branch_required;

  /// No description provided for @enter_branch_here.
  ///
  /// In en, this message translates to:
  /// **'Enter your branch here'**
  String get enter_branch_here;

  /// No description provided for @please_choose_branch_first.
  ///
  /// In en, this message translates to:
  /// **'Please choose your branch first'**
  String get please_choose_branch_first;

  /// No description provided for @choose_product_required.
  ///
  /// In en, this message translates to:
  /// **'Choose Product *'**
  String get choose_product_required;

  /// No description provided for @enter_product_here.
  ///
  /// In en, this message translates to:
  /// **'Enter your product here'**
  String get enter_product_here;

  /// No description provided for @confirm_now.
  ///
  /// In en, this message translates to:
  /// **'Confirm now'**
  String get confirm_now;

  /// No description provided for @no_notifications.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get no_notifications;

  /// No description provided for @no_current_notifications.
  ///
  /// In en, this message translates to:
  /// **'No Current Notifications'**
  String get no_current_notifications;

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get change_language;

  /// No description provided for @delete_address.
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get delete_address;

  /// No description provided for @delete_address_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address? This action cannot be undone.'**
  String get delete_address_confirmation;

  /// No description provided for @item_total.
  ///
  /// In en, this message translates to:
  /// **'Item total:'**
  String get item_total;

  /// No description provided for @delivery_charge.
  ///
  /// In en, this message translates to:
  /// **'Delivery charge:'**
  String get delivery_charge;

  /// No description provided for @free_delivery_condition.
  ///
  /// In en, this message translates to:
  /// **'You will get free delivery if the value of your products exceeds {value}'**
  String free_delivery_condition(String value);

  /// No description provided for @invalid_image.
  ///
  /// In en, this message translates to:
  /// **'❌ Invalid image'**
  String get invalid_image;

  /// No description provided for @error_decoding.
  ///
  /// In en, this message translates to:
  /// **'Error decoding'**
  String get error_decoding;

  /// No description provided for @search_your_coffee_sweets.
  ///
  /// In en, this message translates to:
  /// **'Search your Coffee & sweets'**
  String get search_your_coffee_sweets;

  /// No description provided for @find_best_branches.
  ///
  /// In en, this message translates to:
  /// **'Find best branches for you!'**
  String get find_best_branches;

  /// No description provided for @find_your_best_branch.
  ///
  /// In en, this message translates to:
  /// **'Find Your best Branch...'**
  String get find_your_best_branch;

  /// No description provided for @pay_with_points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get pay_with_points;

  /// No description provided for @money_to_back.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get money_to_back;

  /// No description provided for @view_qr_code.
  ///
  /// In en, this message translates to:
  /// **'View QR Code'**
  String get view_qr_code;

  /// No description provided for @address_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Address updated successfully'**
  String get address_updated_successfully;

  /// No description provided for @data_issue.
  ///
  /// In en, this message translates to:
  /// **'There is a data issue'**
  String get data_issue;

  /// No description provided for @select_location.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get select_location;

  /// No description provided for @select_location_first.
  ///
  /// In en, this message translates to:
  /// **'You must select the location first'**
  String get select_location_first;

  /// No description provided for @select_another_location.
  ///
  /// In en, this message translates to:
  /// **'You must select another location'**
  String get select_another_location;

  /// No description provided for @tap_map_to_select_location.
  ///
  /// In en, this message translates to:
  /// **'Tap on the map to select the location'**
  String get tap_map_to_select_location;

  /// No description provided for @unspecified_phrase.
  ///
  /// In en, this message translates to:
  /// **''**
  String get unspecified_phrase;

  /// No description provided for @branches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branches;

  /// No description provided for @points_count.
  ///
  /// In en, this message translates to:
  /// **'+{points_no} points'**
  String points_count(String points_no);

  /// No description provided for @sort_lowest_first.
  ///
  /// In en, this message translates to:
  /// **'Lowest first'**
  String get sort_lowest_first;

  /// No description provided for @no_phone_number.
  ///
  /// In en, this message translates to:
  /// **'No phone number'**
  String get no_phone_number;

  /// No description provided for @unfollow.
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get unfollow;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @new_entry.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get new_entry;

  /// No description provided for @recommended_branches.
  ///
  /// In en, this message translates to:
  /// **'Find best branches for you!'**
  String get recommended_branches;

  /// No description provided for @search_input_hint.
  ///
  /// In en, this message translates to:
  /// **'Search..'**
  String get search_input_hint;

  /// No description provided for @no_branch_assigned_message.
  ///
  /// In en, this message translates to:
  /// **'You do not have a branch'**
  String get no_branch_assigned_message;

  /// No description provided for @select_branch_prompt.
  ///
  /// In en, this message translates to:
  /// **'Please select the branch'**
  String get select_branch_prompt;

  /// No description provided for @select_branch_action.
  ///
  /// In en, this message translates to:
  /// **'Select branch'**
  String get select_branch_action;

  /// No description provided for @branch_list.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branch_list;

  /// No description provided for @view_all_items.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get view_all_items;

  /// No description provided for @rating_value.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating_value;

  /// No description provided for @delivery_rating_successful.
  ///
  /// In en, this message translates to:
  /// **'Delivery representative was successfully rated.'**
  String get delivery_rating_successful;

  /// No description provided for @operation_completed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Completed successfully'**
  String get operation_completed_successfully;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @driver_rating.
  ///
  /// In en, this message translates to:
  /// **'Rating driver'**
  String get driver_rating;

  /// No description provided for @payment_methods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get payment_methods;

  /// No description provided for @add_cards.
  ///
  /// In en, this message translates to:
  /// **'Add Cards'**
  String get add_cards;

  /// No description provided for @welcome_back_message.
  ///
  /// In en, this message translates to:
  /// **'Welcome back !'**
  String get welcome_back_message;

  /// No description provided for @welcome_back_message_register.
  ///
  /// In en, this message translates to:
  /// **'Welcome !'**
  String get welcome_back_message_register;

  /// No description provided for @registered_info_prompt.
  ///
  /// In en, this message translates to:
  /// **'Please enter the information registered with us.'**
  String get registered_info_prompt;

  /// No description provided for @register_info_prompt.
  ///
  /// In en, this message translates to:
  /// **'please enter your details to create an account.'**
  String get register_info_prompt;

  /// No description provided for @first_name_R.
  ///
  /// In en, this message translates to:
  /// **'First Name *'**
  String get first_name_R;

  /// No description provided for @last_name_R.
  ///
  /// In en, this message translates to:
  /// **'Last Name *'**
  String get last_name_R;

  /// No description provided for @phone_number_R.
  ///
  /// In en, this message translates to:
  /// **'Phone Number *'**
  String get phone_number_R;

  /// No description provided for @password_R.
  ///
  /// In en, this message translates to:
  /// **'Password *'**
  String get password_R;

  /// No description provided for @enter_your_password_here.
  ///
  /// In en, this message translates to:
  /// **'Enter your password here'**
  String get enter_your_password_here;

  /// No description provided for @password_not_match.
  ///
  /// In en, this message translates to:
  /// **'Password not match'**
  String get password_not_match;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @confirm_password_R.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password *'**
  String get confirm_password_R;

  /// No description provided for @enter_your_confirm_password_here.
  ///
  /// In en, this message translates to:
  /// **'Enter your confirm password here'**
  String get enter_your_confirm_password_here;

  /// No description provided for @p_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **' you agree Terms & Conditions & Privacy Policy.'**
  String get p_privacy_policy;

  /// No description provided for @my_order_schedule.
  ///
  /// In en, this message translates to:
  /// **'My order Schedule'**
  String get my_order_schedule;

  /// No description provided for @see_more.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get see_more;

  /// No description provided for @delivery_location.
  ///
  /// In en, this message translates to:
  /// **'Choose your location for delivery !'**
  String get delivery_location;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @save_action.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save_action;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @update_profile_success.
  ///
  /// In en, this message translates to:
  /// **'Update Profile Success'**
  String get update_profile_success;

  /// No description provided for @rank_winning_conditions.
  ///
  /// In en, this message translates to:
  /// **'Conditions for winning the {name} :'**
  String rank_winning_conditions(String name);

  /// No description provided for @classic_plus_tier.
  ///
  /// In en, this message translates to:
  /// **'Classic Plus'**
  String get classic_plus_tier;

  /// No description provided for @italian_coffee_cup_item.
  ///
  /// In en, this message translates to:
  /// **'Buy Italian Coffee Cup'**
  String get italian_coffee_cup_item;

  /// No description provided for @payment_method_type.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get payment_method_type;

  /// No description provided for @master_card_brand.
  ///
  /// In en, this message translates to:
  /// **'Master Card'**
  String get master_card_brand;

  /// No description provided for @points_entry_prompt.
  ///
  /// In en, this message translates to:
  /// **'Enter Number of points here'**
  String get points_entry_prompt;

  /// No description provided for @point_count.
  ///
  /// In en, this message translates to:
  /// **'Number of points *'**
  String get point_count;

  /// No description provided for @status_pending.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get status_pending;

  /// No description provided for @status_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get status_completed;

  /// No description provided for @status_canceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get status_canceled;

  /// No description provided for @edit_address.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get edit_address;

  /// No description provided for @personal_information.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_information;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @address_title.
  ///
  /// In en, this message translates to:
  /// **'Address Title'**
  String get address_title;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @save_address.
  ///
  /// In en, this message translates to:
  /// **'Save My Address'**
  String get save_address;

  /// No description provided for @delivery_option.
  ///
  /// In en, this message translates to:
  /// **'How would you like to receive your order'**
  String get delivery_option;

  /// No description provided for @failed_to_load_product_details.
  ///
  /// In en, this message translates to:
  /// **'Failed to load product details'**
  String get failed_to_load_product_details;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @continue_shopping.
  ///
  /// In en, this message translates to:
  /// **'Continue shopping'**
  String get continue_shopping;

  /// No description provided for @extra_large_cup.
  ///
  /// In en, this message translates to:
  /// **'Extra Large Cup'**
  String get extra_large_cup;

  /// No description provided for @aleey.
  ///
  /// In en, this message translates to:
  /// **'Aleey'**
  String get aleey;

  /// No description provided for @delivery_man.
  ///
  /// In en, this message translates to:
  /// **'Delivery man'**
  String get delivery_man;

  /// No description provided for @order_details.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get order_details;

  /// No description provided for @order_received.
  ///
  /// In en, this message translates to:
  /// **'Order received'**
  String get order_received;

  /// No description provided for @status_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get status_done;

  /// No description provided for @status_preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get status_preparing;

  /// No description provided for @status_in_progress.
  ///
  /// In en, this message translates to:
  /// **'In progress...'**
  String get status_in_progress;

  /// No description provided for @on_way.
  ///
  /// In en, this message translates to:
  /// **'On Way'**
  String get on_way;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @open_qr_code.
  ///
  /// In en, this message translates to:
  /// **'Open Qr Code'**
  String get open_qr_code;

  /// No description provided for @back_to_shopping.
  ///
  /// In en, this message translates to:
  /// **'Back to shopping'**
  String get back_to_shopping;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @user_points_increase.
  ///
  /// In en, this message translates to:
  /// **'+{pointsIncreaseUser} points'**
  String user_points_increase(String pointsIncreaseUser);

  /// No description provided for @order_receipt_time_minutes.
  ///
  /// In en, this message translates to:
  /// **'{orderReceiptTime} min'**
  String order_receipt_time_minutes(String orderReceiptTime);

  /// No description provided for @selected_items_discount_info.
  ///
  /// In en, this message translates to:
  /// **'Discount applies to selected items ordered with your added product'**
  String get selected_items_discount_info;

  /// No description provided for @delivery_option_place.
  ///
  /// In en, this message translates to:
  /// **'Deliver to place'**
  String get delivery_option_place;

  /// No description provided for @pickup_option_branch.
  ///
  /// In en, this message translates to:
  /// **'Pick up from branch'**
  String get pickup_option_branch;

  /// No description provided for @one_click_exchange_feature.
  ///
  /// In en, this message translates to:
  /// **'One-click exchange'**
  String get one_click_exchange_feature;

  /// No description provided for @is_free_delivery_eligible.
  ///
  /// In en, this message translates to:
  /// **'You will get free delivery if the value of your products exceeds {value}'**
  String is_free_delivery_eligible(String value);

  /// No description provided for @terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get terms_and_conditions;

  /// No description provided for @use_now.
  ///
  /// In en, this message translates to:
  /// **'Use Now'**
  String get use_now;

  /// No description provided for @search_location_prompt.
  ///
  /// In en, this message translates to:
  /// **'Search location...'**
  String get search_location_prompt;

  /// No description provided for @delivery_location_info_message.
  ///
  /// In en, this message translates to:
  /// **'Delivery will be made to the location you selected on the map. '**
  String get delivery_location_info_message;

  /// No description provided for @delivery_agent_help_message.
  ///
  /// In en, this message translates to:
  /// **'The information below is provided only to help the delivery agent reach you more easily.'**
  String get delivery_agent_help_message;

  /// No description provided for @use_location_action.
  ///
  /// In en, this message translates to:
  /// **'Use This Location'**
  String get use_location_action;

  /// No description provided for @select_date.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get select_date;

  /// No description provided for @select_file.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get select_file;

  /// No description provided for @select_image.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get select_image;

  /// No description provided for @choose_option_prompt.
  ///
  /// In en, this message translates to:
  /// **'Please Choose {label}'**
  String choose_option_prompt(String label);

  /// No description provided for @no_items.
  ///
  /// In en, this message translates to:
  /// **'No Items'**
  String get no_items;

  /// No description provided for @selected_location.
  ///
  /// In en, this message translates to:
  /// **'Selected Location'**
  String get selected_location;

  /// No description provided for @pick_location.
  ///
  /// In en, this message translates to:
  /// **'Pick Location'**
  String get pick_location;

  /// No description provided for @get_current_location.
  ///
  /// In en, this message translates to:
  /// **'Get current Location'**
  String get get_current_location;

  /// No description provided for @go_back.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get go_back;

  /// No description provided for @select_location_first_message.
  ///
  /// In en, this message translates to:
  /// **'Please select a location first.'**
  String get select_location_first_message;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get place;

  /// No description provided for @selection_prompt.
  ///
  /// In en, this message translates to:
  /// **'Please select {label}'**
  String selection_prompt(String label);

  /// No description provided for @confirm_logout_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out!?'**
  String get confirm_logout_message;

  /// No description provided for @action_reversible_message.
  ///
  /// In en, this message translates to:
  /// **'This Action is Reversible!'**
  String get action_reversible_message;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get log_out;

  /// No description provided for @top_rated.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get top_rated;

  /// No description provided for @lowest_first.
  ///
  /// In en, this message translates to:
  /// **'Lowest first'**
  String get lowest_first;

  /// No description provided for @newly_listed.
  ///
  /// In en, this message translates to:
  /// **'Newly listed'**
  String get newly_listed;

  /// No description provided for @nearest_first.
  ///
  /// In en, this message translates to:
  /// **'Nearest first'**
  String get nearest_first;

  /// No description provided for @higest_first.
  ///
  /// In en, this message translates to:
  /// **'Higest first'**
  String get higest_first;

  /// No description provided for @fastest_delivery.
  ///
  /// In en, this message translates to:
  /// **'Fastest delivery'**
  String get fastest_delivery;

  /// No description provided for @credit_cards.
  ///
  /// In en, this message translates to:
  /// **'Credit cards'**
  String get credit_cards;

  /// No description provided for @additional_filters.
  ///
  /// In en, this message translates to:
  /// **'Additional filters'**
  String get additional_filters;

  /// No description provided for @item_availability_update.
  ///
  /// In en, this message translates to:
  /// **'Item Availability Update'**
  String get item_availability_update;

  /// No description provided for @items_unavailable_message.
  ///
  /// In en, this message translates to:
  /// **'The following items are currently unavailable and will be removed from your reorder:'**
  String get items_unavailable_message;

  /// No description provided for @proceed_with_remaining.
  ///
  /// In en, this message translates to:
  /// **'Do you want to proceed with the remaining items?'**
  String get proceed_with_remaining;

  /// No description provided for @unknown_item.
  ///
  /// In en, this message translates to:
  /// **'Unknown Item'**
  String get unknown_item;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @coupon_code_copied.
  ///
  /// In en, this message translates to:
  /// **'Coupon code copied to clipboard'**
  String get coupon_code_copied;

  /// No description provided for @scan_qr_code.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scan_qr_code;

  /// No description provided for @ready_to_pick_up.
  ///
  /// In en, this message translates to:
  /// **'Ready to pick up'**
  String get ready_to_pick_up;

  /// No description provided for @branch_pickup_only.
  ///
  /// In en, this message translates to:
  /// **'Branch pickup only'**
  String get branch_pickup_only;

  /// No description provided for @scan_instruction_message.
  ///
  /// In en, this message translates to:
  /// **'Press the button below to start scanning the QR code'**
  String get scan_instruction_message;

  /// No description provided for @delete_payment_method_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Payment Method?'**
  String get delete_payment_method_title;

  /// No description provided for @delete_payment_method_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this payment method?'**
  String get delete_payment_method_confirmation;

  /// No description provided for @deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Deleted Successfully'**
  String get deleted_successfully;

  /// No description provided for @failed_to_delete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete'**
  String get failed_to_delete;

  /// No description provided for @empty_payment_methods.
  ///
  /// In en, this message translates to:
  /// **'No Payment Methods'**
  String get empty_payment_methods;

  /// No description provided for @add_payment_method_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new payment method to get started'**
  String get add_payment_method_subtitle;

  /// No description provided for @no_location_added_yet.
  ///
  /// In en, this message translates to:
  /// **'There is no location added yet'**
  String get no_location_added_yet;

  /// No description provided for @no_payment_yet.
  ///
  /// In en, this message translates to:
  /// **'No payment yet, add one'**
  String get no_payment_yet;

  /// No description provided for @valid_requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get valid_requiredField;

  /// No description provided for @valid_generalField.
  ///
  /// In en, this message translates to:
  /// **'Invalid field'**
  String get valid_generalField;

  /// No description provided for @valid_numberBetween.
  ///
  /// In en, this message translates to:
  /// **'Must be between {min} and {max} characters'**
  String valid_numberBetween(int min, int max);

  /// No description provided for @valid_exactLength.
  ///
  /// In en, this message translates to:
  /// **'Must be exactly {length} characters'**
  String valid_exactLength(int length);

  /// No description provided for @valid_requiredPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get valid_requiredPhone;

  /// No description provided for @valid_phoneDoseNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Phone number is not valid'**
  String get valid_phoneDoseNotMatch;

  /// No description provided for @valid_wrongEmailValidation.
  ///
  /// In en, this message translates to:
  /// **'Email is not valid'**
  String get valid_wrongEmailValidation;

  /// No description provided for @valid_requiredPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get valid_requiredPassword;

  /// No description provided for @valid_smallPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get valid_smallPassword;

  /// No description provided for @valid_passwordNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get valid_passwordNotMatch;
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
      <String>['ar', 'en', 'tr'].contains(locale.languageCode);

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
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
