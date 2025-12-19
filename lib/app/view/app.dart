import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/core/constants/app_strings.dart';
import 'package:cybercare/features/achievements/view/achievements_screen.dart';
import 'package:cybercare/features/home/view/home_screen.dart';
import 'package:cybercare/features/modules/view/modules_list_screen.dart';
import 'package:cybercare/features/resources/view/resources_list.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MainNavigatorScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => MainNavigatorScreen());
  const MainNavigatorScreen({super.key});

  @override
  State<MainNavigatorScreen> createState() => _MainNavigatorScreenState();
}

class _MainNavigatorScreenState extends State<MainNavigatorScreen> {
  int _selectedIndex = 0;

  // List of screens to navigate to
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ModulesListScreen(),
    AchievementsScreen(),
    ResourcesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: _buildFloatingBottomNavBar(),
    );
  }

  /// Builds the custom floating bottom navigation bar
  Widget _buildFloatingBottomNavBar() {
    return Container(
      // The margin provides the "floating" effect
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      height: 70, // Set a fixed, predictable height
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        // Distribute items evenly across the bar
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // These now call a new helper widget
          _buildNavBarItem(
            icon: Iconsax.home,
            activeIcon: Iconsax.home_15,
            label: AppStrings.navHome,
            index: 0,
          ),
          _buildNavBarItem(
            icon: Iconsax.archive_book,
            activeIcon: Iconsax.archive_book,
            label: AppStrings.navModules,
            index: 1,
          ),
          _buildNavBarItem(
            icon: Iconsax.medal_star,
            activeIcon: Iconsax.medal_star5,
            label: AppStrings.navBadges,
            index: 2,
          ),
          _buildNavBarItem(
            icon: Iconsax.lamp_charge,
            activeIcon: Iconsax.lamp_charge5,
            label: AppStrings.navResources,
            index: 3,
          ),
        ],
      ),
    );
  }

  // Helper widget to create each navigation item
  Widget _buildNavBarItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    // Check if this item is the currently selected one
    final isSelected = _selectedIndex == index;
    // Determine the color based on the selection state
    final color = isSelected ? AppColors.accentYellow : AppColors.primaryDark;

    return Expanded(
      child: InkWell(
        // Make sure to use your existing state management function
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(12), // Optional: for a nice ripple effect
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon, // Switch between active/inactive icons
              color: color,
              size: 26,
            ),
            const SizedBox(height: 4), // Space between icon and text
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
