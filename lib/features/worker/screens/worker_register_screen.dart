import 'package:flutter/material.dart';
import 'package:fixmate_app/core/theme/app_theme.dart';

class WorkerRegisterScreen extends StatefulWidget {
  const WorkerRegisterScreen({super.key});

  @override
  State<WorkerRegisterScreen> createState() => _WorkerRegisterScreenState();
}

class _WorkerRegisterScreenState extends State<WorkerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {'icon': '🔧', 'label': 'Plumber', 'selected': false, 'nvq': 1},
    {'icon': '⚡', 'label': 'Electrician', 'selected': false, 'nvq': 1},
    {'icon': '🪵', 'label': 'Carpenter', 'selected': false, 'nvq': 1},
    {'icon': '🎨', 'label': 'Painter', 'selected': false, 'nvq': 1},
    {'icon': '❄️', 'label': 'AC Repair', 'selected': false, 'nvq': 1},
    {'icon': '🧹', 'label': 'Cleaner', 'selected': false, 'nvq': 1},
  ];

  bool _certificateUploaded = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Registration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondary.withOpacity(0.2),
                      AppColors.primary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.secondary.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.engineering_rounded,
                        color: AppColors.secondary, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Join as a Worker',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Register your skills and start earning',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Personal details
              _buildSectionTitle('Personal Details'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline_rounded,
                validator: (v) =>
                    v!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v!.isEmpty ? 'Please enter your phone' : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _addressController,
                label: 'Your Area / Address',
                icon: Icons.location_on_outlined,
                validator: (v) =>
                    v!.isEmpty ? 'Please enter your area' : null,
              ),
              const SizedBox(height: 24),

              // Category selection
              _buildSectionTitle('Select Your Skills'),
              const SizedBox(height: 4),
              const Text(
                'Choose all categories you can work in',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.95,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat['selected'] as bool;
                  return GestureDetector(
                    onTap: () => setState(
                        () => _categories[index]['selected'] = !isSelected),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.15)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.surfaceLight,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(cat['icon'] as String,
                              style: const TextStyle(fontSize: 26)),
                          const SizedBox(height: 6),
                          Text(
                            cat['label'] as String,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(height: 4),
                            const Icon(Icons.check_circle_rounded,
                                color: AppColors.primary, size: 14),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),

              // NVQ Level for selected categories
              if (_categories.any((c) => c['selected'] == true)) ...[
                const SizedBox(height: 20),
                _buildSectionTitle('NVQ Level per Skill'),
                const SizedBox(height: 12),
                ..._categories
                    .where((c) => c['selected'] == true)
                    .map((cat) => _buildNvqSelector(cat))
                    .toList(),
              ],

              const SizedBox(height: 20),

              // Certificate upload
              _buildSectionTitle('NVQ Certificate'),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () =>
                    setState(() => _certificateUploaded = true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _certificateUploaded
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _certificateUploaded
                          ? AppColors.success
                          : AppColors.surfaceLight,
                      style: _certificateUploaded
                          ? BorderStyle.solid
                          : BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _certificateUploaded
                            ? Icons.check_circle_rounded
                            : Icons.upload_file_rounded,
                        color: _certificateUploaded
                            ? AppColors.success
                            : AppColors.textSecondary,
                        size: 36,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _certificateUploaded
                            ? 'Certificate Uploaded ✅'
                            : 'Tap to Upload Certificate',
                        style: TextStyle(
                          color: _certificateUploaded
                              ? AppColors.success
                              : AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (!_certificateUploaded)
                        const Text(
                          'NVQ Certificate (PDF or Image)',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Register button
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacementNamed(
                        context, '/worker-dashboard');
                  }
                },
                icon: const Icon(Icons.engineering_rounded),
                label: const Text('Register as Worker'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNvqSelector(Map<String, dynamic> cat) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.surfaceLight),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category name row
        Row(
          children: [
            Text(cat['icon'] as String,
                style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              cat['label'] as String,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // NVQ level buttons on second line
        Row(
          children: [
            const Text(
              'NVQ Level:',
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                children: List.generate(5, (i) {
                  final level = i + 1;
                  final isSelected = cat['nvq'] == level;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => cat['nvq'] = level),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.only(right: 4),
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            '$level',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon:
            Icon(icon, color: AppColors.textSecondary, size: 20),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.surfaceLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}