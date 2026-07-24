# 📊 Google Analytics Integration Guide

## ✅ Installation Complete

Firebase Analytics has been successfully integrated into your Flutter eGrocer Partner app!

---

## 📦 What Was Added

### 1. **Dependencies** (pubspec.yaml)
```yaml
dependencies:
  firebase_core: ^4.2.1
  firebase_messaging: ^16.0.4
  firebase_analytics: ^12.0.4
```

### 2. **Analytics Service**
**Location:** `lib/helper/services/analytics_service.dart`

A centralized service to manage all analytics events with pre-built methods for:
- User authentication (login, signup, logout)
- Product management (view, add, update, delete)
- Order tracking
- Stock management
- Wallet operations
- Search and filters
- Custom events

### 3. **Main App Integration** (main.dart)
- Analytics initialized on app startup
- Navigation observer added for automatic screen tracking

---

## 🚀 How to Use Google Analytics

### **1. Track User Login**
```dart
// In your login success callback
await AnalyticsService.logLogin(method: 'email');
await AnalyticsService.setUserId(userId);
await AnalyticsService.setUserProperties(
  userType: 'partner',
  sellerStatus: 'active',
  city: 'Mumbai',
);
```

### **2. Track Screen Views (Automatic)**
Screen views are tracked automatically via `FirebaseAnalyticsObserver`.
You can also manually log:
```dart
await AnalyticsService.logScreenView(
  screenName: 'Product List',
  screenClass: 'ProductListScreen',
);
```

### **3. Track Product Events**
```dart
// Product viewed
await AnalyticsService.logProductView(
  productId: '123',
  productName: 'Fresh Tomatoes',
  category: 'Vegetables',
  price: 50.0,
);

// Product added
await AnalyticsService.logProductAdded(
  productId: '123',
  productName: 'Fresh Tomatoes',
  category: 'Vegetables',
);

// Product updated
await AnalyticsService.logProductUpdated(
  productId: '123',
  productName: 'Fresh Tomatoes',
);

// Product deleted
await AnalyticsService.logProductDeleted(
  productId: '123',
  productName: 'Fresh Tomatoes',
);
```

### **4. Track Order Events**
```dart
// Order viewed
await AnalyticsService.logOrderView(
  orderId: 'ORD-12345',
  value: 500.0,
);

// Order status updated
await AnalyticsService.logOrderStatusUpdated(
  orderId: 'ORD-12345',
  status: 'delivered',
);
```

### **5. Track Search**
```dart
await AnalyticsService.logSearch(
  searchTerm: 'tomatoes',
  category: 'vegetables',
);
```

### **6. Track Filters**
```dart
await AnalyticsService.logFilterApplied(
  filterType: 'product_type',
  filterValue: 'low_stock',
);
```

### **7. Track Stock Updates**
```dart
await AnalyticsService.logStockUpdated(
  productId: '123',
  quantity: 100,
);
```

### **8. Track Withdrawal Requests**
```dart
await AnalyticsService.logWithdrawalRequest(
  amount: 5000.0,
);
```

### **9. Track Errors**
```dart
await AnalyticsService.logError(
  errorType: 'api_error',
  errorMessage: 'Failed to load products',
  screenName: 'ProductListScreen',
);
```

### **10. Track Custom Events**
```dart
await AnalyticsService.logCustomEvent(
  eventName: 'promo_banner_clicked',
  parameters: {
    'banner_id': '456',
    'banner_name': 'Summer Sale',
  },
);
```

---

## 📝 Implementation Examples

### **Example 1: Login Screen**
```dart
// In loginProvider.dart or your login logic
Future<void> loginUser(String email, String password) async {
  try {
    // Your login API call
    final response = await loginApi(email, password);

    if (response.success) {
      // Track login event
      await AnalyticsService.logLogin(method: 'email');
      await AnalyticsService.setUserId(response.userId);
      await AnalyticsService.setUserProperties(
        userType: 'seller',
        sellerStatus: response.status,
      );
    }
  } catch (e) {
    await AnalyticsService.logError(
      errorType: 'login_error',
      errorMessage: e.toString(),
      screenName: 'LoginScreen',
    );
  }
}
```

