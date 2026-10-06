import 'package:flutter/material.dart';
import '../widgets/user_drawer.dart';
import '../widgets/admin_drawer.dart';
import '../utils/user_session.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/cow_head_icon.dart';

// ─────────────────────────────────────────────
// Top Performer Model
// ─────────────────────────────────────────────
class TopPerformer {
  final String name;
  final String tag;
  final String avgYield;
  final String imagePath;
  final bool hasStar;

  const TopPerformer({
    required this.name,
    required this.tag,
    required this.avgYield,
    required this.imagePath,
    this.hasStar = true,
  });
}

// ─────────────────────────────────────────────
// Milk Yield & Production Screen
// ─────────────────────────────────────────────
class MilkYieldScreen extends StatefulWidget {
  const MilkYieldScreen({super.key});

  @override
  State<MilkYieldScreen> createState() => _MilkYieldScreenState();
}

class _MilkYieldScreenState extends State<MilkYieldScreen> {
  final double _todayMorningLiters = 260.0;
  final double _todayEveningLiters = 222.5;

  static const Color _primaryGreen = Color(0xFF0C3823);
  static const Color _bg = Color(0xFFEFF6F1);

  final List<TopPerformer> _topPerformers = const [
    TopPerformer(
      name: 'Lola',
      tag: 'H-24',
      avgYield: '28.4 L avg',
      imagePath: 'assets/images/holstein_friesian.png',
      hasStar: true,
    ),
    TopPerformer(
      name: 'Bessie',
      tag: 'J-12',
      avgYield: '26.1 L avg',
      imagePath: 'assets/images/jersey_cow.png',
      hasStar: true,
    ),
    TopPerformer(
      name: 'Daisy',
      tag: 'G-09',
      avgYield: '25.5 L avg',
      imagePath: 'assets/images/gir_cow.png',
      hasStar: false,
    ),
  ];

  double get _todayTotal => _todayMorningLiters + _todayEveningLiters;

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
            // ── Header Section ──
            _buildHeaderSection(),

            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // 1. TODAY'S PRODUCTION CARD
                  _buildTodayProductionCard(),
                  const SizedBox(height: 14),

                  // 2. MONTH TO DATE DARK CONTAINER
                  _buildMonthToDateCard(),
                  const SizedBox(height: 14),

                  // 3. QUALITY METRICS SOFT BLUE CARD
                  _buildQualityMetricsCard(),
                  const SizedBox(height: 14),

                  // 4. TOP PERFORMERS CARD
                  _buildTopPerformersCard(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
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
        'Milk Production',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.show_chart, color: Colors.white, size: 22),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Viewing production trend chart...')),
            );
          },
        ),
      ],
    );
  }

  // ── Header Section ──────────────────────────────────────
  Widget _buildHeaderSection() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Milk Yield Analytics',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: _primaryGreen,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Real-time herd production & morning/evening logs',
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  // ── 1. Today's Production Card Widget ───────────────────
  Widget _buildTodayProductionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "TODAY'S PRODUCTION",
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF6B7280),
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  '+4.2% from yesterday',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF15803D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _todayTotal.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Liters Total',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              // Morning Box
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFFD1FAE5),
                        child: Icon(Icons.wb_sunny_outlined, size: 16, color: Color(0xFF059669)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Morning',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_todayMorningLiters.toStringAsFixed(1)} L',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Evening Box
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFFE5E7EB),
                        child: Icon(Icons.nightlight_round_outlined, size: 16, color: Color(0xFF4B5563)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Evening',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_todayEveningLiters.toStringAsFixed(1)} L',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 2. Month To Date Dark Card Widget ─────────────────────
  Widget _buildMonthToDateCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _primaryGreen,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MONTH TO DATE',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: Colors.white70,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '6,450.0 L',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Liters Produced',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.72,
              minHeight: 7,
              backgroundColor: Color(0xFF1C5237),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF86EFAC)),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '72% of monthly target reached (9,000 L goal)',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // ── 3. Quality Metrics Soft Card Widget ───────────────────
  Widget _buildQualityMetricsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MILK QUALITY & FAT METRICS',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF4B5563),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),

          _buildQualityMetricRow('🥛 Avg. Fat Content', '8.2%'),
          const SizedBox(height: 12),
          _buildQualityMetricRow('🧪 Avg. SNF Level', '8.8%'),
          const SizedBox(height: 12),
          _buildQualityMetricRow('🌡️ Chilled Storage Temp', '4.0°C'),
        ],
      ),
    );
  }

  Widget _buildQualityMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  // ── 4. Top Performers Card Widget ─────────────────────────
  Widget _buildTopPerformersCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
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
          const Text(
            'Top Yielding Cattle',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 14),

          Column(
            children: List.generate(_topPerformers.length, (index) {
              final item = _topPerformers[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF3F4F6)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        item.imagePath,
                        height: 38,
                        width: 38,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const CircleAvatar(
                          radius: 19,
                          backgroundColor: _primaryGreen,
                          child: CowHeadIcon(size: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item.name} (${item.tag})',
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.avgYield,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (item.hasStar)
                      const Icon(Icons.star, color: Color(0xFFF59E0B), size: 20),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
