import 'package:GreenConnectMobile/shared/layouts/nav_type.dart';
import 'package:flutter/material.dart';

final List<NavConfig> navItemsHousehold = [
  const NavConfig(
    icon: Icons.home,
    label: "Home",
    routeName: '/household-home',
  ),
  const NavConfig(
    icon: Icons.search,
    label: "Search",
    routeName: '/detail-post',
    extra: {
      'title': 'Recycling Old Phones',
      'description': 'Collected used phones for recycling',
      'postedDate': '20/06/2024',
      'status': 'accepted',
      'pickupTime': 'Morning (8:00 AM - 12:00 PM)',
      'pickupAddress': '45 Green Avenue',
      'scrapItems': [
        {'category': 'Electronics', 'quantity': 3, 'weight': 2.5},
        {'category': 'Electronics', 'quantity': 3, 'weight': 2.5},
      ],
    },
  ),
  const NavConfig(
    icon: Icons.video_call_outlined,
    label: "Video",
    routeName: '/profile-settings',
    extra: {
      'title': 'ha.thanh.phong@example.com',
      'imageUrl': 'assets/images/recycling_post.png',
      'fullname': 'Hà Thanh Phong',
      'address': '45 Green Avenue',
      'phonenumber': '0123456789',
      'role': 'Collector',
    },
  ),
  const NavConfig(
    icon: Icons.person,
    label: "Profile",
    routeName: '/detail-post',
    extra: {
      'postId': "fdsaf",
      'title': "Recycling Old Phones",
      'content': "Collected used phones for recycling",
      'imageUrl': "assets/images/recycling_post.png",
    },
  ),
  const NavConfig(
    icon: Icons.video_call,
    label: "Video Call",
    routeName: '/update-post',
    extra: {
      'title': 'Recycling Old Phones',
      'description': 'Collected used phones for recycling',
      'pickupAddress': '45 Green Avenue',
      'pickupTime': 'Morning (8:00 AM - 12:00 PM)',
      'scrapItems': [
        {
          'category': 'Electronics',
          'quantity': 3,
          'weight': 2.5,
          'image': null,
        },
      ],
    },
  ),
  const NavConfig(
    icon: Icons.settings,
    label: "Settings",
    routeName: '/profile-settings',
  ),
];
