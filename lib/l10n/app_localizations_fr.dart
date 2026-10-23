// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'StayEase';

  @override
  String get language => 'Langue';

  @override
  String get lightTheme => 'Thème clair';

  @override
  String get darkTheme => 'Thème sombre';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get createAccountButton => 'Créer le compte';

  @override
  String get loginError => 'Email ou mot de passe incorrect';

  @override
  String get registerError => 'Impossible de créer le compte';

  @override
  String get or => 'ou';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get errorGoogleUnsupported =>
      'Google Sign-In est disponible sur Android uniquement. Lancez l\'application sur l\'émulateur Android.';

  @override
  String get errorGoogleToken => 'Jeton Google introuvable';

  @override
  String errorGoogleFailed(String code) {
    return 'Connexion Google impossible ($code)';
  }

  @override
  String errorFirebase(String code) {
    return 'Erreur Firebase : $code';
  }

  @override
  String get errorNotLoggedIn => 'Utilisateur non connecté';

  @override
  String get errorFirestoreTimeout =>
      'Firestore ne répond pas. Vérifiez que la base est créée et que la connexion internet fonctionne.';

  @override
  String errorWithMessage(String error) {
    return 'Erreur : $error';
  }

  @override
  String amountTnd(String amount) {
    return '$amount TND';
  }

  @override
  String pricePerNightShort(String price) {
    return '$price TND / nuit';
  }

  @override
  String nightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nuits',
      one: '1 nuit',
      zero: '0 nuit',
    );
    return '$_temp0';
  }

  @override
  String cityTunisia(String city) {
    return '$city, Tunisie';
  }

  @override
  String dateRange(String from, String to) {
    return '$from → $to';
  }

  @override
  String get arrival => 'Arrivée';

  @override
  String get departure => 'Départ';

  @override
  String get arrivalDate => 'Date d\'arrivée';

  @override
  String get departureDate => 'Date de départ';

  @override
  String get hotel => 'Hôtel';

  @override
  String get address => 'Adresse';

  @override
  String get stayDuration => 'Durée du séjour';

  @override
  String get pricePerNight => 'Prix par nuit';

  @override
  String get totalPrice => 'Prix total';

  @override
  String get totalAmount => 'Montant total';

  @override
  String get bookingSummary => 'Récapitulatif de votre réservation';

  @override
  String get hotelsInTunisia => 'Hôtels en Tunisie';

  @override
  String get bookThisHotel => 'Réserver cet hôtel';

  @override
  String get myBookings => 'Mes réservations';

  @override
  String bookYourStayIn(String city) {
    return 'Réservez votre séjour à\n$city';
  }

  @override
  String chooseDatesAndBook(String hotel) {
    return 'Choisissez vos dates et réservez $hotel.';
  }

  @override
  String get selectedHotel => 'Hôtel sélectionné';

  @override
  String get perkClimate => 'Climat favorable';

  @override
  String get perkPrices => 'Prix compétitifs';

  @override
  String get perkStars => 'Hôtels 4-5 étoiles';

  @override
  String get perkWifi => 'WiFi gratuit';

  @override
  String get whyBookNow => 'Pourquoi réserver maintenant ?';

  @override
  String get reasonBestPrice => 'Meilleur prix garanti';

  @override
  String get reasonBestPriceDesc =>
      'Réservez aujourd\'hui et économisez jusqu\'à 30%';

  @override
  String get reasonFreeCancel => 'Annulation gratuite';

  @override
  String get reasonFreeCancelDesc => 'Annulez jusqu\'à 24h avant votre arrivée';

  @override
  String get reasonPremium => 'Service premium';

  @override
  String get reasonPremiumDesc => 'Assistance 24/7 pendant votre séjour';

  @override
  String get selectYourDates => 'Sélectionnez vos dates';

  @override
  String get selectYourDatesSubtitle =>
      'Choisissez vos dates d\'arrivée et de départ';

  @override
  String get stepCity => 'Ville';

  @override
  String get stepDates => 'Dates';

  @override
  String get stepHotel => 'Hôtel';

  @override
  String get stepPayment => 'Paiement';

  @override
  String destination(String city) {
    return 'Destination : $city';
  }

  @override
  String get selected => 'Sélectionné';

  @override
  String get selectArrivalHelper => 'Sélectionnez votre date d\'arrivée';

  @override
  String stayDurationHelper(String duration) {
    return 'Durée du séjour : $duration';
  }

  @override
  String get required => 'Requis';

  @override
  String get datePlaceholder => 'jj/mm/aaaa';

  @override
  String get suggestions => 'Suggestions :';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dans $count jours',
      one: 'Dans 1 jour',
    );
    return '$_temp0';
  }

  @override
  String nightsInCity(int count, String city) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nuits à $city',
      one: '1 nuit à $city',
      zero: '0 nuit à $city',
    );
    return '$_temp0';
  }

  @override
  String totalWithAmount(String amount) {
    return 'Total : $amount';
  }

  @override
  String get continueButton => 'Continuer';

  @override
  String get changeDestination => 'Changer de destination';

  @override
  String get finalizeBooking => 'Finalisez votre réservation';

  @override
  String get finalizeBookingSubtitle =>
      'Choisissez votre méthode de paiement pour confirmer votre séjour';

  @override
  String get choosePaymentMethod => 'Choisissez votre méthode de paiement';

  @override
  String get onlinePayment => 'Paiement en ligne';

  @override
  String get onlinePaymentDesc => 'Payez en ligne de manière sécurisée';

  @override
  String get cashPayment => 'Paiement en espèces';

  @override
  String get cashPaymentDesc => 'Payez à l\'hôtel à votre arrivée';

  @override
  String get pleaseChoosePaymentMethod =>
      'Veuillez choisir une méthode de paiement';

  @override
  String get mustAcceptTermsFull =>
      'Vous devez accepter les conditions générales';

  @override
  String get mustAcceptTerms => 'Vous devez accepter les conditions';

  @override
  String get paymentCancelled => 'Paiement annulé';

  @override
  String saveError(String error) {
    return 'Erreur lors de l\'enregistrement : $error';
  }

  @override
  String get iAccept => 'J\'accepte les ';

  @override
  String get termsAndConditions => 'conditions générales';

  @override
  String get andThe => ' et la ';

  @override
  String get privacyPolicy => 'politique de confidentialité';

  @override
  String get continueToPayment => 'Continuer vers le paiement';

  @override
  String get confirmBooking => 'Confirmer la réservation';

  @override
  String get backToDates => 'Retour aux dates';

  @override
  String get securePayment => 'Paiement 100% sécurisé';

  @override
  String get securePaymentDesc =>
      'Vos données sont cryptées avec la technologie SSL';

  @override
  String get cardHolder => 'Titulaire de la carte';

  @override
  String get cardHolderHint => 'Nom tel qu\'il apparaît sur la carte';

  @override
  String get cardHolderRequired => 'Le nom du titulaire est obligatoire';

  @override
  String get nameTooShort => 'Nom trop court';

  @override
  String get lettersOnly => 'Lettres uniquement';

  @override
  String get cardNumber => 'Numéro de carte';

  @override
  String get cardNumberRequired => 'Numéro de carte obligatoire';

  @override
  String cardNumberLength(int count) {
    return 'Le numéro doit contenir $count chiffres';
  }

  @override
  String get cvvCode => 'Code CVV';

  @override
  String get cvvRequired => 'CVV obligatoire';

  @override
  String digitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chiffres',
      one: '1 chiffre',
    );
    return '$_temp0';
  }

  @override
  String get expiryMonth => 'Mois d\'expiration';

  @override
  String get monthHint => 'Mois';

  @override
  String get chooseMonth => 'Choisissez le mois';

  @override
  String get expiryYear => 'Année d\'expiration';

  @override
  String get yearHint => 'Année';

  @override
  String get chooseYear => 'Choisissez l\'année';

  @override
  String get cardExpired => 'Carte expirée';

  @override
  String payAmount(String amount) {
    return 'Payer $amount';
  }

  @override
  String get cancelPayment => 'Annuler le paiement';

  @override
  String get sslSecured => 'SSL sécurisé';

  @override
  String get encryptedData => 'Données cryptées';

  @override
  String get support247 => 'Support 24/7';

  @override
  String get expiryDate => 'Date d\'expiration';

  @override
  String get namePlaceholder => 'NOM PRÉNOM';

  @override
  String get expiryPlaceholder => 'MM/AA';

  @override
  String get cancelBookingQuestion => 'Annuler la réservation ?';

  @override
  String get no => 'Non';

  @override
  String get yesCancel => 'Oui, annuler';

  @override
  String get bookingCancelled => 'Réservation annulée';

  @override
  String get reference => 'Référence';

  @override
  String get duration => 'Durée';

  @override
  String get payment => 'Paiement';

  @override
  String get online => 'En ligne';

  @override
  String get cash => 'Espèces';

  @override
  String get status => 'Statut';

  @override
  String get total => 'Total';

  @override
  String get statusConfirmed => 'Confirmée';

  @override
  String get statusPending => 'En attente';

  @override
  String get statusCancelled => 'Annulée';

  @override
  String get loadingError => 'Erreur de chargement';

  @override
  String get noBookings => 'Aucune réservation';

  @override
  String get noBookingsYet => 'Vous n\'avez pas encore réservé.';

  @override
  String get noResultsForFilter => 'Aucun résultat pour ce filtre.';

  @override
  String get backToMap => 'Retour à la carte';

  @override
  String get myBookingsSubtitle => 'Consultez et gérez toutes vos réservations';

  @override
  String get newBooking => 'Nouvelle réservation';

  @override
  String get totalBookings => 'Réservations totales';

  @override
  String get confirmedPlural => 'Confirmées';

  @override
  String get pendingPlural => 'En attente';

  @override
  String get filterByStatus => 'Filtrer par statut';

  @override
  String filterAll(int count) {
    return 'Toutes ($count)';
  }

  @override
  String filterConfirmed(int count) {
    return 'Confirmées ($count)';
  }

  @override
  String filterPending(int count) {
    return 'En attente ($count)';
  }

  @override
  String filterCancelled(int count) {
    return 'Annulées ($count)';
  }

  @override
  String get searchHint => 'Rechercher un hôtel ou une ville...';

  @override
  String get paymentMethod => 'Méthode de paiement';

  @override
  String bookedOn(String date) {
    return 'Réservée le $date';
  }

  @override
  String dateAtTime(String date, String time) {
    return '$date à $time';
  }

  @override
  String get details => 'Détails';

  @override
  String get cancel => 'Annuler';

  @override
  String get fillAllFields => 'Veuillez remplir tous les champs';

  @override
  String get errorInvalidCredentials => 'E-mail ou mot de passe incorrect';

  @override
  String get errorEmailInUse =>
      'Cet e-mail est déjà utilisé par un autre compte';

  @override
  String get errorWeakPassword =>
      'Mot de passe trop faible (6 caractères minimum)';

  @override
  String get errorInvalidEmail => 'Adresse e-mail invalide';

  @override
  String get errorNetwork =>
      'Pas de connexion Internet. Vérifiez votre réseau et réessayez.';

  @override
  String get errorTooManyRequests =>
      'Trop de tentatives. Réessayez dans quelques minutes.';

  @override
  String get errorPermissionDenied =>
      'Accès refusé. Vous n\'avez pas les droits pour cette action.';

  @override
  String get errorUnknown =>
      'Une erreur inattendue est survenue. Veuillez réessayer.';

  @override
  String get retry => 'Réessayer';

  @override
  String get mapLoadError =>
      'Impossible de charger la carte. Vérifiez votre connexion.';

  @override
  String get logoutError => 'Échec de la déconnexion. Veuillez réessayer.';

  @override
  String get bookingConfirmedTitle => 'Réservation enregistrée !';

  @override
  String get bookingConfirmedOnline =>
      'Paiement accepté. Votre séjour est confirmé.';

  @override
  String get bookingConfirmedCash =>
      'Votre séjour est réservé. Vous réglerez à l\'hôtel.';

  @override
  String get seeMyBookings => 'Voir mes réservations';

  @override
  String get notifBookingConfirmedTitle => 'Réservation confirmée ✅';

  @override
  String notifBookingConfirmedBody(String hotel, String dates) {
    return '$hotel · $dates. Paiement accepté, à bientôt !';
  }

  @override
  String get notifBookingPendingTitle => 'Réservation en attente ⏳';

  @override
  String notifBookingPendingBody(String hotel, String dates) {
    return '$hotel · $dates. Paiement à régler à l\'hôtel.';
  }

  @override
  String get navExplore => 'Explorer';

  @override
  String get tabMap => 'Carte';

  @override
  String get tabList => 'Liste';

  @override
  String get registerAsAdmin => 'S\'inscrire en tant qu\'administrateur';

  @override
  String get adminCode => 'Code administrateur';

  @override
  String get errorAdminCode => 'Code administrateur invalide.';

  @override
  String get errorAccountDisabled =>
      'Ce compte a été bloqué par un administrateur.';

  @override
  String get adminTitle => 'Administration';

  @override
  String get adminDashboard => 'Tableau de bord';

  @override
  String get adminBookings => 'Réservations';

  @override
  String get adminHotels => 'Hôtels';

  @override
  String get adminUsers => 'Utilisateurs';

  @override
  String get clientView => 'Vue client';

  @override
  String get revenue => 'Revenus (réservations confirmées)';

  @override
  String get recentBookings => 'Dernières réservations';

  @override
  String get searchBookingsHint => 'Hôtel, ville ou e-mail client...';

  @override
  String get markConfirmed => 'Confirmer';

  @override
  String get markPending => 'Mettre en attente';

  @override
  String get markCancelled => 'Annuler la réservation';

  @override
  String get bookingUpdated => 'Réservation mise à jour';

  @override
  String get bookingDeleted => 'Réservation supprimée';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get save => 'Enregistrer';

  @override
  String deleteQuestion(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get irreversible => 'Cette action est irréversible.';

  @override
  String get addHotel => 'Ajouter un hôtel';

  @override
  String get editHotel => 'Modifier l\'hôtel';

  @override
  String get hotelName => 'Nom de l\'hôtel';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get pricePerNightTnd => 'Prix par nuit (TND)';

  @override
  String get stars => 'Étoiles';

  @override
  String get invalidNumber => 'Nombre invalide';

  @override
  String get hotelSaved => 'Hôtel enregistré';

  @override
  String get hotelDeleted => 'Hôtel supprimé';

  @override
  String get noHotels => 'Aucun hôtel';

  @override
  String noHotelsDesc(int count) {
    return 'Les clients voient le catalogue intégré ($count hôtels). Importez-le pour pouvoir le gérer.';
  }

  @override
  String get importHotels => 'Importer les hôtels';

  @override
  String hotelsImported(int count) {
    return '$count hôtels importés';
  }

  @override
  String get searchUsersHint => 'Rechercher un e-mail...';

  @override
  String get noUsers => 'Aucun utilisateur';

  @override
  String get you => '(vous)';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleUser => 'Client';

  @override
  String get blocked => 'Bloqué';

  @override
  String get makeAdmin => 'Nommer administrateur';

  @override
  String get removeAdmin => 'Retirer les droits admin';

  @override
  String get blockUser => 'Bloquer';

  @override
  String get unblockUser => 'Débloquer';

  @override
  String get userUpdated => 'Utilisateur mis à jour';
}
