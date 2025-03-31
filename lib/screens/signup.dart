import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'Signdetail.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final username = TextEditingController();
  final password = TextEditingController();
  final checkPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool Visibilidad = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(11, 131, 125, 1), width: 5),
      ),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Logo
                    Image.asset("../lib/assets/logo.jpg", width: 100),
                    const SizedBox(height: 15),

                    const ListTile(
                      title: Text(
                        "Crear Cuenta",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

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

                    //Confirmar Contraseña
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
                        controller: checkPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "La contraseña no puede estar vacía";
                          } else if (password.text != checkPassword.text) {
                            return "Las contraseñas no coinciden";
                          }
                          return null;
                        },
                        obscureText: Visibilidad,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText: "Confirmar Contraseña",
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
                    //Sign Up button
                    Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromRGBO(11, 131, 125, 1),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Signdetail(),
                            ),
                          );
                          /*
                          if (formKey.currentState!.validate()) {
                            //Login method will be here
                            //login();

                            //Now we have a response from our sqlite method
                            //We are going to create a user
                          }*/
                        },
                        child: const Text(
                          "Siguiente",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    //Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿Ya tienes una cuenta?"),
                        TextButton(
                          onPressed: () {
                            //Navigate to sign up
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text("Inicia Sesión"),
                        ),
                      ],
                    ),
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
