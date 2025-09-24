import 'package:abrar/utils/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '/models/address_model.dart';

class EditAddress extends StatefulWidget {
  const EditAddress({super.key, required this.address});
  final AddressModel address;

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressLineController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _mobileNumberFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();

  String? _selectedDistrict;
  bool _isLoading = false;

  // Tag selection
  final List<String> _tags = ["Home", "Work", "Other"];
  String? _selectedTag;

  @override
  void initState() {
    super.initState();
    final AddressModel address = widget.address;

    //
    _nameController.text = address.name;
    _mobileController.text = address.mobile;
    _addressLineController.text = address.addressLine;
    _selectedDistrict = address.district;
    _selectedTag = address.tag;
  }

  void _updateAddress() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final docId = widget.address.id;
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('address')
          .doc(docId)
          .update({
            'name': _nameController.text.trim(),
            'mobile': _mobileController.text.trim(),
            'district': _selectedDistrict,
            'addressLine': _addressLineController.text.trim(),
            'tag': _selectedTag, // Update the tag field
          });

      //
      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update address: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Address")),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(
                    context,
                  ).requestFocus(_mobileNumberFocusNode),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 16),

                // Mobile
                TextFormField(
                  controller: _mobileController,
                  focusNode: _mobileNumberFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Mobile',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Only numbers
                    LengthLimitingTextInputFormatter(11), // Max 11 digits
                  ],
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_addressFocusNode),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    if (value.length != 11) {
                      return 'Mobile number must be 11 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Address Line
                TextFormField(
                  controller: _addressLineController,
                  focusNode: _addressFocusNode,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Address Line',
                    hintText: 'Enter full address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter address line' : null,
                ),
                const SizedBox(height: 16),

                // District Dropdown
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'District',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: districtList
                        .map(
                          (district) => DropdownMenuItem(
                            value: district,
                            child: Text(district),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedDistrict = value),
                    value: _selectedDistrict,
                    validator: (value) =>
                        value == null ? 'Please select a district' : null,
                  ),
                ),
                const SizedBox(height: 16),

                // Address Tags
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _tags.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final tag = _tags[index];
                      final isSelected = _selectedTag == tag;
                      return ChoiceChip(
                        label: Text(tag),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            _selectedTag = tag;
                          });
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _updateAddress,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(),
                        )
                      : Text('Update Address'.toUpperCase()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
