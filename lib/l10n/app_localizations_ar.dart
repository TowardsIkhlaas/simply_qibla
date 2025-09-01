// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appNamePascalCase => 'سمبلي قبلة';

  @override
  String get appAboutLegalese => '© ٢٠٢٤ TowardsIkhlaas';

  @override
  String get changeLocationBarText => 'الانتقال إلى موقع محدد؟ :)';

  @override
  String get latitudeFieldLabel => '(أرقام 0-9) خط العرض';

  @override
  String get longitudeFieldLabel => '(أرقام 0-9) خط الطول';

  @override
  String get skipText => 'تخطي';

  @override
  String get doneText => 'تم';

  @override
  String get okText => 'حسنا';

  @override
  String get cancelText => 'إلغاء';

  @override
  String get clearText => 'مسح';

  @override
  String get allowText => 'يسمح';

  @override
  String get turnOnText => 'تشغيل';

  @override
  String get coordinatesInputFormTitle => 'أدخل الإحداثيات';

  @override
  String get centerConsoleCenteringText => 'جارٍ تحديد موقعك...';

  @override
  String get centerConsoleDraggingText => 'ارفع لإظهار خط القبلة';

  @override
  String get centerConsoleIdleText => 'كم إلى الكعبة';

  @override
  String get locationDisabled => 'تم تعطيل الموقعك.';

  @override
  String get locationDeniedInitial =>
      'يرجى السماح بإذن الموقع لاستخدام هذه الميزة. نحن لا نخزن أو نبيع بياناتك. :)';

  @override
  String get locationDeniedPermanent =>
      'يرجى السماح بإذن الموقعك لاستخدام هذه الميزة.';

  @override
  String get latitudeErrorText => 'قيمة خط العرض غير صالحة';

  @override
  String get longitudeErrorText => 'قيمة خط الطول غير صالحة';

  @override
  String get thankYouText => 'جزاك الله خيرًا لاستخدامك هذا التطبيق!';

  @override
  String get supportAppealText =>
      'يتطلب تشغيل هذا التطبيق وصيانته (Google Maps API). يرجى النظر في دعم المشروع من خلال الأزرار أدناه (سيتم التبرع بالمبالغ الزائدة للجمعيات الخيرية المسجلة).';

  @override
  String get githubButtonText => 'ادعمنا على GitHub';

  @override
  String get donateButtonText => 'ادعمنا على Ko-Fi';

  @override
  String get socialInstagramButtonText => 'تابعنا على Instagram';

  @override
  String get shareButtonText => 'شارك مع الأصدقاء';

  @override
  String get shareContentText =>
      'السلام عليكم ورحمة الله وبركاته! تحقق من هذا التطبيق الجميل والدقيق لتحديد القبلة';

  @override
  String get onboardingUsageTitle => 'كيف يعمل هذا؟';

  @override
  String get onboardingLocationTitle => 'دع التطبيق يجد موقعك.';

  @override
  String get onboardingSupportTitle => 'ادعم مهمتنا!';

  @override
  String get onboardingUsageBody =>
      'السلام عليكم! لاستخدام التطبيق، ضع جهازك بشكل مسطح وقم بتدويره ليصطف مع المعالم القريبة المعروضة في الخريطة، مثل الشوارع والمباني من حولك.';

  @override
  String get onboardingLocationBody =>
      'تعد أذونات الموقع ضرورية لكي يعمل التطبيق بشكل مثالي، ولكنها ليست إلزامية. كن مطمئنًا، بياناتك لن يتم جمعها أو بيعها.';

  @override
  String get onboardingSupportBody =>
      'سمبلي قبلة خالي من الإعلانات ومفتوح المصدر. إذا أعجبك ما تراه، يرجى دعمنا من خلال الروابط داخل التطبيق. سيتم استخدام دعمك لتشغيل التطبيق، وسيتم التبرع بالفائض للجمعيات الخيرية المسجلة.';
}
