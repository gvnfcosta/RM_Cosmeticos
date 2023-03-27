import 'package:flutter/material.dart';
import '../common_widgets/auth_form.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  //final authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  //Controladores de campos de texto
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SizedBox(
                        height: (deviceSize.height / 2.2),
                        child: Image.asset('assets/images/TelaInicial.png'),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      child: DefaultTextStyle(
                        style:
                            const TextStyle(fontSize: 25, color: Colors.pink),
                        child: AnimatedTextKit(
                          pause: Duration.zero,
                          repeatForever: true,
                          animatedTexts: [
                            FadeAnimatedText('Maquiagem'),
                            FadeAnimatedText('Cremes'),
                            FadeAnimatedText('Shampoos'),
                            FadeAnimatedText('Condicionares'),
                            FadeAnimatedText('Infantil'),
                            FadeAnimatedText('Facial'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //Formulário
              const AuthForm(),
            ],
          ),
        ),
      ),
    );
  }
}
