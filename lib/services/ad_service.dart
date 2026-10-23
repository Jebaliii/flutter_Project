import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Google Mobile Ads helper.
///
/// ⚠️ Only Google's official TEST ad unit ids are used here
/// (https://developers.google.com/admob/android/test-ads).
/// Never replace them with real ids during development.
class AdService {
  AdService._();

  /// The plugin only exists on Android / iOS (not web, not Windows).
  static bool get isSupported =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static String get bannerAdUnitId => Platform.isIOS
      ? 'ca-app-pub-3940256099942544/2435281174'
      : 'ca-app-pub-3940256099942544/9214589741';

  static String get interstitialAdUnitId => Platform.isIOS
      ? 'ca-app-pub-3940256099942544/4411468910'
      : 'ca-app-pub-3940256099942544/1033173712';

  static Future<void> initialize() async {
    if (!isSupported) return;
    await MobileAds.instance.initialize();
    InterstitialAdManager.instance.preload();
  }
}

/// Keeps one interstitial preloaded so it can be shown instantly.
class InterstitialAdManager {
  InterstitialAdManager._();
  static final instance = InterstitialAdManager._();

  InterstitialAd? _ad;
  bool _loading = false;

  void preload() {
    if (!AdService.isSupported || _ad != null || _loading) return;
    _loading = true;
    InterstitialAd.load(
      adUnitId: AdService.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _loading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed to load: $error');
          _loading = false;
        },
      ),
    );
  }

  /// Shows the interstitial if one is ready, then calls [onDone] once it
  /// is closed. If no ad is ready, [onDone] is called right away so the
  /// user flow is never blocked.
  void show({required void Function() onDone}) {
    final ad = _ad;
    if (ad == null) {
      preload();
      onDone();
      return;
    }
    _ad = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        preload();
        onDone();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Interstitial failed to show: $error');
        ad.dispose();
        preload();
        onDone();
      },
    );
    ad.show();
  }
}
