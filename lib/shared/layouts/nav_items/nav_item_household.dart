import 'package:GreenConnectMobile/shared/layouts/nav_type.dart';
import 'package:flutter/material.dart';

final List<NavConfig> navItemsHousehold = [
  const NavConfig(
    icon: Icons.home,
    label: "Home",
    routeName: '/household-home',
  ),
  const NavConfig(
    icon: Icons.chat,
    label: "Complaints",
    routeName: '/household-complaint-list',
  ),
  const NavConfig(
    icon: Icons.receipt,
    label: "Transactions",
    routeName: '/household-list-transactions',
  ),
  const NavConfig(
    icon: Icons.feedback,
    label: "Feedbacks",
    routeName: '/household-feedback-list',
  ),
  const NavConfig(
    icon: Icons.settings,
    label: "Profile",
    routeName: '/household-profile-settings',
  ),
];
