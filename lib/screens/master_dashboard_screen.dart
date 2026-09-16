import 'package:flutter/material.dart';

class MasterDashboardScreen extends StatelessWidget {
  const MasterDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Master Dashboard',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1100
              ? 4
              : constraints.maxWidth >= 700
                  ? 2
                  : 1;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ARank India Control Center',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                const Text(
                  'MASTER ADMIN  •  Global platform control',
                  style: TextStyle(color: Color(0xFF697386)),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    _StatCard(label: 'Total Admins', icon: Icons.admin_panel_settings_rounded),
                    _StatCard(label: 'Total Institutes', icon: Icons.school_rounded),
                    _StatCard(label: 'Total Students', icon: Icons.groups_rounded),
                    _StatCard(label: 'Active Admins', icon: Icons.verified_user_rounded),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Management',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                GridView.count(
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.6,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
          );
        },
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
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const SizedBox(width: 4),
            Icon(icon, size: 32, color: Color(0xFF3157D5)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
            const Text('—', style: TextStyle(fontSize: 22, color: Color(0xFF697386))),
          ],
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
    return Card(
      elevation: 0,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF3157D5)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 15),
            ],
          ),
        ),
      ),
    );
  }
}
