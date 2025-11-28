import 'package:GreenConnectMobile/shared/layouts/nav_type.dart';
import 'package:flutter/material.dart';

final List<NavConfig> navItemsHousehold = [
  const NavConfig(
    icon: Icons.home,
    label: "Home",
    routeName: '/household-home',
  ),
  const NavConfig(
    icon: Icons.receipt,
    label: "Transactions",
    routeName: '/list-transactions',
  ),
   const NavConfig(
    icon: Icons.chat,
    label: "Messages",
    routeName: '/list-message',
  ),
  const NavConfig(
    icon: Icons.settings,
    label: "Settings",
    routeName: '/profile-settings',
  ),
];
