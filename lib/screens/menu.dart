//importando la libreria material
import 'package:flutter/material.dart';
import 'package:proyecto_libreria/screens/Busqueda_screen.dart';
import 'package:proyecto_libreria/screens/Home_screen.dart';
import 'package:proyecto_libreria/screens/LoginScreen.dart';

class menu extends StatelessWidget {
  const menu({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 76, 110, 245),
        title: const Text("MENU"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text("HOME"),
              onPressed:
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home_screen()),
                    ),
                  },
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              child: Text("BUSQUEDA"),
              onPressed:
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Busqueda_screen(),
                      ),
                    ),
                  },
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              child: Text("Login"),
              onPressed:
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    ),
                  },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
} //fin de la clase
