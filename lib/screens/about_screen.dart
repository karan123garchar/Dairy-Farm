import 'package:flutter/material.dart';
import '../widgets/user_drawer.dart';
import '../widgets/cow_head_icon.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const Color _primaryGreen = Color(0xFF0C3823);
  static const Color _bg = Color(0xFFEFF6F1);
  static const Color _textDark = Color(0xFF1F2937);
  static const Color _textGrey = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserDrawer(),
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _primaryGreen,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 22),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'About Krishna Dairy',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Hero Banner ──
            _buildHeroHeader(context),

            const SizedBox(height: 20),

            // ── Key Statistics Row ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildStatCard('150+', 'Healthy Cattle', Icons.pets, const Color(0xFF10B981)),
                  const SizedBox(width: 10),
                  _buildStatCard('2.5k L', 'Daily Output', Icons.water_drop, const Color(0xFF0284C7)),
                  const SizedBox(width: 10),
                  _buildStatCard('100%', 'Pure & Organic', Icons.verified, const Color(0xFF8B5CF6)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Our Story & Mission ──
            _buildSectionCard(
              title: 'Our Legacy & Mission',
              icon: Icons.history_edu,
              content: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Established in 1998 in Pune, Maharashtra, Krishna Dairy Farm has grown from a humble family farm into a premier smart dairy enterprise. We are committed to uncompromised milk purity, humane animal welfare, and sustainable organic farming.',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: _textDark,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Every drop of milk is tested for quality, processed with modern hygienic standards, and delivered fresh daily to thousands of happy families.',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: _textDark,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── High Standards & Facilities ──
            _buildSectionCard(
              title: 'Farm Facilities & Standards',
              icon: Icons.workspace_premium,
              content: Column(
                children: [
                  _buildFacilityRow(
                    Icons.biotech,
                    'Automated Milking Parlors',
                    'Zero direct touch, temperature-controlled milking pipelines.',
                    const Color(0xFF0284C7),
                  ),
                  const Divider(height: 20),
                  _buildFacilityRow(
                    Icons.medical_services_outlined,
                    '24/7 Veterinary Care',
                    'Regular health checkups, vaccination tracking, & organic feed diets.',
                    const Color(0xFF10B981),
                  ),
                  const Divider(height: 20),
                  _buildFacilityRow(
                    Icons.grass_outlined,
                    'In-House Green Fodder',
                    'Nutrient-rich hydroponic grass & organic corn silage feed.',
                    const Color(0xFFD97706),
                  ),
                  const Divider(height: 20),
                  _buildFacilityRow(
                    Icons.ac_unit,
                    'Cold-Chain Logistics',
                    'Chilled at 4°C within 15 minutes of milking for natural freshness.',
                    const Color(0xFF6366F1),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Contact & Location Card ──
            _buildSectionCard(
              title: 'Contact & Farm Location',
              icon: Icons.location_on_outlined,
              content: Column(
                children: [
                  _buildContactRow(
                    Icons.map_outlined,
                    'Address',
                    'Krishna Dairy Farm, Haveli Taluka, Pune, Maharashtra - 411028',
                  ),
                  const SizedBox(height: 12),
                  _buildContactRow(
                    Icons.phone_outlined,
                    'Phone',
                    '+91 98765 43210 / +91 98220 11223',
                  ),
                  const SizedBox(height: 12),
                  _buildContactRow(
                    Icons.email_outlined,
                    'Email',
                    'contact@krishnadairy.com',
                  ),
                  const SizedBox(height: 12),
                  _buildContactRow(
                    Icons.access_time,
                    'Visiting Hours',
                    'Mon - Sat: 7:00 AM - 11:00 AM & 4:00 PM - 7:00 PM',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── App Info Footer ──
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/krishna_logo.png',
                          height: 32,
                          width: 32,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.agriculture,
                            color: _primaryGreen,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Krishna Dairy Smart App',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Version 2.4.0 (Build 82) • Built with Flutter',
                    style: TextStyle(
                      fontSize: 12,
                      color: _textGrey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '© 2026 Krishna Dairy Farm. All rights reserved.',
                    style: TextStyle(
                      fontSize: 11,
                      color: _textGrey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Hero Header ──
  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: const BoxDecoration(
        color: _primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: CircleAvatar(
              radius: 42,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/krishna_logo.png',
                  height: 70,
                  width: 70,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.agriculture,
                    size: 40,
                    color: _primaryGreen,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Krishna Dairy Farm',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Color(0xFFFBBF24), size: 16),
              SizedBox(width: 4),
              Text(
                'Pure Quality • Organic Excellence • Est. 1998',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFFD1FAE5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Stat Card ──
  Widget _buildStatCard(String val, String title, IconData icon, Color color) {
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: icon == Icons.pets
                  ? CowHeadIcon(size: 20, color: color)
                  : Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              val,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              textAlign: TextAlign.center,
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

  // ── Section Card Container ──
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: _primaryGreen, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          content,
        ],
      ),
    );
  }

  // ── Facility Row ──
  Widget _buildFacilityRow(
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
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
                  fontSize: 12,
                  color: _textGrey,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Contact Row ──
  Widget _buildContactRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _primaryGreen),
        const SizedBox(width: 10),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _textGrey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _textDark,
            ),
          ),
        ),
      ],
    );
  }
}
