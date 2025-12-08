# Package Payment Integration

## Overview
This document describes the payment flow integration for package selection with VNPay payment gateway.

## Flow Summary
1. User selects a package → PackageDetailPage
2. Clicks "Select Package" button → calls `createPaymentUrl()`
3. ViewModel creates payment URL via CreatePaymentUrlUsecase
4. App navigates to PaymentWebViewPage with payment URL
5. User completes payment on VNPay
6. VNPay redirects to backend → Backend returns 302 redirect to `greenconnect://payment-result?status=success|failed`
7. OS opens app via deep link
8. App handles payment result

## Implementation Details

### 1. PackageViewModel (`package_viewmodel.dart`)
Added payment-related functionality:

```dart
Future<void> createPaymentUrl(String packageId)
```
- Calls CreatePaymentUrlUsecase from payment feature
- Updates state with `paymentUrl` and `transactionRef`
- Handles errors with AppException

```dart
void clearPaymentData()
```
- Clears payment URL and transaction ref from state

### 2. PackageState (`package_state.dart`)
Added payment fields:

```dart
final bool isProcessing;      // Processing payment URL creation
final String? paymentUrl;     // VNPay payment URL
final String? transactionRef; // Transaction reference
```

Added `clearPayment` flag to copyWith method for resetting payment data.

### 3. PackageDetailPage (`package_detail_page.dart`)
Converted to ConsumerWidget for Riverpod integration:

**Button Logic:**
- Shows loading indicator while `isProcessing == true`
- On press:
  1. Calls `packageViewModel.createPaymentUrl(package.packageId)`
  2. Reads updated state after async call
  3. Navigates to `/payment-webview` with payment data
  4. Clears payment data from state
  5. Shows error snackbar if creation failed

### 4. PaymentWebViewPage (`payment_webview_page.dart`)
Placeholder page for WebView integration:

**Current Implementation:**
- Displays payment info (transaction ref, package name)
- Shows integration instructions
- Allows displaying payment URL in snackbar

**TODO:**
- Add `webview_flutter` or `flutter_inappwebview` package
- Implement WebView widget to load `paymentUrl`
- Handle WebView navigation and redirects
- Listen for deep link callbacks

### 5. Routes Configuration (`routes.dart`)
Added new route:

```dart
GoRoute(
  path: '/payment-webview',
  name: 'payment-webview',
  parentNavigatorKey: _rootNavigatorKey,
  builder: (context, state) {
    final data = state.extra as Map<String, dynamic>;
    return PaymentWebViewPage(
      paymentUrl: data['paymentUrl'] as String,
      transactionRef: data['transactionRef'] as String?,
      packageName: data['packageName'] as String?,
    );
  },
)
```

## Next Steps for Complete Integration

### 1. Add WebView Package
```bash
flutter pub add webview_flutter
# or
flutter pub add flutter_inappwebview
```

### 2. Implement WebView in PaymentWebViewPage
Replace placeholder UI with actual WebView:

```dart
WebView(
  initialUrl: paymentUrl,
  javascriptMode: JavascriptMode.unrestricted,
  navigationDelegate: (NavigationRequest request) {
    if (request.url.startsWith('greenconnect://')) {
      // Handle deep link
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  },
)
```

### 3. Configure Deep Links

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="greenconnect" android:host="payment-result" />
</intent-filter>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string>com.greenconnect.app</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>greenconnect</string>
    </array>
  </dict>
</array>
```

### 4. Add Deep Link Listener
Use `app_links` or `uni_links` package:

```bash
flutter pub add app_links
```

In main.dart or router:
```dart
final appLinks = AppLinks();

appLinks.uriLinkStream.listen((Uri? uri) {
  if (uri != null && uri.scheme == 'greenconnect') {
    if (uri.host == 'payment-result') {
      final status = uri.queryParameters['status'];
      // Navigate to result page
      context.go('/payment-result', extra: {'status': status});
    }
  }
});
```

### 5. Create Payment Result Pages
- `PaymentSuccessPage` - Show success message, update package status
- `PaymentFailedPage` - Show error message, allow retry

## Testing

### Manual Testing Flow:
1. Navigate to Package List
2. Select a package
3. Tap "Select Package" button
4. Verify loading state appears
5. Check navigation to PaymentWebViewPage
6. Verify payment URL and transaction ref are passed

### Unit Tests:
- Test `createPaymentUrl()` success case
- Test `createPaymentUrl()` error handling
- Test state updates (isProcessing, paymentUrl, transactionRef)
- Test `clearPaymentData()` functionality

### Integration Tests:
- Test full payment flow from package selection to WebView
- Test deep link handling
- Test payment result screens

## Error Handling

All errors are caught and handled with:
- AppException for typed errors from repository
- Debug logging with stack traces
- User-friendly error messages via snackbars
- State updates to reflect error conditions

## Dependencies

Current:
- `flutter_riverpod` - State management
- `go_router` - Navigation

Required for completion:
- `webview_flutter` or `flutter_inappwebview` - WebView
- `app_links` or `uni_links` - Deep link handling

## Related Files

- `lib/features/package/presentation/viewmodels/package_viewmodel.dart`
- `lib/features/package/presentation/viewmodels/states/package_state.dart`
- `lib/features/package/presentation/views/package_detail_page.dart`
- `lib/features/package/presentation/views/payment_webview_page.dart`
- `lib/features/payment/domain/usecases/create_payment_url_usecase.dart`
- `lib/features/payment/domain/entities/create_payment_url_entity.dart`
- `lib/features/payment/domain/entities/payment_url_response_entity.dart`
- `lib/core/route/routes.dart`
