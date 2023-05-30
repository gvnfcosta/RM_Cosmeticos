import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Editar SubCategorias'), actions: [
        IconButton(onPressed: _submitForm, icon: const Icon(Icons.check))
      ]),
      body: Center(
        child: !_isLoading
            ? Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextFormField(
                      style: const TextStyle(fontSize: 14),
                      initialValue: _formData['nome']?.toString(),
                      decoration: InputDecoration(
                          labelText: 'Nome',
                          labelStyle: const TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      textInputAction: TextInputAction.next,
                      focusNode: _nomeFocus,
                      onFieldSubmitted: (_) {
                        _submitForm;
                      },
                      onSaved: (name) => _formData['nome'] = name ?? '',
                      validator: (nam) {
                        final name = nam ?? '';

                        if (name.trim().isEmpty) {
                          return 'Nome é obrigatório';
                        }

                        return null;
                      }),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
