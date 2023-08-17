// import 'package:get/get.dart';

// class AuthController extends GetxController {
//   RxBool isLoading = false.obs;

//   final authRepository = AuthRepository();
//   final utilsServices = UtilsServices();

//   UserModel user = UserModel();

//   @override
//   void onInit() {
//     super.onInit();

//     validateToken();
//   }

//   Future<void> validateToken() async {
//     String? token = await utilsServices.getLocalData(key: StorageKeys.token);

//     if (token == null) {
//       Get.offAllNamed(PagesRoutes.signInRoute);
//       return;
//     }

//     AuthResult result = await authRepository.validateToken(token);

//     result.when(
//       success: (user) {
//         this.user = user;

//         saveTokenAndProceedToBase();
//       },
//       error: (message) {
//       },
//     );
//   }

//   Future<void> changePassword({
//     required String currentPassword,
//     required String newPassword,
//   }) async {
//     isLoading.value = true;

//     final result = await authRepository.changePassword(
//       email: user.email!,
//       currentPassword: currentPassword,
//       newPassword: newPassword,
//       token: user.token!,
//     );

//     isLoading.value = false;

//     if (result) {
//       utilsServices.showToast(
//         message: 'A senha foi atualizada com sucesso!',
//       );

//     } else {
//       utilsServices.showToast(
//         message: 'A senha atual está incorreta',
//         isError: true,
//       );
//     }
//   }
// }
