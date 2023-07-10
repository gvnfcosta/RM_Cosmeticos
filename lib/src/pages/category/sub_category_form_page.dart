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

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

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

    if (!isValid) return;

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Editar SubCategoria'), actions: [
        Row(
          children: [
            IconButton(onPressed: _submitForm, icon: const Icon(Icons.check)),
            IconButton(
              icon: const Icon(Icons.delete),
              iconSize: 20,
              color: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Excluir SubCategoria'),
                    content: const Text('Tem certeza?'),
                    actions: [
                      TextButton(
                          child: const Text('NÃO'),
                          onPressed: () => Navigator.of(ctx).pop()),
                      TextButton(
                        child: const Text('SIM'),
                        onPressed: () {
                          Provider.of<SubCategoryList>(context, listen: false)
                              .removeDados(ModalRoute.of(context)
                                  ?.settings
                                  .arguments as SubCategory);
                          Navigator.of(ctx).pop();
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        )
      ]),
      body: !_isLoading
          ? Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
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
                        onFieldSubmitted: (_) => _submitForm(),
                        onSaved: (name) => _formData['nome'] = name ?? '',
                        validator: (nam) {
                          final name = nam ?? '';

                          if (name.trim().isEmpty) {
                            return 'Nome é obrigatório';
                          }

                          return null;
                        }),
                  ),
                  const Text(
                    'CUIDADO',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.red),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Se você tiver cadastrado produtos com esta subcategoria e mudar o nome ou excluir deverá ter problemas',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
