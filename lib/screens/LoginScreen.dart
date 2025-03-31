import 'package:flutter/material.dart';
import 'package:proyecto_libreria/screens/signup.dart';
import 'package:proyecto_libreria/screens/menu.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Text Editing Controller
  final username = TextEditingController();
  final password = TextEditingController();
  bool Visibilidad = false;
  bool Inicio = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromRGBO(11, 131, 125, 1),
          width: 5,
        ), // Borde alrededor de la pantalla
      ),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    //Logo
                    Image.asset("../lib/assets/logo.jpg", width: 200),
                    const SizedBox(height: 15),

                    //Usuario
                    Container(
                      margin: EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromRGBO(11, 131, 125, 0.2),
                      ),
                      child: TextFormField(
                        controller: username,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Usuario no puede estar vacío";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          border: InputBorder.none,
                          hintText: "Usuario",
                        ),
                      ),
                    ),

                    //Contraseña
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromRGBO(11, 131, 125, 0.3),
                      ),
                      child: TextFormField(
                        controller: password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "La contraseña no puede estar vacía";
                          }
                          return null;
                        },
                        obscureText: Visibilidad,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText: "Contraseña",
                          suffixIcon: IconButton(
                            icon: Icon(
                              Visibilidad
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              //Click para mostrar y ocultar la contraseña
                              setState(() {
                                Visibilidad = !Visibilidad;
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                    //Botón de Iniciar Sesión
                    const SizedBox(height: 10),
                    //Login button
                    Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromRGBO(11, 131, 125, 1),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            //Login method will be here
                            //login();

                            //Now we have a response from our sqlite method
                            //We are going to create a user

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const menu(),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Iniciar Sesión",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    //Crear Cuenta
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿No tienes una cuenta?"),
                        TextButton(
                          onPressed: () {
                            //Navigate to sign up
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUp(),
                              ),
                            );
                          },
                          child: const Text("Crea una cuenta"),
                        ),
                      ],
                    ),

                    // We will disable this message in default, when user and pass is incorrect we will trigger this message to user
                    Inicio
                        ? const Text(
                          "Usuario o contraseña incorrectos",
                          style: TextStyle(color: Colors.red),
                        )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
