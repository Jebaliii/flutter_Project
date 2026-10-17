import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'StayEase'**
  String get appName;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @loginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get loginTitle;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccount;

  /// No description provided for @createAccountButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer le compte'**
  String get createAccountButton;

  /// No description provided for @loginError.
  ///
  /// In fr, this message translates to:
  /// **'Email ou mot de passe incorrect'**
  String get loginError;

  /// No description provided for @registerError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de créer le compte'**
  String get registerError;

  /// No description provided for @or.
  ///
  /// In fr, this message translates to:
  /// **'ou'**
  String get or;

  /// No description provided for @continueWithGoogle.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Google'**
  String get continueWithGoogle;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logout;

  /// No description provided for @errorGoogleUnsupported.
  ///
  /// In fr, this message translates to:
  /// **'Google Sign-In est disponible sur Android uniquement. Lancez l\'application sur l\'émulateur Android.'**
  String get errorGoogleUnsupported;

  /// No description provided for @errorGoogleToken.
  ///
  /// In fr, this message translates to:
  /// **'Jeton Google introuvable'**
  String get errorGoogleToken;

  /// No description provided for @errorGoogleFailed.
  ///
  /// In fr, this message translates to:
  /// **'Connexion Google impossible ({code})'**
  String errorGoogleFailed(String code);

  /// No description provided for @errorFirebase.
  ///
  /// In fr, this message translates to:
  /// **'Erreur Firebase : {code}'**
  String errorFirebase(String code);

  /// No description provided for @errorNotLoggedIn.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur non connecté'**
  String get errorNotLoggedIn;

  /// No description provided for @errorFirestoreTimeout.
  ///
  /// In fr, this message translates to:
  /// **'Firestore ne répond pas. Vérifiez que la base est créée et que la connexion internet fonctionne.'**
  String get errorFirestoreTimeout;

  /// No description provided for @errorWithMessage.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : {error}'**
  String errorWithMessage(String error);

  /// No description provided for @amountTnd.
  ///
  /// In fr, this message translates to:
  /// **'{amount} TND'**
  String amountTnd(String amount);

  /// No description provided for @pricePerNightShort.
  ///
  /// In fr, this message translates to:
  /// **'{price} TND / nuit'**
  String pricePerNightShort(String price);

  /// No description provided for @nightsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 nuit} =1{1 nuit} other{{count} nuits}}'**
  String nightsCount(int count);

  /// No description provided for @cityTunisia.
  ///
  /// In fr, this message translates to:
  /// **'{city}, Tunisie'**
  String cityTunisia(String city);

  /// No description provided for @dateRange.
  ///
  /// In fr, this message translates to:
  /// **'{from} → {to}'**
  String dateRange(String from, String to);

  /// No description provided for @arrival.
  ///
  /// In fr, this message translates to:
  /// **'Arrivée'**
  String get arrival;

  /// No description provided for @departure.
  ///
  /// In fr, this message translates to:
  /// **'Départ'**
  String get departure;

  /// No description provided for @arrivalDate.
  ///
  /// In fr, this message translates to:
  /// **'Date d\'arrivée'**
  String get arrivalDate;

  /// No description provided for @departureDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de départ'**
  String get departureDate;

  /// No description provided for @hotel.
  ///
  /// In fr, this message translates to:
  /// **'Hôtel'**
  String get hotel;

  /// No description provided for @address.
  ///
  /// In fr, this message translates to:
  /// **'Adresse'**
  String get address;

  /// No description provided for @stayDuration.
  ///
  /// In fr, this message translates to:
  /// **'Durée du séjour'**
  String get stayDuration;

  /// No description provided for @pricePerNight.
  ///
  /// In fr, this message translates to:
  /// **'Prix par nuit'**
  String get pricePerNight;

  /// No description provided for @totalPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix total'**
  String get totalPrice;

  /// No description provided for @totalAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant total'**
  String get totalAmount;

  /// No description provided for @bookingSummary.
  ///
  /// In fr, this message translates to:
  /// **'Récapitulatif de votre réservation'**
  String get bookingSummary;

  /// No description provided for @hotelsInTunisia.
  ///
  /// In fr, this message translates to:
  /// **'Hôtels en Tunisie'**
  String get hotelsInTunisia;

  /// No description provided for @bookThisHotel.
  ///
  /// In fr, this message translates to:
  /// **'Réserver cet hôtel'**
  String get bookThisHotel;

  /// No description provided for @myBookings.
  ///
  /// In fr, this message translates to:
  /// **'Mes réservations'**
  String get myBookings;

  /// No description provided for @bookYourStayIn.
  ///
  /// In fr, this message translates to:
  /// **'Réservez votre séjour à\n{city}'**
  String bookYourStayIn(String city);

  /// No description provided for @chooseDatesAndBook.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez vos dates et réservez {hotel}.'**
  String chooseDatesAndBook(String hotel);

  /// No description provided for @selectedHotel.
  ///
  /// In fr, this message translates to:
  /// **'Hôtel sélectionné'**
  String get selectedHotel;

  /// No description provided for @perkClimate.
  ///
  /// In fr, this message translates to:
  /// **'Climat favorable'**
  String get perkClimate;

  /// No description provided for @perkPrices.
  ///
  /// In fr, this message translates to:
  /// **'Prix compétitifs'**
  String get perkPrices;

  /// No description provided for @perkStars.
  ///
  /// In fr, this message translates to:
  /// **'Hôtels 4-5 étoiles'**
  String get perkStars;

  /// No description provided for @perkWifi.
  ///
  /// In fr, this message translates to:
  /// **'WiFi gratuit'**
  String get perkWifi;

  /// No description provided for @whyBookNow.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi réserver maintenant ?'**
  String get whyBookNow;

  /// No description provided for @reasonBestPrice.
  ///
  /// In fr, this message translates to:
  /// **'Meilleur prix garanti'**
  String get reasonBestPrice;

  /// No description provided for @reasonBestPriceDesc.
  ///
  /// In fr, this message translates to:
  /// **'Réservez aujourd\'hui et économisez jusqu\'à 30%'**
  String get reasonBestPriceDesc;

  /// No description provided for @reasonFreeCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annulation gratuite'**
  String get reasonFreeCancel;

  /// No description provided for @reasonFreeCancelDesc.
  ///
  /// In fr, this message translates to:
  /// **'Annulez jusqu\'à 24h avant votre arrivée'**
  String get reasonFreeCancelDesc;

  /// No description provided for @reasonPremium.
  ///
  /// In fr, this message translates to:
  /// **'Service premium'**
  String get reasonPremium;

  /// No description provided for @reasonPremiumDesc.
  ///
  /// In fr, this message translates to:
  /// **'Assistance 24/7 pendant votre séjour'**
  String get reasonPremiumDesc;

  /// No description provided for @selectYourDates.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez vos dates'**
  String get selectYourDates;

  /// No description provided for @selectYourDatesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez vos dates d\'arrivée et de départ'**
  String get selectYourDatesSubtitle;

  /// No description provided for @stepCity.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get stepCity;

  /// No description provided for @stepDates.
  ///
  /// In fr, this message translates to:
  /// **'Dates'**
  String get stepDates;

  /// No description provided for @stepHotel.
  ///
  /// In fr, this message translates to:
  /// **'Hôtel'**
  String get stepHotel;

  /// No description provided for @stepPayment.
  ///
  /// In fr, this message translates to:
  /// **'Paiement'**
  String get stepPayment;

  /// No description provided for @destination.
  ///
  /// In fr, this message translates to:
  /// **'Destination : {city}'**
  String destination(String city);

  /// No description provided for @selected.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionné'**
  String get selected;

  /// No description provided for @selectArrivalHelper.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez votre date d\'arrivée'**
  String get selectArrivalHelper;

  /// No description provided for @stayDurationHelper.
  ///
  /// In fr, this message translates to:
  /// **'Durée du séjour : {duration}'**
  String stayDurationHelper(String duration);

  /// No description provided for @required.
  ///
  /// In fr, this message translates to:
  /// **'Requis'**
  String get required;

  /// No description provided for @datePlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'jj/mm/aaaa'**
  String get datePlaceholder;

  /// No description provided for @suggestions.
  ///
  /// In fr, this message translates to:
  /// **'Suggestions :'**
  String get suggestions;

  /// No description provided for @today.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get today;

  /// No description provided for @inDays.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Dans 1 jour} other{Dans {count} jours}}'**
  String inDays(int count);

  /// No description provided for @nightsInCity.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 nuit à {city}} =1{1 nuit à {city}} other{{count} nuits à {city}}}'**
  String nightsInCity(int count, String city);

  /// No description provided for @totalWithAmount.
  ///
  /// In fr, this message translates to:
  /// **'Total : {amount}'**
  String totalWithAmount(String amount);

  /// No description provided for @continueButton.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continueButton;

  /// No description provided for @changeDestination.
  ///
  /// In fr, this message translates to:
  /// **'Changer de destination'**
  String get changeDestination;

  /// No description provided for @finalizeBooking.
  ///
  /// In fr, this message translates to:
  /// **'Finalisez votre réservation'**
  String get finalizeBooking;

  /// No description provided for @finalizeBookingSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre méthode de paiement pour confirmer votre séjour'**
  String get finalizeBookingSubtitle;

  /// No description provided for @choosePaymentMethod.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre méthode de paiement'**
  String get choosePaymentMethod;

  /// No description provided for @onlinePayment.
  ///
  /// In fr, this message translates to:
  /// **'Paiement en ligne'**
  String get onlinePayment;

  /// No description provided for @onlinePaymentDesc.
  ///
  /// In fr, this message translates to:
  /// **'Payez en ligne de manière sécurisée'**
  String get onlinePaymentDesc;

  /// No description provided for @cashPayment.
  ///
  /// In fr, this message translates to:
  /// **'Paiement en espèces'**
  String get cashPayment;

  /// No description provided for @cashPaymentDesc.
  ///
  /// In fr, this message translates to:
  /// **'Payez à l\'hôtel à votre arrivée'**
  String get cashPaymentDesc;

  /// No description provided for @pleaseChoosePaymentMethod.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez choisir une méthode de paiement'**
  String get pleaseChoosePaymentMethod;

  /// No description provided for @mustAcceptTermsFull.
  ///
  /// In fr, this message translates to:
  /// **'Vous devez accepter les conditions générales'**
  String get mustAcceptTermsFull;

  /// No description provided for @mustAcceptTerms.
  ///
  /// In fr, this message translates to:
  /// **'Vous devez accepter les conditions'**
  String get mustAcceptTerms;

  /// No description provided for @paymentCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Paiement annulé'**
  String get paymentCancelled;

  /// No description provided for @saveError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'enregistrement : {error}'**
  String saveError(String error);

  /// No description provided for @iAccept.
  ///
  /// In fr, this message translates to:
  /// **'J\'accepte les '**
  String get iAccept;

  /// No description provided for @termsAndConditions.
  ///
  /// In fr, this message translates to:
  /// **'conditions générales'**
  String get termsAndConditions;

  /// No description provided for @andThe.
  ///
  /// In fr, this message translates to:
  /// **' et la '**
  String get andThe;

  /// No description provided for @privacyPolicy.
  ///
  /// In fr, this message translates to:
  /// **'politique de confidentialité'**
  String get privacyPolicy;

  /// No description provided for @continueToPayment.
  ///
  /// In fr, this message translates to:
  /// **'Continuer vers le paiement'**
  String get continueToPayment;

  /// No description provided for @confirmBooking.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la réservation'**
  String get confirmBooking;

  /// No description provided for @backToDates.
  ///
  /// In fr, this message translates to:
  /// **'Retour aux dates'**
  String get backToDates;

  /// No description provided for @securePayment.
  ///
  /// In fr, this message translates to:
  /// **'Paiement 100% sécurisé'**
  String get securePayment;

  /// No description provided for @securePaymentDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vos données sont cryptées avec la technologie SSL'**
  String get securePaymentDesc;

  /// No description provided for @cardHolder.
  ///
  /// In fr, this message translates to:
  /// **'Titulaire de la carte'**
  String get cardHolder;

  /// No description provided for @cardHolderHint.
  ///
  /// In fr, this message translates to:
  /// **'Nom tel qu\'il apparaît sur la carte'**
  String get cardHolderHint;

  /// No description provided for @cardHolderRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le nom du titulaire est obligatoire'**
  String get cardHolderRequired;

  /// No description provided for @nameTooShort.
  ///
  /// In fr, this message translates to:
  /// **'Nom trop court'**
  String get nameTooShort;

  /// No description provided for @lettersOnly.
  ///
  /// In fr, this message translates to:
  /// **'Lettres uniquement'**
  String get lettersOnly;

  /// No description provided for @cardNumber.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de carte'**
  String get cardNumber;

  /// No description provided for @cardNumberRequired.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de carte obligatoire'**
  String get cardNumberRequired;

  /// No description provided for @cardNumberLength.
  ///
  /// In fr, this message translates to:
  /// **'Le numéro doit contenir {count} chiffres'**
  String cardNumberLength(int count);

  /// No description provided for @cvvCode.
  ///
  /// In fr, this message translates to:
  /// **'Code CVV'**
  String get cvvCode;

  /// No description provided for @cvvRequired.
  ///
  /// In fr, this message translates to:
  /// **'CVV obligatoire'**
  String get cvvRequired;

  /// No description provided for @digitsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 chiffre} other{{count} chiffres}}'**
  String digitsCount(int count);

  /// No description provided for @expiryMonth.
  ///
  /// In fr, this message translates to:
  /// **'Mois d\'expiration'**
  String get expiryMonth;

  /// No description provided for @monthHint.
  ///
  /// In fr, this message translates to:
  /// **'Mois'**
  String get monthHint;

  /// No description provided for @chooseMonth.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez le mois'**
  String get chooseMonth;

  /// No description provided for @expiryYear.
  ///
  /// In fr, this message translates to:
  /// **'Année d\'expiration'**
  String get expiryYear;

  /// No description provided for @yearHint.
  ///
  /// In fr, this message translates to:
  /// **'Année'**
  String get yearHint;

  /// No description provided for @chooseYear.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez l\'année'**
  String get chooseYear;

  /// No description provided for @cardExpired.
  ///
  /// In fr, this message translates to:
  /// **'Carte expirée'**
  String get cardExpired;

  /// No description provided for @payAmount.
  ///
  /// In fr, this message translates to:
  /// **'Payer {amount}'**
  String payAmount(String amount);

  /// No description provided for @cancelPayment.
  ///
  /// In fr, this message translates to:
  /// **'Annuler le paiement'**
  String get cancelPayment;

  /// No description provided for @sslSecured.
  ///
  /// In fr, this message translates to:
  /// **'SSL sécurisé'**
  String get sslSecured;

  /// No description provided for @encryptedData.
  ///
  /// In fr, this message translates to:
  /// **'Données cryptées'**
  String get encryptedData;

  /// No description provided for @support247.
  ///
  /// In fr, this message translates to:
  /// **'Support 24/7'**
  String get support247;

  /// No description provided for @expiryDate.
  ///
  /// In fr, this message translates to:
  /// **'Date d\'expiration'**
  String get expiryDate;

  /// No description provided for @namePlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'NOM PRÉNOM'**
  String get namePlaceholder;

  /// No description provided for @expiryPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'MM/AA'**
  String get expiryPlaceholder;

  /// No description provided for @cancelBookingQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la réservation ?'**
  String get cancelBookingQuestion;

  /// No description provided for @no.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get no;

  /// No description provided for @yesCancel.
  ///
  /// In fr, this message translates to:
  /// **'Oui, annuler'**
  String get yesCancel;

  /// No description provided for @bookingCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Réservation annulée'**
  String get bookingCancelled;

  /// No description provided for @reference.
  ///
  /// In fr, this message translates to:
  /// **'Référence'**
  String get reference;

  /// No description provided for @duration.
  ///
  /// In fr, this message translates to:
  /// **'Durée'**
  String get duration;

  /// No description provided for @payment.
  ///
  /// In fr, this message translates to:
  /// **'Paiement'**
  String get payment;

  /// No description provided for @online.
  ///
  /// In fr, this message translates to:
  /// **'En ligne'**
  String get online;

  /// No description provided for @cash.
  ///
  /// In fr, this message translates to:
  /// **'Espèces'**
  String get cash;

  /// No description provided for @status.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get status;

  /// No description provided for @total.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @statusConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Confirmée'**
  String get statusConfirmed;

  /// No description provided for @statusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get statusPending;

  /// No description provided for @statusCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulée'**
  String get statusCancelled;

  /// No description provided for @loadingError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de chargement'**
  String get loadingError;

  /// No description provided for @noBookings.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation'**
  String get noBookings;

  /// No description provided for @noBookingsYet.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas encore réservé.'**
  String get noBookingsYet;

  /// No description provided for @noResultsForFilter.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat pour ce filtre.'**
  String get noResultsForFilter;

  /// No description provided for @backToMap.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la carte'**
  String get backToMap;

  /// No description provided for @myBookingsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Consultez et gérez toutes vos réservations'**
  String get myBookingsSubtitle;

  /// No description provided for @newBooking.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle réservation'**
  String get newBooking;

  /// No description provided for @totalBookings.
  ///
  /// In fr, this message translates to:
  /// **'Réservations totales'**
  String get totalBookings;

  /// No description provided for @confirmedPlural.
  ///
  /// In fr, this message translates to:
  /// **'Confirmées'**
  String get confirmedPlural;

  /// No description provided for @pendingPlural.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get pendingPlural;

  /// No description provided for @filterByStatus.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer par statut'**
  String get filterByStatus;

  /// No description provided for @filterAll.
  ///
  /// In fr, this message translates to:
  /// **'Toutes ({count})'**
  String filterAll(int count);

  /// No description provided for @filterConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Confirmées ({count})'**
  String filterConfirmed(int count);

  /// No description provided for @filterPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente ({count})'**
  String filterPending(int count);

  /// No description provided for @filterCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulées ({count})'**
  String filterCancelled(int count);

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un hôtel ou une ville...'**
  String get searchHint;

  /// No description provided for @paymentMethod.
  ///
  /// In fr, this message translates to:
  /// **'Méthode de paiement'**
  String get paymentMethod;

  /// No description provided for @bookedOn.
  ///
  /// In fr, this message translates to:
  /// **'Réservée le {date}'**
  String bookedOn(String date);

  /// No description provided for @dateAtTime.
  ///
  /// In fr, this message translates to:
  /// **'{date} à {time}'**
  String dateAtTime(String date, String time);

  /// No description provided for @details.
  ///
  /// In fr, this message translates to:
  /// **'Détails'**
  String get details;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;
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
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

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
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
