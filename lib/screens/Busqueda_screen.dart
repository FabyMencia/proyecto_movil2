import 'package:flutter/material.dart';
import 'package:proyecto_libreria/screens/custom_navbar.dart';

class Busqueda_screen extends StatelessWidget {
  const Busqueda_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B837D),
        title: const Text('Búsqueda de Libros'),
      ),
      body: Container(
        color: const Color(0xFFCAD9DC),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Campo de búsqueda
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF5E8585),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Buscar libros...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                  ), // Alinea el texto con el icono
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Explorar categorías
            const Text(
              'Explorar categorías',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  categoryButton(
                    "Ficción",
                    "https://cdn.pixabay.com/photo/2025/02/19/06/17/winter-9416919_640.jpg",
                  ),
                  categoryButton(
                    "Ciencia",
                    "https://cdn.pixabay.com/photo/2025/02/03/21/01/forest-9380294_640.jpg",
                  ),
                  categoryButton(
                    "Historia",
                    "https://cdn.pixabay.com/photo/2024/12/27/14/58/owl-9294302_640.jpg",
                  ),
                  categoryButton(
                    "Filosofía",
                    "https://cdn.pixabay.com/photo/2025/02/03/21/01/forest-9380292_640.jpg",
                  ),
                  categoryButton(
                    "Arte",
                    "https://cdn.pixabay.com/photo/2025/02/19/06/17/winter-9416919_640.jpg",
                  ),
                  categoryButton(
                    "Misterio",
                    "https://cdn.pixabay.com/photo/2024/12/27/14/58/owl-9294302_640.jpg",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Libros destacados
            const Text(
              'Libros destacados',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                featuredBookCard(
                  'La gran aventura',
                  'John Smith',
                  'https://cdn.pixabay.com/photo/2025/02/19/06/17/winter-9416919_640.jpg',
                ),
                featuredBookCard(
                  'Misterio en el bosque',
                  'Emily Doe',
                  'https://cdn.pixabay.com/photo/2025/02/19/06/17/winter-9416919_640.jpg',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                featuredBookCard(
                  'Ciencia para todos',
                  'Alice Brown',
                  'https://cdn.pixabay.com/photo/2025/02/19/06/17/winter-9416919_640.jpg',
                ),
                featuredBookCard(
                  'Maravillas Históricas',
                  'Michael Green',
                  'https://cdn.pixabay.com/photo/2025/02/19/06/17/winter-9416919_640.jpg',
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }

  // Método para crear los botones de categorías
  Widget categoryButton(String categoryName, String imageUrl) {
    return GestureDetector(
      child: Container(
        width: 120,
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Text(
              categoryName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  // Método para crear las cartas de libros destacados
  Widget featuredBookCard(String bookName, String author, String imageUrl) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: const Color(0xFF135e5c), // Color de fondo de la carta
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10), // Espacio superior

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ), // Espacio a los lados
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Espacio debajo de la imagen
          const SizedBox(height: 10),

          // Título del libro
          Text(
            bookName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          // Autor del libro
          Text(
            author,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
