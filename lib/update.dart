import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateDataForm extends StatefulWidget {
  QueryDocumentSnapshot<Map<String, dynamic>> data;

  UpdateDataForm({
    super.key,
    required this.data,
  });

  @override
  State<UpdateDataForm> createState() => _UpdateDataFormState();
}

class _UpdateDataFormState extends State<UpdateDataForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void updateData(BuildContext context) async {
    print('update data');
    var db = FirebaseFirestore.instance;
    await db.collection("companies").doc(widget.data.id).update({
      "lastupdate" : Timestamp.now(),
      'info': _infoController.text,
      'location': _locationController.text,
      'name': _nameController.text,
      'phone': int.parse(_phoneController.text)
    }).catchError((e) {
      print('error : ');
      print(e);
    }).then((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("تم تحديث البيانات")));
    });
  }

  void updattextfiled() {
    _infoController.text = widget.data.data()['info'];
    _nameController.text = widget.data.data()['name'];
    _locationController.text = widget.data.data()['location'];
    _phoneController.text = widget.data.data()['phone'].toString();
    setState(() {});
  }

  @override
  void initState() {
    updattextfiled();
    super.initState();
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
        title: const Text('تحديث رقم الشركة'),
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
                keyboardType: TextInputType.number,
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
                child: const Text('تحديث'),
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
      updateData(context);
    }
  }
}
