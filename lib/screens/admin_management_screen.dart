import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/master_data_service.dart';

class AdminManagementScreen extends StatelessWidget {
  const AdminManagementScreen({super.key});

  Future<void> _create(BuildContext context) async {
    final name = TextEditingController();
    final email = TextEditingController();
    final password = TextEditingController();
    final institute = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      title: const Text('Create Admin'),
      content: SizedBox(width: 460, child: Form(key: formKey, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Admin Name'), validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        TextFormField(controller: email, decoration: const InputDecoration(labelText: 'Email'), validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        TextFormField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Temporary Password'), validator: (v) => v!.length < 6 ? 'Minimum 6 characters' : null),
        TextFormField(controller: institute, decoration: const InputDecoration(labelText: 'Institute Name'), validator: (v) => v!.trim().isEmpty ? 'Required' : null),
      ]))),
      actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')), ElevatedButton(onPressed: () async {
        if (!formKey.currentState!.validate()) return;
        Navigator.pop(context, true);
      }, child: const Text('Create'))],
    ));
    if (ok != true) return;
    try {
      await MasterDataService.createAdmin(name: name.text, email: email.text, password: password.text, instituteName: institute.text);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Admin and Institute created successfully.')));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Create failed: $e')));
    }
    name.dispose(); email.dispose(); password.dispose(); institute.dispose();
  }

  @override
  Widget build(BuildContext context) => _ManagementPage(
    title: 'Admin Management', subtitle: 'Create, enable or disable Admin accounts', action: ElevatedButton.icon(onPressed: () => _create(context), icon: const Icon(Icons.person_add_alt_1_rounded), label: const Text('Create Admin')),
    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: MasterDataService.admins(), builder: (context, snap) {
      if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
      if (snap.hasError) return Center(child: Text('Unable to load admins: ${snap.error}'));
      final docs = snap.data?.docs ?? [];
      if (docs.isEmpty) return const _Empty(text: 'No Admin accounts yet');
      return ListView.separated(itemCount: docs.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (_, i) {
        final d = docs[i].data(); final active = d['isActive'] == true;
        return _Tile(icon: Icons.manage_accounts_rounded, title: '${d['adminName'] ?? d['name'] ?? 'Admin'}', subtitle: '${d['adminId'] ?? d.id}  •  ${d['email'] ?? ''}\nInstitute: ${d['instituteId'] ?? d['appId'] ?? '—'}', active: active, onChanged: (v) => MasterDataService.setAdminActive(d.id, v));
      });
    }),
  );
}

class _ManagementPage extends StatelessWidget {
  const _ManagementPage({required this.title, required this.subtitle, required this.child, this.action});
  final String title, subtitle; final Widget child; final Widget? action;
  @override Widget build(BuildContext context) => Scaffold(body: Stack(children: [const _Water(), SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), Text(subtitle, style: const TextStyle(color: Color(0xff5F7180)))])), if (action != null) action!]), const SizedBox(height: 22), Expanded(child: Card(color: Colors.white.withValues(alpha: .94), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), child: Padding(padding: const EdgeInsets.all(18), child: child))) ]))]));
}
class _Tile extends StatelessWidget { const _Tile({required this.icon, required this.title, required this.subtitle, required this.active, required this.onChanged}); final IconData icon; final String title, subtitle; final bool active; final ValueChanged<bool> onChanged; @override Widget build(BuildContext context) => ListTile(tileColor: const Color(0xffF7FBFF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), leading: CircleAvatar(backgroundColor: const Color(0xffE1F4FF), child: Icon(icon, color: const Color(0xff1677D2))), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(subtitle), trailing: Switch(value: active, onChanged: onChanged)); }
class _Empty extends StatelessWidget { const _Empty({required this.text}); final String text; @override Widget build(BuildContext context) => Center(child: Text(text, style: const TextStyle(color: Color(0xff607889), fontWeight: FontWeight.w700))); }
class _Water extends StatelessWidget { const _Water(); @override Widget build(BuildContext context) => Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [Color(0xffB8E9FF),Color(0xffF0FBFF),Color(0xff86D2F5)]))); }
