import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/features/addresses/cubit/addresses_cubit.dart';
import 'package:getincoffee/features/addresses/domain/model/addresses_model/datum.dart';
import 'package:getincoffee/features/addresses/presentation/widgets/update_addreess_sheet_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressItemWidget extends StatefulWidget {
  final AddresseData address;
  final Function(AddresseData) onEdit;
  final Function(int) onDelete;

  const AddressItemWidget({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<AddressItemWidget> createState() => _AddressItemWidgetState();
}

class _AddressItemWidgetState extends State<AddressItemWidget> {
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            Text(LocalizationHelper.tr.delete_address),
          ],
        ),
        content: Text(
          LocalizationHelper.tr.delete_address_confirmation,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(LocalizationHelper.tr.cancel,
                style: const TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onDelete(widget.address.id!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(LocalizationHelper.tr.delete,
                style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Accent gradient strip
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 4,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [primaryColor, primaryColor.withOpacity(0.7)],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and actions
                  Row(
                    children: [
                      // Location icon with primary color
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.location_on_rounded,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.address.addressTitle ??
                                  LocalizationHelper.tr.address,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            if (widget.address.firstName != null ||
                                widget.address.lastName != null)
                              Text(
                                '${widget.address.firstName ?? LocalizationHelper.tr.unspecified_phrase} ${widget.address.lastName ?? LocalizationHelper.tr.unspecified_phrase}'
                                    .trim(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Action buttons
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Alerts.bottomSheet(context,
                                    child: BlocProvider.value(
                                        value: AddressesCubit.get(context),
                                        child: UpdateAddreessSheetBody(
                                            addressModel: widget.address)));
                              },
                              icon: const Icon(Icons.edit_rounded),
                              color: primaryColor,
                              tooltip: LocalizationHelper.tr.edit_address,
                              style: IconButton.styleFrom(
                                minimumSize: const Size(40, 40),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 20,
                              color: Colors.grey[300],
                            ),
                            IconButton(
                              onPressed: _showDeleteDialog,
                              icon: const Icon(Icons.delete_rounded),
                              color: Colors.red[400],
                              tooltip: LocalizationHelper.tr.delete_address,
                              style: IconButton.styleFrom(
                                minimumSize: const Size(40, 40),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Address Details Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Address description
                        if (widget.address.addressDescription != null &&
                            widget.address.addressDescription!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.place_rounded,
                                  size: 18,
                                  color: primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.address.addressDescription!,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[700],
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Building details
                        Row(
                          children: [
                            Icon(
                              Icons.apartment_rounded,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Building ${widget.address.buildingNumber ?? 'N/A'} • Floor ${widget.address.floor ?? 'N/A'} • Apt ${widget.address.apartment ?? 'N/A'}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Phone number if available
                        if (widget.address.phoneNumber != null &&
                            widget.address.phoneNumber!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.phone_rounded,
                                  size: 18,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.address.phoneNumber!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
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
/* 
class AddressEditDialog extends StatefulWidget {
  final AddresseData address;
  final Function(AddresseData) onSave;

  const AddressEditDialog({
    Key? key,
    required this.address,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AddressEditDialog> createState() => _AddressEditDialogState();
}

class _AddressEditDialogState extends State<AddressEditDialog> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressTitleController;
  late TextEditingController _addressDescriptionController;
  late TextEditingController _buildingController;
  late TextEditingController _floorController;
  late TextEditingController _apartmentController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.address.firstName);
    _lastNameController = TextEditingController(text: widget.address.lastName);
    _phoneController = TextEditingController(text: widget.address.phoneNumber);
    _addressTitleController =
        TextEditingController(text: widget.address.addressTitle);
    _addressDescriptionController =
        TextEditingController(text: widget.address.addressDescription);
    _buildingController =
        TextEditingController(text: widget.address.buildingNumber);
    _floorController = TextEditingController(text: widget.address.floor);
    _apartmentController =
        TextEditingController(text: widget.address.apartment);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressTitleController.dispose();
    _addressDescriptionController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    final updatedAddress = widget.address.copyWith(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: _phoneController.text,
      addressTitle: _addressTitleController.text,
      addressDescription: _addressDescriptionController.text,
      buildingNumber: _buildingController.text,
      floor: _floorController.text,
      apartment: _apartmentController.text,
    );

    widget.onSave(updatedAddress);
    Navigator.of(context).pop();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    final primaryColor = Theme.of(context).primaryColor;

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(color: Colors.grey[600]),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 440, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.edit_location_alt_rounded,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  LocalizationHelper.tr.edit_address,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Personal Information Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocalizationHelper.tr.personal_information,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _firstNameController,
                                  label: LocalizationHelper.tr.first_name,
                                  icon: Icons.person_rounded,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTextField(
                                  controller: _lastNameController,
                                  label: LocalizationHelper.tr.last_name,
                                  icon: Icons.person_outline_rounded,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _phoneController,
                            label: LocalizationHelper.tr.phone_number,
                            icon: Icons.phone_rounded,
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Address Information Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocalizationHelper.tr.address_information,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _addressTitleController,
                            label: LocalizationHelper.tr.address_title,
                            icon: Icons.title_rounded,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _addressDescriptionController,
                            label: 'Address Description',
                            icon: Icons.description_rounded,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _buildingController,
                                  label: LocalizationHelper.tr.building,
                                  icon: Icons.apartment_rounded,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildTextField(
                                  controller: _floorController,
                                  label: LocalizationHelper.tr.floor,
                                  icon: Icons.layers_rounded,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildTextField(
                                  controller: _apartmentController,
                                  label: LocalizationHelper.tr.apartment,
                                  icon: Icons.home_rounded,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      LocalizationHelper.tr.cancel,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      LocalizationHelper.tr.save_changes,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
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
 */
