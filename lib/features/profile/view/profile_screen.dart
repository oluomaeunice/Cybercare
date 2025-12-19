import 'package:cybercare/core/common/cubits/app_user.dart'; // Import AppUserCubit
import 'package:cybercare/core/common/snackbar.dart'; // Import your snackbar helper
import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/core/constants/app_strings.dart';
import 'package:cybercare/features/auth/view/bloc/auth_bloc.dart'; // Import AuthBloc
import 'package:cybercare/features/auth/view/pages/edit_profile_screen.dart';
import 'package:cybercare/features/auth/view/pages/login_page.dart'; // Import Login Page
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Flutter Bloc

class ProfileScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const ProfileScreen());
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State variables for the switches
  bool _pushNotifications = true;
  bool _emailUpdates = false;
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    // 1. Wrap Scaffold in BlocListener to handle Navigation upon Logout
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showSnackBar(context, 'Logout Failed', state.message);
        } else if (state is AuthInitial) {
          // When state resets to Initial, user is logged out.
          Navigator.pushAndRemoveUntil(
            context,
            LoginPage.route(),
                (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _CustomAppBar(),
                  const SizedBox(height: 24),

                  Text(
                    AppStrings.settingsTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. Wrap ProfileCard in BlocBuilder to show REAL User Data
                  BlocBuilder<AppUserCubit, AppUserState>(
                    builder: (context, state) {
                      // Default values
                      String name = 'User';
                      String email = 'email@cybercare.com';

                      // 1. Update values if logged in
                      if (state is AppUserLoggedIn) {
                        // Check if the name from DB is not empty before assigning
                        if (state.user.name.isNotEmpty) {
                          name = state.user.name;
                        }
                        email = state.user.email;
                      }

                      // 2. Safely get the initial.
                      // If name is somehow still empty, fallback to 'U' (for User) or 'C' (for cybercare)
                      final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

                      return _ProfileCard(
                        name: name,
                        email: email,
                        // 3. Use the safe 'initial' variable here
                        avatarUrl: 'https://placehold.co/100x100/F7F9FC/222B45?text=$initial',
                        onTap: () {
                          Navigator.push(context, EditProfileScreen.route());                        },
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // 4. Notifications Settings Group
                  _buildSectionTitle(AppStrings.settingsNotifications),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildSettingRow(
                          context,
                          icon: Icons.notifications_active_outlined,
                          title: AppStrings.settingsPushNotifications,
                          trailing: Switch(
                            value: _pushNotifications,
                            onChanged: (value) {
                              setState(() => _pushNotifications = value);
                            },
                            activeColor: AppColors.accentYellow,
                          ),
                        ),
                        _buildDivider(),
                        _buildSettingRow(
                          context,
                          icon: Icons.email_outlined,
                          title: AppStrings.settingsEmailUpdates,
                          trailing: Switch(
                            value: _emailUpdates,
                            onChanged: (value) {
                              setState(() => _emailUpdates = value);
                            },
                            activeColor: AppColors.accentYellow,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 5. Application Settings Group
                  _buildSectionTitle(AppStrings.settingsApplication),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildSettingRow(
                          context,
                          icon: Icons.dark_mode_outlined,
                          title: AppStrings.settingsDarkMode,
                          trailing: Switch(
                            value: _darkMode,
                            onChanged: (value) {
                              setState(() => _darkMode = value);
                            },
                            activeColor: AppColors.accentYellow,
                          ),
                        ),
                        _buildDivider(),
                        _buildSettingRow(
                          context,
                          icon: Icons.language_outlined,
                          title: AppStrings.settingsLanguage,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'English',
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios,
                                  color: AppColors.textGrey, size: 16),
                            ],
                          ),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildSettingRow(
                          context,
                          icon: Icons.help_outline,
                          title: AppStrings.settingsHelpSupport,
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: AppColors.textGrey, size: 16),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildSettingRow(
                          context,
                          icon: Icons.privacy_tip_outlined,
                          title: AppStrings.settingsPrivacyPolicy,
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: AppColors.textGrey, size: 16),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // 6. Logout Button
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // 3. Trigger the Logout Event
                        context.read<AuthBloc>().add(AuthLogout());
                      },
                      child: Text(
                        AppStrings.settingsLogout,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.accentYellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Colors.white.withOpacity(0.9),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSettingRow(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Widget trailing,
        VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColors.primaryDark.withOpacity(0.5),
      height: 1,
      indent: 60,
    );
  }
}

// ... _ProfileCard and _CustomAppBar classes remain the same ...
// You don't need to change them, just ensure _ProfileCard is taking the dynamic arguments passed above.

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.onTap,
  });

  final String name;
  final String email;
  final String avatarUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            // Using network image since we are generating dynamic URL above
            backgroundImage: NetworkImage(avatarUrl),
            // Fallback to asset if you prefer:
            // backgroundImage: AssetImage('assets/profile.jpg'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textDark.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: onTap,
            icon: Icon(Icons.edit_outlined, color: AppColors.primaryDark),
            tooltip: AppStrings.settingsEditProfile,
          ),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryLight,
            border: Border.all(color: AppColors.primaryDark.withOpacity(0.5)),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        Text(
          AppStrings.navSettings,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}