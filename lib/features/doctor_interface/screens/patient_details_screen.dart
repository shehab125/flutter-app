import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientDetailsScreen extends StatelessWidget {
  final String patientId;

  const PatientDetailsScreen({
    Key? key,
    required this.patientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المريض'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(patientId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('حدث خطأ: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final patient = snapshot.data?.data() as Map<String, dynamic>?;

          if (patient == null) {
            return const Center(
              child: Text('لم يتم العثور على بيانات المريض'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(
                  'المعلومات الشخصية',
                  [
                    _buildInfoRow('الاسم', patient['name'] ?? ''),
                    _buildInfoRow('البريد الإلكتروني', patient['email'] ?? ''),
                    _buildInfoRow('رقم الهاتف', patient['phoneNumber'] ?? ''),
                    _buildInfoRow('العنوان', patient['address'] ?? ''),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  'السجلات الطبية',
                  [
                    // TODO: Add medical records
                    const ListTile(
                      title: Text('لا توجد سجلات طبية متاحة'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  'المواعيد',
                  [
                    // TODO: Add appointments
                    const ListTile(
                      title: Text('لا توجد مواعيد متاحة'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
} 