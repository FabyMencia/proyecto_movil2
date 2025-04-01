import 'package:flutter/material.dart';
import 'package:proyecto_libreria/screens/custom_navbar.dart';

class BibliotecaScreen extends StatefulWidget {
  const BibliotecaScreen({Key? key}) : super(key: key);

  @override
  _BibliotecaScreenState createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bibliotecapage(),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }

  Widget bibliotecapage() {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 76, 72),
          title: const Text(
            "Biblioteca",
            style: TextStyle(
              color: Color.fromARGB(255, 7, 222, 201),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Color.fromARGB(255, 7, 222, 201),
            unselectedLabelColor: Color.fromARGB(255, 183, 196, 195),
            indicatorColor: Color.fromARGB(255, 7, 222, 201),
            tabs: <Widget>[
              Tab(icon: Icon(Icons.menu_book), text: "Lecturas"),
              Tab(icon: Icon(Icons.collections_bookmark), text: "Colecciones"),
              Tab(icon: Icon(Icons.bookmark_add), text: "Próximos"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            librosGridView(), // Pestaña "Lecturas" muestra el grid de libros
            ColeccionesPage(), //Pestaña "Colecciones" para que se clasifiquen por genero
            ProximosPage(), //Pestaña "Próximos" para descubrir nuevos libros
          ],
        ),
      ),
    );
  }
}

//Estructura de Lecturas (sobre como se mostrarían los libros)
Widget librosGridView() {
  return Container(
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.symmetric(),
    child: GridView.builder(
      itemCount: libros.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //Número de columnas
        crossAxisSpacing: 15, // Espaciado Horizontal
        mainAxisSpacing: 10, // Espaciado vertical
      ),
      itemBuilder: (BuildContext context, int index) {
        return libroCard(libros[index]);
      },
    ),
  );
}

//Estructura de Colecciones
class ColeccionesPage extends StatelessWidget {
  //Lista de categoría
  final List<String> categorias = [
    "Fantasía",
    "Ciencia Ficción",
    "Romance",
    "Aventura",
    "Biografía",
    "Paranormal",
  ];

  //Libros agrupados por categoría
  final Map<String, List<Libro>> librosPorCategoria = {
    "Fantasía": [
      Libro(
        titulo: "Libro 1",
        genero: "Fantasía",
        imagen:
            "https://cdn.pixabay.com/photo/2025/02/19/06/17/winter-9416919_640.jpg",
      ),
      Libro(
        titulo: "Libro 2",
        genero: "Fantasía",
        imagen:
            "https://cdn.pixabay.com/photo/2025/02/03/21/01/forest-9380292_640.jpg",
      ),
    ],
    "Ciencia Ficción": [
      Libro(
        titulo: "Libro 3",
        genero: "Ciencia Ficción",
        imagen:
            "https://cdn.pixabay.com/photo/2024/12/27/14/58/owl-9294302_640.jpg",
      ),
    ],
    "Romance": [
      Libro(
        titulo: "Libro 4",
        genero: "Romance",
        imagen:
            "https://cdn.pixabay.com/photo/2025/02/19/06/17/winter-9416919_640.jpg",
      ),
      Libro(
        titulo: "Libro 5",
        genero: "Romance",
        imagen:
            "https://cdn.pixabay.com/photo/2025/02/03/21/01/forest-9380292_640.jpg",
      ),
    ],
    "Aventura": [
      Libro(
        titulo: "Libro 6",
        genero: "Aventura",
        imagen:
            "https://cdn.pixabay.com/photo/2024/12/27/14/58/owl-9294302_640.jpg",
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    const SizedBox(height: 20);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Mi Biblioteca por Temas",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: categorias.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //Número de columnas
          crossAxisSpacing: 15, // Espaciado Horizontal
          mainAxisSpacing: 10, // Espaciado vertical
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              //Muestra los libros de la categoría seleccionada
              showBottomSheetLibros(
                context,
                categorias[index],
                librosPorCategoria[categorias[index]] ?? [],
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  categorias[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

//Estructura de Proximos
class ProximosPage extends StatelessWidget {
  //Nuevos libros recomendados
  final List<Libro> librosNuevos = [
    Libro(
      titulo: "Libro 7",
      genero: "Gen 1",
      imagen:
          "https://cdn.pixabay.com/photo/2025/02/19/06/17/winter-9416919_640.jpg",
    ),
    Libro(
      titulo: "Libro 8",
      genero: "Gen 2",
      imagen:
          "https://cdn.pixabay.com/photo/2025/02/03/21/01/forest-9380292_640.jpg",
    ),
    Libro(
      titulo: "Libro 9",
      genero: "Gen 3",
      imagen:
          "https://cdn.pixabay.com/photo/2024/12/27/14/58/owl-9294302_640.jpg",
    ),
    Libro(
      titulo: "Libro 10",
      genero: "Gen 4",
      imagen:
          "https://cdn.pixabay.com/photo/2025/02/19/06/17/winter-9416919_640.jpg",
    ),
    Libro(
      titulo: "Libro 11",
      genero: "Gen 5",
      imagen:
          "https://cdn.pixabay.com/photo/2025/02/03/21/01/forest-9380292_640.jpg",
    ),
    Libro(
      titulo: "Libro 12",
      genero: "Gen 6",
      imagen:
          "https://cdn.pixabay.com/photo/2024/12/27/14/58/owl-9294302_640.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Descubre nuevas Historias",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0B837d),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: librosNuevos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          return libroCard(librosNuevos[index]);
        },
      ),
    );
  }
}

void showBottomSheetLibros(
  BuildContext context,
  String categoria,
  List<Libro> libros,
) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Libros en $categoria",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 76, 72),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: libros.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //Número de columnas
                  crossAxisSpacing: 15, // Espaciado Horizontal
                  mainAxisSpacing: 15, // Espaciado vertical
                ),
                itemBuilder: (BuildContext context, int index) {
                  return libroCard(libros[index]);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Clase para definir un libro
class Libro {
  final String titulo;
  final String genero;
  final String imagen;
  Libro({required this.titulo, required this.genero, required this.imagen});
}

List<Libro> libros = [
  Libro(
    titulo: "Libro 1",
    genero: "Gen 1",
    imagen:
        "https://cdn.pixabay.com/photo/2025/02/19/06/17/winter-9416919_640.jpg",
  ),
  Libro(
    titulo: "Libro 2",
    genero: "Gen 2",
    imagen:
        "https://cdn.pixabay.com/photo/2025/02/03/21/01/forest-9380292_640.jpg",
  ),
  Libro(
    titulo: "Libro 3",
    genero: "Gen 3",
    imagen:
        "https://cdn.pixabay.com/photo/2024/12/27/14/58/owl-9294302_640.jpg",
  ),
  Libro(
    titulo: "Libro 4",
    genero: "Gen 4",
    imagen:
        "https://cdn.pixabay.com/photo/2025/02/19/06/17/winter-9416919_640.jpg",
  ),
  Libro(
    titulo: "Libro 5",
    genero: "Gen 5",
    imagen:
        "https://cdn.pixabay.com/photo/2025/02/03/21/01/forest-9380292_640.jpg",
  ),
  Libro(
    titulo: "Libro 6",
    genero: "Gen 6",
    imagen:
        "https://cdn.pixabay.com/photo/2024/12/27/14/58/owl-9294302_640.jpg",
  ),
];

// Cards
Widget libroCard(Libro book) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Stack(
      children: [
        //Abarca todo el espacio del cuadro
        Image.network(
          book.imagen, //Usa la URL de la imagen
          width: double.infinity, //ancho completo
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black54,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  book.titulo,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  book.genero,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
