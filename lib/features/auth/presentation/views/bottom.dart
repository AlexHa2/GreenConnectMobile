import 'package:GreenConnectMobile/shared/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;

  final _pages = [
    const Center(child: Text("🏠 Home Page")),
    const Center(child: Text("🔍 Search")),
    const Center(child: Text("🎥 Record")),
    const Center(child: Text("🔖 Saved")),
    const Center(child: Text("⚙️ Settings")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: CustomBottomNav(
        initialIndex: _pageIndex,
        items: [
          BottomNavItem(
            icon: Icons.home_outlined,
            label: "Home",
            onPressed: () => setState(() => _pageIndex = 0),
          ),
          BottomNavItem(
            icon: Icons.search,
            label: "Search",
            onPressed: () => setState(() => _pageIndex = 1),
          ),
          BottomNavItem(
            icon: Icons.videocam_outlined,
            label: "Record",
            onPressed: () => setState(() => _pageIndex = 2),
          ),
          BottomNavItem(
            icon: Icons.bookmark_border,
            label: "Saved",
            onPressed: () => setState(() => _pageIndex = 3),
          ),
          BottomNavItem(
            icon: Icons.settings_outlined,
            label: "Settings",
            onPressed: () => setState(() => _pageIndex = 4),
          ),
        ],
      ),
    );
  }
}


