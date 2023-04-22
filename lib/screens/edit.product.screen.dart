import 'package:ecom_shop_app/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/Product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routeName = '/EditProductScreen';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _pricefocusnode = FocusNode();
  final _descriptionfocusnode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlfocusnode = FocusNode();
  final _form = GlobalKey<FormState>();
  // ignore: prefer_final_fields
  var _editedProducts = Product(
    // ignore: null_check_always_fails
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: 'url',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = false;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlfocusnode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // Modal route cannot be called in init, so we are using didChangeDependencies,
    //but to prevent it getting called againa and again we are using _isInIt
    if (_isInit) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final productId = ModalRoute.of(context)!.settings.arguments as String;
        if (productId != null) {
          _editedProducts =
              Provider.of<Products>(context, listen: false).findById(productId);

          //for setting the initial values from the textfiled
          _initValues = {
            'title': _editedProducts.title,
            'description': _editedProducts.description,
            'price': _editedProducts.price.toString(),
            // 'imageUrl': _editedProduct.imageUrl,
            'imageUrl': '',
          };
          _imageUrlController.text = _editedProducts.imageUrl;
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pricefocusnode.dispose();
    _descriptionfocusnode.dispose();
    _imageUrlController.dispose();
    _imageUrlfocusnode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlfocusnode.hasFocus) {
      if (!_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('https') &&
              !_imageUrlController.text.startsWith('http')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpeg') &&
              !_imageUrlController.text.endsWith('.jpg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProducts.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProducts.id.toString(), _editedProducts);

      // Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProducts);
      } catch (error) {
        return showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(' An Error! Occured'),
                  content: Text('something went Wrong!'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Okay!')),
                  ],
                ));
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
    // if (_editedProducts.id!.isEmpty) {
    //   //add newly added item
    // }
    // print(_editedProduct.id);
    // print(_editedProduct.imageUrl);
    // print(_editedProduct.price);
    // print(_editedProducts.id!.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
              onPressed: _saveForm, icon: Icon(Icons.cloud_download_rounded)),
        ],
      ),
      body: _isLoading
          // ignore: prefer_const_constructors
          ? Center(
              // ignore: prefer_const_constructors
              child: CircularProgressIndicator(
                color: Colors.redAccent,
                backgroundColor: Colors.black,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a Text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_pricefocusnode);
                        },
                        onSaved: (newValue) {
                          _editedProducts = Product(
                            title: newValue as String,
                            description: _editedProducts.description,
                            price: _editedProducts.price,
                            imageUrl: _editedProducts.imageUrl,
                            id: _editedProducts.id,
                            isFavorite: _editedProducts.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter a Price For Product';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please Enter a Valid Number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please Enter a Number greater than Zero';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _pricefocusnode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionfocusnode);
                        },
                        onSaved: (newValue) {
                          _editedProducts = Product(
                            title: _editedProducts.title,
                            description: _editedProducts.description,
                            price: double.parse(newValue as String),
                            imageUrl: _editedProducts.imageUrl,
                            id: _editedProducts.id,
                            isFavorite: _editedProducts.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Add a Description';
                          }
                          if (value.length <= 10) {
                            return 'Please Enter atleast 10 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionfocusnode,
                        onSaved: (newValue) {
                          _editedProducts = Product(
                            title: _editedProducts.title,
                            description: newValue as String,
                            price: _editedProducts.price,
                            imageUrl: _editedProducts.imageUrl,
                            id: _editedProducts.id,
                            isFavorite: _editedProducts.isFavorite,
                          );
                        },
                        //textInputAction: TextInputAction.next,
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context).requestFocus(_descriptionfocusnode);
                        // },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black87),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text(
                                    'Enter a Url',
                                    textAlign: TextAlign.center,
                                  )
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              //initialValue: _initValues['imageUrl'],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter a Image Url Address';
                                }
                                if (!value.startsWith('https') &&
                                    !value.startsWith('http')) {
                                  return 'Please enter a vaild Url';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpeg') &&
                                    !value.endsWith('.jpg')) {
                                  return 'Please enter a vaild Image Url';
                                }
                                return null;
                              },
                              decoration:
                                  InputDecoration(labelText: 'Image Url'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlfocusnode,
                              onFieldSubmitted: (_) => _saveForm,
                              onSaved: (newValue) {
                                _editedProducts = Product(
                                  title: _editedProducts.title,
                                  description: _editedProducts.description,
                                  price: _editedProducts.price,
                                  imageUrl: newValue as String,
                                  id: _editedProducts.id,
                                  isFavorite: _editedProducts.isFavorite,
                                );
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
