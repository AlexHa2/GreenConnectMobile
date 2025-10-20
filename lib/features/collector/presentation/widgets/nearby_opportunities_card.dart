import 'package:flutter/material.dart';
import 'package:GreenConnectMobile/shared/styles/app_color.dart';
import 'package:GreenConnectMobile/features/collector/domain/entities/nearby_opportunity.dart';

class NearbyOpportunitiesCard extends StatelessWidget {
  final List<NearbyOpportunity> opportunities;
  final String tapText;

  const NearbyOpportunitiesCard({
    super.key,
    required this.opportunities,
    required this.tapText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to map view
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Map markers simulation
            ..._buildMapMarkers(),
            
            // Tap instruction overlay
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  tapText,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMapMarkers() {
    return [
      // Marker 1
      Positioned(
        left: 60,
        top: 40,
        child: _buildMarker(),
      ),
      // Marker 2
      Positioned(
        right: 80,
        top: 60,
        child: _buildMarker(),
      ),
      // Marker 3
      Positioned(
        left: 100,
        bottom: 50,
        child: _buildMarker(),
      ),
      // Marker 4
      Positioned(
        right: 60,
        bottom: 80,
        child: _buildMarker(),
      ),
    ];
  }

  Widget _buildMarker() {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
