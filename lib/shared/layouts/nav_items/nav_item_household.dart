import 'package:GreenConnectMobile/shared/layouts/nav_type.dart';
import 'package:flutter/material.dart';

final List<NavConfig> navItemsHousehold = [
  const NavConfig(
    icon: Icons.home,
    label: "Home",
    routeName: '/household-home',
  ),
  const NavConfig(
    icon: Icons.gif_box,
    label: "Rewards",
    routeName: '/rewards',
  ),
  const NavConfig(
    icon: Icons.message,
    label: "Messages",
    routeName: '/household-list-message',
  ),
  const NavConfig(
    icon: Icons.settings,
    label: "Profile",
    routeName: '/household-profile-settings',
  ),
];
