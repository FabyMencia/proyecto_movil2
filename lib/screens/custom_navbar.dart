import 'package:flutter/material.dart';
import 'package:proyecto_libreria/screens/Biblioteca_screen.dart';
import 'package:proyecto_libreria/screens/Busqueda_screen.dart';
import 'package:proyecto_libreria/screens/Home_screen.dart';
import 'package:proyecto_libreria/screens/favorites_screen.dart';
import 'package:proyecto_libreria/screens/perfil_usuario.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final String currentuser;
  const CustomBottomNavBar({Key? key, required this.currentIndex,required this.currentuser})
    : super(key: key);

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = Home_screen(userid: currentuser,);
        break;
      case 1:
        nextScreen =  BibliotecaScreen(userId: currentuser);
        break;
      case 2:
        nextScreen =  Busqueda_screen(currentuser: currentuser,);
        break;
      case 3:
        nextScreen =  FavoritosScreen(userId: currentuser);
        break;
      case 4:
        nextScreen =  ProfileScreen(userId: currentuser);
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _navigate(context, index),
      selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
      unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      backgroundColor: const Color(0xFF0B837D),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: 'Biblioteca',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}
