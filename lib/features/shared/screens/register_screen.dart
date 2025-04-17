import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_medical_box_app/core/providers/auth_provider.dart';
import 'package:smart_medical_box_app/shared/widgets/custom_button.dart';
import 'package:smart_medical_box_app/shared/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedUserType = 'patient';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty) {
      setState(() {
        _errorMessage = 'يرجى ملء جميع الحقول المطلوبة';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signUp(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _phoneController.text,
        _addressController.text,
        _selectedUserType,
        null,
      );

      if (!success && mounted) {
        setState(() {
          _errorMessage = authProvider.error ?? 'حدث خطأ أثناء التسجيل';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                label: 'الاسم',
                hint: 'أدخل اسمك',
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'البريد الإلكتروني',
                hint: 'أدخل بريدك الإلكتروني',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'كلمة المرور',
                hint: 'أدخل كلمة المرور',
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'رقم الهاتف',
                hint: 'أدخل رقم هاتفك',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'العنوان',
                hint: 'أدخل عنوانك',
                controller: _addressController,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedUserType,
                decoration: const InputDecoration(
                  labelText: 'نوع المستخدم',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'patient',
                    child: Text('مريض'),
                  ),
                  DropdownMenuItem(
                    value: 'doctor',
                    child: Text('طبيب'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedUserType = value;
                    });
                  }
                },
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 30),
              CustomButton(
                text: 'تسجيل',
                onPressed: _register,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 