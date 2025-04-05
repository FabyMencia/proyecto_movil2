import 'package:flutter/material.dart';
import 'package:proyecto_libreria/database/Usuario_db.dart';
import 'package:proyecto_libreria/screens/loginScreen.dart';
import 'package:proyecto_libreria/model/Users.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

bool Verificar_usuario = false;
bool resultado = false;

class _SignUpState extends State<SignUp> {
  final UsuarioDB _UserQuery = UsuarioDB();
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

  Future<void> _verificarUsuario(String usuario) async {
    var User_L = (await _UserQuery.getUserById(usuario))?.toMap();
    if (User_L != null) {
      resultado = false;
    } else {
      resultado = true;
    }
  }

  //Validaciones
  String Validaciones(String cadena, int operacion) {
    //Validaciones generales
    if (cadena.isEmpty) {
      return 'No puede estar vacío';
    } else if ((cadena.trim().isEmpty ||
        RegExp(r'^\s|\s$').hasMatch(cadena) ||
        cadena.contains(' ')) && operacion != 4) {
      return 'No puede se permiten espacios en blanco';
    }
    //Validaciones Usuario
    else if (!RegExp(r'^[a-zA-Z0-9!@#$%^&*(),.?":{}|<>_]+$').hasMatch(cadena) &&
        operacion == 1) {
      return 'Debe escribir solo números, letras o caracteres';
    }
    //Validaciones de contraseña
    else if (cadena.length < 8 && operacion == 2) {
      return 'Debe tener al menos 8 caracteres';
    } else if (!RegExp(r'[A-Z]').hasMatch(cadena) && operacion == 2) {
      return 'Debe incluir al menos una letra mayúscula';
    } else if (!RegExp(r'[a-z]').hasMatch(cadena) && operacion == 2) {
      return 'Debe incluir al menos una letra minúscula';
    } else if (!RegExp(r'[0-9]').hasMatch(cadena) && operacion == 2) {
      return 'Debe incluir al menos un número';
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_-]').hasMatch(cadena) &&
        operacion == 2) {
      return 'Debe incluir al menos un carácter especial';
    }
    //Validaciones de nombre y apellido
    else if (!RegExp(r'^[a-zA-ZÁÉÍÓÚáéíóú]+$').hasMatch(cadena) &&
        (operacion == 3)) {
      return 'Solo se permiten letras';
    }
    //Validaciones de nombre y apellido
    else if (!RegExp(r'^[A-Z]').hasMatch(cadena) && operacion == 3) {
      return 'La primera letra debe estar en mayúscula';
    }
    //Validaciones de nombre, apellido, nombre de usuario y descripción
    else if (RegExp(r'[a-zA-Z]').allMatches(cadena).length < 3 &&
        (operacion == 1 || operacion == 3 || operacion == 4)) {
      return 'Debe incluir al menos 3 letras';
    }

    return "";
  }

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
                  Image.asset("lib/assets/logo.jpg", width: 100),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(11, 131, 125, 0.2),
                    ),
                    child: TextFormField(
                      maxLength: 16,
                      controller: usernameController,
                      validator: (value) {
                        String resultado_contra = Validaciones(value!, 1);
                        if (resultado_contra == "") {
                          return null;
                        }
                        return resultado_contra;
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(11, 131, 125, 0.3),
                    ),
                    child: TextFormField(
                      maxLength: 20,
                      controller: passwordController,
                      validator: (value) {
                        String resultado_contra = Validaciones(value!, 2);
                        if (resultado_contra == "") {
                          return null;
                        }
                        return resultado_contra;
                      },
                      obscureText: isPasswordVisible,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: "Contraseña",
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(11, 131, 125, 0.3),
                    ),
                    child: TextFormField(
                      maxLength: 20,
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "La contraseña no puede estar vacía";
                        } else if (passwordController.text !=
                            confirmPasswordController.text) {
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
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(11, 131, 125, 0.2),
                    ),
                    child: TextFormField(
                      maxLength: 16,
                      controller: nameController,
                      validator: (value) {
                        String resultado_contra = Validaciones(value!, 3);
                        if (resultado_contra == "") {
                          return null;
                        }
                        return resultado_contra;
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(11, 131, 125, 0.2),
                    ),
                    child: TextFormField(
                      maxLength: 16,
                      controller: surnameController,
                      validator: (value) {
                        String resultado_contra = Validaciones(value!, 3);
                        if (resultado_contra == "") {
                          return null;
                        }
                        return resultado_contra;
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(11, 131, 125, 0.2),
                    ),
                    child: TextFormField(
                      maxLength: 40,
                      controller: descriptionController,
                      validator: (value) {
                        String resultado_contra = Validaciones(value!, 4);
                        if (resultado_contra == "") {
                          return null;
                        }
                        return resultado_contra;
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
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
                        DropdownMenuItem(
                          child: Text("Masculino"),
                          value: "Masculino",
                        ),
                        DropdownMenuItem(
                          child: Text("Femenino"),
                          value: "Femenino",
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecciona una opción';
                        }
                        return null;
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
                          //Verificar que el usuario existe en la base de datos
                          await _verificarUsuario(usernameController.text);

                          setState(() {});

                          if (resultado == true) {
                            resultado =
                                false; // Restablecer la variable después de usarla

                            // Crear el usuario
                            Users newUser = Users(
                              usernameController.text,
                              nameController.text,
                              surnameController.text,
                              selectedGender ??
                                  "Masculino", // Por defecto Masculino
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
                          } else {
                            setState(() {
                              Verificar_usuario =
                                  true; // Muestra mensaje de error
                            });
                          }
                        }
                      },
                      child: const Text(
                        "Registrarse",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
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
                        child: const Text("Iniciar Sesión"),
                      ),
                    ],
                  ),

                  Verificar_usuario
                      ? const Text(
                        "El nombre de usuario ya existe.",
                        style: TextStyle(color: Colors.red),
                      )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
