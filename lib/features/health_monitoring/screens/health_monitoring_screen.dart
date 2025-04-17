import 'package:flutter/material.dart';
import 'package:smart_medical_box_app/core/models/vital_sign.dart';
import 'package:smart_medical_box_app/shared/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthMonitoringScreen extends StatefulWidget {
  const HealthMonitoringScreen({super.key});

  @override
  State<HealthMonitoringScreen> createState() => _HealthMonitoringScreenState();
}

class _HealthMonitoringScreenState extends State<HealthMonitoringScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeRange = 'Week';
  final List<String> _timeRanges = ['Day', 'Week', 'Month', 'Year'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Health Monitoring'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Heart Rate'),
            Tab(text: 'Blood Pressure'),
            Tab(text: 'Temperature'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  'Time Range:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SegmentedButton<String>(
                    segments: _timeRanges.map((range) {
                      return ButtonSegment<String>(
                        value: range,
                        label: Text(range),
                      );
                    }).toList(),
                    selected: {_selectedTimeRange},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _selectedTimeRange = newSelection.first;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                OverviewTab(timeRange: _selectedTimeRange),
                HeartRateTab(timeRange: _selectedTimeRange),
                BloodPressureTab(timeRange: _selectedTimeRange),
                TemperatureTab(timeRange: _selectedTimeRange),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add vital sign screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class OverviewTab extends StatelessWidget {
  final String timeRange;

  const OverviewTab({super.key, required this.timeRange});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentVitalsCard(),
          const SizedBox(height: 16),
          _buildVitalSignsChart(),
          const SizedBox(height: 16),
          _buildRecentMeasurementsCard(),
          const SizedBox(height: 16),
          _buildConnectedDevicesCard(),
        ],
      ),
    );
  }

  Widget _buildCurrentVitalsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Vitals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildVitalMetric(
                  icon: Icons.favorite,
                  value: '72',
                  unit: 'bpm',
                  label: 'Heart Rate',
                  color: AppTheme.primaryColor,
                  time: '10:30 AM',
                ),
                _buildVitalMetric(
                  icon: Icons.speed,
                  value: '120/80',
                  unit: 'mmHg',
                  label: 'Blood Pressure',
                  color: AppTheme.secondaryColor,
                  time: '10:30 AM',
                ),
                _buildVitalMetric(
                  icon: Icons.thermostat,
                  value: '36.8',
                  unit: '°C',
                  label: 'Temperature',
                  color: AppTheme.warningColor,
                  time: '10:30 AM',
                ),
                _buildVitalMetric(
                  icon: Icons.air,
                  value: '98',
                  unit: '%',
                  label: 'Oxygen',
                  color: AppTheme.accentColor,
                  time: '10:30 AM',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalMetric({
    required IconData icon,
    required String value,
    required String unit,
    required String label,
    required Color color,
    required String time,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(height: 8),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          time,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildVitalSignsChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Vital Signs Trends',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: 'Heart Rate',
                  items: const [
                    DropdownMenuItem(
                      value: 'Heart Rate',
                      child: Text('Heart Rate'),
                    ),
                    DropdownMenuItem(
                      value: 'Blood Pressure',
                      child: Text('Blood Pressure'),
                    ),
                    DropdownMenuItem(
                      value: 'Temperature',
                      child: Text('Temperature'),
                    ),
                    DropdownMenuItem(
                      value: 'Oxygen',
                      child: Text('Oxygen'),
                    ),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 70),
                        FlSpot(1, 72),
                        FlSpot(2, 75),
                        FlSpot(3, 74),
                        FlSpot(4, 73),
                        FlSpot(5, 72),
                        FlSpot(6, 70),
                      ],
                      isCurved: true,
                      color: AppTheme.primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.primaryColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentMeasurementsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Measurements',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMeasurementItem(
              type: 'Heart Rate',
              value: '72 bpm',
              time: 'Today, 10:30 AM',
              icon: Icons.favorite,
              color: AppTheme.primaryColor,
            ),
            const Divider(),
            _buildMeasurementItem(
              type: 'Blood Pressure',
              value: '120/80 mmHg',
              time: 'Today, 10:30 AM',
              icon: Icons.speed,
              color: AppTheme.secondaryColor,
            ),
            const Divider(),
            _buildMeasurementItem(
              type: 'Temperature',
              value: '36.8 °C',
              time: 'Today, 10:30 AM',
              icon: Icons.thermostat,
              color: AppTheme.warningColor,
            ),
            const Divider(),
            _buildMeasurementItem(
              type: 'Oxygen',
              value: '98%',
              time: 'Today, 10:30 AM',
              icon: Icons.air,
              color: AppTheme.accentColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementItem({
    required String type,
    required String value,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedDevicesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Connected Devices',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.add_circle_outline),
              ],
            ),
            const SizedBox(height: 16),
            _buildDeviceItem(
              name: 'Smart Medical Box',
              status: 'Connected',
              lastSync: '2 minutes ago',
              icon: Icons.medical_services,
              isConnected: true,
            ),
            const Divider(),
            _buildDeviceItem(
              name: 'Blood Pressure Monitor',
              status: 'Connected',
              lastSync: '30 minutes ago',
              icon: Icons.speed,
              isConnected: true,
            ),
            const Divider(),
            _buildDeviceItem(
              name: 'Smart Watch',
              status: 'Disconnected',
              lastSync: '2 hours ago',
              icon: Icons.watch,
              isConnected: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceItem({
    required String name,
    required String status,
    required String lastSync,
    required IconData icon,
    required bool isConnected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isConnected
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isConnected ? AppTheme.primaryColor : Colors.grey,
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
                  ),
                ),
                Text(
                  'Last sync: $lastSync',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isConnected
                  ? AppTheme.successColor.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: isConnected ? AppTheme.successColor : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeartRateTab extends StatelessWidget {
  final String timeRange;

  const HeartRateTab({super.key, required this.timeRange});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Heart Rate Tab - Coming Soon'),
    );
  }
}

class BloodPressureTab extends StatelessWidget {
  final String timeRange;

  const BloodPressureTab({super.key, required this.timeRange});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Blood Pressure Tab - Coming Soon'),
    );
  }
}

class TemperatureTab extends StatelessWidget {
  final String timeRange;

  const TemperatureTab({super.key, required this.timeRange});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Temperature Tab - Coming Soon'),
    );
  }
}
