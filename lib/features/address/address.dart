import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/models/address_model.dart';
import '../../routes/app_route.dart';

class AddressPage extends ConsumerWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Address')),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () => context.push(AppRoute.addAddress.path),
          child: const Text("Add Address"),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('address')
            .snapshots(),
        builder: (context, addrSnap) {
          if (addrSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!addrSnap.hasData || addrSnap.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Text("No address found!")],
              ),
            );
          }

          final addresses = addrSnap.data!.docs
              .map(
                (doc) => AddressModel.fromMap(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList();

          // Listen to user's defaultAddressId
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .snapshots(),
            builder: (context, userSnap) {
              if (!userSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final userData =
                  userSnap.data!.data() as Map<String, dynamic>? ?? {};
              final defaultId = userData['defaultAddressId'] as String?;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Please select your address'),
                    ),

                    //
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final addressModel = addresses[index];
                        final isSelected = addressModel.id == defaultId;

                        return GestureDetector(
                          onTap: () async {
                            // 🔥 Update Firestore defaultAddressId
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .update({'defaultAddressId': addressModel.id});
                          },
                          child: Stack(
                            alignment: AlignmentGeometry.bottomRight,
                            children: [
                              //
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  10,
                                  10,
                                  10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue.shade50
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.black12,
                                    width: isSelected ? 2 : 2,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle_outline
                                          : Icons.circle_outlined,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        spacing: 4,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 1,
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              // color: Colors.green,
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text("${addressModel.tag}"),
                                          ),

                                          SizedBox(height: 2),
                                          Text(
                                            addressModel.name.toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Mobile: ${addressModel.mobile}",
                                          ),
                                          Text(
                                            "Address:${addressModel.addressLine}",
                                          ),
                                          Text(
                                            "District: ${addressModel.district}",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(uid)
                                          .collection('address')
                                          .doc(addressModel.id)
                                          .delete();

                                      // if add id == defaultAddressId ten del
                                      if (addressModel.id == defaultId) {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(uid)
                                            .update({'defaultAddressId': ""});
                                      }
                                    },
                                  ),

                                  //edit button
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      context.push(
                                        AppRoute.editAddress.path,
                                        extra: addressModel,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
