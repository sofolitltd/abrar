import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '/model/product_model.dart';
import 'add_category.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _regularPriceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _stockPriceController = TextEditingController();
  String _category = '';
  String _brand = '';
  bool isLoading = false;

  List<File> _imageFiles = [];
  final List<String> _imageUrls = [];

//
  Future<void> _pickImage() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose Image Source'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                final picker = ImagePicker();
                final pickedFiles = await picker.pickMultiImage();
                if (pickedFiles != null) {
                  setState(() {
                    _imageFiles = pickedFiles.map((x) => File(x.path)).toList();
                  });
                }
              },
              child: const Text('Gallery'),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                final picker = ImagePicker();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() {
                    _imageFiles.add(File(pickedFile.path));
                  });
                }
              },
              child: const Text('Camera'),
            ),
          ],
        );
      },
    );
  }

  //
  Future<void> _uploadImages(String productId) async {
    _imageUrls.clear(); // Clear previous URLs
    for (int i = 0; i < _imageFiles.length; i++) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('products/$productId-$i.jpg'); // Unique name for each image

      try {
        await storageRef.putFile(_imageFiles[i]);
        String downloadUrl = await storageRef.getDownloadURL();
        _imageUrls.add(downloadUrl);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 10),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // des
                TextFormField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Product Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 10),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product description';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //regular
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _regularPriceController,
                        decoration: InputDecoration(
                          labelText: 'Regular Price',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the regular price';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    // sale
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _salePriceController,
                        decoration: InputDecoration(
                          labelText: 'Sale Price',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the sale price';
                          }
                          double regularPrice =
                              double.parse(_regularPriceController.text);
                          double salePrice = double.parse(value);
                          if (regularPrice < salePrice) {
                            return 'Regular price less than sale price';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    // stock
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _stockPriceController,
                        decoration: InputDecoration(
                          labelText: 'Stock',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 10,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the stock';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // category
                Row(
                  children: [
                    //
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('categories')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(child: Text('Something wrong'));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          }

                          if (snapshot.data!.docs.isEmpty) {
                            return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black45),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 10,
                                ),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                    'No category found! Please add.'));
                          }

                          var data = snapshot.data!.docs;

                          List<String> listItem = [];
                          for (var item in data) {
                            String name = item.get('name');
                            listItem.add(name);
                          }

                          return Autocomplete(
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return listItem;
                              }
                              List<String> words = textEditingValue.text
                                  .toLowerCase()
                                  .split(' ');
                              return listItem.where((String item) {
                                // Check if all words are contained in the item
                                return words.every((word) =>
                                    item.toLowerCase().contains(word));
                              });
                            },
                            fieldViewBuilder: (BuildContext context,
                                TextEditingController textEditingController,
                                FocusNode focusNode,
                                VoidCallback onFieldSubmitted) {
                              return TextField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                onSubmitted: (value) {
                                  _category = value;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search Category ',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 10,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    //
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        showAddDialog(context, collection: 'categories');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 10,
                        ),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // brand
                Row(
                  children: [
                    //
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('brands')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(child: Text('Something wrong'));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          }

                          if (snapshot.data!.docs.isEmpty) {
                            return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black45),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 10,
                                ),
                                alignment: Alignment.centerLeft,
                                child:
                                    const Text('No brand found! Please add..'));
                          }

                          var data = snapshot.data!.docs;

                          List<String> listItem = [];
                          for (var item in data) {
                            String name = item.get('name');
                            listItem.add(name);
                          }

                          return Autocomplete(
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return listItem;
                              }
                              List<String> words = textEditingValue.text
                                  .toLowerCase()
                                  .split(' ');
                              return listItem.where((String item) {
                                // Check if all words are contained in the item
                                return words.every((word) =>
                                    item.toLowerCase().contains(word));
                              });
                            },
                            fieldViewBuilder: (BuildContext context,
                                TextEditingController textEditingController,
                                FocusNode focusNode,
                                VoidCallback onFieldSubmitted) {
                              return TextField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                onSubmitted: (value) {
                                  _brand = value;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search Brand ',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 10,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    //
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        showAddDialog(context, collection: 'brands');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 10,
                        ),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                //
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (_imageFiles != null)
                        Row(
                          children: _imageFiles.map((imageFile) {
                            return Container(
                              height: 80,
                              width: 80,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black12),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(imageFile))),
                            );
                          }).toList(),
                        ),

                      //
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 32,
                            )),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // add btn
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });

                        //
                        String id =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        await _uploadImages(id);

                        //
                        ProductModel product = ProductModel(
                          id: id,
                          name: _nameController.text.trim(),
                          description: _descriptionController.text.trim(),
                          regularPrice:
                              double.parse(_regularPriceController.text),
                          salePrice: double.parse(_salePriceController.text),
                          stockQuantity: int.parse(_stockPriceController.text),
                          images: _imageUrls,
                          category: _category,
                          brand: _brand,
                        );
                        //

                        await FirebaseFirestore.instance
                            .collection('products')
                            .doc(id)
                            .set(product.toJson())
                            .then((value) {
                          if (kDebugMode) {
                            print('Add successfully');
                          }
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: isLoading
                        ? const SizedBox(
                            height: 32,
                            width: 32,
                            child: CircularProgressIndicator())
                        : const Text('Add Product'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//category
// if (_categories.isNotEmpty)
// Container(
// padding: const EdgeInsets.only(top: 16),
// height: 50,
// child: ListView(
// shrinkWrap: true,
// scrollDirection: Axis.horizontal,
// children: _categories.map((category) {
// return Padding(
// padding: const EdgeInsets.only(right: 8),
// child: InkWell(
// onTap: () {
// _categories.remove(category);
// setState(() {});
// },
// child: Container(
// padding: const EdgeInsets.symmetric(
// vertical: 0,
// horizontal: 8,
// ),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(8),
// border: Border.all(color: Colors.black12)),
// child: Row(
// children: [
// //
// Text(
// category,
// style: const TextStyle(
// fontSize: 16, height: 1),
// ),
//
// const SizedBox(width: 4),
// //
// const Icon(
// Icons.clear,
// size: 16,
// ),
// ],
// ),
// ),
// ),
// );
// }).toList(),
// ),
// ),
