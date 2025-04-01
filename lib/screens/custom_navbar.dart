import 'package:flutter/material.dart';
import 'package:proyecto_libreria/screens/Biblioteca_screen.dart';
import 'package:proyecto_libreria/screens/Busqueda_screen.dart';
import 'package:proyecto_libreria/screens/Home_screen.dart';
import 'package:proyecto_libreria/screens/favorites_screen.dart';
import 'package:proyecto_libreria/screens/perfil_usuario.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({Key? key, required this.currentIndex})
    : super(key: key);

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = const Home_screen();
        break;
      case 1:
        nextScreen = const BibliotecaScreen();
        return;
      case 2:
        nextScreen = const Busqueda_screen();
        break;
      case 3:
        nextScreen = const FavoritosScreen(userId: 'user1');
        break;
      case 4:
        nextScreen = const ProfileScreen(userId: 'user1');
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
