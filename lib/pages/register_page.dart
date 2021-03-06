import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/** Services */
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';

/** Utils */
import 'package:chat_app/utils/show_alert.dart';

/** Custom Widgets */
import 'package:chat_app/widgets/boton_azul.dart';
import 'package:chat_app/widgets/custom_logo.dart';
import 'package:chat_app/widgets/custom_labels.dart';
import 'package:chat_app/widgets/custom_input.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                CustomLogo(title: 'Registro'),
                _Form(),
                CustomLabels(
                    textOne: '¿Ya tienes una cuenta?',
                    textTwo: 'Ingresa ahora!',
                    routeTwo: 'login'),
                Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Text(
                    'Terminos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),

          // TODO: Crear oton
          BotonAzul(
            textBtn: 'Crear cuenta',
            onPressed: authService.autenticando
                ? null
                : () async {
                    print(emailCtrl.text);
                    print(passCtrl.text);
                    final registroOk = await authService.register(
                      nameCtrl.text,
                      emailCtrl.text.trim(),
                      passCtrl.text.trim(),
                    );

                    if (registroOk == true) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      // Mostrar alerta
                      showSnackBar(context, registroOk);
                    }
                  },
          )
        ],
      ),
    );
  }
}
