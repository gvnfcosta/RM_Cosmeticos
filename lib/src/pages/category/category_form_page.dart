import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/custom_colors.dart';
import '../../models/category_list.dart';
import '../../models/category_model.dart';

class CategoryFormPage extends StatefulWidget {
  const CategoryFormPage({Key? key}) : super(key: key);

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _nomeFocus = FocusNode();
  final _imageUrlFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  final _imageUrlController = TextEditingController();

  bool _isLoading = false;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final category = arg as Category;
        _formData['id'] = category.id;
        _formData['nome'] = category.nome;
        _formData['imageUrl'] = category.imageUrl;
        _imageUrlController.text = category.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nomeFocus.dispose();
    _imageUrlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  bool _isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl; //&& endsWithFile;
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<CategoryList>(context, listen: false)
          .saveCategories(_formData);
    } catch (error) {
      await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: const Text('ERRO!'),
                  content: const Text('Erro na gravação dos dados'),
                  actions: [
                    TextButton(
                        child: const Text('Ok'),
                        onPressed: () => Navigator.of(context).pop())
                  ]));
    } finally {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      appBar: AppBar(
          title: const Text(
            'Editar Categorias',
            style: TextStyle(fontSize: 13),
          ),
          actions: [
            IconButton(onPressed: _submitForm, icon: const Icon(Icons.save))
          ]),
      body: SingleChildScrollView(
        child: SizedBox(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  //       height: deviceSize.height / 2,
                  child: _imageUrlController.text.isEmpty
                      ? const Center(
                          child: Text(
                            'Informe os dados',
                            style: TextStyle(fontSize: 25),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
              ),
              Container(
                height: 200,
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: !_isLoading
                    ? Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: SizedBox(
                                child: TextFormField(
                                    style: const TextStyle(fontSize: 14),
                                    initialValue: _formData['nome']?.toString(),
                                    decoration: InputDecoration(
                                        labelText: 'Nome',
                                        labelStyle:
                                            const TextStyle(fontSize: 12),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    textInputAction: TextInputAction.next,
                                    focusNode: _nomeFocus,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_imageUrlFocus);
                                    },
                                    onSaved: (name) =>
                                        _formData['nome'] = name ?? '',
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
                                decoration: InputDecoration(
                                    labelText: 'Url da Imagem',
                                    labelStyle: const TextStyle(fontSize: 12),
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

                                  if (!_isValidImageUrl(imageUrl)) {
                                    return 'Informe uma Url válida!';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ],
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
