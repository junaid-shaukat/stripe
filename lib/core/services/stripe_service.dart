import '/core/app_export.dart';

class StripeService {
  StripeService._internal();

  static final StripeService instance = StripeService._internal();
  Preference preference = Preference.instance;

  Future<void> onInit() async {
    Stripe.publishableKey = preference.publishableKey ?? 'pk_test_51QRTE1RuMFwM6PXE2IutuTZyvDDYXa6FEW3jLqqXk18rTuAs0NZWp3Ro0KeQAK3UmNUSYZjFk2ZxJ9MztUPS618E00E58Xi68n';
    Stripe.merchantIdentifier =
        preference.merchantIdentifier ?? 'merchant.flutter.stripe.test';
    Stripe.urlScheme = preference.urlScheme ?? 'flutterstripe';

    await Stripe.instance.applySettings();
  }
}
