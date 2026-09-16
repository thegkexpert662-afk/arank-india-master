import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/master_data_service.dart';

class ServiceManagementScreen extends StatefulWidget {
  const ServiceManagementScreen({super.key});

  @override
  State<ServiceManagementScreen> createState() => _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen> {
  String? selectedAdminUid;

  static const services = <String, String>{
    'mockTests': 'Mock Tests',
    'liveTests': 'Live Tests',
    'questionBank': 'Question Bank',
    'videoSolutions': 'Video Solutions',
    'aiSolutions': 'AI Solutions',
    'currentAffairs': 'Current Affairs',
    'practice': 'Practice',
    'leaderboard': 'Leaderboard',
    'notifications': 'Notifications',
    'rewards': 'Rewards',
  };

  static const icons = <String, IconData>{
    'mockTests': Icons.assignment_rounded,
    'liveTests': Icons.timer_rounded,
    'questionBank': Icons.menu_book_rounded,
    'videoSolutions': Icons.play_circle_fill_rounded,
    'aiSolutions': Icons.auto_awesome_rounded,
    'currentAffairs': Icons.newspaper_rounded,
    'practice': Icons.edit_note_rounded,
    'leaderboard': Icons.leaderboard_rounded,
    'notifications': Icons.notifications_rounded,
    'rewards': Icons.workspace_premium_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _Water(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Service Management',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              'Control which services each Admin / Institute can use',
                              style: TextStyle(color: Color(0xff5F7180)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: MasterDataService.services(),
                      builder: (context, globalSnap) {
                        final global = globalSnap.data?.data() ?? {};
                        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: MasterDataService.admins(),
                          builder: (context, adminSnap) {
                            if (adminSnap.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (adminSnap.hasError) {
                              return Center(child: Text('Unable to load Admins: ${adminSnap.error}'));
                            }

                            final admins = adminSnap.data?.docs ?? [];
                            if (admins.isEmpty) {
                              return const _Empty(text: 'Create an Admin first from Admin Management.');
                            }

                            if (selectedAdminUid == null || !admins.any((d) => d.id == selectedAdminUid)) {
                              selectedAdminUid = admins.first.id;
                            }

                            final selected = admins.firstWhere((d) => d.id == selectedAdminUid);
                            final admin = selected.data();
                            final adminName = '${admin['adminName'] ?? admin['name'] ?? 'Admin'}';
                            final adminId = '${admin['adminId'] ?? selected.id}';
                            final instituteId = '${admin['instituteId'] ?? admin['appId'] ?? '—'}';
                            final adminActive = admin['isActive'] == true;

                            return LayoutBuilder(
                              builder: (context, constraints) {
                                final compact = constraints.maxWidth < 900;
                                final selector = _AdminSelector(
                                  admins: admins,
                                  selectedUid: selectedAdminUid!,
                                  onSelected: (uid) => setState(() => selectedAdminUid = uid),
                                );
                                final controls = _ServiceControls(
                                  adminUid: selected.id,
                                  adminName: adminName,
                                  adminId: adminId,
                                  instituteId: instituteId,
                                  adminActive: adminActive,
                                  global: global,
                                );

                                if (compact) {
                                  return Column(
                                    children: [
                                      SizedBox(height: 230, child: selector),
                                      const SizedBox(height: 14),
                                      Expanded(child: controls),
                                    ],
                                  );
                                }

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(width: 320, child: selector),
                                    const SizedBox(width: 16),
                                    Expanded(child: controls),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminSelector extends StatelessWidget {
  const _AdminSelector({required this.admins, required this.selectedUid, required this.onSelected});

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> admins;
  final String selectedUid;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: .94),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 8, 10, 14),
            child: Text('Select Admin / Institute', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          ),
          ...admins.map((doc) {
            final data = doc.data();
            final active = data['isActive'] == true;
            final selected = doc.id == selectedUid;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                selected: selected,
                selectedTileColor: const Color(0xffDDF2FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xffE1F4FF),
                  child: const Icon(Icons.admin_panel_settings_rounded, color: Color(0xff1677D2)),
                ),
                title: Text('${data['adminName'] ?? data['name'] ?? 'Admin'}', style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text('${data['adminId'] ?? doc.id}\n${data['instituteId'] ?? data['appId'] ?? 'No Institute'} • ${active ? 'Active' : 'Disabled'}'),
                onTap: () => onSelected(doc.id),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ServiceControls extends StatelessWidget {
  const _ServiceControls({
    required this.adminUid,
    required this.adminName,
    required this.adminId,
    required this.instituteId,
    required this.adminActive,
    required this.global,
  });

  final String adminUid;
  final String adminName;
  final String adminId;
  final String instituteId;
  final bool adminActive;
  final Map<String, dynamic> global;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: .94),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(adminName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text('Admin ID: $adminId  •  Institute ID: $instituteId', style: const TextStyle(color: Color(0xff5F7180))),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xffEAF7FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.account_tree_rounded, color: Color(0xff1677D2)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Master control is the upper limit. A service must be ON here and ON for this Admin before students can use it.',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: MasterDataService.adminServices(adminUid),
                builder: (context, adminSnap) {
                  final adminServices = adminSnap.data?.data() ?? {};
                  return ListView.separated(
                    itemCount: _ServiceManagementScreenState.services.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final key = _ServiceManagementScreenState.services.keys.elementAt(index);
                      final label = _ServiceManagementScreenState.services[key]!;
                      final masterEnabled = global[key] != false;
                      final adminEnabled = adminServices[key] == true;
                      final effective = adminActive && masterEnabled && adminEnabled;

                      return SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                        secondary: Icon(
                          _ServiceManagementScreenState.icons[key],
                          color: effective ? const Color(0xff1677D2) : const Color(0xff8798A6),
                        ),
                        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
                        subtitle: Text(
                          !adminActive
                              ? 'Admin disabled — service unavailable'
                              : !masterEnabled
                                  ? 'Master OFF — this Admin cannot enable it'
                                  : adminEnabled
                                      ? 'Enabled for this Admin / Institute'
                                      : 'Not enabled for this Admin / Institute',
                        ),
                        value: effective,
                        onChanged: (!adminActive || !masterEnabled)
                            ? null
                            : (value) => MasterDataService.setAdminService(adminUid, key, value),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Center(
        child: Text(text, style: const TextStyle(color: Color(0xff607889), fontWeight: FontWeight.w700)),
      );
}

class _Water extends StatelessWidget {
  const _Water();

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffB8E9FF), Color(0xffF0FBFF), Color(0xff86D2F5)],
          ),
        ),
      );
}
