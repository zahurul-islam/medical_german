/// In-App Purchase and Subscription Service
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Subscription product IDs
class SubscriptionProducts {
  // iOS Product IDs (configured in App Store Connect)
  static const String monthlyIOS = 'meddeutsch_monthly';
  static const String yearlyIOS = 'meddeutsch_yearly';
  static const String lifetimeIOS = 'meddeutsch_lifetime';
  
  // Android Product IDs (configured in Google Play Console)
  static const String monthlyAndroid = 'meddeutsch_monthly';
  static const String yearlyAndroid = 'meddeutsch_yearly';
  static const String lifetimeAndroid = 'meddeutsch_lifetime';
  
  static Set<String> get allProductIds => Platform.isIOS
      ? {monthlyIOS, yearlyIOS, lifetimeIOS}
      : {monthlyAndroid, yearlyAndroid, lifetimeAndroid};
  
  static String get monthlyId => Platform.isIOS ? monthlyIOS : monthlyAndroid;
  static String get yearlyId => Platform.isIOS ? yearlyIOS : yearlyAndroid;
  static String get lifetimeId => Platform.isIOS ? lifetimeIOS : lifetimeAndroid;
}

/// Subscription plan details
class SubscriptionPlan {
  final String id;
  final String title;
  final String description;
  final String price;
  final String? pricePerMonth;
  final String? savings;
  final bool isPopular;
  final ProductDetails? productDetails;

  SubscriptionPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.pricePerMonth,
    this.savings,
    this.isPopular = false,
    this.productDetails,
  });
}

/// Subscription status
enum SubscriptionStatus {
  none,
  monthly,
  yearly,
  lifetime,
}

/// Subscription Service
class SubscriptionService {
  static SubscriptionService? _instance;
  static SubscriptionService get instance => _instance ??= SubscriptionService._();
  
  SubscriptionService._();
  
  final InAppPurchase _iap = InAppPurchase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  
  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;
  
  SubscriptionStatus _status = SubscriptionStatus.none;
  SubscriptionStatus get status => _status;
  
  bool get isPremium => _status != SubscriptionStatus.none;
  
  DateTime? _expiryDate;
  DateTime? get expiryDate => _expiryDate;
  
  // Callbacks
  Function()? onPurchaseSuccess;
  Function(String error)? onPurchaseError;
  Function()? onPurchasePending;
  Function()? onPurchaseRestored;
  
  /// Initialize the subscription service
  Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();
    
    if (!_isAvailable) {
      debugPrint('In-App Purchases not available');
      return;
    }
    
    // Configure for iOS
    if (Platform.isIOS) {
      final iosPlatformAddition = _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(PaymentQueueDelegate());
    }
    
