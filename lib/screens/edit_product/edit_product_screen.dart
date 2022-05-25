// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '/other/models.dart';
import '/other/random_generator.dart';
import '/providers/products_provider.dart';
import '/providers/user_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  final String currentProductId;

  const EditProductScreen({Key? key, this.currentProductId = ""})
      : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  File? _fileImage;
  final ImagePicker _picker = ImagePicker();
  void pickImage(BuildContext context, ImageSource src) async {
    _picker
        .getImage(
      source: src,
    )
        .then((value) {
      if (value != null) {
        setState(() {
          _fileImage = File(value.path);
        });
      }
    });
  }

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _product = {
    "productId": "",
    "productName": "",
    "productDescription": "",
    "productPrice": 0,
    "productImageUrl": "",
  };

  bool _isLoading = false;
  @override
  void initState() {
    if (widget.currentProductId != "") {
      _product = Provider.of<ProductProvider>(context, listen: false)
          .findById(widget.currentProductId)
          .toMap();
    }
    super.initState();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _fileImage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.currentProductId == "" ? "Add Product" : "Edit Product"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              await _saveForm(context);

              _isLoading = false;
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.currentProductId == "" && _fileImage != null
                            ? CircleAvatar(
                                minRadius: 50,
                                maxRadius: 100,
                                backgroundColor: Colors.black38,
                                backgroundImage: FileImage(_fileImage!),
                                // child: ClipRRect(
                                //     child: Image.file(
                                //       _fileImage!,
                                //     ),
                                //     borderRadius:
                                //         BorderRadius.all(Radius.circular(10))),
                              )
                            : _product['productImageUrl'] == ''
                                ? CircleAvatar(
                                    minRadius: 50,
                                    maxRadius: 100,
                                  )
                                : CircleAvatar(
                                    minRadius: 50,
                                    maxRadius: 100,
                                    backgroundImage: NetworkImage(
                                        _product['productImageUrl']),
                                  )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () => picModalSheet(context),
                            child: const Text("Choose Picture"))
                      ],
                    ),
                    TextFormField(
                      initialValue: _product["productName"],
                      decoration: const InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please type a value";
                        }
                        return null;
                      },
                      onSaved: (name) {
                        _product["productName"] = name;
                      },
                    ),
                    TextFormField(
                      initialValue: _product["productPrice"] == 0
                          ? ""
                          : _product["productPrice"].toString(),
                      decoration: const InputDecoration(labelText: "Price"),
                      focusNode: _priceFocusNode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a price";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please enter a valid price";
                        }
                        if (double.parse(value) <= 0) {
                          return "Please enter a number greater than 0";
                        }
                        return null;
                      },
                      onSaved: (price) {
                        _product["productPrice"] =
                            double.parse(price.toString());
                      },
                    ),
                    TextFormField(
                      initialValue: _product["productDescription"],
                      decoration:
                          const InputDecoration(labelText: "Description"),
                      focusNode: _descriptionFocusNode,
                      // keyboardType: TextInputType.multiline,
                      onFieldSubmitted: (_) {
                        if (_product["productImageUrl"] == "" &&
                            _fileImage == null) {
                          picModalSheet(context);
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a description";
                        }
                        if (value.length <= 10) {
                          return "Description is too short";
                        }
                        return null;
                      },
                      onSaved: (description) {
                        _product["productDescription"] = description;
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void picModalSheet(BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        context: context,
        builder: (ctx) => Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Text("Product photo",
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(left: 15)),
                        ),
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                        ),
                        label: const Text("Camera"),
                        onPressed: () {
                          pickImage(context, ImageSource.camera);
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton.icon(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.only(left: 15),
                          ),
                        ),
                        icon: const Icon(
                          Icons.photo,
                        ),
                        label: const Text("Gellary"),
                        onPressed: () {
                          pickImage(context, ImageSource.gallery);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }

  Future<void> _saveForm(BuildContext ctx) async {
    final isVaild = _formKey.currentState!.validate();
    if (!isVaild) {
      return;
    }
    if (_product["productImageUrl"] == "" && _fileImage == null) {
      ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        content: Text("Please choose a picture first."),
        duration: Duration(milliseconds: 1500),
      ));
      return;
    } else {
      _formKey.currentState!.save();
      if (_fileImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${RGenerator().getRandomString(25)}.jpg');
        await ref.putFile(_fileImage!);

        await ref.getDownloadURL().then((url) {
          if (widget.currentProductId != "") {
            FirebaseStorage.instance
                .ref()
                .child('user_image')
                .child(_product['productImageUrl'])
                .delete();
          }
          _product['productImageUrl'] = url;
        });
      }

      var prov = Provider.of<UserProvider>(context, listen: false);
      _product.addAll({
        "creatorId": FirebaseAuth.instance.currentUser!.uid,
        "creatorName": prov.userName,
        "creatorImageUrl": prov.userImageUrl,
        "isFavorite": false,
      });

      if (widget.currentProductId != "") {
        await Provider.of<ProductProvider>(context, listen: false)
            .updateProduct(
                _product["productId"], ProductItem.fromMap(_product));
      } else {
        await Provider.of<ProductProvider>(context, listen: false)
            .addProduct(ProductItem.fromMap(_product));
      }
      Navigator.pop(ctx);
    }
  }
}
