import 'package:flutter/material.dart';
import 'package:proyecto_libreria/database/Usuario_db.dart';
import 'package:proyecto_libreria/screens/loginScreen.dart';
import 'package:proyecto_libreria/model/Users.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  String? selectedGender;

  final UsuarioDB _userQuery = UsuarioDB(); // Instancia de la base de datos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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

                  // Usuario
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(11, 131, 125, 0.2),
                    ),
                    child: TextFormField(
                      controller: usernameController,
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

                  // Contraseña
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(11, 131, 125, 0.3),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "La contraseña no puede estar vacía";
                        }
                        return null;
                      },
                      obscureText: isPasswordVisible,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: "Contraseña",
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Confirmar Contraseña
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(11, 131, 125, 0.3),
                    ),
                    child: TextFormField(
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "La contraseña no puede estar vacía";
                        } else if (passwordController.text != confirmPasswordController.text) {
                          return "Las contraseñas no coinciden";
                        }
                        return null;
                      },
                      obscureText: isPasswordVisible,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: "Confirmar Contraseña",
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Nombre
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(11, 131, 125, 0.2),
                    ),
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Nombre no puede estar vacío";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.account_circle),
                        hintText: "Nombre",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  // Apellido
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(11, 131, 125, 0.2),
                    ),
                    child: TextFormField(
                      controller: surnameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Apellido no puede estar vacío";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.arrow_forward),
                        hintText: "Apellido",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  // Descripción
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(11, 131, 125, 0.2),
                    ),
                    child: TextFormField(
                      controller: descriptionController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Descripción no puede estar vacía";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.add_reaction),
                        hintText: "Defínete en una palabra",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  // Género
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(11, 131, 125, 0.2),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: const InputDecoration(
                        hintText: "Género",
                        border: InputBorder.none,
                      ),
                      items: const [
                        DropdownMenuItem(child: Text("Masculino"), value: "Masculino"),
                        DropdownMenuItem(child: Text("Femenino"), value: "Femenino"),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                  ),

                  // Botón de Registro
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromRGBO(11, 131, 125, 1),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          // Crear el usuario
                          Users newUser = Users(
                            usernameController.text,
                            nameController.text,
                            surnameController.text,
                            selectedGender ?? "Masculino", // Por defecto Masculino
                            passwordController.text,
                            descriptionController.text,
                          );

                          // Insertar el usuario en la base de datos
                          await _userQuery.insertUser(newUser);

                          // Navegar a la pantalla de login después de registrar
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Registrarse",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}