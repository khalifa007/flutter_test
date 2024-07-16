import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDataForm extends StatefulWidget {
  const AddDataForm({Key? key}) : super(key: key);

  @override
  State<AddDataForm> createState() => _AddDataFormState();
}

class _AddDataFormState extends State<AddDataForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void adddata(BuildContext context) async {
    print('send data');
    var db = FirebaseFirestore.instance;
    await db.collection("companies").add({
      'date': Timestamp.now(),
      'info': _infoController.text,
      'location': _locationController.text,
      'name': _nameController.text,
      'phone': _phoneController.text
    }).catchError((e) {
      print('error : ');
      print(e);
    }).then((e) {
      print("تم اضافة البيانات");
    });
  }

  @override
  void dispose() {
    _infoController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة رقم الشركة'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField(
                controller: _infoController,
                label: 'معلومات',
                hint: 'أدخل المعلومات',
                icon: Icons.info,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال بعض المعلومات';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _nameController,
                label: 'الاسم',
                hint: 'أدخل الاسم',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الاسم';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _locationController,
                label: 'الموقع',
                hint: 'أدخل الموقع',
                icon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الموقع';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _phoneController,
                label: 'رقم الهاتف',
                hint: 'أدخل رقم الهاتف',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم الهاتف';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: const Text('إضافة'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        prefixIcon: Icon(icon),
      ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Process the form data
      print('Form submitted');
      print('Info: ${_infoController.text}');
      print('Name: ${_nameController.text}');
      print('Location: ${_locationController.text}');
      print('Phone: ${_phoneController.text}');
      adddata(context);
    }
  }
}