### **Example 2: Product List Screen**
Add to `lib/screens/mainHomeScreen/productListScreen.dart`:

```dart
@override
void initState() {
  super.initState();

  // Track screen view
  AnalyticsService.logScreenView(screenName: 'Product List');

  Future.delayed(Duration.zero).then((value) async {
    currentAppliedFilter = widget.currentFilterIndex;
    scrollController.addListener(scrollListener);
    callApi(isReset: true);
  });

  searchController.addListener(_onSearchChanged);
}

// In search callback
void _onSearchChanged() {
  if (_debounceTimer?.isActive ?? false) {
    _debounceTimer!.cancel();
  }

  _debounceTimer = Timer(Duration(milliseconds: 500), () {
    // Track search event
    if (searchController.text.trim().isNotEmpty) {
      AnalyticsService.logSearch(
        searchTerm: searchController.text.trim(),
      );
    }
    callApi(isReset: true);
  });
}

// In filter selection
void onFilterApplied(int index) {
  currentAppliedFilter = index;

  // Track filter event
  AnalyticsService.logFilterApplied(
    filterType: 'product_filter',
    filterValue: productListSortTypes[index],
  );

  callApi(isReset: true);
}
```

### **Example 3: Product Add/Update**
```dart
// After successful product add
await AnalyticsService.logProductAdded(
  productId: productId,
  productName: productName,
  category: categoryName,
);

// After successful product update
await AnalyticsService.logProductUpdated(
  productId: productId,
  productName: productName,
);

// After successful product delete
await AnalyticsService.logProductDeleted(
  productId: productId,
  productName: productName,
);
```

### **Example 4: Order Status Update**
Add to home screen order update:
```dart
// After successful order status update
await AnalyticsService.logOrderStatusUpdated(
  orderId: order.id.toString(),
  status: newStatus,
);
```

### **Example 5: Stock Management**
```dart
// After stock update
await AnalyticsService.logStockUpdated(
  productId: productVariantId,
  quantity: newStock,
);
```

---

## 🔍 View Analytics Data

### **Firebase Console**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Analytics** → **Dashboard**
4. View real-time events and user data

