import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/custom_colors.dart';
import '../../models/sub_category_list.dart';
import '../../models/sub_category_model.dart';

class SubCategoryFormPage extends StatefulWidget {
  const SubCategoryFormPage({Key? key}) : super(key: key);

  @override
  State<SubCategoryFormPage> createState() => _SubCategoryFormPageState();
}

class _SubCategoryFormPageState extends State<SubCategoryFormPage> {
  final _nomeFocus = FocusNode();
  final _imageUrlFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  final _imageUrlController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<SubCategoryList>(context, listen: false).loadSubCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final subCategory = arg as SubCategory;
        _formData['id'] = subCategory.id;
        _formData['nome'] = subCategory.nome;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nomeFocus.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<SubCategoryList>(context, listen: false)
          .saveSubCategories(_formData);
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
            'Editar SubCategorias',
            style: TextStyle(fontSize: 13),
          ),
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
                child: Container(
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: !_isLoading
                      ? Container(
                          height: 100,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: SizedBox(
                                    child: TextFormField(
                                        style: const TextStyle(fontSize: 14),
                                        initialValue:
                                            _formData['nome']?.toString(),
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
                                          _submitForm;
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
                              ],
                            ),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
