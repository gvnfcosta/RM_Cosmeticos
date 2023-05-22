import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../models/sub_category_list.dart';
import '/src/models/category_list.dart';
import '../../models/product_list.dart';
import '/src/models/product_model.dart';
import '../../config/custom_colors.dart';
import '/src/services/utils_services.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final utilsServices = UtilsServices();

  final bool _readOnly = false;
  bool _isLoading = false;

  final _codeFocus = FocusNode();
  final _nameFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _categoryFocus = FocusNode();
  final _offerFocus = FocusNode();
  final _subCategoryFocus = FocusNode();
  final _priceFocus = FocusNode();
  final _unitFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  List unidades = ['Un', 'Kit', 'Cx'];
  List ofertas = ['De Linha', 'Promoção', 'Queima'];

  String? selectedUnidade;
  String? selectedOffer;
  String? selectedCategoria;
  String? selectedSubCategoria;

  @override
  void initState() {
    super.initState();
    Provider.of<CategoryList>(context, listen: false)
        .loadCategories()
        .then((value) {
      setState(() {
        _isLoading = false;
        _imageUrlFocus.addListener(updateImage);
      });
    });
    Provider.of<SubCategoryList>(context, listen: false).loadSubCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      _formData['show'] = true;
      _formData['unit'] = 'Un';
      _formData['offer'] = 'De Linha';

      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['code'] = product.code;
        _formData['name'] = product.name;
        _formData['description'] = product.description;
        _formData['category'] = product.category;
        _formData['subCategory'] = product.subCategory;
        _formData['offer'] = product.offer;
        _formData['price'] = product.price;
        _formData['unit'] = product.unit;
        _formData['show'] = product.show;
        _formData['imageUrl'] = product.imageUrl;
        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _codeFocus.dispose();
    _nameFocus.dispose();
    _descriptionFocus.dispose();
    _categoryFocus.dispose();
    _offerFocus.dispose();
    _subCategoryFocus.dispose();
    _priceFocus.dispose();
    _unitFocus.dispose();
    _imageUrlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl; //&& endsWithFile;
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<ProductList>(context, listen: false)
          .saveProduct(_formData);
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('ERRO!'),
          content: const Text('Erro na gravação dos dados'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    final CategoryList categoria = Provider.of(context);
    final SubCategoryList subCategoria = Provider.of(context);

    selectedUnidade = _formData['unit']?.toString();
    selectedOffer = _formData['offer']?.toString();
    selectedCategoria = _formData['category']?.toString();
    selectedSubCategoria = _formData['subCategory']?.toString();

    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      appBar: AppBar(
          title: const Text('Editar Produtos'),
          elevation: 0,
          actions: [
            IconButton(onPressed: _submitForm, icon: const Icon(Icons.check))
          ]),
      body: SingleChildScrollView(
        child: SizedBox(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: _imageUrlController.text.isEmpty
                      ? const Center(
                          child: Text(
                            'Informe os dados',
                            style: TextStyle(fontSize: 25),
                          ),
                        )
                      : Image.network(_imageUrlController.text),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade600,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: !_isLoading
                    ? Form(
                        key: _formKey,
                        child: Container(
                          height: 430,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5.0, right: 5.0),
                                      child: SizedBox(
                                        height: 40,
                                        child: TextFormField(
                                            style:
                                                const TextStyle(fontSize: 14),
                                            initialValue:
                                                _formData['code']?.toString(),
                                            decoration: InputDecoration(
                                                labelText: 'Código RM',
                                                labelStyle: const TextStyle(
                                                    fontSize: 12),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8))),
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: _codeFocus,
                                            onFieldSubmitted: (_) {
                                              FocusScope.of(context)
                                                  .requestFocus(_nameFocus);
                                            },
                                            onSaved: (code) =>
                                                _formData['code'] = code ?? '',
                                            validator: (cod) {
                                              final code = cod ?? '';

                                              if (code.trim().isEmpty) {
                                                return 'Código é obrigatório';
                                              }

                                              return null;
                                            }),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5.0, right: 5.0),
                                      child: SizedBox(
                                        height: 40,
                                        child: TextFormField(
                                            style:
                                                const TextStyle(fontSize: 14),
                                            initialValue:
                                                _formData['price']?.toString(),
                                            decoration: InputDecoration(
                                                labelText: 'Preço',
                                                labelStyle: const TextStyle(
                                                    fontSize: 12),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8))),
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: _priceFocus,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                              decimal: true,
                                              signed: true,
                                            ),
                                            onFieldSubmitted: (_) {
                                              FocusScope.of(context)
                                                  .requestFocus(_unitFocus);
                                            },
                                            onSaved: (price) =>
                                                _formData['price'] =
                                                    double.parse(price ?? '0'),
                                            validator: (pric) {
                                              final priceString = pric ?? '';
                                              final price = double.tryParse(
                                                      priceString) ??
                                                  -1;

                                              if (price <= 0) {
                                                return 'Informe um preço válido';
                                              }

                                              return null;
                                            }),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 8.0, right: 8.0),
                                      child: Container(
                                        height: 40,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.black38,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: DropdownButtonHideUnderline(
                                          child: SizedBox(
                                            width: 80,
                                            child: DropdownButton2(
                                              focusNode: _unitFocus,
                                              dropdownElevation: 12,
                                              hint: Text('Unidade',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Theme.of(context)
                                                          .hintColor)),
                                              items: unidades
                                                  .map((item) =>
                                                      DropdownMenuItem<String>(
                                                          value: item,
                                                          child: Text(item,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14))))
                                                  .toList(),
                                              value: selectedUnidade,
                                              onChanged: (value) {
                                                setState(
                                                  () {
                                                    selectedUnidade =
                                                        value as String;
                                                    _formData['unit'] = value;
                                                  },
                                                );
                                              },
                                              buttonHeight: 30,
                                              buttonWidth: 10,
                                              itemHeight: 30,
                                              autofocus: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8.0, right: 8.0),
                                    child: Container(
                                      height: 40,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.black38,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: DropdownButtonHideUnderline(
                                        child: SizedBox(
                                          width: 80,
                                          child: DropdownButton2(
                                            focusNode: _offerFocus,
                                            dropdownElevation: 12,
                                            hint: Text('Oferta',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Theme.of(context)
                                                        .hintColor)),
                                            items: ofertas
                                                .map((item) =>
                                                    DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(item,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14))))
                                                .toList(),
                                            value: selectedOffer,
                                            onChanged: (value) {
                                              setState(
                                                () {
                                                  selectedOffer =
                                                      value as String;
                                                  _formData['offer'] = value;
                                                },
                                              );
                                            },
                                            buttonHeight: 30,
                                            buttonWidth: 10,
                                            itemHeight: 30,
                                            autofocus: true,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.visibility,
                                          color: Colors.indigo,
                                        ),
                                        Switch(
                                            value: _formData['show'] as bool,
                                            activeColor: Colors.blue,
                                            onChanged: (bool value) {
                                              setState(() {
                                                _formData['show'] = value;
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8.0, right: 8.0),
                                    child: SizedBox(
                                      child: Container(
                                        height: 40,
                                        width: 200,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.black38,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: DropdownButtonHideUnderline(
                                          child: SizedBox(
                                            width: 120,
                                            child: DropdownButton2(
                                              focusNode: _unitFocus,
                                              dropdownElevation: 12,
                                              hint: Text('Categoria',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Theme.of(context)
                                                          .hintColor)),
                                              items: categoria.items
                                                  .map((item) =>
                                                      DropdownMenuItem<String>(
                                                          value: item.nome,
                                                          child: Text(item.nome,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14))))
                                                  .toList(),
                                              value: selectedCategoria,
                                              onChanged: (value) {
                                                setState(
                                                  () {
                                                    selectedCategoria =
                                                        value as String;
                                                    _formData['category'] =
                                                        value;
                                                  },
                                                );
                                              },
                                              buttonHeight: 30,
                                              buttonWidth: 10,
                                              itemHeight: 30,
                                              autofocus: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: SizedBox(
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.black38,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: DropdownButtonHideUnderline(
                                            child: SizedBox(
                                              //width: 120,
                                              child: DropdownButton2(
                                                focusNode: _subCategoryFocus,
                                                dropdownElevation: 12,
                                                hint: Text('SubCategoria',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                items: subCategoria.items
                                                    .map((item) => DropdownMenuItem<
                                                            String>(
                                                        value: item.nome,
                                                        child: Text(item.nome,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14))))
                                                    .toList(),
                                                value: selectedSubCategoria,
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      selectedSubCategoria =
                                                          value as String;
                                                      _formData['subCategory'] =
                                                          value;
                                                    },
                                                  );
                                                },
                                                buttonHeight: 30,
                                                buttonWidth: 10,
                                                itemHeight: 30,
                                                autofocus: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: SizedBox(
                                  height: 40,
                                  child: TextFormField(
                                      style: const TextStyle(fontSize: 14),
                                      initialValue:
                                          _formData['name']?.toString(),
                                      decoration: InputDecoration(
                                          labelText: 'Nome',
                                          labelStyle:
                                              const TextStyle(fontSize: 12),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      textInputAction: TextInputAction.next,
                                      focusNode: _nameFocus,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_offerFocus);
                                      },
                                      onSaved: (name) =>
                                          _formData['name'] = name ?? '',
                                      validator: (nam) {
                                        final name = nam ?? '';

                                        if (name.trim().isEmpty) {
                                          return 'Nome é obrigatório';
                                        }

                                        return null;
                                      }),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: TextFormField(
                                    maxLines: 3,
                                    style: const TextStyle(fontSize: 14),
                                    initialValue:
                                        _formData['imgUrl']?.toString(),
                                    decoration: InputDecoration(
                                        labelText: 'Url da Imagem',
                                        labelStyle:
                                            const TextStyle(fontSize: 12),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    keyboardType: TextInputType.url,
                                    textInputAction: TextInputAction.done,
                                    focusNode: _imageUrlFocus,
                                    controller: _imageUrlController,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_imageUrlFocus);
                                    },
                                    onSaved: (imageUrl) =>
                                        _formData['imageUrl'] = imageUrl ?? '',
                                    validator: (imageUr) {
                                      final imageUrl = imageUr ?? '';

                                      if (!isValidImageUrl(imageUrl)) {
                                        return 'Informe uma Url válida!';
                                      }

                                      return null;
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: TextFormField(
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 14),
                                    initialValue:
                                        _formData['description']?.toString(),
                                    decoration: InputDecoration(
                                        labelText: 'Descrição',
                                        labelStyle:
                                            const TextStyle(fontSize: 12),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _descriptionFocus,
                                    onFieldSubmitted: (_) => _submitForm(),
                                    onSaved: (description) =>
                                        _formData['description'] =
                                            description ?? '',
                                    validator: (descriptio) {
                                      final description = descriptio ?? '';

                                      if (description.trim().isEmpty) {
                                        return 'Descrição é obrigatório';
                                      }

                                      return null;
                                    }),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
