import 'package:flutter/material.dart';
import 'package:smart_medical_box_app/shared/theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  final bool isDoctor;
  
  const AppDrawer({
    super.key,
    this.isDoctor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isDoctor ? 'Dr. Sarah Ahmed' : 'Ahmed Hassan',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isDoctor ? 'Cardiologist' : 'Patient',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (isDoctor) _buildDoctorMenuItems(context) else _buildPatientMenuItems(context),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Navigate to settings
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              // Navigate to help
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Logout logic
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPatientMenuItems(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.dashboard),
          title: const Text('Dashboard'),
          onTap: () {
            // Navigate to dashboard
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.medication),
          title: const Text('Medications'),
          onTap: () {
            // Navigate to medications
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.monitor_heart),
          title: const Text('Health Monitoring'),
          onTap: () {
            // Navigate to health monitoring
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.insights),
          title: const Text('Health Insights'),
          onTap: () {
            // Navigate to health insights
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Appointments'),
          onTap: () {
            // Navigate to appointments
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.message),
          title: const Text('Messages'),
          onTap: () {
            // Navigate to messages
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.people),
          title: const Text('Family Sharing'),
          onTap: () {
            // Navigate to family sharing
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildDoctorMenuItems(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.dashboard),
          title: const Text('Dashboard'),
          onTap: () {
            // Navigate to dashboard
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.people),
          title: const Text('Patients'),
          onTap: () {
            // Navigate to patients
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Appointments'),
          onTap: () {
            // Navigate to appointments
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.message),
          title: const Text('Messages'),
          onTap: () {
            // Navigate to messages
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.analytics),
          title: const Text('Analytics'),
          onTap: () {
            // Navigate to analytics
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
