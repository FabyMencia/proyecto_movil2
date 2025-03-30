import 'package:flutter/material.dart';
import 'package:proyecto_libreria/screens/custom_navbar.dart';

class Home_screen extends StatelessWidget {
  const Home_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b837d),
        title: const Text("LibPlus"),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFcad9dc),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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

            // Sección de Libros Destacados
            const Text(
              "Libros Destacados",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  bookCard(
                    "https://cdn.pixabay.com/photo/2024/12/27/14/58/owl-9294302_640.jpg",
                  ),
                  bookCard(
                    "https://cdn.pixabay.com/photo/2025/02/19/06/17/winter-9416919_640.jpg",
                  ),
                  bookCard(
                    "https://cdn.pixabay.com/photo/2025/02/03/21/01/forest-9380292_640.jpg",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sección de Géneros Populares
            const Text(
              "Géneros Populares",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Botones de géneros en dos filas
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  genreButton(
                    "Ficción",
                    "https://cdn.pixabay.com/photo/2025/02/19/06/17/winter-9416919_640.jpg",
                  ),
                  genreButton(
                    "Ciencia",
                    "https://cdn.pixabay.com/photo/2025/02/03/21/01/forest-9380294_640.jpg",
                  ),
                  genreButton(
                    "Historia",
                    "https://cdn.pixabay.com/photo/2024/12/27/14/58/owl-9294302_640.jpg",
                  ),
                  genreButton(
                    "Filosofía",
                    "https://cdn.pixabay.com/photo/2025/02/03/21/01/forest-9380292_640.jpg",
                  ),
                  genreButton(
                    "Arte",
                    "https://cdn.pixabay.com/photo/2025/02/19/06/17/winter-9416919_640.jpg",
                  ),
                  genreButton(
                    "Misterio",
                    "https://cdn.pixabay.com/photo/2024/12/27/14/58/owl-9294302_640.jpg",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }

  // Widget para cada libro en la lista horizontal
  Widget bookCard(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl,
          width: 120,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Widget para los botones de géneros populares
  Widget genreButton(String title, String imageUrl) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF083332),
      ),
      onPressed: () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black54,
            padding: const EdgeInsets.all(5),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
