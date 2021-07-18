import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  var _initalVal = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoding = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImgurl);
  }

  //للتعديل مره واحده واختارناها بدل initstate عشان فى بعض الاحيان لانسطيع استخدامها داخل modal route
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null)
        _editProduct = Provider.of<Products>(context).findById(productId);
      _initalVal = {
        'title': _editProduct.title,
        'description': _editProduct.description,
        'price': _editProduct.price.toString(),
        'imageUrl': _editProduct.imageUrl,
      };
      _imageUrlController.text = _editProduct.imageUrl;
    }
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();

    _imageUrlFocusNode.removeListener(_updateImgurl);
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    // _imageUrlContoller.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
  }

  void _updateImgurl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https') ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg')))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final _isval = _formKey.currentState.validate();
    if (!_isval) {
      return;
    }
    _formKey.currentState.save();

    setState(() {

      print('ok');
      _isLoding = true;
    });
    if (_editProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateDta(_editProduct.id, _editProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProd(_editProduct);
      } catch (e) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error Acurrent'),
                  content: Text('somthing went wrong'),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text('okey'))
                  ],
                ));
      }
    }

    setState(() {
      _isLoding = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Product"),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveForm,
            )
          ],
        ),
        body: _isLoding
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                          initialValue: _initalVal['title'],
                          decoration: InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'please Provide of value';
                            }
                            return null;
                          },
                          onSaved: (vale) {
                            _editProduct = Product(
                              id: _editProduct.id,
                              title: vale,
                              description: _editProduct.description,
                              price: _editProduct.price,
                              imageUrl: _editProduct.imageUrl,
                              isFavo: _editProduct.isFavo,
                            );
                          }),
                      TextFormField(
                          initialValue: _initalVal['price'],
                          decoration: InputDecoration(labelText: 'price'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'please Provide of value';
                            }
                            if (double.tryParse(val) == null) {
                              return 'Please provide number';
                            }
                            if (double.parse(val) <= 0) {
                              return 'please enter a number grater than zero .';
                            }
                            return null;
                          },
                          onSaved: (vale) {
                            _editProduct = Product(
                              id: _editProduct.id,
                              title: _editProduct.title,
                              description: _editProduct.description,
                              price: double.parse(vale),
                              imageUrl: _editProduct.imageUrl,
                              isFavo: _editProduct.isFavo,
                            );
                          }),
                      TextFormField(
                          initialValue: _initalVal['description'],
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          //  textInputAction: TextInputAction.next,
                          //  onFieldSubmitted: (_) {
                          //  FocusScope.of(context)
                          //    .requestFocus(_descriptionFocusNode);
                          //},
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'please Provide of description';
                            }
                            if (val.length < 10) {
                              return 'should be at least 10 char long ';
                            }
                            return null;
                          },
                          onSaved: (vale) {
                            _editProduct = Product(
                              id: _editProduct.id,
                              title: _editProduct.title,
                              description: vale,
                              price: _editProduct.price,
                              imageUrl: _editProduct.imageUrl,
                              isFavo: _editProduct.isFavo,
                            );
                          }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                                //   initialValue: _initalVal['description'],
                                controller: _imageUrlController,
                                decoration:
                                    InputDecoration(labelText: 'IMAGE URL'),
                                keyboardType: TextInputType.url,
                                focusNode: _imageUrlFocusNode,
                                //  textInputAction: TextInputAction.next,
                                //  onFieldSubmitted: (_) {
                                //  FocusScope.of(context)
                                //    .requestFocus(_descriptionFocusNode);
                                //},
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'please Provide of url ';
                                  }
                                  if (!val.startsWith('http') &&
                                      !val.startsWith('https')) {
                                    return 'please enter valid URL.';
                                  }
                                  if (!val.endsWith('png') &&
                                      !val.endsWith('jpg') &&
                                      !val.endsWith('jpeg')) {
                                    return 'pleas enter valid url .';
                                  }
                                  return null;
                                },
                                onSaved: (vale) {
                                  _editProduct = Product(
                                    id: _editProduct.id,
                                    title: _editProduct.title,
                                    description: _editProduct.description,
                                    price: _editProduct.price,
                                    imageUrl: vale,
                                    isFavo: _editProduct.isFavo,
                                  );
                                }),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ));
  }
}
