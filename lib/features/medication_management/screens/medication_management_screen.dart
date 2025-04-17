import 'package:flutter/material.dart';
import 'package:smart_medical_box_app/core/models/medication.dart';
import 'package:smart_medical_box_app/shared/theme/app_theme.dart';

class MedicationManagementScreen extends StatefulWidget {
  const MedicationManagementScreen({super.key});

  @override
  State<MedicationManagementScreen> createState() => _MedicationManagementScreenState();
}

class _MedicationManagementScreenState extends State<MedicationManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Schedule'),
            Tab(text: 'Inventory'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TodayMedicationsTab(),
          ScheduleTab(),
          InventoryTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add medication screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodayMedicationsTab extends StatelessWidget {
  const TodayMedicationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildTimeSection('Morning', [
          _buildMedicationItem(
            name: 'Aspirin',
            time: '08:00 AM',
            dosage: '100mg',
            status: 'taken',
          ),
          _buildMedicationItem(
            name: 'Vitamin D',
            time: '08:00 AM',
            dosage: '1000 IU',
            status: 'taken',
          ),
        ]),
        _buildTimeSection('Afternoon', [
          _buildMedicationItem(
            name: 'Metformin',
            time: '01:30 PM',
            dosage: '500mg',
            status: 'missed',
          ),
        ]),
        _buildTimeSection('Evening', [
          _buildMedicationItem(
            name: 'Atorvastatin',
            time: '09:00 PM',
            dosage: '20mg',
            status: 'upcoming',
          ),
          _buildMedicationItem(
            name: 'Omega-3',
            time: '09:00 PM',
            dosage: '1000mg',
            status: 'upcoming',
          ),
        ]),
      ],
    );
  }

  Widget _buildTimeSection(String title, List<Widget> medications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...medications,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMedicationItem({
    required String name,
    required String time,
    required String dosage,
    required String status, // 'taken', 'missed', 'upcoming'
  }) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'taken':
        statusColor = AppTheme.successColor;
        statusText = 'Taken';
        statusIcon = Icons.check_circle;
        break;
      case 'missed':
        statusColor = AppTheme.errorColor;
        statusText = 'Missed';
        statusIcon = Icons.cancel;
        break;
      case 'upcoming':
        statusColor = AppTheme.primaryColor;
        statusText = 'Upcoming';
        statusIcon = Icons.schedule;
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
        statusIcon = Icons.help;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.medication,
                color: AppTheme.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$time - $dosage',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  statusIcon,
                  color: statusColor,
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleTab extends StatelessWidget {
  const ScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('April 2025'),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 7,
            itemBuilder: (context, index) {
              final day = DateTime.now().add(Duration(days: index));
              final dayName = _getDayName(day.weekday);
              final dayNumber = day.day;
              final month = _getMonthName(day.month);
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  title: Text(
                    '$dayName, $month $dayNumber',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    _buildScheduleItem('08:00 AM', 'Aspirin, Vitamin D'),
                    _buildScheduleItem('01:30 PM', 'Metformin'),
                    _buildScheduleItem('09:00 PM', 'Atorvastatin, Omega-3'),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleItem(String time, String medications) {
    return ListTile(
      leading: const Icon(Icons.access_time),
      title: Text(time),
      subtitle: Text(medications),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Navigate to detailed view
      },
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'January';
      case 2: return 'February';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'August';
      case 9: return 'September';
      case 10: return 'October';
      case 11: return 'November';
      case 12: return 'December';
      default: return '';
    }
  }
}

class InventoryTab extends StatelessWidget {
  const InventoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildInventoryItem(
          name: 'Aspirin',
          dosage: '100mg',
          remaining: 25,
          total: 30,
          refillDate: 'May 15, 2025',
        ),
        _buildInventoryItem(
          name: 'Metformin',
          dosage: '500mg',
          remaining: 12,
          total: 60,
          refillDate: 'April 25, 2025',
          isLow: true,
        ),
        _buildInventoryItem(
          name: 'Atorvastatin',
          dosage: '20mg',
          remaining: 45,
          total: 90,
          refillDate: 'July 10, 2025',
        ),
        _buildInventoryItem(
          name: 'Vitamin D',
          dosage: '1000 IU',
          remaining: 18,
          total: 60,
          refillDate: 'May 5, 2025',
        ),
        _buildInventoryItem(
          name: 'Omega-3',
          dosage: '1000mg',
          remaining: 5,
          total: 60,
          refillDate: 'April 18, 2025',
          isLow: true,
        ),
      ],
    );
  }

  Widget _buildInventoryItem({
    required String name,
    required String dosage,
    required int remaining,
    required int total,
    required String refillDate,
    bool isLow = false,
  }) {
    final percentRemaining = (remaining / total * 100).round();
    Color progressColor;
    
    if (percentRemaining > 50) {
      progressColor = AppTheme.successColor;
    } else if (percentRemaining > 20) {
      progressColor = AppTheme.warningColor;
    } else {
      progressColor = AppTheme.errorColor;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (isLow)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning,
                          color: AppTheme.errorColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Low Stock',
                          style: TextStyle(
                            color: AppTheme.errorColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              dosage,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: remaining / total,
                      backgroundColor: Colors.grey[200],
                      color: progressColor,
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '$remaining/$total',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Next refill: $refillDate',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Request refill
                  },
                  child: const Text('Request Refill'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
