import 'package:flutter/material.dart';

import '../services/master_auth_service.dart';
import 'master_login_screen.dart';

class MasterDashboardScreen extends StatelessWidget {
  const MasterDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _WaterBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 800;
                return Row(
                  children: [
                    if (!compact) const _MasterSidebar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(compact ? 16 : 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (compact)
                                  Builder(
                                    builder: (context) => IconButton(
                                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Use the desktop layout for the full navigation menu.')),
                                      ),
                                      icon: const Icon(Icons.menu_rounded),
                                    ),
                                  ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Master Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                                      SizedBox(height: 4),
                                      Text('ARank India • Global Control Center', style: TextStyle(color: Color(0xFF5F7180))),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Sign out',
                                  onPressed: () async {
                                    await MasterAuthService().signOut();
                                    if (!context.mounted) return;
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (_) => const MasterLoginScreen()),
                                      (_) => false,
                                    );
                                  },
                                  icon: const Icon(Icons.logout_rounded),
                                ),
                              ],
                            ),
                            const SizedBox(height: 26),
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: const [
                                _StatCard(label: 'Total Admins', icon: Icons.admin_panel_settings_rounded),
                                _StatCard(label: 'Total Institutes', icon: Icons.school_rounded),
                                _StatCard(label: 'Total Students', icon: Icons.groups_rounded),
                                _StatCard(label: 'Active Admins', icon: Icons.verified_user_rounded),
                              ],
                            ),
                            const SizedBox(height: 32),
                            const Text('Management', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: const [
                                _ActionCard(title: 'Admin Management', icon: Icons.manage_accounts_rounded),
                                _ActionCard(title: 'Institute Management', icon: Icons.account_balance_rounded),
                                _ActionCard(title: 'Student Management', icon: Icons.school_outlined),
                                _ActionCard(title: 'Service Management', icon: Icons.tune_rounded),
                                _ActionCard(title: 'Audit Logs', icon: Icons.fact_check_outlined),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MasterSidebar extends StatelessWidget {
  const _MasterSidebar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .88),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white),
        boxShadow: const [BoxShadow(blurRadius: 24, color: Color(0x220B6FA4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.network(
              'https://raw.githubusercontent.com/thegkexpert662-afk/arank-india/main/assets/images/logos/logo.png',
              width: 74,
              height: 74,
              errorBuilder: (_, __, ___) => const Icon(Icons.school_rounded, size: 58, color: Color(0xFF1677D2)),
            ),
          ),
          const SizedBox(height: 10),
          const Center(child: Text('ARank India', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
          const Center(child: Text('MASTER ADMIN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: Color(0xFF1677D2)))),
          const SizedBox(height: 28),
          const _NavItem(icon: Icons.dashboard_rounded, title: 'Dashboard', selected: true),
          const _NavItem(icon: Icons.manage_accounts_rounded, title: 'Admin Management'),
          const _NavItem(icon: Icons.account_balance_rounded, title: 'Institute Management'),
          const _NavItem(icon: Icons.groups_rounded, title: 'Student Management'),
          const _NavItem(icon: Icons.tune_rounded, title: 'Service Management'),
          const _NavItem(icon: Icons.fact_check_outlined, title: 'Audit Logs'),
          const Spacer(),
          const Text('MASTER → ADMIN → STUDENT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF607889))),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.title, this.selected = false});
  final IconData icon;
  final String title;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFDDF2FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(13),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: selected ? const Color(0xFF1677D2) : const Color(0xFF667B8B)),
        title: Text(title, style: TextStyle(fontWeight: selected ? FontWeight.w800 : FontWeight.w600)),
        onTap: () {},
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Card(
        elevation: 0,
        color: Colors.white.withValues(alpha: .92),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFE1F4FF), borderRadius: BorderRadius.circular(15)),
              child: Icon(icon, color: const Color(0xFF1677D2)),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF647789))),
              const SizedBox(height: 5),
              const Text('—', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            ])),
          ]),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 310,
      height: 92,
      child: Card(
        elevation: 0,
        color: Colors.white.withValues(alpha: .92),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(children: [
              Icon(icon, size: 28, color: const Color(0xFF1677D2)),
              const SizedBox(width: 15),
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800))),
              const Icon(Icons.arrow_forward_ios_rounded, size: 15),
            ]),
          ),
        ),
      ),
    );
  }
}

class _WaterBackground extends StatelessWidget {
  const _WaterBackground();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB8E9FF), Color(0xFFF0FBFF), Color(0xFF86D2F5)],
        ),
      ),
      child: CustomPaint(painter: _WavePainter(), size: Size.infinite),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: .16);
    for (var i = 0; i < 6; i++) {
      final y = size.height * (.08 + i * .18);
      final path = Path()..moveTo(-50, y);
      for (var x = -50.0; x < size.width + 50; x += 100) {
        path.quadraticBezierTo(x + 25, y - 22, x + 50, y);
        path.quadraticBezierTo(x + 75, y + 22, x + 100, y);
      }
      path.lineTo(size.width + 50, y + 75);
      path.lineTo(-50, y + 75);
      path.close();
      canvas.drawPath(path, paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
