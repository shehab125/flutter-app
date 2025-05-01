# Smart Medical Box App

تطبيق صندوق الدواء الذكي لإدارة الأدوية ومراقبة الصحة.

## المتطلبات

- Flutter SDK (3.0.0 أو أحدث)
- Dart SDK (3.0.0 أو أحدث)
- Android Studio / VS Code
- Firebase Account

## الإعداد

1. قم بتثبيت Flutter SDK من [هنا](https://flutter.dev/docs/get-started/install)

2. قم بتنزيل المشروع:
```bash
git clone [رابط المشروع]
cd smart_medical_box_app
```

3. قم بتثبيت التبعيات:
```bash
flutter pub get
```

4. إعداد Firebase:
   - قم بإنشاء مشروع جديد في Firebase Console
   - قم بإضافة تطبيق Android جديد
   - قم بتحميل ملف `google-services.json` وضعه في `android/app/`
   - قم بتمكين Authentication وتفعيل Email/Password sign-in

5. قم بتشغيل التطبيق:
```bash
flutter run
```

## الميزات

- تسجيل الدخول وإنشاء الحساب
- واجهة خاصة للمرضى
- واجهة خاصة للأطباء
- إدارة الأدوية
- مراقبة العلامات الحيوية
- المواعيد والتذكيرات
- الإشعارات

## الهيكل

```
lib/
  ├── core/
  │   ├── models/
  │   ├── providers/
  │   └── services/
  ├── features/
  │   ├── doctor_interface/
  │   ├── patient_interface/
  │   └── shared/
  └── shared/
      ├── theme/
      └── widgets/
```

## ملاحظات مهمة

1. يجب إضافة ملف `google-services.json` الخاص بك
2. تأكد من تمكين المصادقة في Firebase
3. قم بتحديث إعدادات Firebase حسب احتياجاتك

## المساهمة

إذا كنت ترغب في المساهمة في هذا المشروع، يرجى اتباع الخطوات التالية:

1. قم بعمل Fork للمشروع
2. قم بإنشاء فرع جديد للميزة: `git checkout -b feature/amazing-feature`
3. قم بعمل Commit للتغييرات: `git commit -m 'إضافة ميزة رائعة'`
4. قم بدفع الفرع: `git push origin feature/amazing-feature`
5. قم بفتح Pull Request