### **Google Analytics 4**
1. Link your Firebase project to Google Analytics (if not already done)
2. Go to [Google Analytics](https://analytics.google.com/)
3. Select your property
4. View detailed reports

---

## 📊 Available Reports

### **Real-Time Reports**
- Active users right now
- Screen views
- Events happening in real-time

### **User Reports**
- User demographics
- User retention
- User engagement
- User lifetime value

### **Event Reports**
- All custom events
- Event counts
- Event parameters
- Conversion tracking

### **Acquisition Reports**
- User acquisition
- Traffic sources
- Campaign performance

---

## 🎯 Recommended Events to Track

### **High Priority**
1. ✅ **User Login** - Already configured
2. ✅ **Screen Views** - Automatic tracking
3. ✅ **Product Views** - Ready to use
4. ✅ **Search** - Ready to use
5. ✅ **Order Status Updates** - Ready to use

### **Medium Priority**
6. ✅ **Product Add/Update/Delete** - Ready to use
7. ✅ **Stock Updates** - Ready to use
8. ✅ **Filters Applied** - Ready to use
9. ✅ **Withdrawal Requests** - Ready to use

### **Custom Events**
10. Add any business-specific events using `logCustomEvent()`

---

## 🛠️ Testing Analytics

### **Debug Mode (Android)**
```bash
# Enable debug mode
adb shell setprop debug.firebase.analytics.app YOUR_PACKAGE_NAME

# View analytics events in real-time
adb logcat -s FA
```

### **Debug Mode (iOS)**
Add to Xcode scheme:
- Edit Scheme → Run → Arguments
- Add: `-FIRAnalyticsDebugEnabled`

### **Verify Events**
1. Open Firebase Console
2. Go to **Analytics** → **DebugView**
3. Run your app
4. See events in real-time

---

## ⚙️ Configuration

### **Enable/Disable Analytics**
```dart
// Disable analytics collection (GDPR compliance)
await AnalyticsService.setAnalyticsCollectionEnabled(false);

// Enable analytics collection
await AnalyticsService.setAnalyticsCollectionEnabled(true);
```

### **Reset Analytics Data**
```dart
// For testing purposes
await AnalyticsService.resetAnalyticsData();
```

---

## 🔐 Privacy & GDPR Compliance

### **User Consent**
Before tracking, ask for user consent:
```dart
// Check if user has given consent
bool hasConsent = await getUserConsentFromSettings();

if (hasConsent) {
  await AnalyticsService.setAnalyticsCollectionEnabled(true);
} else {
  await AnalyticsService.setAnalyticsCollectionEnabled(false);
}
```

### **Data Deletion**
Allow users to request data deletion:
```dart
// When user requests data deletion
await AnalyticsService.resetAnalyticsData();
await AnalyticsService.setAnalyticsCollectionEnabled(false);
```

---

## 📱 Platform-Specific Setup

### **Android**
✅ Already configured via `google-services.json`

### **iOS**
✅ Already configured via `GoogleService-Info.plist`

**Additional iOS Setup (Optional):**
Add to `Info.plist` for better tracking:
```xml
<key>FirebaseAutomaticScreenReportingEnabled</key>
<false/>
```

---

## 🚨 Common Issues & Solutions

### **Issue 1: Events not showing in Firebase**
**Solution:**
- Wait 24 hours for data to appear in main reports
- Use DebugView for real-time testing
- Ensure `google-services.json` / `GoogleService-Info.plist` are correct

### **Issue 2: Screen tracking not working**
**Solution:**
- Verify `FirebaseAnalyticsObserver` is added to `navigatorObservers`
- Check if navigation uses the same `Navigator` key

### **Issue 3: User properties not updating**
**Solution:**
- Call `setUserProperties()` after successful login
- Ensure user is authenticated

---

## 📚 Best Practices

1. **Don't Over-Track**
   - Track meaningful user actions only
   - Avoid tracking every button click

2. **Use Consistent Naming**
   - Use snake_case for event names: `product_added`
   - Keep names short and descriptive

3. **Add Context with Parameters**
   - Include relevant data with events
   - Don't exceed 25 parameters per event

4. **Respect User Privacy**
   - Don't log personally identifiable information (PII)
   - Implement GDPR compliance

5. **Test Before Release**
   - Use DebugView to verify events
   - Test on both Android and iOS

---

## 🎓 Next Steps

1. **Add Analytics to Key Screens**
   - Login Screen ✅
   - Product List Screen → Add tracking
   - Order List Screen → Add tracking
   - Stock Management → Add tracking

2. **Set Up Conversion Events**
   - Mark important events as conversions in Firebase

3. **Create Custom Dashboards**
   - Build dashboards for business metrics

4. **Set Up Alerts**
   - Get notified of important events

---

## 📞 Support

- **Firebase Documentation:** https://firebase.google.com/docs/analytics
- **Flutter Analytics Guide:** https://firebase.google.com/docs/analytics/get-started?platform=flutter
- **Google Analytics 4:** https://support.google.com/analytics

---

## ✨ Summary

✅ Firebase Analytics is **fully integrated**
✅ **Automatic screen tracking** enabled
✅ **30+ pre-built event methods** ready to use
✅ **User properties** tracking configured
✅ **Error tracking** available
✅ **GDPR-compliant** controls included

**You're all set! Start tracking events to gain insights into your app usage.** 🚀
