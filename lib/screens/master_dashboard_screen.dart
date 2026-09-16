import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/master_auth_service.dart';
import '../services/master_data_service.dart';
import 'master_login_screen.dart';
import 'admin_management_screen.dart';
import 'institute_management_screen.dart';
import 'student_management_screen.dart';
import 'service_management_screen.dart';
import 'audit_logs_screen.dart';

class MasterDashboardScreen extends StatelessWidget {
  const MasterDashboardScreen({super.key});

  void _open(BuildContext context, Widget screen) => Navigator.push(context, MaterialPageRoute(builder: (_) => screen));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: SafeArea(child: _MasterMenu(onOpen: (screen) { Navigator.pop(context); _open(context, screen); }))),
      body: Stack(children: [
        const _WaterBackground(),
        SafeArea(child: LayoutBuilder(builder: (context, constraints) {
          final compact = constraints.maxWidth < 800;
          return Row(children: [
            if (!compact) _MasterSidebar(onOpen: (screen) => _open(context, screen)),
            Expanded(child: SingleChildScrollView(padding: EdgeInsets.all(compact ? 16 : 28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                if (compact) IconButton(onPressed: () => Scaffold.of(context).openDrawer(), icon: const Icon(Icons.menu_rounded)),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Master Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), SizedBox(height: 4), Text('ARank India • Global Control Center', style: TextStyle(color: Color(0xFF5F7180)))])),
                IconButton(tooltip: 'Sign out', onPressed: () async { await MasterAuthService().signOut(); if (!context.mounted) return; Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MasterLoginScreen()), (_) => false); }, icon: const Icon(Icons.logout_rounded)),
              ]),
              const SizedBox(height: 26),
              Wrap(spacing: 16, runSpacing: 16, children: [
                _StatCard(label: 'Total Admins', icon: Icons.admin_panel_settings_rounded, stream: MasterDataService.admins()),
                _StatCard(label: 'Total Institutes', icon: Icons.school_rounded, stream: MasterDataService.institutes()),
                _StatCard(label: 'Total Students', icon: Icons.groups_rounded, stream: MasterDataService.students()),
                _StatCard(label: 'Active Admins', icon: Icons.verified_user_rounded, stream: MasterDataService.admins(), activeOnly: true),
              ]),
              const SizedBox(height: 32),
              const Text('Management', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),
              Wrap(spacing: 16, runSpacing: 16, children: [
                _ActionCard(title: 'Admin Management', icon: Icons.manage_accounts_rounded, onTap: () => _open(context, const AdminManagementScreen())),
                _ActionCard(title: 'Institute Management', icon: Icons.account_balance_rounded, onTap: () => _open(context, const InstituteManagementScreen())),
                _ActionCard(title: 'Student Management', icon: Icons.school_outlined, onTap: () => _open(context, const StudentManagementScreen())),
                _ActionCard(title: 'Service Management', icon: Icons.tune_rounded, onTap: () => _open(context, const ServiceManagementScreen())),
                _ActionCard(title: 'Audit Logs', icon: Icons.fact_check_outlined, onTap: () => _open(context, const AuditLogsScreen())),
              ]),
            ])))
          ]);
        }))
      ]),
    );
  }
}

