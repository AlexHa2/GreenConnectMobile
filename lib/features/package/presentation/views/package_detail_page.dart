import 'package:GreenConnectMobile/features/package/domain/entities/package_entity.dart';
import 'package:GreenConnectMobile/features/package/presentation/providers/package_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PackageDetailPage extends ConsumerWidget {
  final PackageEntity package;

  const PackageDetailPage({super.key, required this.package});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;
    final textTheme = theme.textTheme;
    final packageState = ref.watch(packageViewModelProvider);
    final packageViewModel = ref.read(packageViewModelProvider.notifier);

    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(s.package_details),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(space),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Package Header Card
              Card(
                elevation: 4,
                shadowColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(space * 1.5),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(space * 2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(space * 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Package type badge
                      _buildTypeBadge(package.packageType, theme, space, s),
                      SizedBox(height: space),

                      // Package name
                      Text(
                        package.name,
                        style: textTheme.headlineMedium?.copyWith(
                          color: theme.scaffoldBackgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: space * 0.5),

                      // Package price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            package.price == 0
                                ? s.free
                                : currencyFormat.format(package.price),
                            style: textTheme.displaySmall?.copyWith(
                              color: theme.scaffoldBackgroundColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // if (package.price > 0) ...[
                          //   SizedBox(width: space * 0.5),
                          //   Padding(
                          //     padding: EdgeInsets.only(bottom: space * 0.5),
                          //     child: Text(
                          //       '/ ${s.points}',
                          //       style: textTheme.bodyLarge?.copyWith(
                          //         color: theme.scaffoldBackgroundColor
                          //             .withValues(alpha: 0.8),
                          //       ),
                          //     ),
                          //   ),
                          // ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: space * 2),

              // Description Section
              _buildSection(
                title: s.description,
                child: Text(
                  package.description,
                  style: textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                theme: theme,
                space: space,
              ),

              SizedBox(height: space * 1.5),

              // Features Section
              _buildSection(
                title: s.features,
                child: Column(
                  children: [
                    // Connection Amount
                    if (package.connectionAmount != null)
                      _buildFeatureItem(
                        icon: Icons.people_outline,
                        title: s.connection_amount,
                        value: '${package.connectionAmount} ${s.features}',
                        theme: theme,
                        space: space,
                      ),

                    SizedBox(height: space),

                    // Package Type
                    _buildFeatureItem(
                      icon: Icons.category_outlined,
                      title: s.package_type,
                      value: package.packageType == s.freemium_packages ||
                              package.packageType.toLowerCase() == 'freemium'
                          ? s.freemium_packages
                          : s.paid_packages,
                      theme: theme,
                      space: space,
                    ),

                    SizedBox(height: space),

                    // Status
                    if (package.isActive != null)
                      _buildFeatureItem(
                        icon: package.isActive!
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined,
                        title: s.status,
                        value: package.isActive! ? s.available : s.rejected,
                        theme: theme,
                        space: space,
                        valueColor: package.isActive!
                            ? theme.primaryColor
                            : theme.colorScheme.error,
                      ),
                  ],
                ),
                theme: theme,
                space: space,
              ),

              SizedBox(height: space * 3),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: packageState.isProcessing
                      ? null
                      : () async {
                          await packageViewModel
                              .createPaymentUrl(package.packageId);

                          // Re-read state after async call
                          final updatedState =
                              ref.read(packageViewModelProvider);

                          if (context.mounted) {
                            if (updatedState.paymentUrl != null) {
                              // Navigate to payment webview with URL
                              context.push(
                                '/payment-webview',
                                extra: {
                                  'paymentUrl': updatedState.paymentUrl!,
                                  'transactionRef': updatedState.transactionRef,
                                  'packageName': package.name,
                                },
                              );

                              // Clear payment data after navigation
                              packageViewModel.clearPaymentData();
                            } else if (updatedState.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(updatedState.errorMessage!),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: theme.colorScheme.error,
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: space * 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(space),
                    ),
                    elevation: 2,
                  ),
                  child: packageState.isProcessing
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          s.select_package,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(String type, ThemeData theme, double space, S s) {
    final isFreemium =
        type == s.freemium_packages || type.toLowerCase() == 'freemium';
    final badgeText = isFreemium ? s.freemium_packages : s.paid_packages;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: space, vertical: space * 0.5),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(space * 0.5),
      ),
      child: Text(
        badgeText,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
    required ThemeData theme,
    required double space,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: space),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(space),
            side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
          ),
          child: Padding(padding: EdgeInsets.all(space * 1.5), child: child),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String value,
    required ThemeData theme,
    required double space,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(space * 0.8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(space * 0.6),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.onPrimaryContainer,
            size: 24,
          ),
        ),
        SizedBox(width: space),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: space * 0.2),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: valueColor ?? theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
