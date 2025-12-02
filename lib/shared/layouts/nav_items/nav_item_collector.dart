import 'package:GreenConnectMobile/shared/layouts/nav_type.dart';
import 'package:flutter/material.dart';

final List<NavConfig> navItemsCollector = [
  const NavConfig(
    icon: Icons.home,
    label: "Home",
    routeName: '/collector-home',
  ),
  const NavConfig(
    icon: Icons.recycling,
    label: "Posts",
    routeName: '/collector-list-post',
  ),
  const NavConfig(
    icon: Icons.local_offer,
    label: "Offers",
    routeName: '/collector-offer-list',
    extra: {'isCollectorView': true},
  ),
  const NavConfig(
    icon: Icons.schedule,
    label: "Schedules",
    routeName: '/collector-schedule-list',
  ),
  const NavConfig(
    icon: Icons.chat,
    label: "Complaints",
    routeName: '/collector-complaint-list',
  ),
  const NavConfig(
    icon: Icons.receipt,
    label: "Transactions",
    routeName: '/collector-list-transactions',
  ),
  const NavConfig(
    icon: Icons.feedback,
    label: "Feedbacks",
    routeName: '/collector-feedback-list',
  ),
  const NavConfig(
    icon: Icons.settings,
    label: "Profile",
    routeName: '/collector-profile-settings',
  ),
];
