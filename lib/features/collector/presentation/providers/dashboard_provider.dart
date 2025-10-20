import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:GreenConnectMobile/features/collector/domain/entities/dashboard_stats.dart';
import 'package:GreenConnectMobile/features/collector/domain/entities/nearby_opportunity.dart';

// Mock data provider for dashboard stats
final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  return const DashboardStats(
    earningsToday: 45.50,
    jobsAvailable: 12,
    rating: 4.8,
  );
});

// Mock data provider for nearby opportunities
final nearbyOpportunitiesProvider = Provider<List<NearbyOpportunity>>((ref) {
  final baseDate = DateTime(2024, 1, 15);
  return [
    NearbyOpportunity(
      id: '1',
      title: 'Thu gom điện thoại cũ',
      description: 'iPhone 12 Pro Max, Samsung Galaxy S21',
      latitude: 10.7769,
      longitude: 106.7009,
      distance: 0.5,
      estimatedValue: 25.0,
      category: 'Điện thoại',
      createdAt: baseDate,
    ),
    NearbyOpportunity(
      id: '2',
      title: 'Thu gom laptop cũ',
      description: 'MacBook Pro 2019, Dell XPS 13',
      latitude: 10.7800,
      longitude: 106.7100,
      distance: 1.2,
      estimatedValue: 150.0,
      category: 'Laptop',
      createdAt: baseDate,
    ),
    NearbyOpportunity(
      id: '3',
      title: 'Thu gom máy tính để bàn',
      description: 'CPU Intel i7, RAM 16GB, VGA RTX 3060',
      latitude: 10.7700,
      longitude: 106.6900,
      distance: 0.8,
      estimatedValue: 80.0,
      category: 'PC',
      createdAt: baseDate,
    ),
    NearbyOpportunity(
      id: '4',
      title: 'Thu gom đồ gia dụng điện tử',
      description: 'Tủ lạnh, máy giặt, điều hòa',
      latitude: 10.7850,
      longitude: 106.7200,
      distance: 2.1,
      estimatedValue: 200.0,
      category: 'Đồ gia dụng',
      createdAt: baseDate,
    ),
  ];
});
