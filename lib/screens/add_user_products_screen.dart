//dart
import 'dart:async';

//flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//providers
import '../providers/product.dart';
import '../providers/products.dart';

class AddProductsScreen extends StatefulWidget {
  static const String route = "Add-Product";
  @override
  _AddProductsScreenState createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  final _form = GlobalKey<FormState>();

  bool _isInit = true;
  bool _isLoading = false;

  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final TextEditingController _imgUrlControler = TextEditingController();
  final FocusNode _imgUrlFocusNode = FocusNode();
  final FocusNode _titleFocusNode = FocusNode();

  Product _editedProduct =
      Product(id: null, title: "", price: 0, description: "", imageUrl: "");

  var _initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imgUrl': '',
  };

  @override
  void initState() {
    _imgUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          //'imgUrl': _editedProduct.imageUrl,
        };
        _imgUrlControler.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imgUrlFocusNode.dispose();
    _imgUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imgUrlControler.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imgUrlFocusNode.hasFocus) {
      if (_imgUrlControler.text.isEmpty ||
          !_imgUrlControler.text.startsWith('http') &&
              !_imgUrlControler.text.startsWith('https') ||
          (!_imgUrlControler.text.endsWith('.png') &&
              !_imgUrlControler.text.endsWith('.jpg') &&
              !_imgUrlControler.text.endsWith('.jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if(_editedProduct.id != null) {
    try{

      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);

    } catch(error){

      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error Occurred"),
            content: Text("Something went wrong error " + error.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } finally {

        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error Occurred"),
            content: Text("Something went wrong error " + error.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Product",
          style: Theme.of(context).appBarTheme.textTheme.title,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).primaryColor)),
                            child: _imgUrlControler.text.isEmpty
                                ? Text("Enter a Url")
                                : FittedBox(
                                    child: Image.network(_imgUrlControler.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              //initialValue: _initValue['imgUrl'], Não pode por causa do controlador
                              decoration: InputDecoration(
                                labelText: "Image Url",
                                labelStyle:
                                    Theme.of(context).textTheme.subtitle,
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter an image URL.";
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return "Please enter a valid URL.";
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return "Please enter an valid image URL";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.next,
                              controller: _imgUrlControler,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_titleFocusNode);
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: value,
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: _initValue['title'],
                        decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: Theme.of(context).textTheme.subtitle,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please provide a Title";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        focusNode: _titleFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: value,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['price'],
                        decoration: InputDecoration(
                          labelText: "Price",
                          labelStyle: Theme.of(context).textTheme.subtitle,
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter a Price";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          } else if (double.parse(value) <= 0) {
                            return "Please enter a number greater than zero";
                          }
                          return null;
                        },
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value),
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['description'],
                        decoration: InputDecoration(
                          labelText: "Description",
                          labelStyle: Theme.of(context).textTheme.subtitle,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter a Description";
                          }
                          if (value.length < 10) {
                            return "Description should be al least 10 characters long";
                          }
                          return null;
                        },
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _saveForm,
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            description: value,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