    // Listen to purchase updates
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: _onPurchaseDone,
      onError: _onPurchaseError,
    );
    
    // Load products
    await loadProducts();
    
    // Check existing subscription
    await checkSubscriptionStatus();
  }
  
  /// Load products from the stores
  Future<void> loadProducts() async {
    if (!_isAvailable) return;
    
    final response = await _iap.queryProductDetails(SubscriptionProducts.allProductIds);
    
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Products not found: ${response.notFoundIDs}');
    }
    
    _products = response.productDetails;
    debugPrint('Loaded ${_products.length} products');
  }
  
  /// Get subscription plans
  List<SubscriptionPlan> getSubscriptionPlans() {
    final plans = <SubscriptionPlan>[];
    
    // Monthly plan
    final monthlyProduct = _products.where((p) => p.id == SubscriptionProducts.monthlyId).firstOrNull;
    plans.add(SubscriptionPlan(
      id: SubscriptionProducts.monthlyId,
      title: 'Monatlich',
      description: 'Voller Zugang für einen Monat',
      price: monthlyProduct?.price ?? '\$4.99',
      pricePerMonth: monthlyProduct?.price ?? '\$4.99',
      productDetails: monthlyProduct,
    ));
    
    // Yearly plan (most popular)
    final yearlyProduct = _products.where((p) => p.id == SubscriptionProducts.yearlyId).firstOrNull;
    plans.add(SubscriptionPlan(
      id: SubscriptionProducts.yearlyId,
      title: 'Jährlich',
      description: 'Voller Zugang für ein Jahr',
      price: yearlyProduct?.price ?? '\$47.99',
      pricePerMonth: '\$4.00/Monat',
      savings: '20% sparen',
      isPopular: true,
      productDetails: yearlyProduct,
    ));
    
    // Lifetime plan
    final lifetimeProduct = _products.where((p) => p.id == SubscriptionProducts.lifetimeId).firstOrNull;
    plans.add(SubscriptionPlan(
      id: SubscriptionProducts.lifetimeId,
      title: 'Lebenslang',
      description: 'Einmalzahlung, für immer Zugang',
      price: lifetimeProduct?.price ?? '\$149.99',
      pricePerMonth: 'Einmalig',
      savings: 'Bester Wert',
      productDetails: lifetimeProduct,
    ));
    
    return plans;
  }
  
  /// Purchase a subscription
  Future<bool> purchase(String productId) async {
    if (!_isAvailable) {
      onPurchaseError?.call('In-App Käufe sind nicht verfügbar');
      return false;
    }
    
    final product = _products.where((p) => p.id == productId).firstOrNull;
    if (product == null) {
      onPurchaseError?.call('Produkt nicht gefunden');
      return false;
    }
    
    final purchaseParam = PurchaseParam(productDetails: product);
    
    try {
      // For lifetime, use buyNonConsumable; for subscriptions, use buyNonConsumable too
      // (subscriptions are handled differently on each platform)
      if (productId == SubscriptionProducts.lifetimeId) {
        return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      onPurchaseError?.call('Kauf fehlgeschlagen: $e');
      return false;
    }
  }
  
  /// Restore purchases
  Future<void> restorePurchases() async {
    if (!_isAvailable) {
      onPurchaseError?.call('In-App Käufe sind nicht verfügbar');
      return;
    }
    
    try {
      await _iap.restorePurchases();
    } catch (e) {
      onPurchaseError?.call('Wiederherstellen fehlgeschlagen: $e');
    }
  }
  
  /// Handle purchase updates
  void _onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          onPurchasePending?.call();
          break;
          
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // Verify and deliver the purchase
          await _verifyAndDeliverPurchase(purchase);
          if (purchase.status == PurchaseStatus.restored) {
            onPurchaseRestored?.call();
          } else {
            onPurchaseSuccess?.call();
          }
          break;
          
        case PurchaseStatus.error:
          onPurchaseError?.call(purchase.error?.message ?? 'Unbekannter Fehler');
          break;
          
        case PurchaseStatus.canceled:
          // User cancelled
          break;
      }
      
      // Complete the purchase
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }
  
  /// Verify and deliver the purchase
  Future<void> _verifyAndDeliverPurchase(PurchaseDetails purchase) async {
    // In production, you should verify the purchase with your backend
    // For now, we'll just save it locally and to Firestore
    
    SubscriptionStatus newStatus;
    DateTime? expiry;
    
    if (purchase.productID == SubscriptionProducts.monthlyId) {
      newStatus = SubscriptionStatus.monthly;
      expiry = DateTime.now().add(const Duration(days: 30));
    } else if (purchase.productID == SubscriptionProducts.yearlyId) {
      newStatus = SubscriptionStatus.yearly;
      expiry = DateTime.now().add(const Duration(days: 365));
    } else if (purchase.productID == SubscriptionProducts.lifetimeId) {
      newStatus = SubscriptionStatus.lifetime;
      expiry = null; // No expiry for lifetime
    } else {
      return;
    }
    
    _status = newStatus;
    _expiryDate = expiry;
    
    // Save locally
    await _saveSubscriptionLocally(newStatus, expiry);
  }
  
  void _onPurchaseDone() {
    _subscription?.cancel();
  }
  
  void _onPurchaseError(dynamic error) {
    debugPrint('Purchase stream error: $error');
  }
  
  /// Check subscription status
  Future<void> checkSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    
    final statusString = prefs.getString('subscription_status');
    final expiryString = prefs.getString('subscription_expiry');
    
    if (statusString != null) {
      _status = SubscriptionStatus.values.firstWhere(
        (s) => s.name == statusString,
        orElse: () => SubscriptionStatus.none,
      );
      
      if (expiryString != null) {
        _expiryDate = DateTime.tryParse(expiryString);
        
        // Check if subscription has expired
        if (_expiryDate != null && DateTime.now().isAfter(_expiryDate!) && _status != SubscriptionStatus.lifetime) {
          _status = SubscriptionStatus.none;
          _expiryDate = null;
          await _saveSubscriptionLocally(SubscriptionStatus.none, null);
        }
      }
    }
  }
  
  /// Save subscription locally
  Future<void> _saveSubscriptionLocally(SubscriptionStatus status, DateTime? expiry) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('subscription_status', status.name);
    if (expiry != null) {
      await prefs.setString('subscription_expiry', expiry.toIso8601String());
    } else {
      await prefs.remove('subscription_expiry');
    }
  }
  
  /// Save subscription to Firestore for a user
  Future<void> saveSubscriptionToFirestore(String userId) async {
    await _firestore.collection('users').doc(userId).set({
      'subscription': {
        'status': _status.name,
        'expiryDate': _expiryDate?.toIso8601String(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    }, SetOptions(merge: true));
  }
  
  /// Dispose
  void dispose() {
    _subscription?.cancel();
  }
}

/// iOS Payment Queue Delegate
class PaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}

