// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'StayEase';

  @override
  String get language => 'اللغة';

  @override
  String get lightTheme => 'الوضع الفاتح';

  @override
  String get darkTheme => 'الوضع الداكن';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get createAccountButton => 'إنشاء الحساب';

  @override
  String get loginError => 'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get registerError => 'تعذّر إنشاء الحساب';

  @override
  String get or => 'أو';

  @override
  String get continueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get errorGoogleUnsupported =>
      'تسجيل الدخول عبر Google متاح على Android فقط. شغّل التطبيق على محاكي Android.';

  @override
  String get errorGoogleToken => 'لم يتم العثور على رمز Google';

  @override
  String errorGoogleFailed(String code) {
    return 'تعذّر تسجيل الدخول عبر Google ($code)';
  }

  @override
  String errorFirebase(String code) {
    return 'خطأ في Firebase: $code';
  }

  @override
  String get errorNotLoggedIn => 'المستخدم غير مسجّل الدخول';

  @override
  String get errorFirestoreTimeout =>
      'لا يستجيب Firestore. تأكّد من إنشاء قاعدة البيانات ومن عمل اتصال الإنترنت.';

  @override
  String errorWithMessage(String error) {
    return 'خطأ: $error';
  }

  @override
  String amountTnd(String amount) {
    return '$amount د.ت';
  }

  @override
  String pricePerNightShort(String price) {
    return '$price د.ت / الليلة';
  }

  @override
  String nightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ليلة',
      many: '$count ليلة',
      few: '$count ليالٍ',
      two: 'ليلتان',
      one: 'ليلة واحدة',
      zero: '0 ليلة',
    );
    return '$_temp0';
  }

  @override
  String cityTunisia(String city) {
    return '$city، تونس';
  }

  @override
  String dateRange(String from, String to) {
    return 'من $from إلى $to';
  }

  @override
  String get arrival => 'الوصول';

  @override
  String get departure => 'المغادرة';

  @override
  String get arrivalDate => 'تاريخ الوصول';

  @override
  String get departureDate => 'تاريخ المغادرة';

  @override
  String get hotel => 'الفندق';

  @override
  String get address => 'العنوان';

  @override
  String get stayDuration => 'مدة الإقامة';

  @override
  String get pricePerNight => 'السعر لليلة';

  @override
  String get totalPrice => 'السعر الإجمالي';

  @override
  String get totalAmount => 'المبلغ الإجمالي';

  @override
  String get bookingSummary => 'ملخّص حجزك';

  @override
  String get hotelsInTunisia => 'فنادق في تونس';

  @override
  String get bookThisHotel => 'احجز هذا الفندق';

  @override
  String get myBookings => 'حجوزاتي';

  @override
  String bookYourStayIn(String city) {
    return 'احجز إقامتك في\n$city';
  }

  @override
  String chooseDatesAndBook(String hotel) {
    return 'اختر تواريخك واحجز $hotel.';
  }

  @override
  String get selectedHotel => 'الفندق المختار';

  @override
  String get perkClimate => 'مناخ معتدل';

  @override
  String get perkPrices => 'أسعار تنافسية';

  @override
  String get perkStars => 'فنادق 4-5 نجوم';

  @override
  String get perkWifi => 'واي فاي مجاني';

  @override
  String get whyBookNow => 'لماذا تحجز الآن؟';

  @override
  String get reasonBestPrice => 'أفضل سعر مضمون';

  @override
  String get reasonBestPriceDesc => 'احجز اليوم ووفّر حتى 30%';

  @override
  String get reasonFreeCancel => 'إلغاء مجاني';

  @override
  String get reasonFreeCancelDesc => 'يمكنك الإلغاء حتى 24 ساعة قبل وصولك';

  @override
  String get reasonPremium => 'خدمة مميّزة';

  @override
  String get reasonPremiumDesc => 'مساعدة على مدار الساعة طوال إقامتك';

  @override
  String get selectYourDates => 'اختر تواريخك';

  @override
  String get selectYourDatesSubtitle => 'اختر تاريخَي الوصول والمغادرة';

  @override
  String get stepCity => 'المدينة';

  @override
  String get stepDates => 'التواريخ';

  @override
  String get stepHotel => 'الفندق';

  @override
  String get stepPayment => 'الدفع';

  @override
  String destination(String city) {
    return 'الوجهة: $city';
  }

  @override
  String get selected => 'مختار';

  @override
  String get selectArrivalHelper => 'اختر تاريخ وصولك';

  @override
  String stayDurationHelper(String duration) {
    return 'مدة الإقامة: $duration';
  }

  @override
  String get required => 'مطلوب';

  @override
  String get datePlaceholder => '--/--/----';

  @override
  String get suggestions => 'اقتراحات:';

  @override
  String get today => 'اليوم';

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'بعد $count يوم',
      many: 'بعد $count يومًا',
      few: 'بعد $count أيام',
      two: 'بعد يومين',
      one: 'بعد يوم واحد',
    );
    return '$_temp0';
  }

  @override
  String nightsInCity(int count, String city) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ليلة في $city',
      many: '$count ليلة في $city',
      few: '$count ليالٍ في $city',
      two: 'ليلتان في $city',
      one: 'ليلة واحدة في $city',
      zero: '0 ليلة في $city',
    );
    return '$_temp0';
  }

  @override
  String totalWithAmount(String amount) {
    return 'المجموع: $amount';
  }

  @override
  String get continueButton => 'متابعة';

  @override
  String get changeDestination => 'تغيير الوجهة';

  @override
  String get finalizeBooking => 'أكمل حجزك';

  @override
  String get finalizeBookingSubtitle => 'اختر طريقة الدفع لتأكيد إقامتك';

  @override
  String get choosePaymentMethod => 'اختر طريقة الدفع';

  @override
  String get onlinePayment => 'الدفع عبر الإنترنت';

  @override
  String get onlinePaymentDesc => 'ادفع عبر الإنترنت بأمان';

  @override
  String get cashPayment => 'الدفع نقدًا';

  @override
  String get cashPaymentDesc => 'ادفع في الفندق عند وصولك';

  @override
  String get pleaseChoosePaymentMethod => 'يرجى اختيار طريقة الدفع';

  @override
  String get mustAcceptTermsFull => 'يجب الموافقة على الشروط العامة';

  @override
  String get mustAcceptTerms => 'يجب الموافقة على الشروط';

  @override
  String get paymentCancelled => 'تم إلغاء الدفع';

  @override
  String saveError(String error) {
    return 'خطأ أثناء الحفظ: $error';
  }

  @override
  String get iAccept => 'أوافق على ';

  @override
  String get termsAndConditions => 'الشروط العامة';

  @override
  String get andThe => ' و';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get continueToPayment => 'المتابعة إلى الدفع';

  @override
  String get confirmBooking => 'تأكيد الحجز';

  @override
  String get backToDates => 'العودة إلى التواريخ';

  @override
  String get securePayment => 'دفع آمن 100%';

  @override
  String get securePaymentDesc => 'بياناتك مشفّرة بتقنية SSL';

  @override
  String get cardHolder => 'صاحب البطاقة';

  @override
  String get cardHolderHint => 'الاسم كما يظهر على البطاقة';

  @override
  String get cardHolderRequired => 'اسم صاحب البطاقة مطلوب';

  @override
  String get nameTooShort => 'الاسم قصير جدًا';

  @override
  String get lettersOnly => 'أحرف فقط';

  @override
  String get cardNumber => 'رقم البطاقة';

  @override
  String get cardNumberRequired => 'رقم البطاقة مطلوب';

  @override
  String cardNumberLength(int count) {
    return 'يجب أن يتكوّن الرقم من $count رقمًا';
  }

  @override
  String get cvvCode => 'رمز CVV';

  @override
  String get cvvRequired => 'رمز CVV مطلوب';

  @override
  String digitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count رقم',
      many: '$count رقمًا',
      few: '$count أرقام',
      two: 'رقمان',
      one: 'رقم واحد',
    );
    return '$_temp0';
  }

  @override
  String get expiryMonth => 'شهر الانتهاء';

  @override
  String get monthHint => 'الشهر';

  @override
  String get chooseMonth => 'اختر الشهر';

  @override
  String get expiryYear => 'سنة الانتهاء';

  @override
  String get yearHint => 'السنة';

  @override
  String get chooseYear => 'اختر السنة';

  @override
  String get cardExpired => 'البطاقة منتهية الصلاحية';

  @override
  String payAmount(String amount) {
    return 'ادفع $amount';
  }

  @override
  String get cancelPayment => 'إلغاء الدفع';

  @override
  String get sslSecured => 'حماية SSL';

  @override
  String get encryptedData => 'بيانات مشفّرة';

  @override
  String get support247 => 'دعم على مدار الساعة';

  @override
  String get expiryDate => 'تاريخ الانتهاء';

  @override
  String get namePlaceholder => 'الاسم واللقب';

  @override
  String get expiryPlaceholder => 'MM/YY';

  @override
  String get cancelBookingQuestion => 'إلغاء الحجز؟';

  @override
  String get no => 'لا';

  @override
  String get yesCancel => 'نعم، إلغاء';

  @override
  String get bookingCancelled => 'تم إلغاء الحجز';

  @override
  String get reference => 'المرجع';

  @override
  String get duration => 'المدة';

  @override
  String get payment => 'الدفع';

  @override
  String get online => 'عبر الإنترنت';

  @override
  String get cash => 'نقدًا';

  @override
  String get status => 'الحالة';

  @override
  String get total => 'المجموع';

  @override
  String get statusConfirmed => 'مؤكَّد';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get statusCancelled => 'ملغى';

  @override
  String get loadingError => 'خطأ في التحميل';

  @override
  String get noBookings => 'لا توجد حجوزات';

  @override
  String get noBookingsYet => 'لم تقم بأي حجز بعد.';

  @override
  String get noResultsForFilter => 'لا توجد نتائج لهذا الفلتر.';

  @override
  String get backToMap => 'العودة إلى الخريطة';

  @override
  String get myBookingsSubtitle => 'اطّلع على جميع حجوزاتك وأدِرها';

  @override
  String get newBooking => 'حجز جديد';

  @override
  String get totalBookings => 'إجمالي الحجوزات';

  @override
  String get confirmedPlural => 'مؤكَّدة';

  @override
  String get pendingPlural => 'قيد الانتظار';

  @override
  String get filterByStatus => 'التصفية حسب الحالة';

  @override
  String filterAll(int count) {
    return 'الكل ($count)';
  }

  @override
  String filterConfirmed(int count) {
    return 'مؤكَّدة ($count)';
  }

  @override
  String filterPending(int count) {
    return 'قيد الانتظار ($count)';
  }

  @override
  String filterCancelled(int count) {
    return 'ملغاة ($count)';
  }

  @override
  String get searchHint => 'ابحث عن فندق أو مدينة...';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String bookedOn(String date) {
    return 'تم الحجز في $date';
  }

  @override
  String dateAtTime(String date, String time) {
    return '$date الساعة $time';
  }

  @override
  String get details => 'التفاصيل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get fillAllFields => 'يرجى ملء جميع الحقول';

  @override
  String get errorInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get errorEmailInUse =>
      'هذا البريد الإلكتروني مستخدم بالفعل من قبل حساب آخر';

  @override
  String get errorWeakPassword => 'كلمة المرور ضعيفة جدًا (6 أحرف على الأقل)';

  @override
  String get errorInvalidEmail => 'عنوان البريد الإلكتروني غير صالح';

  @override
  String get errorNetwork =>
      'لا يوجد اتصال بالإنترنت. تحقق من الشبكة وحاول مرة أخرى.';

  @override
  String get errorTooManyRequests =>
      'محاولات كثيرة جدًا. حاول مرة أخرى بعد بضع دقائق.';

  @override
  String get errorPermissionDenied =>
      'تم رفض الوصول. ليس لديك صلاحية لهذا الإجراء.';

  @override
  String get errorUnknown => 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get mapLoadError => 'تعذر تحميل الخريطة. تحقق من اتصالك.';

  @override
  String get logoutError => 'فشل تسجيل الخروج. يرجى المحاولة مرة أخرى.';

  @override
  String get bookingConfirmedTitle => 'تم تسجيل الحجز!';

  @override
  String get bookingConfirmedOnline => 'تم قبول الدفع. إقامتك مؤكدة.';

  @override
  String get bookingConfirmedCash => 'تم حجز إقامتك. ستدفع في الفندق.';

  @override
  String get seeMyBookings => 'عرض حجوزاتي';

  @override
  String get notifBookingConfirmedTitle => 'تم تأكيد الحجز ✅';

  @override
  String notifBookingConfirmedBody(String hotel, String dates) {
    return '$hotel · $dates. تم قبول الدفع، نراك قريبًا!';
  }

  @override
  String get notifBookingPendingTitle => 'الحجز قيد الانتظار ⏳';

  @override
  String notifBookingPendingBody(String hotel, String dates) {
    return '$hotel · $dates. الدفع في الفندق.';
  }

  @override
  String get navExplore => 'استكشاف';

  @override
  String get tabMap => 'الخريطة';

  @override
  String get tabList => 'القائمة';

  @override
  String get registerAsAdmin => 'التسجيل كمسؤول';

  @override
  String get adminCode => 'رمز المسؤول';

  @override
  String get errorAdminCode => 'رمز المسؤول غير صحيح.';

  @override
  String get errorAccountDisabled => 'تم حظر هذا الحساب من قبل المسؤول.';

  @override
  String get adminTitle => 'الإدارة';

  @override
  String get adminDashboard => 'لوحة التحكم';

  @override
  String get adminBookings => 'الحجوزات';

  @override
  String get adminHotels => 'الفنادق';

  @override
  String get adminUsers => 'المستخدمون';

  @override
  String get clientView => 'واجهة العميل';

  @override
  String get revenue => 'الإيرادات (الحجوزات المؤكدة)';

  @override
  String get recentBookings => 'آخر الحجوزات';

  @override
  String get searchBookingsHint => 'فندق، مدينة أو بريد العميل...';

  @override
  String get markConfirmed => 'تأكيد';

  @override
  String get markPending => 'وضع قيد الانتظار';

  @override
  String get markCancelled => 'إلغاء الحجز';

  @override
  String get bookingUpdated => 'تم تحديث الحجز';

  @override
  String get bookingDeleted => 'تم حذف الحجز';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get save => 'حفظ';

  @override
  String deleteQuestion(String name) {
    return 'حذف «$name»؟';
  }

  @override
  String get irreversible => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get addHotel => 'إضافة فندق';

  @override
  String get editHotel => 'تعديل الفندق';

  @override
  String get hotelName => 'اسم الفندق';

  @override
  String get latitude => 'خط العرض';

  @override
  String get longitude => 'خط الطول';

  @override
  String get pricePerNightTnd => 'السعر لليلة (د.ت)';

  @override
  String get stars => 'النجوم';

  @override
  String get invalidNumber => 'رقم غير صالح';

  @override
  String get hotelSaved => 'تم حفظ الفندق';

  @override
  String get hotelDeleted => 'تم حذف الفندق';

  @override
  String get noHotels => 'لا توجد فنادق';

  @override
  String noHotelsDesc(int count) {
    return 'يرى العملاء الكتالوج المدمج ($count فندقًا). استورده لتتمكن من إدارته.';
  }

  @override
  String get importHotels => 'استيراد الفنادق';

  @override
  String hotelsImported(int count) {
    return 'تم استيراد $count فندقًا';
  }

  @override
  String get searchUsersHint => 'البحث عن بريد إلكتروني...';

  @override
  String get noUsers => 'لا يوجد مستخدمون';

  @override
  String get you => '(أنت)';

  @override
  String get roleAdmin => 'مسؤول';

  @override
  String get roleUser => 'عميل';

  @override
  String get blocked => 'محظور';

  @override
  String get makeAdmin => 'تعيين كمسؤول';

  @override
  String get removeAdmin => 'إزالة صلاحيات المسؤول';

  @override
  String get blockUser => 'حظر';

  @override
  String get unblockUser => 'إلغاء الحظر';

  @override
  String get userUpdated => 'تم تحديث المستخدم';
}
