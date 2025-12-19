// import 'package:GreenConnectMobile/features/profile/presentation/providers/profile_providers.dart';
// import 'package:GreenConnectMobile/generated/l10n.dart';
// import 'package:GreenConnectMobile/shared/styles/app_color.dart';
// import 'package:GreenConnectMobile/shared/styles/padding.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class PackageDashboardPage extends ConsumerWidget {
//   const PackageDashboardPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final theme = Theme.of(context);
//     final space = theme.extension<AppSpacing>()!.screenPadding;
//     final s = S.of(context)!;

//     final profileState = ref.watch(profileViewModelProvider);
//     final isLoading = profileState.isLoading;
//     final error = profileState.errorMessage;
//     final user = profileState.user;
//     final int? creditBalance = user?.creditBalance;
//     final String? fullName = user?.fullName;

//     final String? avatarUrl = user?.avatarUrl;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(s.package_dashboard),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//       ),
//       extendBodyBehindAppBar: true,
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: AppColors.linearPrimary,
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(space),
//           child: isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : error != null
//                   ? Center(child: Text(error, style: theme.textTheme.bodyLarge))
//                   : ListView(
//                       children: [
//                         // Banner nhỏ với màu info
//                         Container(
//                           margin: EdgeInsets.only(bottom: space),
//                           padding: EdgeInsets.symmetric(vertical: space * 0.7, horizontal: space),
//                           decoration: BoxDecoration(
//                             color: AppColors.info.withOpacity(0.12),
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black12,
//                                 blurRadius: 8,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(Icons.card_giftcard, color: AppColors.info, size: 28),
//                               SizedBox(width: space),
//                               Expanded(
//                                 child: Text(
//                                   'Dùng điểm để nhận ưu đãi và mua các gói dịch vụ!',
//                                   style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.info),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Card tổng quan điểm + avatar với surface
//                         Container(
//                           decoration: BoxDecoration(
//                             color: AppColors.surface.withOpacity(0.98),
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black12,
//                                 blurRadius: 12,
//                                 offset: Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           padding: EdgeInsets.all(space * 1.2),
//                           child: Row(
//                             children: [
//                               if (avatarUrl != null && avatarUrl.isNotEmpty)
//                                 CircleAvatar(
//                                   radius: 32,
//                                   backgroundImage: NetworkImage(avatarUrl),
//                                 )
//                               else
//                                 CircleAvatar(
//                                   radius: 32,
//                                   backgroundColor: AppColors.primary.withOpacity(0.12),
//                                   child: Icon(Icons.person, color: AppColors.primary, size: 32),
//                                 ),
//                               SizedBox(width: space),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     if (fullName != null)
//                                       Text(fullName, style: theme.textTheme.titleMedium?.copyWith(color: AppColors.textPrimary)),
//                                     SizedBox(height: 6),
//                                     Text(s.current_points, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
//                                     SizedBox(height: 2),
//                                     Text(
//                                       creditBalance?.toString() ?? '-',
//                                       style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Icon(Icons.monetization_on, color: AppColors.warning, size: 36),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: space * 1.2),
//                         // Các nút điều hướng với spacing hợp lý
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             _DashboardButton(
//                               icon: Icons.shopping_cart,
//                               label: s.buy_package,
//                               onTap: () {
//                                 context.pushNamed('package-list');
//                               },
//                             ),
//                             _DashboardButton(
//                               icon: Icons.history,
//                               label: s.point_history,
//                               onTap: () {
//                                 context.pushNamed('collector-list-credit-transactions');
//                               },
//                             ),
//                             _DashboardButton(
//                               icon: Icons.receipt_long,
//                               label: s.purchase_history,
//                               onTap: () {
//                                 context.pushNamed('payment-transaction-history');
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//         ),
//       ),
//     );
//   }
// }

// class _DashboardButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//   const _DashboardButton({required this.icon, required this.label, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Column(
//       children: [
//         InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: AppColors.primary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Icon(icon, color: AppColors.primary, size: 32),
//           ),
//         ),
//         SizedBox(height: 8),
//         Text(label, style: theme.textTheme.bodySmall),
//       ],
//     );
//   }
// }
import 'package:GreenConnectMobile/features/package/presentation/views/widgets/package_action_grid.dart';
import 'package:GreenConnectMobile/features/package/presentation/views/widgets/package_credit_card.dart';
import 'package:GreenConnectMobile/features/package/presentation/views/widgets/package_info_banner.dart';
import 'package:GreenConnectMobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PackageDashboardPage extends ConsumerWidget {
  const PackageDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final space = theme.extension<AppSpacing>()!.screenPadding;
    final s = S.of(context)!;

    final profileState = ref.watch(profileViewModelProvider);
    final user = profileState.user;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(s.package_dashboard),
        titleTextStyle: TextStyle(
          color: theme.scaffoldBackgroundColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.scaffoldBackgroundColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.linearPrimary),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(space),
            child: profileState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : profileState.errorMessage != null
                ? Center(child: Text(profileState.errorMessage!))
                : Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(space * 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const InfoBanner(),
                        const SizedBox(height: 20),
                        CreditCard(user: user),
                        const SizedBox(height: 28),
                        const ActionGrid(),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
