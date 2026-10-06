import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/user_session.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/cow_head_icon.dart';

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// AdminPanelScreen â€” Ultra-Premium Executive Control Center
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class AdminPanelScreen extends StatefulWidget {
  final int initialTabIndex;

  const AdminPanelScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  // â”€â”€ Design Tokens â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const Color _primaryGreen = Color(0xFF0C3823);
  static const Color _accentGreen = Color(0xFF22C55E);
  static const Color _lightBg = Color(0xFFEFF6F1);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1F2937);
  static const Color _textMuted = Color(0xFF6B7280);

  // â”€â”€ State Data (In-Memory Admin Management Database) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  final List<Map<String, dynamic>> _cattleList = [
    {
      'id': 'COW-101',
      'name': 'Kamdhenu',
      'breed': 'Gir Cow',
      'age': '4 Yrs',
      'milkYield': '16.5 L/day',
      'status': 'Milking',
      'health': 'Healthy',
      'photo': 'assets/images/gir_cow.png'
    },
    {
      'id': 'COW-102',
      'name': 'Gauri',
      'breed': 'Gir Cow',
      'age': '3.5 Yrs',
      'milkYield': '14.0 L/day',
      'status': 'Milking',
      'health': 'Healthy',
      'photo': 'assets/images/gir_cow.png'
    },
    {
      'id': 'HF-201',
      'name': 'Bella',
      'breed': 'Holstein Friesian',
      'age': '5 Yrs',
      'milkYield': '24.0 L/day',
      'status': 'Milking',
      'health': 'Healthy',
      'photo': 'assets/images/holstein_friesian.png'
    },
    {
      'id': 'HF-202',
      'name': 'Daisy',
      'breed': 'Holstein Friesian',
      'age': '3 Yrs',
      'milkYield': '21.5 L/day',
      'status': 'Milking',
      'health': 'Observation',
      'photo': 'assets/images/holstein_friesian.png'
    },
    {
      'id': 'JRS-301',
      'name': 'Lakshmi',
      'breed': 'Jersey Cow',
      'age': '4.5 Yrs',
      'milkYield': '18.0 L/day',
      'status': 'Dry',
      'health': 'Healthy',
      'photo': 'assets/images/jersey_cow.png'
    },
    {
      'id': 'BUF-401',
      'name': 'Kali',
      'breed': 'Murrah Buffalo',
      'age': '6 Yrs',
      'milkYield': '12.5 L/day',
      'status': 'Milking',
      'health': 'Healthy',
      'photo': 'assets/images/murrah_buffalo.png'
    },
  ];

  final List<Map<String, dynamic>> _milkYieldLogs = [
    {'session': 'Morning', 'time': '06:00 AM', 'qty': 184.5, 'cows': 38, 'fat': '4.5%'},
    {'session': 'Evening', 'time': '05:30 PM', 'qty': 127.5, 'cows': 38, 'fat': '4.6%'},
    {'session': 'Yesterday Morning', 'time': '06:00 AM', 'qty': 180.0, 'cows': 37, 'fat': '4.4%'},
    {'session': 'Yesterday Evening', 'time': '05:30 PM', 'qty': 125.0, 'cows': 37, 'fat': '4.5%'},
  ];

  final List<Map<String, dynamic>> _feedStockList = [
    {'name': 'Green Fodder (Napier Grass)', 'qty': '1,200 kg', 'status': 'High Stock', 'color': Colors.green},
    {'name': 'Dry Straw & Hay', 'qty': '850 kg', 'status': 'Good Stock', 'color': Colors.blue},
    {'name': 'Concentrate Feed Mix (Protein)', 'qty': '420 kg', 'status': 'Medium Stock', 'color': Colors.orange},
    {'name': 'Mineral Mixture & Calcium', 'qty': '65 kg', 'status': 'Low Stock Alert', 'color': Colors.red},
  ];

  final List<Map<String, dynamic>> _staffList = [
    {
      'name': 'Rahul Sharma',
      'role': 'Farm Owner & Admin',
      'phone': '+91 98765 43210',
      'shift': 'Full Authority',
      'status': 'Active',
      'avatar': 'RS'
    },
    {
      'name': 'Dr. Suresh Meht',
      'role': 'Chief Veterinarian',
      'phone': '+91 98123 45678',
      'shift': 'On-Call / Daily Visit',
      'status': 'Active',
      'avatar': 'SM'
    },
    {
      'name': 'Vikram Singh',
      'role': 'Feed & Stock Manager',
      'phone': '+91 97654 32109',
      'shift': 'Morning Shift (6AM - 2PM)',
      'status': 'Active',
      'avatar': 'VS'
    },
    {
      'name': 'Anil Kumar',
      'role': 'Milking Supervisor',
      'phone': '+91 96543 21098',
      'shift': 'Double Shift (5AM & 5PM)',
      'status': 'Active',
      'avatar': 'AK'
    },
    {
      'name': 'Pooja Verma',
      'role': 'Quality Control & Lab',
      'phone': '+91 95432 10987',
      'shift': 'Day Shift (9AM - 5PM)',
      'status': 'Active',
      'avatar': 'PV'
    },
  ];

  final List<Map<String, dynamic>> _productList = [
    {
      'name': 'Raw Organic Whole Milk',
      'price': 65,
      'unit': 'Litre',
      'stock': '340 L available',
      'status': 'In Stock',
      'icon': Icons.water_drop
    },
    {
      'name': 'A2 Gir Cow Milk (Glass Bottle)',
      'price': 90,
      'unit': 'Litre',
      'stock': '120 L available',
      'status': 'In Stock',
      'icon': Icons.local_drink
    },
    {
      'name': 'Pure Desi Bilona Ghee',
      'price': 1450,
      'unit': 'Kg',
      'stock': '45 Kg in store',
      'status': 'In Stock',
      'icon': Icons.soup_kitchen
    },
    {
      'name': 'Fresh Malai Paneer',
      'price': 420,
      'unit': 'Kg',
      'stock': '25 Kg available',
      'status': 'In Stock',
      'icon': Icons.grid_view
    },
    {
      'name': 'Cultured Fresh Dahi (Curd)',
      'price': 80,
      'unit': 'Kg',
      'stock': '60 Kg available',
      'status': 'In Stock',
      'icon': Icons.rice_bowl
    },
  ];

  bool _apiLoading = false;

  // ── Farms state (Tab 6) ────────────────────────────────────────────────────
  List<Map<String, dynamic>> _farmsList = [];
  bool _farmsLoading = false;

  final List<Map<String, dynamic>> _auditLogs = [
    {
      'time': 'Just now',
      'user': 'Admin (Rahul)',
      'action': 'System check & cloud database backup completed',
      'type': 'system'
    },
    {
      'time': '12 mins ago',
      'user': 'Dr. Suresh Mehta',
      'action': 'Updated health observation for Daisy (Tag HF-202)',
      'type': 'health'
    },
    {
      'time': '45 mins ago',
      'user': 'Anil Kumar',
      'action': 'Recorded Morning Milk Collection: 184.5 Litres',
      'type': 'yield'
    },
    {
      'time': '2 hours ago',
      'user': 'Vikram Singh',
      'action': 'Received 500kg Green Fodder shipment',
      'type': 'feed'
    },
    {
      'time': '5 hours ago',
      'user': 'Admin (Rahul)',
      'action': 'Adjusted retail price for A2 Gir Cow Milk to â‚¹90/L',
      'type': 'price'
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTabIndex;
    _tabController = TabController(
      length: 7,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _loadFromApi();
    _loadFarms();
  }

  Future<void> _loadFarms() async {
    setState(() => _farmsLoading = true);
    try {
      final farms = await apiService.getFarms();
      if (mounted) {
        setState(() {
          _farmsList = farms
              .map((f) => {
                    'id': f.id,
                    'name': f.name,
                    'owner_name': f.ownerName,
                    'phone': f.phone ?? '',
                    'email': f.email ?? '',
                    'city': f.city ?? '',
                    'state': f.state ?? '',
                    'address': f.address ?? '',
                    'pincode': f.pincode ?? '',
                    'description': f.description ?? '',
                    'status': f.status,
                  })
              .toList();
        });
      }
    } catch (_) {
      // Retain empty list if API fails
    } finally {
      if (mounted) setState(() => _farmsLoading = false);
    }
  }

  Future<void> _loadFromApi() async {
    setState(() => _apiLoading = true);
    try {
      final animals = await apiService.getAnimals();
      if (animals.isNotEmpty) {
        setState(() {
          _cattleList.clear();
          for (final a in animals) {
            _cattleList.add({
              'id': a.tagNumber,
              'name': a.displayName,
              'breed': a.breedDisplay,
              'age': _calcAge(a.dateOfBirth),
              'milkYield': '15.0 L/day',
              'status': a.status.toLowerCase() == 'active' ? 'Milking' : 'Dry',
              'health': 'Healthy',
              'photo': 'assets/images/gir_cow.png',
            });
          }
        });
      }
    } catch (_) {
      // Retain fallback mock list if API fails
    } finally {
      if (mounted) setState(() => _apiLoading = false);
    }
  }

  String _calcAge(String? dob) {
    if (dob == null) return '3 Yrs';
    try {
      final birth = DateTime.parse(dob);
      final years = (DateTime.now().difference(birth).inDays / 365).floor();
      return years > 0 ? '$years Yrs' : '<1 Yr';
    } catch (_) {
      return '3 Yrs';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBg,
      drawer: AdminDrawer(
        currentTabIndex: _selectedTabIndex,
        onSelectTab: (index) {
          _tabController.animateTo(index);
        },
      ),
      appBar: AppBar(
        backgroundColor: _primaryGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: _accentGreen, width: 1.5),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/krishna_logo.png',
                  height: 24,
                  width: 24,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Control Center',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Full Management Privileges Active',
                  style: TextStyle(
                    color: Color(0xFF86EFAC),
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Farm Emergency Broadcast',
            icon: const Icon(Icons.campaign_outlined, color: Colors.white),
            onPressed: () => _showBroadcastDialog(),
          ),
          IconButton(
            tooltip: 'Cloud Database Backup',
            icon: const Icon(Icons.cloud_upload_outlined, color: Colors.white),
            onPressed: () => _simulateBackup(),
          ),
          const SizedBox(width: 6),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: _accentGreen,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard_outlined, size: 17)),
            Tab(text: 'Herd Cattle', icon: CowHeadIcon(size: 17, color: Colors.white)),
            Tab(text: 'Milk Production', icon: Icon(Icons.water_drop_outlined, size: 17)),
            Tab(text: 'Feed Stock', icon: Icon(Icons.grass_outlined, size: 17)),
            Tab(text: 'Prices & Products', icon: Icon(Icons.sell_outlined, size: 17)),
            Tab(text: 'Staff & Audit', icon: Icon(Icons.people_outline, size: 17)),
            Tab(text: 'Farms', icon: Icon(Icons.store_outlined, size: 17)),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_apiLoading)
            const LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(_accentGreen),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildHerdTab(),
                _buildMilkTab(),
                _buildFeedTab(),
                _buildPricingTab(),
                _buildStaffAndAuditTab(),
                _buildFarmsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildContextualFAB(),
    );
  }

  Widget? _buildContextualFAB() {
    switch (_selectedTabIndex) {
      case 1:
        return FloatingActionButton.extended(
          backgroundColor: _primaryGreen,
          onPressed: () => _showAddCattleDialog(),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Add Cattle', style: TextStyle(color: Colors.white)),
        );
      case 2:
        return FloatingActionButton.extended(
          backgroundColor: _primaryGreen,
          onPressed: () => _showAddMilkLogDialog(),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Record Milk Log', style: TextStyle(color: Colors.white)),
        );
      case 3:
        return FloatingActionButton.extended(
          backgroundColor: _primaryGreen,
          onPressed: () => _showAddFeedStockDialog(),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Add Feed Stock', style: TextStyle(color: Colors.white)),
        );
      case 4:
        return FloatingActionButton.extended(
          backgroundColor: _primaryGreen,
          onPressed: () => _showAddProductDialog(),
          icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
          label: const Text('Add Product', style: TextStyle(color: Colors.white)),
        );
      case 5:
        return FloatingActionButton.extended(
          backgroundColor: _primaryGreen,
          onPressed: () => _showAddStaffDialog(),
          icon: const Icon(Icons.person_add, color: Colors.white),
          label: const Text('Add Staff Member', style: TextStyle(color: Colors.white)),
        );
      case 6:
        return FloatingActionButton.extended(
          backgroundColor: _primaryGreen,
          onPressed: () => _showFarmFormDialog(),
          icon: const Icon(Icons.add_business, color: Colors.white),
          label: const Text('Add Farm', style: TextStyle(color: Colors.white)),
        );
      default:
        return null;
    }
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // TAB 1: OVERVIEW & EXECUTIVE DASHBOARD
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // â”€â”€ Admin Hero Banner â”€â”€
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0C3823), Color(0xFF14532D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: _accentGreen.withValues(alpha: 0.2),
                  child: const Text('ðŸ‘‘', style: TextStyle(fontSize: 26)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Executive Command Center',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Full Control Active â€¢ ${globalUserSession.roleName}',
                        style: const TextStyle(color: Color(0xFF86EFAC), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.circle, color: Color(0xFF4ADE80), size: 10),
                      SizedBox(width: 6),
                      Text('Live', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // â”€â”€ Executive KPI Grid â”€â”€
          const Text(
            'FARM KEY PERFORMANCE METRICS',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: _textMuted, letterSpacing: 1.1),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.35,
            children: [
              _buildKPICard(
                title: 'Total Herd Count',
                value: '${_cattleList.length} Animals',
                subtitle: '${_cattleList.where((e) => e['status'] == 'Milking').length} Milking â€¢ ${_cattleList.where((e) => e['status'] == 'Dry').length} Dry',
                icon: Icons.pets,
                customIconWidget: const CowHeadIcon(size: 16, color: Color(0xFF16A34A)),
                iconBg: const Color(0xFFDCFCE7),
                iconColor: const Color(0xFF16A34A),
              ),
              _buildKPICard(
                title: 'Daily Milk Production',
                value: '312.0 Litres',
                subtitle: 'â†‘ 4.2% yield increase',
                icon: Icons.water_drop,
                iconBg: const Color(0xFFE0F2FE),
                iconColor: const Color(0xFF0284C7),
              ),
              _buildKPICard(
                title: 'Monthly Revenue',
                value: 'â‚¹3,45,800',
                subtitle: 'Milk & Dairy Products',
                icon: Icons.currency_rupee,
                iconBg: const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFD97706),
              ),
              _buildKPICard(
                title: 'Feed Inventory',
                value: '84% Stocked',
                subtitle: '12 Days Fodder Reserve',
                icon: Icons.grass,
                iconBg: const Color(0xFFF3E8FF),
                iconColor: const Color(0xFF7C3AED),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // â”€â”€ Quick Action Bar â”€â”€
          const Text(
            'QUICK ADMINISTRATIVE CONTROLS',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: _textMuted, letterSpacing: 1.1),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  icon: Icons.add_circle_outline,
                  label: 'Add Cattle',
                  color: const Color(0xFF0C3823),
                  onTap: () {
                    _tabController.animateTo(1);
                    _showAddCattleDialog();
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildQuickActionButton(
                  icon: Icons.post_add,
                  label: 'Log Yield',
                  color: const Color(0xFF0284C7),
                  onTap: () {
                    _tabController.animateTo(2);
                    _showAddMilkLogDialog();
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildQuickActionButton(
                  icon: Icons.price_change,
                  label: 'Adjust Rates',
                  color: const Color(0xFFD97706),
                  onTap: () => _tabController.animateTo(4),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // â”€â”€ Live Audit Log Snapshot â”€â”€
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'LIVE SYSTEM AUDIT STREAM',
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: _textMuted, letterSpacing: 1.1),
              ),
              TextButton(
                onPressed: () => _tabController.animateTo(5),
                child: const Text('View All Logs', style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _auditLogs.length > 3 ? 3 : _auditLogs.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final log = _auditLogs[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFEFF6F1),
                    child: Icon(_getLogIcon(log['type']), size: 16, color: _primaryGreen),
                  ),
                  title: Text(log['action'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark)),
                  subtitle: Text('By ${log['user']} â€¢ ${log['time']}', style: const TextStyle(fontSize: 11, color: _textMuted)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    Widget? customIconWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _textMuted), overflow: TextOverflow.ellipsis),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
                child: customIconWidget ?? Icon(icon, size: 16, color: iconColor),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: _textDark)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 10.5, color: _accentGreen, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // TAB 2: HERD CATTLE CONTROL
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildHerdTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Tag ID or Name...',
                    prefixIcon: const Icon(Icons.search, size: 20, color: _textMuted),
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _cattleList.length,
            itemBuilder: (context, index) {
              final item = _cattleList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE5E7EB))),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item['photo'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 60,
                            height: 60,
                            color: const Color(0xFFD1FAE5),
                            child: const Center(child: CowHeadIcon(size: 26, color: _primaryGreen)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFFEFF6F1), borderRadius: BorderRadius.circular(4)),
                                  child: Text(item['id'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _primaryGreen)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('${item['breed']} â€¢ ${item['age']} â€¢ ${item['milkYield']}', style: const TextStyle(fontSize: 12, color: _textMuted)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                _buildBadge(item['status'], item['status'] == 'Milking' ? Colors.green : Colors.orange),
                                const SizedBox(width: 6),
                                _buildBadge(item['health'], item['health'] == 'Healthy' ? Colors.blue : Colors.red),
                              ],
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: _textMuted),
                        onSelected: (action) {
                          if (action == 'edit') {
                            _showEditCattleDialog(item);
                          } else if (action == 'delete') {
                            setState(() {
                              _cattleList.removeAt(index);
                              _auditLogs.insert(0, {
                                'time': 'Just now',
                                'user': 'Admin',
                                'action': 'Removed animal ${item['id']} from cattle inventory',
                                'type': 'system'
                              });
                            });
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18, color: Colors.blue), SizedBox(width: 8), Text('Edit Cattle Details')])),
                          const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 18, color: Colors.red), SizedBox(width: 8), Text('Remove Animal')])),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
    );
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // TAB 3: MILK PRODUCTION MANAGER
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildMilkTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0284C7).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF0284C7).withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.water_drop, color: Color(0xFF0284C7), size: 32),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Today Total Collection', style: TextStyle(fontSize: 12, color: _textMuted, fontWeight: FontWeight.w600)),
                    Text('312.0 Litres', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0284C7))),
                    Text('38 Cows Milked â€¢ Avg Fat 4.5%', style: TextStyle(fontSize: 11, color: Color(0xFF0369A1))),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddMilkLogDialog(),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7)),
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: const Text('Add Entry', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('COLLECTION SESSIONS LOG', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: _textMuted, letterSpacing: 1.1)),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _milkYieldLogs.length,
          itemBuilder: (context, index) {
            final log = _milkYieldLogs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE5E7EB))),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE0F2FE),
                  child: Icon(Icons.water_drop, color: Color(0xFF0284C7), size: 20),
                ),
                title: Text('${log['session']} (${log['time']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('${log['cows']} Animals â€¢ Fat Rate ${log['fat']}', style: const TextStyle(fontSize: 12, color: _textMuted)),
                trailing: Text('${log['qty']} L', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: _primaryGreen)),
              ),
            );
          },
        ),
      ],
    );
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // TAB 4: FEED & STOCK MANAGEMENT
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildFeedTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.grass, color: Color(0xFF7C3AED), size: 32),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Feed Stock Index', style: TextStyle(fontSize: 12, color: _textMuted, fontWeight: FontWeight.w600)),
                    Text('2,535 kg Total', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF7C3AED))),
                    Text('Sufficient for 12 days supply', style: TextStyle(fontSize: 11, color: Color(0xFF6D28D9))),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddFeedStockDialog(),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED)),
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: const Text('Add Stock', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('CURRENT FODDER INVENTORY', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: _textMuted, letterSpacing: 1.1)),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _feedStockList.length,
          itemBuilder: (context, index) {
            final feed = _feedStockList[index];
            final Color statusColor = feed['color'] as Color;
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE5E7EB))),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: statusColor.withValues(alpha: 0.15),
                  child: Icon(Icons.eco, color: statusColor, size: 20),
                ),
                title: Text(feed['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('Status: ${feed['status']}', style: TextStyle(fontSize: 11.5, color: statusColor, fontWeight: FontWeight.w600)),
                trailing: Text(feed['qty'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
              ),
            );
          },
        ),
      ],
    );
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // TAB 5: PRICING & PRODUCTS MANAGER
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildPricingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFCD34D)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFFD97706)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Prices set here apply immediately across the entire customer catalog and billing system.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF92400E), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _productList.length,
            itemBuilder: (context, index) {
              final prod = _productList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE5E7EB))),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFEFF6F1), borderRadius: BorderRadius.circular(10)),
                        child: Icon(prod['icon'], color: _primaryGreen, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(prod['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 2),
                            Text(prod['stock'], style: const TextStyle(fontSize: 11, color: _textMuted)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('â‚¹${prod['price']} / ${prod['unit']}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: _primaryGreen)),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () => _showEditPriceDialog(prod),
                            child: const Text('Edit Rate', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // TAB 6: STAFF & AUDIT STREAM
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildStaffAndAuditTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('STAFF ROSTER & PERMISSIONS', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: _textMuted, letterSpacing: 1.1)),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _staffList.length,
          itemBuilder: (context, index) {
            final staff = _staffList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE5E7EB))),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: _primaryGreen,
                      child: Text(staff['avatar'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(staff['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('${staff['role']} â€¢ ${staff['shift']}', style: const TextStyle(fontSize: 11.5, color: _primaryGreen, fontWeight: FontWeight.w600)),
                          Text(staff['phone'], style: const TextStyle(fontSize: 11, color: _textMuted)),
                        ],
                      ),
                    ),
                    Switch(
                      value: staff['status'] == 'Active',
                      activeThumbColor: _accentGreen,
                      onChanged: (val) {
                        setState(() {
                          staff['status'] = val ? 'Active' : 'Inactive';
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        const Text('SYSTEM AUDIT STREAM', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: _textMuted, letterSpacing: 1.1)),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _auditLogs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final log = _auditLogs[index];
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE5E7EB))),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFEFF6F1),
                  child: Icon(_getLogIcon(log['type']), color: _primaryGreen, size: 18),
                ),
                title: Text(log['action'], style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                subtitle: Text('User: ${log['user']} â€¢ ${log['time']}', style: const TextStyle(fontSize: 11, color: _textMuted)),
              ),
            );
          },
        ),
      ],
    );
  }

  IconData _getLogIcon(String type) {
    switch (type) {
      case 'health':
        return Icons.medical_services_outlined;
      case 'yield':
        return Icons.water_drop_outlined;
      case 'feed':
        return Icons.grass_outlined;
      case 'price':
        return Icons.attach_money;
      case 'system':
      default:
        return Icons.security_outlined;
    }
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // INTERACTIVE MANAGEMENT DIALOGS
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _showAddCattleDialog() {
    final nameCtrl = TextEditingController();
    final breedCtrl = TextEditingController(text: 'Gir Cow');
    final yieldCtrl = TextEditingController(text: '16.0 L/day');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [CowHeadIcon(size: 20, color: _primaryGreen), SizedBox(width: 8), Text('Register New Livestock')]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Cattle Name / Identifier')),
            const SizedBox(height: 8),
            TextField(controller: breedCtrl, decoration: const InputDecoration(labelText: 'Breed (Gir, HF, Jersey, Murrah)')),
            const SizedBox(height: 8),
            TextField(controller: yieldCtrl, decoration: const InputDecoration(labelText: 'Expected Daily Yield (e.g., 16 L/day)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primaryGreen),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                final newId = 'COW-${100 + _cattleList.length + 1}';
                setState(() {
                  _cattleList.insert(0, {
                    'id': newId,
                    'name': nameCtrl.text,
                    'breed': breedCtrl.text,
                    'age': '2 Yrs',
                    'milkYield': yieldCtrl.text,
                    'status': 'Milking',
                    'health': 'Healthy',
                    'photo': 'assets/images/gir_cow.png'
                  });
                  _auditLogs.insert(0, {'time': 'Just now', 'user': 'Admin', 'action': 'Registered new animal ${nameCtrl.text} ($newId)', 'type': 'system'});
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save Cattle', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditCattleDialog(Map<String, dynamic> item) {
    final nameCtrl = TextEditingController(text: item['name']);
    final yieldCtrl = TextEditingController(text: item['milkYield']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit ${item['id']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 8),
            TextField(controller: yieldCtrl, decoration: const InputDecoration(labelText: 'Daily Yield')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primaryGreen),
            onPressed: () {
              setState(() {
                item['name'] = nameCtrl.text;
                item['milkYield'] = yieldCtrl.text;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddMilkLogDialog() {
    final qtyCtrl = TextEditingController(text: '150.0');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [Icon(Icons.water_drop, color: Color(0xFF0284C7)), SizedBox(width: 8), Text('Record Milk Collection')]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: qtyCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Milk Quantity Collected (Litres)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7)),
            onPressed: () {
              final qty = double.tryParse(qtyCtrl.text) ?? 100.0;
              setState(() {
                _milkYieldLogs.insert(0, {
                  'session': 'Manual Collection Log',
                  'time': 'Just now',
                  'qty': qty,
                  'cows': 38,
                  'fat': '4.5%',
                });
                _auditLogs.insert(0, {'time': 'Just now', 'user': 'Admin', 'action': 'Logged milk collection of $qty Litres', 'type': 'yield'});
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save Entry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddFeedStockDialog() {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [Icon(Icons.grass, color: Color(0xFF7C3AED)), SizedBox(width: 8), Text('Add Feed Stock')]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Fodder / Feed Name')),
            const SizedBox(height: 8),
            TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: 'Quantity (e.g. 500 kg)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED)),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                setState(() {
                  _feedStockList.insert(0, {
                    'name': nameCtrl.text,
                    'qty': qtyCtrl.text.isEmpty ? '300 kg' : qtyCtrl.text,
                    'status': 'Good Stock',
                    'color': Colors.green,
                  });
                  _auditLogs.insert(0, {'time': 'Just now', 'user': 'Admin', 'action': 'Added ${qtyCtrl.text} of ${nameCtrl.text} feed stock', 'type': 'feed'});
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save Feed', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final unitCtrl = TextEditingController(text: 'Kg');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [Icon(Icons.add_shopping_cart, color: _primaryGreen), SizedBox(width: 8), Text('Add Farm Product')]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Product Name')),
            const SizedBox(height: 8),
            TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price (â‚¹)')),
            const SizedBox(height: 8),
            TextField(controller: unitCtrl, decoration: const InputDecoration(labelText: 'Unit (Litre / Kg / Packet)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primaryGreen),
            onPressed: () {
              final p = int.tryParse(priceCtrl.text) ?? 100;
              if (nameCtrl.text.isNotEmpty) {
                setState(() {
                  _productList.add({
                    'name': nameCtrl.text,
                    'price': p,
                    'unit': unitCtrl.text,
                    'stock': '50 Units in store',
                    'status': 'In Stock',
                    'icon': Icons.inventory_2
                  });
                  _auditLogs.insert(0, {'time': 'Just now', 'user': 'Admin', 'action': 'Added new product ${nameCtrl.text} at â‚¹$p/${unitCtrl.text}', 'type': 'price'});
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add Product', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditPriceDialog(Map<String, dynamic> prod) {
    final priceCtrl = TextEditingController(text: prod['price'].toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Adjust Rate: ${prod['name']}'),
        content: TextField(
          controller: priceCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'New Price per ${prod['unit']} (â‚¹)', prefixText: 'â‚¹ '),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primaryGreen),
            onPressed: () {
              final newPrice = int.tryParse(priceCtrl.text);
              if (newPrice != null) {
                setState(() {
                  prod['price'] = newPrice;
                  _auditLogs.insert(0, {'time': 'Just now', 'user': 'Admin', 'action': 'Changed rate of ${prod['name']} to â‚¹$newPrice/${prod['unit']}', 'type': 'price'});
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save Rate', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddStaffDialog() {
    final nameCtrl = TextEditingController();
    final roleCtrl = TextEditingController(text: 'Farm Worker');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [Icon(Icons.person_add, color: _primaryGreen), SizedBox(width: 8), Text('Add Staff Member')]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
            const SizedBox(height: 8),
            TextField(controller: roleCtrl, decoration: const InputDecoration(labelText: 'Role (Vet, Supervisor, Worker)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primaryGreen),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                final initials = nameCtrl.text.trim().split(' ').map((e) => e[0]).take(2).join();
                setState(() {
                  _staffList.add({
                    'name': nameCtrl.text,
                    'role': roleCtrl.text,
                    'phone': '+91 99000 00000',
                    'shift': 'General Shift',
                    'status': 'Active',
                    'avatar': initials.toUpperCase()
                  });
                  _auditLogs.insert(0, {'time': 'Just now', 'user': 'Admin', 'action': 'Registered staff ${nameCtrl.text} (${roleCtrl.text})', 'type': 'system'});
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add Member', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // TAB 7: FARMS MANAGEMENT
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildFarmsTab() {
    return Column(
      children: [
        if (_farmsLoading)
          const LinearProgressIndicator(
            minHeight: 2,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(_accentGreen),
          ),
        Expanded(
          child: _farmsList.isEmpty && !_farmsLoading
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.store_outlined,
                          size: 60, color: _textMuted.withValues(alpha: 0.4)),
                      const SizedBox(height: 12),
                      const Text(
                        'No farms found',
                        style: TextStyle(
                            fontSize: 16,
                            color: _textMuted,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tap the + button to add your first farm',
                        style:
                            TextStyle(fontSize: 13, color: _textMuted.withValues(alpha: 0.7)),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: _primaryGreen,
                  onRefresh: _loadFarms,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    itemCount: _farmsList.length,
                    itemBuilder: (context, index) {
                      final farm = _farmsList[index];
                      return _buildFarmCard(farm, index);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFarmCard(Map<String, dynamic> farm, int index) {
    final bool isActive = farm['status'] == true || farm['status'] == 1;
    final String city = farm['city']?.toString() ?? '';
    final String state = farm['state']?.toString() ?? '';
    final String location =
        [city, state].where((s) => s.isNotEmpty).join(', ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.store_outlined,
                    size: 22,
                    color: isActive
                        ? const Color(0xFF16A34A)
                        : _textMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farm['name']?.toString() ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Owner: ${farm['owner_name'] ?? ''}',
                        style: const TextStyle(
                            fontSize: 12.5, color: _textMuted),
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? const Color(0xFF16A34A)
                          : const Color(0xFFDC2626),
                    ),
                  ),
                ),
              ],
            ),
            // ── Details ──
            if (location.isNotEmpty || (farm['phone']?.toString() ?? '').isNotEmpty) ...
              [
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 16,
                  runSpacing: 6,
                  children: [
                    if (location.isNotEmpty)
                      _farmInfoChip(
                          Icons.location_on_outlined, location),
                    if ((farm['phone']?.toString() ?? '').isNotEmpty)
                      _farmInfoChip(
                          Icons.phone_outlined, farm['phone'].toString()),
                    if ((farm['email']?.toString() ?? '').isNotEmpty)
                      _farmInfoChip(
                          Icons.email_outlined, farm['email'].toString()),
                  ],
                ),
              ],
            if ((farm['description']?.toString() ?? '').isNotEmpty) ...
              [
                const SizedBox(height: 8),
                Text(
                  farm['description'].toString(),
                  style: const TextStyle(
                      fontSize: 12.5, color: _textMuted, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            const SizedBox(height: 12),
            // ── Action buttons ──
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showFarmFormDialog(
                        farmData: farm, index: index),
                    icon: const Icon(Icons.edit_outlined, size: 15),
                    label: const Text('Edit',
                        style: TextStyle(fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primaryGreen,
                      side: const BorderSide(color: _primaryGreen),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding:
                          const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _confirmDeleteFarm(farm, index),
                    icon: const Icon(Icons.delete_outline, size: 15),
                    label: const Text('Delete',
                        style: TextStyle(fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(
                          color: Color(0xFFDC2626)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding:
                          const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _farmInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: _textMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: _textMuted),
        ),
      ],
    );
  }

  // ── Add / Edit Farm Dialog ─────────────────────────────────────────────────
  void _showFarmFormDialog({
    Map<String, dynamic>? farmData,
    int? index,
  }) {
    final isEdit = farmData != null;
    final nameCtrl =
        TextEditingController(text: farmData?['name']?.toString() ?? '');
    final ownerCtrl =
        TextEditingController(text: farmData?['owner_name']?.toString() ?? '');
    final phoneCtrl =
        TextEditingController(text: farmData?['phone']?.toString() ?? '');
    final emailCtrl =
        TextEditingController(text: farmData?['email']?.toString() ?? '');
    final cityCtrl =
        TextEditingController(text: farmData?['city']?.toString() ?? '');
    final stateCtrl =
        TextEditingController(text: farmData?['state']?.toString() ?? '');
    final addressCtrl =
        TextEditingController(text: farmData?['address']?.toString() ?? '');
    final pincodeCtrl =
        TextEditingController(text: farmData?['pincode']?.toString() ?? '');
    final descCtrl =
        TextEditingController(text: farmData?['description']?.toString() ?? '');
    bool isActive =
        farmData?['status'] == true || farmData?['status'] == 1;
    bool saving = false;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, scrollCtrl) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // ── Handle ──
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 4),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // ── Title ──
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.store_outlined,
                            color: _primaryGreen, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isEdit ? 'Edit Farm' : 'Add New Farm',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: _textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // ── Form ──
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollCtrl,
                    padding: EdgeInsets.fromLTRB(
                      20,
                      16,
                      20,
                      MediaQuery.of(ctx).viewInsets.bottom + 20,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _farmField(
                            'Farm Name *',
                            nameCtrl,
                            Icons.store_outlined,
                            'e.g. Krishna Dairy Farm',
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Farm name is required'
                                : null,
                          ),
                          _farmField(
                            'Owner Name *',
                            ownerCtrl,
                            Icons.person_outline,
                            'e.g. Rahul Sharma',
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Owner name is required'
                                : null,
                          ),
                          _farmField(
                            'Phone',
                            phoneCtrl,
                            Icons.phone_outlined,
                            '+91 98765 43210',
                            keyboardType: TextInputType.phone,
                          ),
                          _farmField(
                            'Email',
                            emailCtrl,
                            Icons.email_outlined,
                            'farm@example.com',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          _farmField(
                            'Address',
                            addressCtrl,
                            Icons.home_outlined,
                            'Street address',
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: _farmField(
                                'City',
                                cityCtrl,
                                Icons.location_city_outlined,
                                'Pune',
                              )),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: _farmField(
                                'State',
                                stateCtrl,
                                Icons.map_outlined,
                                'Maharashtra',
                              )),
                            ],
                          ),
                          _farmField(
                            'Pincode',
                            pincodeCtrl,
                            Icons.pin_outlined,
                            '411001',
                            keyboardType: TextInputType.number,
                          ),
                          _farmField(
                            'Description',
                            descCtrl,
                            Icons.notes_outlined,
                            'Brief about this farm...',
                            maxLines: 3,
                          ),
                          // ── Status toggle ──
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Farm Status',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: _textDark,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    isActive ? 'Active' : 'Inactive',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isActive
                                          ? const Color(0xFF16A34A)
                                          : _textMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Switch(
                                    value: isActive,
                                    onChanged: (v) =>
                                        setSheet(() => isActive = v),
                                    activeThumbColor: _primaryGreen,
                                    activeTrackColor:
                                        const Color(0xFF86EFAC),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // ── Save button ──
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: saving
                                  ? null
                                  : () async {
                                      if (!formKey.currentState!
                                          .validate()) {
                                        return;
                                      }
                                      setSheet(() => saving = true);
                                      final payload = {
                                        'name': nameCtrl.text.trim(),
                                        'owner_name':
                                            ownerCtrl.text.trim(),
                                        'phone': phoneCtrl.text.trim(),
                                        'email': emailCtrl.text.trim(),
                                        'address':
                                            addressCtrl.text.trim(),
                                        'city': cityCtrl.text.trim(),
                                        'state': stateCtrl.text.trim(),
                                        'pincode':
                                            pincodeCtrl.text.trim(),
                                        'description':
                                            descCtrl.text.trim(),
                                        'status': isActive ? 1 : 0,
                                      };
                                      try {
                                        if (isEdit) {
                                          final updated =
                                              await apiService.updateFarm(
                                            farmData['id'] as int,
                                            payload,
                                          );
                                          if (mounted && index != null) {
                                            setState(() {
                                              _farmsList[index] = {
                                                'id': updated.id,
                                                'name': updated.name,
                                                'owner_name':
                                                    updated.ownerName,
                                                'phone': updated.phone ?? '',
                                                'email': updated.email ?? '',
                                                'city': updated.city ?? '',
                                                'state': updated.state ?? '',
                                                'address':
                                                    updated.address ?? '',
                                                'pincode':
                                                    updated.pincode ?? '',
                                                'description':
                                                    updated.description ?? '',
                                                'status': updated.status,
                                              };
                                            });
                                          }
                                        } else {
                                          final created =
                                              await apiService.createFarm(
                                                  payload);
                                          if (mounted) {
                                            setState(() {
                                              _farmsList.add({
                                                'id': created.id,
                                                'name': created.name,
                                                'owner_name':
                                                    created.ownerName,
                                                'phone': created.phone ?? '',
                                                'email': created.email ?? '',
                                                'city': created.city ?? '',
                                                'state': created.state ?? '',
                                                'address':
                                                    created.address ?? '',
                                                'pincode':
                                                    created.pincode ?? '',
                                                'description':
                                                    created.description ?? '',
                                                'status': created.status,
                                              });
                                            });
                                          }
                                        }
                                        if (ctx.mounted) Navigator.pop(ctx);
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            backgroundColor: _primaryGreen,
                                            content: Text(isEdit
                                                ? '✅ Farm updated successfully!'
                                                : '✅ Farm added successfully!'),
                                          ));
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                              '❌ ${e.toString().replaceAll('Exception:', '').trim()}',
                                            ),
                                          ));
                                        }
                                      } finally {
                                        if (ctx.mounted) {
                                          setSheet(() => saving = false);
                                        }
                                      }
                                    },
                              icon: saving
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2),
                                    )
                                  : const Icon(Icons.save_outlined,
                                      color: Colors.white, size: 18),
                              label: Text(
                                saving
                                    ? 'Saving...'
                                    : isEdit
                                        ? 'Update Farm'
                                        : 'Add Farm',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryGreen,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Farm form field helper ─────────────────────────────────────────────────
  Widget _farmField(
    String label,
    TextEditingController ctrl,
    IconData icon,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: ctrl,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
              prefixIcon: Icon(icon, size: 18, color: _textMuted),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: _primaryGreen, width: 1.5),
              ),
              errorStyle: const TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // ── Delete confirmation ────────────────────────────────────────────────────
  void _confirmDeleteFarm(Map<String, dynamic> farm, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Farm',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
            'Are you sure you want to delete "${farm['name']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: _textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await apiService.deleteFarm(farm['id'] as int);
                if (mounted) {
                  setState(() => _farmsList.removeAt(index));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Color(0xFFDC2626),
                      content: Text('Farm deleted successfully.'),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        '❌ ${e.toString().replaceAll('Exception:', '').trim()}',
                      ),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showBroadcastDialog() {
    final msgCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [Icon(Icons.campaign, color: Colors.orange), SizedBox(width: 8), Text('Emergency Announcement')]),
        content: TextField(
          controller: msgCtrl,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Enter announcement for all staff members & app users...', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Broadcast alert sent to all staff devices!')));
            },
            child: const Text('Broadcast Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _simulateBackup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cloud backup completed successfully!')));
        });
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(color: _primaryGreen),
              SizedBox(width: 20),
              Text('Syncing & backing up database...'),
            ],
          ),
        );
      },
    );
  }
}

