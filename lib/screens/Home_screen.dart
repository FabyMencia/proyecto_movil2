import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:proyecto_libreria/screens/custom_navbar.dart';
import 'package:proyecto_libreria/screens/Busqueda_screen.dart';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carrusel de imágenes con estilo mejorado
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.85, // Tamaño de las imágenes
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn, // Animación más fluida
                    enableInfiniteScroll: true,
                  ),
                  items:
                      [
                        'lib/assets/carousel1.jpg',
                        'lib/assets/carousel2.jpg',
                        'lib/assets/carousel3.jpg',
                        'lib/assets/carousel4.jpg',
                      ].map((item) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: const Offset(2, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(item, fit: BoxFit.cover),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.1),
                                        Colors.black.withOpacity(0.5),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
                // Indicador de posición
                Positioned(
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        4, // Cantidad de imágenes
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == 0 ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sección de Géneros Populares
            const Text(
              "Géneros Populares",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Botones de géneros en GridView
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                genreButton("Ficción", "lib/assets/ficción.jpg", 1, context),
                genreButton("Ciencia", "lib/assets/ciencia.jpg", 2, context),
                genreButton("Historia", "lib/assets/historia.jpg", 3, context),
                genreButton(
                  "Filosofía",
                  "lib/assets/filosofia.jpg",
                  4,
                  context,
                ),
                genreButton("Arte", "lib/assets/arte.jpg", 5, context),
                genreButton("Misterio", "lib/assets/misterio.jpg", 6, context),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget genreButton(
    String title,
    String assetPath,
    int categoryId,
    BuildContext context,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF083332),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => Busqueda_screen(selectedCategoryId: categoryId),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              assetPath,
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