class _MasterMenu extends StatelessWidget {
  const _MasterMenu({required this.onOpen});
  final void Function(Widget) onOpen;
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(18), children: [
    const SizedBox(height: 14), Center(child: Image(image: NetworkImage('https://raw.githubusercontent.com/thegkexpert662-afk/arank-india/main/assets/images/logos/logo.png'), width: 70, height: 70)),
    const Center(child: Text('ARank India', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
    const Center(child: Text('MASTER ADMIN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: Color(0xFF1677D2)))),
    const SizedBox(height: 25),
    ListTile(leading: const Icon(Icons.dashboard_rounded), title: const Text('Dashboard'), onTap: () => Navigator.pop(context)),
    ListTile(leading: const Icon(Icons.manage_accounts_rounded), title: const Text('Admin Management'), onTap: () => onOpen(const AdminManagementScreen())),
    ListTile(leading: const Icon(Icons.account_balance_rounded), title: const Text('Institute Management'), onTap: () => onOpen(const InstituteManagementScreen())),
    ListTile(leading: const Icon(Icons.groups_rounded), title: const Text('Student Management'), onTap: () => onOpen(const StudentManagementScreen())),
    ListTile(leading: const Icon(Icons.tune_rounded), title: const Text('Service Management'), onTap: () => onOpen(const ServiceManagementScreen())),
    ListTile(leading: const Icon(Icons.fact_check_outlined), title: const Text('Audit Logs'), onTap: () => onOpen(const AuditLogsScreen())),
  ]);
}

class _MasterSidebar extends StatelessWidget {
  const _MasterSidebar({required this.onOpen});
  final void Function(Widget) onOpen;
  @override Widget build(BuildContext context) => Container(width: 250, margin: const EdgeInsets.all(18), padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .88), borderRadius: BorderRadius.circular(26), border: Border.all(color: Colors.white), boxShadow: const [BoxShadow(blurRadius: 24, color: Color(0x220B6FA4))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Center(child: Image.network('https://raw.githubusercontent.com/thegkexpert662-afk/arank-india/main/assets/images/logos/logo.png', width: 74, height: 74, errorBuilder: (_, __, ___) => const Icon(Icons.school_rounded, size: 58, color: Color(0xFF1677D2)))),
    const SizedBox(height: 10), const Center(child: Text('ARank India', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))), const Center(child: Text('MASTER ADMIN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: Color(0xFF1677D2)))), const SizedBox(height: 28),
    const _NavItem(icon: Icons.dashboard_rounded, title: 'Dashboard', selected: true),
    _NavItem(icon: Icons.manage_accounts_rounded, title: 'Admin Management', onTap: () => onOpen(const AdminManagementScreen())),
    _NavItem(icon: Icons.account_balance_rounded, title: 'Institute Management', onTap: () => onOpen(const InstituteManagementScreen())),
    _NavItem(icon: Icons.groups_rounded, title: 'Student Management', onTap: () => onOpen(const StudentManagementScreen())),
    _NavItem(icon: Icons.tune_rounded, title: 'Service Management', onTap: () => onOpen(const ServiceManagementScreen())),
    _NavItem(icon: Icons.fact_check_outlined, title: 'Audit Logs', onTap: () => onOpen(const AuditLogsScreen())),
    const Spacer(), const Text('MASTER → ADMIN → STUDENT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF607889))),
  ]);
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.title, this.selected = false, this.onTap}); final IconData icon; final String title; final bool selected; final VoidCallback? onTap;
  @override Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 6), decoration: BoxDecoration(color: selected ? const Color(0xFFDDF2FF) : Colors.transparent, borderRadius: BorderRadius.circular(13)), child: ListTile(dense: true, leading: Icon(icon, color: selected ? const Color(0xFF1677D2) : const Color(0xFF667B8B)), title: Text(title, style: TextStyle(fontWeight: selected ? FontWeight.w800 : FontWeight.w600)), onTap: onTap));
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.icon, required this.stream, this.activeOnly = false}); final String label; final IconData icon; final Stream<QuerySnapshot<Map<String, dynamic>>> stream; final bool activeOnly;
  @override Widget build(BuildContext context) => SizedBox(width: 250, child: Card(elevation: 0, color: Colors.white.withValues(alpha: .92), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), child: Padding(padding: const EdgeInsets.all(20), child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: stream, builder: (_, snap) { final docs = snap.data?.docs ?? []; final count = activeOnly ? docs.where((d) => d.data()['isActive'] == true).length : docs.length; return Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFE1F4FF), borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: const Color(0xFF1677D2))), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF647789))), const SizedBox(height: 5), Text(snap.hasError ? '!' : '$count', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900))])); }); })));
}

class _ActionCard extends StatelessWidget { const _ActionCard({required this.title, required this.icon, required this.onTap}); final String title; final IconData icon; final VoidCallback onTap; @override Widget build(BuildContext context) => SizedBox(width: 310, height: 92, child: Card(elevation: 0, color: Colors.white.withValues(alpha: .92), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), child: InkWell(borderRadius: BorderRadius.circular(20), onTap: onTap, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: Row(children: [Icon(icon, size: 28, color: const Color(0xFF1677D2)), const SizedBox(width: 15), Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800))), const Icon(Icons.arrow_forward_ios_rounded, size: 15)])))));
}

class _WaterBackground extends StatelessWidget { const _WaterBackground(); @override Widget build(BuildContext context) => Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFB8E9FF), Color(0xFFF0FBFF), Color(0xFF86D2F5)])), child: CustomPaint(painter: _WavePainter(), size: Size.infinite)); }
class _WavePainter extends CustomPainter { @override void paint(Canvas canvas, Size size) { final paint = Paint()..color = Colors.white.withValues(alpha: .16); for (var i = 0; i < 6; i++) { final y = size.height * (.08 + i * .18); final path = Path()..moveTo(-50, y); for (var x = -50.0; x < size.width + 50; x += 100) { path.quadraticBezierTo(x + 25, y - 22, x + 50, y); path.quadraticBezierTo(x + 75, y + 22, x + 100, y); } path.lineTo(size.width + 50, y + 75); path.lineTo(-50, y + 75); path.close(); canvas.drawPath(path, paint); } } @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false; }
