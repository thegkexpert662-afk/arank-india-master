import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/master_data_service.dart';

class InstituteManagementScreen extends StatelessWidget {
  const InstituteManagementScreen({super.key});

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
                              'Institute Management',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              'Control every connected Student Institute',
                              style: TextStyle(color: Color(0xff5F7180)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Expanded(
                    child: Card(
                      color: Colors.white.withValues(alpha: .94),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: MasterDataService.institutes(),
                          builder: (context, snap) {
                            if (snap.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snap.hasError) {
                              return Center(child: Text('Unable to load institutes: ${snap.error}'));
                            }

                            final docs = snap.data?.docs ?? [];
                            if (docs.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No institutes yet',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              );
                            }

                            return ListView.separated(
                              itemCount: docs.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 10),
                              itemBuilder: (_, i) {
                                final doc = docs[i];
                                final data = doc.data();
                                final active = data['isActive'] == true;
                                final instituteId =
                                    (data['instituteId'] ?? doc.id).toString();
                                final instituteName =
                                    (data['instituteName'] ?? data['appName'] ?? 'Institute').toString();
                                final adminName =
                                    (data['adminName'] ?? data['adminId'] ?? '—').toString();

                                return ListTile(
                                  tileColor: const Color(0xffF7FBFF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  leading: const CircleAvatar(
                                    backgroundColor: Color(0xffE1F4FF),
                                    child: Icon(
                                      Icons.account_balance_rounded,
                                      color: Color(0xff1677D2),
                                    ),
                                  ),
                                  title: Text(
                                    instituteName,
                                    style: const TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                  subtitle: Text(
                                    'Institute ID: $instituteId\nAdmin: $adminName',
                                  ),
                                  trailing: Switch(
                                    value: active,
                                    onChanged: (value) =>
                                        MasterDataService.setInstituteActive(doc.id, value),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
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

class _Water extends StatelessWidget {
  const _Water();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffB8E9FF),
            Color(0xffF0FBFF),
            Color(0xff86D2F5),
          ],
        ),
      ),
    );
  }
}
