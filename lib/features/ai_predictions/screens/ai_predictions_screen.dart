import 'package:flutter/material.dart';
import 'package:smart_medical_box_app/core/models/health_prediction.dart';
import 'package:smart_medical_box_app/shared/theme/app_theme.dart';

class AIPredictionsScreen extends StatefulWidget {
  const AIPredictionsScreen({super.key});

  @override
  State<AIPredictionsScreen> createState() => _AIPredictionsScreenState();
}

class _AIPredictionsScreenState extends State<AIPredictionsScreen> with SingleTickerProviderStateMixin {
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
        title: const Text('Health Insights'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Health Risks'),
            Tab(text: 'Recommendations'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OverviewTab(),
          HealthRisksTab(),
          RecommendationsTab(),
        ],
      ),
    );
  }
}

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHealthScoreCard(),
          const SizedBox(height: 16),
          _buildRecentInsightsCard(),
          const SizedBox(height: 16),
          _buildMedicationAdherenceCard(),
          const SizedBox(height: 16),
          _buildHealthTrendsCard(),
        ],
      ),
    );
  }

  Widget _buildHealthScoreCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Health Score',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: 0.85,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey[300],
                            color: AppTheme.successColor,
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '85',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Good',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.successColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildScoreItem(
                        label: 'Heart Health',
                        score: 90,
                        color: AppTheme.successColor,
                      ),
                      const SizedBox(height: 8),
                      _buildScoreItem(
                        label: 'Medication Adherence',
                        score: 85,
                        color: AppTheme.successColor,
                      ),
                      const SizedBox(height: 8),
                      _buildScoreItem(
                        label: 'Vital Signs Stability',
                        score: 80,
                        color: AppTheme.successColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Your health score is calculated based on your vital signs, medication adherence, and other health factors.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem({
    required String label,
    required int score,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              '$score',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: score / 100,
          backgroundColor: Colors.grey[300],
          color: color,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildRecentInsightsCard() {
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
                  'Recent Insights',
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
            _buildInsightItem(
              title: 'Low Risk of Heart Issues',
              description:
                  'Based on your recent vital signs, you have a low risk of heart-related issues.',
              date: 'Today',
              icon: Icons.favorite,
              color: AppTheme.successColor,
            ),
            const Divider(),
            _buildInsightItem(
              title: 'Blood Pressure Trend',
              description:
                  'Your blood pressure has been stable over the past week.',
              date: 'Yesterday',
              icon: Icons.speed,
              color: AppTheme.primaryColor,
            ),
            const Divider(),
            _buildInsightItem(
              title: 'Medication Interaction Alert',
              description:
                  'Potential interaction detected between Aspirin and your new medication.',
              date: '3 days ago',
              icon: Icons.warning,
              color: AppTheme.warningColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem({
    required String title,
    required String description,
    required String date,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationAdherenceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Medication Adherence',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: 0.9,
                            strokeWidth: 8,
                            backgroundColor: Colors.grey[300],
                            color: AppTheme.successColor,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          '90%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.successColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Great job!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'You\'ve taken 27 out of 30 medications on time this week.',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Missed: Metformin (1), Aspirin (2)',
                        style: TextStyle(
                          color: AppTheme.errorColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Tip: Set up additional reminders for your afternoon medications to improve adherence.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthTrendsCard() {
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
                  'Health Trends',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Last 30 Days',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTrendItem(
                  label: 'Heart Rate',
                  value: '72 bpm',
                  trend: 'stable',
                  icon: Icons.favorite,
                  color: AppTheme.primaryColor,
                ),
                _buildTrendItem(
                  label: 'Blood Pressure',
                  value: '120/80',
                  trend: 'improving',
                  icon: Icons.speed,
                  color: AppTheme.secondaryColor,
                ),
                _buildTrendItem(
                  label: 'Blood Sugar',
                  value: '110 mg/dL',
                  trend: 'worsening',
                  icon: Icons.water_drop,
                  color: AppTheme.warningColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendItem({
    required String label,
    required String value,
    required String trend,
    required IconData icon,
    required Color color,
  }) {
    IconData trendIcon;
    Color trendColor;

    switch (trend) {
      case 'improving':
        trendIcon = Icons.trending_up;
        trendColor = AppTheme.successColor;
        break;
      case 'worsening':
        trendIcon = Icons.trending_down;
        trendColor = AppTheme.errorColor;
        break;
      case 'stable':
      default:
        trendIcon = Icons.trending_flat;
        trendColor = Colors.grey;
        break;
    }

    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Icon(trendIcon, color: trendColor, size: 16),
      ],
    );
  }
}

class HealthRisksTab extends StatelessWidget {
  const HealthRisksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildRiskCard(
          title: 'Heart Disease Risk',
          riskLevel: 'Low',
          riskScore: 15,
          description:
              'Based on your vital signs and medical history, your risk of developing heart disease is low.',
          factors: [
            'Normal blood pressure',
            'Regular physical activity',
            'No family history of heart disease',
          ],
          recommendations: [
            'Continue regular exercise',
            'Maintain a heart-healthy diet',
            'Monitor blood pressure regularly',
          ],
          color: AppTheme.successColor,
        ),
        const SizedBox(height: 16),
        _buildRiskCard(
          title: 'Diabetes Risk',
          riskLevel: 'Moderate',
          riskScore: 45,
          description:
              'Your blood sugar levels and other factors indicate a moderate risk of developing type 2 diabetes.',
          factors: [
            'Slightly elevated blood sugar',
            'Family history of diabetes',
            'Sedentary lifestyle',
          ],
          recommendations: [
            'Increase physical activity',
            'Reduce sugar intake',
            'Monitor blood sugar regularly',
            'Consult with your doctor about preventive measures',
          ],
          color: AppTheme.warningColor,
        ),
        const SizedBox(height: 16),
        _buildRiskCard(
          title: 'Respiratory Infection Risk',
          riskLevel: 'Low',
          riskScore: 20,
          description:
              'Your risk of developing respiratory infections is currently low.',
          factors: [
            'Normal oxygen levels',
            'No recent exposure to respiratory illnesses',
            'Up-to-date vaccinations',
          ],
          recommendations: [
            'Practice good hand hygiene',
            'Avoid close contact with sick individuals',
            'Ensure adequate ventilation in indoor spaces',
          ],
          color: AppTheme.successColor,
        ),
      ],
    );
  }

  Widget _buildRiskCard({
    required String title,
    required String riskLevel,
    required int riskScore,
    required String description,
    required List<String> factors,
    required List<String> recommendations,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    riskLevel,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: riskScore / 100,
              backgroundColor: Colors.grey[200],
              color: color,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              'Risk Score: $riskScore/100',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Key Factors:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...factors.map((factor) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(factor)),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            const Text(
              'Recommendations:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...recommendations.map((recommendation) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(recommendation)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class RecommendationsTab extends StatelessWidget {
  const RecommendationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildCategoryCard(
          title: 'Lifestyle Recommendations',
          icon: Icons.directions_run,
          color: AppTheme.primaryColor,
          recommendations: [
            _buildRecommendationItem(
              title: 'Increase Physical Activity',
              description:
                  'Aim for at least 30 minutes of moderate exercise 5 days a week.',
              priority: 'High',
            ),
            _buildRecommendationItem(
              title: 'Improve Sleep Quality',
              description:
                  'Maintain a regular sleep schedule and aim for 7-8 hours of sleep per night.',
              priority: 'Medium',
            ),
            _buildRecommendationItem(
              title: 'Reduce Stress',
              description:
                  'Practice relaxation techniques such as deep breathing or meditation for 10 minutes daily.',
              priority: 'Medium',
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCategoryCard(
          title: 'Medication Recommendations',
          icon: Icons.medication,
          color: AppTheme.secondaryColor,
          recommendations: [
            _buildRecommendationItem(
              title: 'Take Medications with Food',
              description:
                  'Take Metformin with meals to reduce gastrointestinal side effects.',
              priority: 'High',
            ),
            _buildRecommendationItem(
              title: 'Adjust Medication Schedule',
              description:
                  'Consider taking evening medications 30 minutes earlier to improve adherence.',
              priority: 'Medium',
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCategoryCard(
          title: 'Dietary Recommendations',
          icon: Icons.restaurant,
          color: AppTheme.accentColor,
          recommendations: [
            _buildRecommendationItem(
              title: 'Reduce Sodium Intake',
              description:
                  'Limit processed foods and add less salt to meals to help control blood pressure.',
              priority: 'High',
            ),
            _buildRecommendationItem(
              title: 'Increase Fiber Intake',
              description:
                  'Add more fruits, vegetables, and whole grains to your diet to improve digestive health and blood sugar control.',
              priority: 'Medium',
            ),
            _buildRecommendationItem(
              title: 'Stay Hydrated',
              description:
                  'Drink at least 8 glasses of water daily to maintain proper hydration.',
              priority: 'Medium',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> recommendations,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...recommendations,
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem({
    required String title,
    required String description,
    required String priority,
  }) {
    Color priorityColor;
    switch (priority.toLowerCase()) {
      case 'high':
        priorityColor = AppTheme.errorColor;
        break;
      case 'medium':
        priorityColor = AppTheme.warningColor;
        break;
      case 'low':
      default:
        priorityColor = AppTheme.successColor;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  priority,
                  style: TextStyle(
                    color: priorityColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
