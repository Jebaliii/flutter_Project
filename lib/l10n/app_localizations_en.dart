// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'StayEase';

  @override
  String get language => 'Language';

  @override
  String get lightTheme => 'Light theme';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get createAccount => 'Create an account';

  @override
  String get createAccountButton => 'Create account';

  @override
  String get loginError => 'Incorrect email or password';

  @override
  String get registerError => 'Unable to create the account';

  @override
  String get or => 'or';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get logout => 'Sign out';

  @override
  String get errorGoogleUnsupported =>
      'Google Sign-In is only available on Android. Run the app on the Android emulator.';

  @override
  String get errorGoogleToken => 'Google token not found';

  @override
  String errorGoogleFailed(String code) {
    return 'Google sign-in failed ($code)';
  }

  @override
  String errorFirebase(String code) {
    return 'Firebase error: $code';
  }

  @override
  String get errorNotLoggedIn => 'User not signed in';

  @override
  String get errorFirestoreTimeout =>
      'Firestore is not responding. Check that the database exists and that your internet connection works.';

  @override
  String errorWithMessage(String error) {
    return 'Error: $error';
  }

  @override
  String amountTnd(String amount) {
    return '$amount TND';
  }

  @override
  String pricePerNightShort(String price) {
    return '$price TND / night';
  }

  @override
  String nightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nights',
      one: '1 night',
      zero: '0 nights',
    );
    return '$_temp0';
  }

  @override
  String cityTunisia(String city) {
    return '$city, Tunisia';
  }

  @override
  String dateRange(String from, String to) {
    return '$from → $to';
  }

  @override
  String get arrival => 'Check-in';

  @override
  String get departure => 'Check-out';

  @override
  String get arrivalDate => 'Check-in date';

  @override
  String get departureDate => 'Check-out date';

  @override
  String get hotel => 'Hotel';

  @override
  String get address => 'Address';

  @override
  String get stayDuration => 'Length of stay';

  @override
  String get pricePerNight => 'Price per night';

  @override
  String get totalPrice => 'Total price';

  @override
  String get totalAmount => 'Total amount';

  @override
  String get bookingSummary => 'Your booking summary';

  @override
  String get hotelsInTunisia => 'Hotels in Tunisia';

  @override
  String get bookThisHotel => 'Book this hotel';

  @override
  String get myBookings => 'My bookings';

  @override
  String bookYourStayIn(String city) {
    return 'Book your stay in\n$city';
  }

  @override
  String chooseDatesAndBook(String hotel) {
    return 'Choose your dates and book $hotel.';
  }

  @override
  String get selectedHotel => 'Selected hotel';

  @override
  String get perkClimate => 'Pleasant climate';

  @override
  String get perkPrices => 'Competitive prices';

  @override
  String get perkStars => '4-5 star hotels';

  @override
  String get perkWifi => 'Free WiFi';

  @override
  String get whyBookNow => 'Why book now?';

  @override
  String get reasonBestPrice => 'Best price guaranteed';

  @override
  String get reasonBestPriceDesc => 'Book today and save up to 30%';

  @override
  String get reasonFreeCancel => 'Free cancellation';

  @override
  String get reasonFreeCancelDesc => 'Cancel up to 24h before check-in';

  @override
  String get reasonPremium => 'Premium service';

  @override
  String get reasonPremiumDesc => '24/7 assistance during your stay';

  @override
  String get selectYourDates => 'Select your dates';

  @override
  String get selectYourDatesSubtitle =>
      'Choose your check-in and check-out dates';

  @override
  String get stepCity => 'City';

  @override
  String get stepDates => 'Dates';

  @override
  String get stepHotel => 'Hotel';

  @override
  String get stepPayment => 'Payment';

  @override
  String destination(String city) {
    return 'Destination: $city';
  }

  @override
  String get selected => 'Selected';

  @override
  String get selectArrivalHelper => 'Select your check-in date';

  @override
  String stayDurationHelper(String duration) {
    return 'Length of stay: $duration';
  }

  @override
  String get required => 'Required';

  @override
  String get datePlaceholder => 'dd/mm/yyyy';

  @override
  String get suggestions => 'Suggestions:';

  @override
  String get today => 'Today';

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count days',
      one: 'In 1 day',
    );
    return '$_temp0';
  }

  @override
  String nightsInCity(int count, String city) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nights in $city',
      one: '1 night in $city',
      zero: '0 nights in $city',
    );
    return '$_temp0';
  }

  @override
  String totalWithAmount(String amount) {
    return 'Total: $amount';
  }

  @override
  String get continueButton => 'Continue';

  @override
  String get changeDestination => 'Change destination';

  @override
  String get finalizeBooking => 'Complete your booking';

  @override
  String get finalizeBookingSubtitle =>
      'Choose your payment method to confirm your stay';

  @override
  String get choosePaymentMethod => 'Choose your payment method';

  @override
  String get onlinePayment => 'Online payment';

  @override
  String get onlinePaymentDesc => 'Pay securely online';

  @override
  String get cashPayment => 'Cash payment';

  @override
  String get cashPaymentDesc => 'Pay at the hotel on arrival';

  @override
  String get pleaseChoosePaymentMethod => 'Please choose a payment method';

  @override
  String get mustAcceptTermsFull => 'You must accept the terms and conditions';

  @override
  String get mustAcceptTerms => 'You must accept the terms';

  @override
  String get paymentCancelled => 'Payment cancelled';

  @override
  String saveError(String error) {
    return 'Error while saving: $error';
  }

  @override
  String get iAccept => 'I accept the ';

  @override
  String get termsAndConditions => 'terms and conditions';

  @override
  String get andThe => ' and the ';

  @override
  String get privacyPolicy => 'privacy policy';

  @override
  String get continueToPayment => 'Continue to payment';

  @override
  String get confirmBooking => 'Confirm booking';

  @override
  String get backToDates => 'Back to dates';

  @override
  String get securePayment => '100% secure payment';

  @override
  String get securePaymentDesc => 'Your data is encrypted with SSL technology';

  @override
  String get cardHolder => 'Cardholder';

  @override
  String get cardHolderHint => 'Name as it appears on the card';

  @override
  String get cardHolderRequired => 'Cardholder name is required';

  @override
  String get nameTooShort => 'Name too short';

  @override
  String get lettersOnly => 'Letters only';

  @override
  String get cardNumber => 'Card number';

  @override
  String get cardNumberRequired => 'Card number is required';

  @override
  String cardNumberLength(int count) {
    return 'The number must contain $count digits';
  }

  @override
  String get cvvCode => 'CVV code';

  @override
  String get cvvRequired => 'CVV is required';

  @override
  String digitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count digits',
      one: '1 digit',
    );
    return '$_temp0';
  }

  @override
  String get expiryMonth => 'Expiry month';

  @override
  String get monthHint => 'Month';

  @override
  String get chooseMonth => 'Choose the month';

  @override
  String get expiryYear => 'Expiry year';

  @override
  String get yearHint => 'Year';

  @override
  String get chooseYear => 'Choose the year';

  @override
  String get cardExpired => 'Card expired';

  @override
  String payAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String get cancelPayment => 'Cancel payment';

  @override
  String get sslSecured => 'SSL secured';

  @override
  String get encryptedData => 'Encrypted data';

  @override
  String get support247 => '24/7 support';

  @override
  String get expiryDate => 'Expiry date';

  @override
  String get namePlaceholder => 'FULL NAME';

  @override
  String get expiryPlaceholder => 'MM/YY';

  @override
  String get cancelBookingQuestion => 'Cancel this booking?';

  @override
  String get no => 'No';

  @override
  String get yesCancel => 'Yes, cancel';

  @override
  String get bookingCancelled => 'Booking cancelled';

  @override
  String get reference => 'Reference';

  @override
  String get duration => 'Duration';

  @override
  String get payment => 'Payment';

  @override
  String get online => 'Online';

  @override
  String get cash => 'Cash';

  @override
  String get status => 'Status';

  @override
  String get total => 'Total';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get loadingError => 'Loading error';

  @override
  String get noBookings => 'No bookings';

  @override
  String get noBookingsYet => 'You haven\'t booked anything yet.';

  @override
  String get noResultsForFilter => 'No results for this filter.';

  @override
  String get backToMap => 'Back to the map';

  @override
  String get myBookingsSubtitle => 'View and manage all your bookings';

  @override
  String get newBooking => 'New booking';

  @override
  String get totalBookings => 'Total bookings';

  @override
  String get confirmedPlural => 'Confirmed';

  @override
  String get pendingPlural => 'Pending';

  @override
  String get filterByStatus => 'Filter by status';

  @override
  String filterAll(int count) {
    return 'All ($count)';
  }

  @override
  String filterConfirmed(int count) {
    return 'Confirmed ($count)';
  }

  @override
  String filterPending(int count) {
    return 'Pending ($count)';
  }

  @override
  String filterCancelled(int count) {
    return 'Cancelled ($count)';
  }

  @override
  String get searchHint => 'Search for a hotel or a city...';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String bookedOn(String date) {
    return 'Booked on $date';
  }

  @override
  String dateAtTime(String date, String time) {
    return '$date at $time';
  }

  @override
  String get details => 'Details';

  @override
  String get cancel => 'Cancel';

  @override
  String get fillAllFields => 'Please fill in all fields';

  @override
  String get errorInvalidCredentials => 'Incorrect email or password';

  @override
  String get errorEmailInUse => 'This email is already used by another account';

  @override
  String get errorWeakPassword => 'Password too weak (at least 6 characters)';

  @override
  String get errorInvalidEmail => 'Invalid email address';

  @override
  String get errorNetwork =>
      'No internet connection. Check your network and try again.';

  @override
  String get errorTooManyRequests =>
      'Too many attempts. Try again in a few minutes.';

  @override
  String get errorPermissionDenied =>
      'Access denied. You are not allowed to do this.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please try again.';

  @override
  String get retry => 'Retry';

  @override
  String get mapLoadError => 'Unable to load the map. Check your connection.';

  @override
  String get logoutError => 'Sign-out failed. Please try again.';

  @override
  String get bookingConfirmedTitle => 'Booking saved!';

  @override
  String get bookingConfirmedOnline =>
      'Payment accepted. Your stay is confirmed.';

  @override
  String get bookingConfirmedCash =>
      'Your stay is booked. You will pay at the hotel.';

  @override
  String get seeMyBookings => 'See my bookings';

  @override
  String get notifBookingConfirmedTitle => 'Booking confirmed ✅';

  @override
  String notifBookingConfirmedBody(String hotel, String dates) {
    return '$hotel · $dates. Payment accepted, see you soon!';
  }

  @override
  String get notifBookingPendingTitle => 'Booking pending ⏳';

  @override
  String notifBookingPendingBody(String hotel, String dates) {
    return '$hotel · $dates. Payment due at the hotel.';
  }

  @override
  String get navExplore => 'Explore';

  @override
  String get tabMap => 'Map';

  @override
  String get tabList => 'List';

  @override
  String get registerAsAdmin => 'Register as administrator';

  @override
  String get adminCode => 'Administrator code';

  @override
  String get errorAdminCode => 'Invalid administrator code.';

  @override
  String get errorAccountDisabled =>
      'This account has been blocked by an administrator.';

  @override
  String get adminTitle => 'Administration';

  @override
  String get adminDashboard => 'Dashboard';

  @override
  String get adminBookings => 'Bookings';

  @override
  String get adminHotels => 'Hotels';

  @override
  String get adminUsers => 'Users';

  @override
  String get clientView => 'Client view';

  @override
  String get revenue => 'Revenue (confirmed bookings)';

  @override
  String get recentBookings => 'Latest bookings';

  @override
  String get searchBookingsHint => 'Hotel, city or client email...';

  @override
  String get markConfirmed => 'Confirm';

  @override
  String get markPending => 'Set as pending';

  @override
  String get markCancelled => 'Cancel booking';

  @override
  String get bookingUpdated => 'Booking updated';

  @override
  String get bookingDeleted => 'Booking deleted';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String deleteQuestion(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get irreversible => 'This action cannot be undone.';

  @override
  String get addHotel => 'Add a hotel';

  @override
  String get editHotel => 'Edit hotel';

  @override
  String get hotelName => 'Hotel name';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get pricePerNightTnd => 'Price per night (TND)';

  @override
  String get stars => 'Stars';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get hotelSaved => 'Hotel saved';

  @override
  String get hotelDeleted => 'Hotel deleted';

  @override
  String get noHotels => 'No hotels';

  @override
  String noHotelsDesc(int count) {
    return 'Clients see the built-in catalogue ($count hotels). Import it to manage it here.';
  }

  @override
  String get importHotels => 'Import hotels';

  @override
  String hotelsImported(int count) {
    return '$count hotels imported';
  }

  @override
  String get searchUsersHint => 'Search an email...';

  @override
  String get noUsers => 'No users';

  @override
  String get you => '(you)';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleUser => 'Client';

  @override
  String get blocked => 'Blocked';

  @override
  String get makeAdmin => 'Make administrator';

  @override
  String get removeAdmin => 'Remove admin rights';

  @override
  String get blockUser => 'Block';

  @override
  String get unblockUser => 'Unblock';

  @override
  String get userUpdated => 'User updated';
}
