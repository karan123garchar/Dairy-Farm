import 'package:flutter/material.dart';
import '../widgets/user_drawer.dart';
import '../widgets/admin_drawer.dart';
import '../utils/user_session.dart';
import '../widgets/bottom_nav_bar.dart';

// ─────────────────────────────────────────────
// Vaccine Model
// ─────────────────────────────────────────────
class VaccineTask {
  final String id;
  final String title;
  final String dateText;
  final String pendingText;
  final bool isOverdue;
  final String overdueDays;

  const VaccineTask({
    required this.id,
    required this.title,
    required this.dateText,
    required this.pendingText,
    this.isOverdue = false,
    this.overdueDays = '',
  });
}

// ─────────────────────────────────────────────
// Health & Vaccination Screen
// ─────────────────────────────────────────────
class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  int _selectedTab = 0; // 0: Vaccination Schedule, 1: Health Records


  final List<VaccineTask> _vaccines = const [
    VaccineTask(
      id: 'v1',
      title: 'Foot and Mouth Disease (FMD)',
      dateText: 'Oct 24, 2023',
      pendingText: '12 Animals Pending',
    ),
    VaccineTask(
      id: 'v2',
      title: 'Brucellosis Booster',
      dateText: '',
      pendingText: '08 Animals Pending',
      isOverdue: true,
      overdueDays: 'Overdue: 2 days',
    ),
    VaccineTask(
      id: 'v3',
      title: 'Black Quarter (BQ)',
      dateText: 'Nov 12, 2023',
      pendingText: 'Herd-wide Task',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: globalUserSession.isAdmin ? const AdminDrawer() : const UserDrawer(),
      backgroundColor: const Color(0xFFEFF6F1),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header Section ──
            _buildHeaderSection(),

            // ── Chief Vet Card ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildChiefVetCard(),
            ),
            const SizedBox(height: 18),

            // ── Section: Active Health Alerts ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFDC2626)),
                      SizedBox(width: 6),
                      Text(
                        'ACTIVE HEALTH ALERTS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF374151),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Alert 1: Urgent Cow #HF-204
                  _buildUrgentAlertCard(),
                  const SizedBox(height: 12),

                  // Alert 2: Monitor Buffalo #M-102
                  _buildMonitorAlertCard(),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Tabs & Upcoming Vaccines ──
            _buildTabSwitcher(),

            const SizedBox(height: 16),

            // ── Upcoming Vaccines Section ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upcoming Vaccines',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.tune, size: 14, color: Color(0xFF4B5563)),
                        label: const Text(
                          'Filter',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          minimumSize: Size.zero,
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Vaccine Tasks List
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _vaccines.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return _buildVaccineCard(_vaccines[index]);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: const DairyBottomNavBar(selectedIndex: -1),
    );
  }

  // ── AppBar ──────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0C3823),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 22),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: const Text(
        'Health & Vaccination',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.white, size: 26),
            onPressed: () {},
          ),
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
            'Health & Vaccination',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Monitor herd wellness and upcoming medical tasks.',
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  // ── Chief Vet Card ──────────────────────────────────────
  Widget _buildChiefVetCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFD1FAE5),
            child: Icon(Icons.medical_services_outlined, size: 20, color: Color(0xFF059669)),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dr. Amit Verma',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Chief Veterinarian',
                style: TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Urgent Alert Card Widget ──────────────────────────────
  Widget _buildUrgentAlertCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFEE2E2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFFEE2E2),
                    child: Icon(Icons.sentiment_very_dissatisfied, size: 18, color: Color(0xFFDC2626)),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cow #HF-204',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      Text(
                        'Mastitis Suspected',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'URGENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Details Row
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Isolation: Required',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4B5563),
                ),
              ),
              Text(
                'Detected: 2h ago',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Log Treatment Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Color(0xFF072718),
                    content: Text('Treatment logged for Cow #HF-204'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0E7FF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Log Treatment',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3730A3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Monitor Alert Card Widget ─────────────────────────────
  Widget _buildMonitorAlertCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFFEF3C7),
                    child: Icon(Icons.thermostat, size: 18, color: Color(0xFFD97706)),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buffalo #M-102',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      Text(
                        'High Temperature',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF78350F),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'MONITOR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Details Row
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Temp: 80.5° c',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4B5563),
                ),
              ),
              Text(
                'Observation: Every 4h',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Update Reading Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0E7FF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Update Reading',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3730A3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab Switcher Widget ──────────────────────────────────
  Widget _buildTabSwitcher() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _selectedTab == 0 ? const Color(0xFF0C3823) : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Vaccination Schedule',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _selectedTab == 0 ? FontWeight.w700 : FontWeight.w500,
                        color: _selectedTab == 0 ? const Color(0xFF0C3823) : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = 1),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _selectedTab == 1 ? const Color(0xFF0C3823) : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Health Records',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _selectedTab == 1 ? FontWeight.w700 : FontWeight.w500,
                        color: _selectedTab == 1 ? const Color(0xFF0C3823) : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Vaccine Card Widget ──────────────────────────────────
  Widget _buildVaccineCard(VaccineTask task) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFD1FAE5),
                child: Icon(Icons.vaccines, size: 18, color: Color(0xFF059669)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (task.isOverdue)
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
                          children: [
                            TextSpan(
                              text: '⏰ ${task.overdueDays} ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFDC2626),
                              ),
                            ),
                            TextSpan(text: '• ${task.pendingText}'),
                          ],
                        ),
                      )
                    else
                      Text(
                        '📅 ${task.dateText} • ${task.pendingText}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Action Buttons Row
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF072718),
                        content: Text('${task.title} marked as completed!'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F382B),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Mark Done',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Color(0xFF9CA3AF), size: 20),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

}
