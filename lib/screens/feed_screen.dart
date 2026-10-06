import 'package:flutter/material.dart';
import '../widgets/user_drawer.dart';
import '../widgets/admin_drawer.dart';
import '../utils/user_session.dart';
import '../widgets/bottom_nav_bar.dart';

// ─────────────────────────────────────────────
// Feed Item Model
// ─────────────────────────────────────────────
class FeedItem {
  final String id;
  final String title;
  final String description;
  final String statusBadge;
  final Color badgeBg;
  final Color badgeTextColor;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  int currentStockKg;
  final int totalCapacityKg;
  final Color progressColor;
  final Color stockTextColor;

  FeedItem({
    required this.id,
    required this.title,
    required this.description,
    required this.statusBadge,
    required this.badgeBg,
    required this.badgeTextColor,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.currentStockKg,
    required this.totalCapacityKg,
    required this.progressColor,
    required this.stockTextColor,
  });

  double get stockRatio => currentStockKg / totalCapacityKg;
}

// ─────────────────────────────────────────────
// Feed Management Screen
// ─────────────────────────────────────────────
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  static const Color _primaryGreen = Color(0xFF0C3823);
  static const Color _bg = Color(0xFFEFF6F1);

  final List<FeedItem> _feedItems = [
    FeedItem(
      id: 'f1',
      title: 'Cattle Feed Pellets',
      description: 'High-protein balanced diet for dairy cows.',
      statusBadge: 'Optimal',
      badgeBg: const Color(0xFFDCFCE7),
      badgeTextColor: const Color(0xFF166534),
      icon: Icons.rice_bowl_outlined,
      iconBg: const Color(0xFFDCFCE7),
      iconColor: const Color(0xFF15803D),
      currentStockKg: 850,
      totalCapacityKg: 1000,
      progressColor: const Color(0xFF15803D),
      stockTextColor: const Color(0xFF111827),
    ),
    FeedItem(
      id: 'f2',
      title: 'Green Hydroponic Fodder',
      description: 'Fresh maize & sorghum organic grass.',
      statusBadge: 'Low Stock',
      badgeBg: const Color(0xFFFEE2E2),
      badgeTextColor: const Color(0xFF991B1B),
      icon: Icons.grass,
      iconBg: const Color(0xFFFEF3C7),
      iconColor: const Color(0xFFD97706),
      currentStockKg: 180,
      totalCapacityKg: 1000,
      progressColor: const Color(0xFFDC2626),
      stockTextColor: const Color(0xFFDC2626),
    ),
    FeedItem(
      id: 'f3',
      title: 'Dry Hay Bales',
      description: 'High-fiber sun-cured hay for digestion.',
      statusBadge: 'Moderate',
      badgeBg: const Color(0xFFE0F2FE),
      badgeTextColor: const Color(0xFF0369A1),
      icon: Icons.agriculture_outlined,
      iconBg: const Color(0xFFE0F2FE),
      iconColor: const Color(0xFF0284C7),
      currentStockKg: 460,
      totalCapacityKg: 1000,
      progressColor: const Color(0xFFD97706),
      stockTextColor: const Color(0xFFD97706),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: globalUserSession.isAdmin ? const AdminDrawer() : const UserDrawer(),
      backgroundColor: _bg,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Farm Banner ──
            _buildHeroBanner(),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Text(
                'Feed Inventory & Stock Levels',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: _primaryGreen,
                  letterSpacing: -0.3,
                ),
              ),
            ),

            // ── Feed Inventory Cards ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _feedItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return _buildFeedCard(_feedItems[index]);
                },
              ),
            ),
            const SizedBox(height: 16),

            // ── Cost Analysis Card ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildCostAnalysisCard(),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: const DairyBottomNavBar(selectedIndex: -1),
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
      title: const Text(
        'Feed Management',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
    );
  }

  // ── Hero Banner ──────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.grass_outlined, color: _primaryGreen, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Krishna Feed & Nutrition',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Daily feed allocation: 1,200 kg / day across 150 cattle',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Feed Card Container ──────────────────────────────────
  Widget _buildFeedCard(FeedItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: item.badgeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.statusBadge,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: item.badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Stock Gauge Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Stock Gauge',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
              ),
              Text(
                '${item.currentStockKg} / ${item.totalCapacityKg} kg',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: item.stockTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: item.stockRatio,
              minHeight: 8,
              backgroundColor: const Color(0xFFF3F4F6),
              valueColor: AlwaysStoppedAnimation<Color>(item.progressColor),
            ),
          ),
        ],
      ),
    );
  }

  // ── Cost Analysis Card ───────────────────────────────────
  Widget _buildCostAnalysisCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: _primaryGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Monthly Feed Budget & Cost',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Monthly Spent (Est.)', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
              Text('₹ 1,45,000', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cost per Litre Milk', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
              Text('₹ 22.4 / L', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
            ],
          ),
        ],
      ),
    );
  }
}
