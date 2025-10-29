import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OpportunitiesMapView extends StatefulWidget {
  const OpportunitiesMapView({super.key});

  @override
  State<OpportunitiesMapView> createState() => _OpportunitiesMapViewState();
}

class _OpportunitiesMapViewState extends State<OpportunitiesMapView> {
  int? _selectedOpportunityIndex;

  final List<Map<String, dynamic>> _opportunities = [
    {
      'id': 1,
      'title': 'Plastic Bottles - 25kg',
      'address': '123 Green Avenue, District 1',
      'distance': '0.5 km',
      'price': '\$45.00',
      'time': '8:00 AM - 12:00 PM',
      'position': const Offset(0.3, 0.25),
    },
    {
      'id': 2,
      'title': 'Paper Recycling - 18kg',
      'address': '456 Eco Street, District 3',
      'distance': '1.2 km',
      'price': '\$38.50',
      'time': '1:00 PM - 5:00 PM',
      'position': const Offset(0.7, 0.2),
    },
    {
      'id': 3,
      'title': 'Metal Scraps - 32kg',
      'address': '789 Nature Road, District 5',
      'distance': '2.1 km',
      'price': '\$62.00',
      'time': 'Flexible',
      'position': const Offset(0.35, 0.6),
    },
    {
      'id': 4,
      'title': 'Glass Bottles - 15kg',
      'address': '321 Recycle Blvd, District 7',
      'distance': '3.5 km',
      'price': '\$28.00',
      'time': '9:00 AM - 11:00 AM',
      'position': const Offset(0.65, 0.65),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Map View
          Positioned.fill(
            child: Container(
              color: const Color(0xFFE8F5E9),
              child: CustomPaint(
                painter: MapGridPainter(),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: _opportunities.asMap().entries.map((entry) {
                        final index = entry.key;
                        final opportunity = entry.value;
                        final position = opportunity['position'] as Offset;

                        return Positioned(
                          left: constraints.maxWidth * position.dx - 20,
                          top: constraints.maxHeight * position.dy - 40,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedOpportunityIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              child: Column(
                                children: [
                                  Container(
                                    width: _selectedOpportunityIndex == index
                                        ? 50
                                        : 40,
                                    height: _selectedOpportunityIndex == index
                                        ? 50
                                        : 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.5),
                                          blurRadius: 10,
                                          spreadRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                      size: _selectedOpportunityIndex == index
                                          ? 28
                                          : 22,
                                    ),
                                  ),
                                  if (_selectedOpportunityIndex == index)
                                    Container(
                                      width: 3,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ),

          // Top App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: spacing.screenPadding,
                right: spacing.screenPadding,
                bottom: spacing.screenPadding,
              ),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    color: theme.iconTheme.color,
                  ),
                  SizedBox(width: spacing.screenPadding),
                  Text(
                    S.of(context)!.nearby_opportunities,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // TODO: Filter opportunities
                    },
                    icon: const Icon(Icons.tune),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Sheet with opportunity details
          if (_selectedOpportunityIndex != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(spacing.screenPadding * 2),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(spacing.screenPadding * 2),
                    topRight: Radius.circular(spacing.screenPadding * 2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _opportunities[_selectedOpportunityIndex!]['title'],
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedOpportunityIndex = null;
                            });
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing.screenPadding),
                    _buildDetailRow(
                      context,
                      Icons.location_on_outlined,
                      _opportunities[_selectedOpportunityIndex!]['address'],
                    ),
                    SizedBox(height: spacing.screenPadding / 2),
                    _buildDetailRow(
                      context,
                      Icons.navigation_outlined,
                      _opportunities[_selectedOpportunityIndex!]['distance'],
                    ),
                    SizedBox(height: spacing.screenPadding / 2),
                    _buildDetailRow(
                      context,
                      Icons.access_time_outlined,
                      _opportunities[_selectedOpportunityIndex!]['time'],
                    ),
                    SizedBox(height: spacing.screenPadding * 1.5),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Giá trị ước tính',
                                style: textTheme.bodySmall,
                              ),
                              SizedBox(height: 4),
                              Text(
                                _opportunities[_selectedOpportunityIndex!]
                                    ['price'],
                                style: textTheme.titleLarge?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Accept opportunity
                          },
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Chấp nhận'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing.screenPadding * 2,
                              vertical: spacing.screenPadding * 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Floating Action Button - Browse List
          if (_selectedOpportunityIndex == null)
            Positioned(
              bottom: spacing.screenPadding * 2,
              right: spacing.screenPadding * 2,
              child: FloatingActionButton.extended(
                onPressed: () {
                  // TODO: Show list view
                },
                backgroundColor: AppColors.primary,
                icon: const Icon(Icons.list, color: Colors.white),
                label: Text(
                  'Danh sách',
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

// Custom painter for map grid pattern (reuse from nearby_opportunities_map.dart)
class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withValues(alpha: 0.08)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw grid lines
    const gridSize = 40.0;
    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }
    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }

    // Draw some decorative roads/paths
    final roadPaint = Paint()
      ..color = Colors.green.withValues(alpha: 0.15)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Horizontal road
    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      roadPaint,
    );

    // Vertical road
    canvas.drawLine(
      Offset(size.width * 0.6, 0),
      Offset(size.width * 0.6, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

