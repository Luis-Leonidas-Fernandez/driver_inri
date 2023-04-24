
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:inri_drivers/service/background_service.dart';

import 'package:inri_drivers/service/socket_service.dart';
import 'package:provider/provider.dart';
import 'package:inri_drivers/routes/routes.dart';

import 'package:inri_drivers/login_ui/input_decorations.dart';
import 'package:inri_drivers/providers/login_form_validar.dart';

import 'package:inri_drivers/service/auth_service.dart';
import 'package:inri_drivers/widgets/card_container.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
        
        child: Column(

          children: [

          const  SizedBox( height: 250),

            CardContainer(
              child: Column(

                children:  [

               const   SizedBox(height: 10,),

                const  Text('Inicio sesion', style: TextStyle(fontSize: 20)),

                const  SizedBox(height: 25,),

                  ChangeNotifierProvider(
                    create: (_) => LoginFormValidar(),
                    child: const _LoginForm(),
                    
                    )
                  
                 
                  
                
                ],
              )
            ),
           const SizedBox(height: 50),
            ElevatedButton(onPressed: ()=> Navigator.pushReplacementNamed(context, 'register'),
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.2))
            ),
             child: const Text('Crear una Cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
            )
          ],
        ),
        )
      )
            
      );
    
  }
}
class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {

  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final loginFormValidar = Provider.of<LoginFormValidar>(context);

    return Form(
      key: loginFormValidar.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
     child: Column(
       children: [
         
         TextFormField(
           autocorrect: false,
           keyboardType: TextInputType.emailAddress,
           decoration: InputDecorations.authInputDecoration(
             hintText: 'exequiel7@gmail.com',
             labelText: 'correo electrónico',
             prefixIcon: Icons.alternate_email_rounded,
           ),
           onChanged: (value) => loginFormValidar.email,
             validator:(value){
               String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp  = RegExp(pattern);
                  
                  return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';
             },
             controller: emailCtrl,             
           ),
         
       const  SizedBox(height: 30),
         
         TextFormField(
           autocorrect: false,
           obscureText: true,
           keyboardType: TextInputType.emailAddress,
           decoration: InputDecorations.authInputDecoration(
             hintText: '********',
             labelText: 'contraseña',
             prefixIcon: Icons.lock_outline
           ),
           onChanged: (value) => loginFormValidar.password,
            validator: ( value ) {

                  return ( value != null && value.length >= 7 ) 
                    ? null
                    : 'La contraseña debe de ser de 8 caracteres';                                    
                  
              },
              controller: passCtrl,
         ),
        const SizedBox(height: 30,),
         MaterialButton(
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
           disabledColor: Colors.grey,
           elevation: 0,
           color: Colors.purple,
           onPressed: authService.autenticando ? null : () async {


             loginOk(context);
             SocketService.instance.initSocket();
             
             final service = FlutterBackgroundService();
             final isRunning = await service.isRunning();

             if(isRunning){
              return;
             }else{
               await BackgroundService.instance.initializeService();
             }
             setState(() {});
          


             
          },
           child: Container(
             padding: const EdgeInsets.symmetric(horizontal:  80, vertical: 15),
             child: Text(
               loginFormValidar.isLoading? 'Espere'
               : 'Ingresar',
               style: const TextStyle(color: Colors.white),
             ),
           )
         )
       ],
     ) 
     );
  }
  void loginOk(BuildContext context) async {

   

  final authService = Provider.of<AuthService>(context, listen: false); 

  await authService.login(emailCtrl.text.toString(), passCtrl.text.toString());
  
  

  if (!mounted) return;
  Navigator.pushReplacementNamed(context, 'loading');
}
}

