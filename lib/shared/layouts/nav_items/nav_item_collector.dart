import 'package:GreenConnectMobile/shared/layouts/nav_type.dart';
import 'package:flutter/material.dart';

final List<NavConfig> navItemsCollector = [
  const NavConfig(
    icon: Icons.home,
    label: "Home",
    routeName: '/collector-home',
  ),
  const NavConfig(
    icon: Icons.chat,
    label: "Complaints",
    routeName: '/collector-list-post',
  ),
  const NavConfig(
    icon: Icons.receipt,
    label: "Transactions",
    routeName: '/list-transactions',
  ),
   const NavConfig(
    icon: Icons.feedback,
    label: "Feedbacks",
    routeName: '/feedback-list',
  ),
  const NavConfig(
    icon: Icons.settings,
    label: "Profile",
    routeName: '/profile-settings',
  ),
];
