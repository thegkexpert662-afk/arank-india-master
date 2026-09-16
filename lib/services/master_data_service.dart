import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

class MasterDataService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> admins() =>
      _db.collection('admins').limit(500).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> institutes() =>
      _db.collection('apps').limit(500).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> students() =>
      _db.collection('users').limit(500).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> auditLogs() =>
      _db.collection('audit_logs').orderBy('createdAt', descending: true).limit(200).snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> services() =>
      _db.collection('service_controls').doc('global').snapshots();

  static String _id(String prefix, int length) {
    final value = DateTime.now().millisecondsSinceEpoch.toString();
    final random = Random.secure().nextInt(900).toString().padLeft(3, '0');
    final raw = '$value$random';
    return '$prefix${raw.substring(raw.length - length)}';
  }

  static String newAdminId() => _id('ARK', 6);
  static String newInstituteId() => _id('ARANK-', 8);

  static Future<void> createAdmin({
    required String name,
    required String email,
    required String password,
    required String instituteName,
  }) async {
    final masterUid = _auth.currentUser?.uid;
    if (masterUid == null) throw StateError('Master session not found.');

    final secondaryApp = await Firebase.initializeApp(
      name: 'master-admin-creator-${DateTime.now().microsecondsSinceEpoch}',
      options: DefaultFirebaseOptions.currentPlatform,
    );

    UserCredential? credential;
    try {
      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
      credential = await secondaryAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = credential.user!.uid;
      final adminId = newAdminId();
      final instituteId = newInstituteId();
      final batch = _db.batch();

      batch.set(_db.collection('admins').doc(uid), {
        'adminUid': uid,
        'adminId': adminId,
        'name': name.trim(),
        'adminName': name.trim(),
        'email': email.trim(),
        'role': 'admin',
        'instituteId': instituteId,
        'appId': instituteId,
        'isActive': true,
        'createdBy': masterUid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      batch.set(_db.collection('apps').doc(instituteId), {
        'appId': instituteId,
        'instituteId': instituteId,
        'ownerAdminUid': uid,
        'adminUid': uid,
        'adminId': adminId,
        'adminName': name.trim(),
        'appName': 'ARank India',
        'instituteName': instituteName.trim(),
        'supportEmail': email.trim(),
        'mobile': '',
        'logoUrl': '',
        'isActive': true,
        'features': <String, dynamic>{},
        'createdBy': masterUid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      batch.set(_db.collection('audit_logs').doc(), {
        'action': 'admin_created',
        'targetUid': uid,
        'targetAdminId': adminId,
        'targetInstituteId': instituteId,
        'performedBy': masterUid,
        'createdAt': FieldValue.serverTimestamp(),
        'details': 'Admin and institute created by Master Admin',
      });

      await batch.commit();
    } finally {
      await secondaryApp.delete();
    }
  }

  static Future<void> setAdminActive(String uid, bool active) async {
    final masterUid = _auth.currentUser?.uid;
    final adminRef = _db.collection('admins').doc(uid);
    final snap = await adminRef.get();
    final data = snap.data() ?? {};
    final instituteId = (data['instituteId'] ?? data['appId'] ?? '').toString();
    final batch = _db.batch();
    batch.update(adminRef, {'isActive': active, 'updatedAt': FieldValue.serverTimestamp()});
    if (instituteId.isNotEmpty) {
      batch.set(_db.collection('apps').doc(instituteId), {
        'isActive': active,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
    batch.set(_db.collection('audit_logs').doc(), {
      'action': active ? 'admin_enabled' : 'admin_disabled',
      'targetUid': uid,
      'performedBy': masterUid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }

  static Future<void> setInstituteActive(String instituteId, bool active) async {
    final masterUid = _auth.currentUser?.uid;
    await _db.collection('apps').doc(instituteId).set({
      'isActive': active,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await _db.collection('audit_logs').doc().set({
      'action': active ? 'institute_enabled' : 'institute_disabled',
      'targetInstituteId': instituteId,
      'performedBy': masterUid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> setStudentActive(String uid, bool active) async {
    final masterUid = _auth.currentUser?.uid;
    await _db.collection('users').doc(uid).set({
      'isActive': active,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await _db.collection('audit_logs').doc().set({
      'action': active ? 'student_enabled' : 'student_disabled',
      'targetUid': uid,
      'performedBy': masterUid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> setMasterService(String key, bool enabled) async {
    final masterUid = _auth.currentUser?.uid;
    await _db.collection('service_controls').doc('global').set({
      key: enabled,
      'updatedBy': masterUid,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await _db.collection('audit_logs').doc().set({
      'action': enabled ? 'service_enabled' : 'service_disabled',
      'service': key,
      'performedBy': masterUid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
