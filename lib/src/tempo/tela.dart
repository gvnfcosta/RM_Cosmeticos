import 'package:flutter/material.dart';

class Tela extends StatefulWidget {
  const Tela({super.key});

  @override
  State<Tela> createState() => _TelaState();
}

class _TelaState extends State<Tela> {
  int cartItemQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Quantidade(
              qtde: cartItemQuantity,
              result: (quantity) {
                setState(() {
                  cartItemQuantity = quantity;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Quantidade extends StatelessWidget {
  const Quantidade({super.key, required this.qtde, required this.result});

  final int qtde;
  final Function(int quantity) result;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text('$qtde unid'),
      InkWell(
        onTap: () {
          int resultCount = qtde + 1;
          result(resultCount);
        },
        child: Ink(child: const Icon(Icons.add)),
      ),
    ]);
  }
}
