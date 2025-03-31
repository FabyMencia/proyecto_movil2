import 'LoginScreen.dart';
import 'package:flutter/material.dart';

class Signdetail extends StatefulWidget {
  const Signdetail({super.key});

  @override
  State<Signdetail> createState() => _SigndetailState();
}

class _SigndetailState extends State<Signdetail> {
  final formKey = GlobalKey<FormState>();

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
                    const ListTile(
                      title: Text(
                        "Cuentanos sobre ti",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    //Nombre
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

                    //Apellido
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

                    //Descripción
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Descripción no puede estar vacía";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.add_reaction),
                          hintText: "Definete en una palabra",
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    //Combo box Genero
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
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          hintText: "Género",
                          border: InputBorder.none,
                        ),
                        items: const [
                          DropdownMenuItem(
                            child: Text("Masculino"),
                            value: "1",
                          ),
                          DropdownMenuItem(child: Text("Femenino"), value: "2"),
                        ],
                        onChanged: (value) {},
                      ),
                    ),

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
                            Navigator.push(
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
      ),
    );
  }
}
