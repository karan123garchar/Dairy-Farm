import 'package:flutter/material.dart';
import '../widgets/user_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import 'about_screen.dart';

// ─────────────────────────────────────────────
// User Profile Screen
// ─────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'Rahul Sharma';
  String _userRole = 'Verified Customer Account';
  String _userPhone = '+91 98765 43210';
  String _userLocation = 'Junagadh, Gujarat';
  bool _notificationsEnabled = true;

  static const Color _primaryGreen = Color(0xFF0C3823);
  static const Color _bg = Color(0xFFEFF6F1);
  static const Color _textDark = Color(0xFF111827);
  static const Color _textGrey = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserDrawer(),
      backgroundColor: _bg,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Profile Hero Section ──
            _buildProfileHero(),

            const SizedBox(height: 20),

            // ── Quick Stats Grid ──
            _buildQuickStatsGrid(),

            const SizedBox(height: 24),

            // ── Customer Details Section ──
            _buildSectionLabel('CUSTOMER DASHBOARD'),
            _buildMenuCard([
              // _buildMenuRow(
              //   iconBg: const Color(0xFFDCFCE7),
              //   iconColor: const Color(0xFF16A34A),
              //   icon: Icons.shopping_bag_outlined,
              //   title: 'My Orders & Subscriptions',
              //   subtitle: 'Track daily milk delivery & order history',
              //   onTap: () => _showInfoSnack('My Orders'),
              // ),
              // _buildDivider(),
              // _buildMenuRow(
              //   iconBg: const Color(0xFFE0F2FE),
              //   iconColor: const Color(0xFF0284C7),
              //   icon: Icons.location_on_outlined,
              //   title: 'Delivery Addresses',
              //   subtitle: 'Manage home & office delivery locations',
              //   onTap: () => _showInfoSnack('Delivery Addresses'),
              // ),
              // _buildDivider(),
              // _buildMenuRow(
              //   iconBg: const Color(0xFFF3E8FF),
              //   iconColor: const Color(0xFF9333EA),
              //   icon: Icons.payment_outlined,
              //   title: 'Payment Methods',
              //   subtitle: 'UPI, Debit/Credit cards & Net banking',
              //   onTap: () => _showInfoSnack('Payment Methods'),
              // ),
              // _buildDivider(),
              // _buildMenuRow(
              //   iconBg: const Color(0xFFFEF3C7),
              //   iconColor: const Color(0xFFD97706),
              //   icon: Icons.favorite_border,
              //   title: 'My Wishlist',
              //   subtitle: 'Saved dairy products & seasonal offers',
              //   onTap: () => _showInfoSnack('Wishlist'),
              // ),
              _buildDivider(),
              _buildMenuRow(
                iconBg: const Color(0xFFE0F2FE),
                iconColor: const Color(0xFF0284C7),
                icon: Icons.support_agent_outlined,
                title: 'Help & Support',
                subtitle: 'Customer care, FAQs & feedback',
                onTap: () => _showInfoSnack('Help & Support'),
              ),
            ]),

            const SizedBox(height: 24),

            // ── Preferences & Information Section ──
            _buildSectionLabel('PREFERENCES & INFORMATION'),
            _buildMenuCard([
              _buildToggleRow(
                iconBg: const Color(0xFFF3E8FF),
                iconColor: const Color(0xFF9333EA),
                icon: Icons.notifications_active_outlined,
                title: 'Farm Alerts & Reminders',
                subtitle: 'Milking schedules & health tasks',
                value: _notificationsEnabled,
                onChanged: (val) => setState(() => _notificationsEnabled = val),
              ),
              _buildDivider(),
              _buildMenuRow(
                iconBg: const Color(0xFFE0E7FF),
                iconColor: const Color(0xFF4F46E5),
                icon: Icons.info_outline,
                title: 'About Krishna Dairy',
                subtitle: 'Farm history, location & contact details',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutScreen()),
                  );
                },
              ),
            ]),

            const SizedBox(height: 28),

            // ── Logout Button ──
            _buildLogoutButton(),

            const SizedBox(height: 16),

            // ── Version Footer ──
            const Text(
              'Krishna Dairy v2.4.0 (Build 82)',
              style: TextStyle(
                fontSize: 11.5,
                color: _textGrey,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: const DairyBottomNavBar(selectedIndex: 2),
    );
  }

  // ── AppBar ──────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _primaryGreen,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 22),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/dairy_logo.png',
              height: 30,
              width: 30,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.agriculture, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'My Profile',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
          onPressed: _showEditProfileDialog,
        ),
      ],
    );
  }

  // ── Profile Hero Card ────────────────────────────────────
  Widget _buildProfileHero() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF86EFAC),
                    width: 3,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 43,
                  backgroundColor: Color(0xFFD1FAE5),
                  child: Icon(
                    Icons.person,
                    size: 46,
                    color: _primaryGreen,
                  ),
                ),
              ),
              InkWell(
                onTap: _showEditProfileDialog,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _primaryGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Name
          Text(
            _userName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: _textDark,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),

          // Role
          Text(
            _userRole,
            style: const TextStyle(
              fontSize: 13.5,
              color: _textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: _textGrey),
              const SizedBox(width: 4),
              Text(
                '$_userLocation  •  $_userPhone',
                style: const TextStyle(
                  fontSize: 12,
                  color: _textGrey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Premium Badge Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF9C3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFDE68A), width: 1),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium_rounded, size: 15, color: Color(0xFFB45309)),
                SizedBox(width: 6),
                Text(
                  'Krishna Dairy Owner',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF92400E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Stats Grid ─────────────────────────────────────
  Widget _buildQuickStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildStatBox('150', 'Cattle Managed', Icons.pets, const Color(0xFF10B981)),
          const SizedBox(width: 10),
          _buildStatBox('25', 'Active Staff', Icons.badge_outlined, const Color(0xFF0284C7)),
          const SizedBox(width: 10),
          _buildStatBox('98.5%', 'Herd Health', Icons.favorite_outline, const Color(0xFFEC4899)),
        ],
      ),
    );
  }

  Widget _buildStatBox(String count, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              count,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: _textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section Label ─────────────────────────────────────────
  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: _textGrey,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  // ── Menu Card Container ───────────────────────────────────
  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // ── Menu Row ──────────────────────────────────────────────
  Widget _buildMenuRow({
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: _textGrey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB), size: 22),
          ],
        ),
      ),
    );
  }

  // ── Toggle Row ────────────────────────────────────────────
  Widget _buildToggleRow({
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: _textGrey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: _primaryGreen,
            activeTrackColor: const Color(0xFF86EFAC),
            inactiveThumbColor: const Color(0xFFD1D5DB),
            inactiveTrackColor: const Color(0xFFE5E7EB),
          ),
        ],
      ),
    );
  }

  // ── Thin Divider ─────────────────────────────────────────
  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 70),
      child: Divider(height: 1, color: Color(0xFFF3F4F6)),
    );
  }

  // ── Edit Profile Modal ───────────────────────────────────
  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _userName);
    final phoneCtrl = TextEditingController(text: _userPhone);
    final locCtrl = TextEditingController(text: _userLocation);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Edit Profile Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: locCtrl,
              decoration: const InputDecoration(
                labelText: 'Location / City',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userName = nameCtrl.text;
                _userPhone = phoneCtrl.text;
                _userLocation = locCtrl.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: _primaryGreen,
                  content: Text('Profile details updated successfully!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Logout Button ─────────────────────────────────────────
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFECACA), width: 1),
        ),
        child: InkWell(
          onTap: () => _showLogoutDialog(),
          borderRadius: BorderRadius.circular(16),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 20),
                SizedBox(width: 10),
                Text(
                  'Logout from Account',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Logout Confirmation Dialog ────────────────────────────
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold, color: _textDark),
        ),
        content: const Text(
          'Are you sure you want to log out of Krishna Dairy Farm?',
          style: TextStyle(color: Color(0xFF4B5563), fontSize: 13.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: _textGrey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Color(0xFFDC2626),
                  content: Text('Logged out successfully.'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Toast helper ─────────────────────────────────────────
  void _showInfoSnack(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text('Opening $label...'),
      ),
    );
  }
}
