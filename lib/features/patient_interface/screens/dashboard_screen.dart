import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_medical_box_app/core/providers/auth_provider.dart';

class PatientDashboardScreen extends StatelessWidget {
  const PatientDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم المريض', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal.shade700,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('إعدادات الحساب قيد التطوير'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authProvider.signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade400, Colors.teal.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.teal.shade700,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'مرحباً ${user?.name ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'البريد الإلكتروني: ${user?.email ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.favorite, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'الحالة الصحية: جيدة',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الخدمات المتاحة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('تحديث'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم تحديث البيانات'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildActionCard(
                    context,
                    'حجز موعد',
                    Icons.calendar_today,
                    Colors.blue,
                    () {
                      _showAppointmentBookingScreen(context);
                    },
                  ),
                  _buildActionCard(
                    context,
                    'الوصفات الطبية',
                    Icons.medical_services,
                    Colors.green,
                    () {
                      _showPrescriptionsScreen(context);
                    },
                  ),
                  _buildActionCard(
                    context,
                    'التقارير',
                    Icons.description,
                    Colors.orange,
                    () {
                      _showReportsScreen(context);
                    },
                  ),
                  _buildActionCard(
                    context,
                    'الإشعارات',
                    Icons.notifications,
                    Colors.red,
                    () {
                      _showPatientNotificationsScreen(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: color,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAppointmentBookingScreen(BuildContext context) {
    final dateController = TextEditingController(text: 'اليوم');
    final timeController = TextEditingController(text: '10:00 صباحاً');
    final reasonController = TextEditingController();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('حجز موعد جديد'),
            backgroundColor: Colors.teal.shade700,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'معلومات الموعد',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: dateController,
                          decoration: const InputDecoration(
                            labelText: 'التاريخ',
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                          onTap: () {
                            // Date picker would go here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('سيتم إضافة منتقي التاريخ قريباً'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: timeController,
                          decoration: const InputDecoration(
                            labelText: 'الوقت',
                            prefixIcon: Icon(Icons.access_time),
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                          onTap: () {
                            // Time picker would go here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('سيتم إضافة منتقي الوقت قريباً'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: reasonController,
                          decoration: const InputDecoration(
                            labelText: 'سبب الزيارة',
                            prefixIcon: Icon(Icons.medical_services),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'اختر الطبيب',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDoctorSelectionTile(
                          'د. أحمد محمد',
                          'طب عام',
                          'متاح',
                          Colors.green,
                          true,
                        ),
                        _buildDoctorSelectionTile(
                          'د. سارة أحمد',
                          'أمراض باطنية',
                          'متاح',
                          Colors.green,
                          false,
                        ),
                        _buildDoctorSelectionTile(
                          'د. محمد علي',
                          'جراحة',
                          'غير متاح',
                          Colors.red,
                          false,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم حجز الموعد بنجاح'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'تأكيد الحجز',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDoctorSelectionTile(
    String name,
    String specialization,
    String availability,
    Color availabilityColor,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.teal : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: Text(
            name.substring(0, 1),
            style: TextStyle(
              color: Colors.teal.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(name),
        subtitle: Text(specialization),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: availabilityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                availability,
                style: TextStyle(
                  color: availabilityColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.teal,
              ),
          ],
        ),
      ),
    );
  }
  
  void _showPrescriptionsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('الوصفات الطبية'),
            backgroundColor: Colors.teal.shade700,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildPrescriptionCard(
                'د. أحمد محمد',
                'منذ 3 أيام',
                [
                  'باراسيتامول 500 مجم - 3 مرات يومياً',
                  'أموكسيسيلين 250 مجم - مرتين يومياً',
                  'فيتامين سي - مرة واحدة يومياً',
                ],
                true,
              ),
              _buildPrescriptionCard(
                'د. سارة أحمد',
                'منذ أسبوعين',
                [
                  'ايبوبروفين 400 مجم - عند الحاجة',
                  'سيتريزين 10 مجم - مرة واحدة يومياً',
                ],
                false,
              ),
              _buildPrescriptionCard(
                'د. محمد علي',
                'منذ شهر',
                [
                  'أوميبرازول 20 مجم - مرة واحدة يومياً',
                  'كالسيوم 500 مجم - مرتين يومياً',
                ],
                false,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPrescriptionCard(
    String doctorName,
    String date,
    List<String> medications,
    bool isActive,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.teal.shade100,
                  child: Text(
                    doctorName.substring(3, 4),
                    style: TextStyle(
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        date,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isActive ? 'نشطة' : 'منتهية',
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'الأدوية:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            ...medications.map((medication) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.medication,
                    size: 16,
                    color: Colors.teal,
                  ),
                  const SizedBox(width: 8),
                  Text(medication),
                ],
              ),
            )),
            if (isActive) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('تجديد الوصفة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  void _showReportsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('التقارير الطبية'),
            backgroundColor: Colors.teal.shade700,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildReportCard(
                'تقرير فحص عام',
                'د. أحمد محمد',
                'منذ 3 أيام',
                'تقرير الفحص العام يظهر أن الحالة الصحية جيدة مع الحاجة إلى متابعة مستوى ضغط الدم.',
                Colors.green,
              ),
              _buildReportCard(
                'نتائج تحليل الدم',
                'د. سارة أحمد',
                'منذ أسبوعين',
                'نتائج تحليل الدم ضمن المعدل الطبيعي مع انخفاض طفيف في مستوى فيتامين د.',
                Colors.orange,
              ),
              _buildReportCard(
                'تقرير الأشعة السينية',
                'د. محمد علي',
                'منذ شهر',
                'لا توجد مشاكل ظاهرة في الأشعة السينية للصدر.',
                Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildReportCard(
    String title,
    String doctorName,
    String date,
    String summary,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.description,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      doctorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Text(
                  summary,
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('عرض التفاصيل'),
                      onPressed: () {},
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('تحميل'),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _showPatientNotificationsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('الإشعارات'),
            backgroundColor: Colors.teal.shade700,
            actions: [
              IconButton(
                icon: const Icon(Icons.check_circle),
                tooltip: 'تحديد الكل كمقروء',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تحديد جميع الإشعارات كمقروءة'),
                    ),
                  );
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildPatientNotificationItem(
                'تذكير بموعد',
                'لديك موعد مع د. أحمد محمد غداً الساعة 10:00 صباحاً',
                '10:30 صباحاً',
                Colors.blue,
                Icons.calendar_today,
                false,
              ),
              _buildPatientNotificationItem(
                'وصفة طبية جديدة',
                'تم إضافة وصفة طبية جديدة من قبل د. سارة أحمد',
                'منذ ساعتين',
                Colors.green,
                Icons.medical_services,
                false,
              ),
              _buildPatientNotificationItem(
                'نتائج التحاليل جاهزة',
                'نتائج تحليل الدم الخاص بك جاهزة للاطلاع',
                'أمس',
                Colors.orange,
                Icons.description,
                true,
              ),
              _buildPatientNotificationItem(
                'تحديث النظام',
                'تم تحديث النظام إلى الإصدار الجديد بنجاح',
                'منذ يومين',
                Colors.purple,
                Icons.system_update,
                true,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPatientNotificationItem(
    String title,
    String content,
    String time,
    Color color,
    IconData icon,
    bool isRead,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: isRead ? 1 : 3,
      color: isRead ? Colors.white : Colors.teal.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  if (!isRead)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: const Text('تحديد كمقروء'),
                        onPressed: () {},
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
