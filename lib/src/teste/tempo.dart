import 'package:flutter/material.dart';

class Component extends StatelessWidget {
  const Component({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border.fromBorderSide(
          BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            margin: const EdgeInsets.only(right: 4),
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
          ),
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.notifications,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




// import 'package:flutter/material.dart';

// class InputCustomWidget extends StatelessWidget {
//   const InputCustomWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(8),
//       child: TextFormField(
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(
//               color: Colors.grey.shade400,
//             ),
//           ),
//           prefixIcon: Row(
//             children: [
//               Container(
//                 width: 15,
//                 height: 60,
//                 color: Colors.red,
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(left: 5),
//                 child: Icon(
//                   Icons.notifications,
//                   color: Colors.black,
//                 ),
//               )
//             ],
//           ),
//         ),
//         onTapOutside: (e) => FocusScope.of(context).unfocus(),
//       ),
//     );
//   }
// }


 // Product(
  //   id: '1',
  //   code: 'RM 31378',
  //   description: '1 Pincel G, 1 Esponja coxinha, 2 Esponja base',
  //   category: 'kits',
  //   imgUrl:
  //       'https://firebasestorage.googleapis.com/v0/b/rmapp-3284d.appspot.com/o/c-97.png?alt=media&token=daafe9f1-573f-42a1-aed8-a78fdbc95546',
  //   name: 'Kit C-97',
  //   price: 9.95,
  //   show: true,
  //   unit: 'un',
  // ),
  // Product(
  //   id: '2',
  //   code: 'RM 33952',
  //   description: '1 Brilho M Pink, 1 Batom DiscoTeen, 2 Xuxinha Pompom',
  //   category: 'kits',
  //   imgUrl:
  //       'https://firebasestorage.googleapis.com/v0/b/rmapp-3284d.appspot.com/o/p-66.png?alt=media&token=baf15781-8f06-43a4-8c50-6ef017da07b7',
  //   name: 'Kit P-66',
  //   price: 8.10,
  //   show: true,
  //   unit: 'un',
  // ),
  // Product(
  //   id: '3',
  //   code: 'RM 34096',
  //   description: '1 Brilho M Pink, 1 Batom DiscoTeen, 2 Xuxinha Pompom',
  //   category: 'kits',
  //   imgUrl:
  //       'https://firebasestorage.googleapis.com/v0/b/rmapp-3284d.appspot.com/o/p-80.png?alt=media&token=b550dffe-ec54-445a-b334-f18b80ae7333',
  //   name: 'Kit P-80',
  //   price: 8.10,
  //   show: true,
  //   unit: 'un',
  // ),
  // Product(
  //   id: '4',
  //   code: 'RM 28484',
  //   description:
  //       '1 Esmalte infantil, 1 Kit Elástico Color, 1 Batom Discoteen, 1 Brilho moranguinho',
  //   category: 'kits',
  //   imgUrl:
  //       'https://firebasestorage.googleapis.com/v0/b/rmapp-3284d.appspot.com/o/cm-1.png?alt=media&token=433d63d3-4c7d-4dba-8682-4106bb64d243',
  //   name: 'Kit CM-1',
  //   price: 11.95,
  //   show: true,
  //   unit: 'un',
  // ),
  // Product(
  //   id: '5',
  //   code: 'RM 31392',
  //   description: '1 Elástico Colorido, 2 Moranguinho Neon',
  //   category: 'kits',
  //   imgUrl:
  //       'https://firebasestorage.googleapis.com/v0/b/rmapp-3284d.appspot.com/o/presente%2019.png?alt=media&token=a100dd28-a580-4cb3-8e9b-24a0480b1d97',
  //   name: 'Kit PRESENTE 19',
  //   price: 11.95,
  //   show: true,
  //   unit: 'un',
  // ),