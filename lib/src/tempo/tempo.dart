// import 'package:flutter/material.dart';

// class Component extends StatelessWidget {
//   const Component({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 60,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: const Border.fromBorderSide(
//           BorderSide(
//             width: 1,
//             color: Colors.grey,
//           ),
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 20,
//             margin: const EdgeInsets.only(right: 4),
//             decoration: const BoxDecoration(
//               color: Colors.red,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(8),
//                 bottomLeft: Radius.circular(8),
//               ),
//             ),
//           ),
//           const Expanded(
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Icon(
//                 Icons.notifications,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




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
