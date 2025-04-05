import 'package:flutter/material.dart';
import 'package:proyecto_libreria/screens/custom_navbar.dart';
import 'package:proyecto_libreria/database/Biblioteca_db.dart';
import 'package:proyecto_libreria/database/Databasehelper.dart';

class BibliotecaScreen extends StatefulWidget {
  final String userId;

  const BibliotecaScreen({Key? key, required this.userId});

  @override
  _BibliotecaScreenState createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBibliotecaPage(),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildBibliotecaPage() {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 76, 72),
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
            LecturasPage(userId: widget.userId),
            ColeccionesPage(userId: widget.userId),
            ProximosPage(userId: widget.userId),
          ],
        ),
      ),
    );
  }
}

class LecturasPage extends StatelessWidget {
  final String userId;

  const LecturasPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Mis Lecturas",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: BibliotecaDb().getUserLecturas(userId),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error al cargar lecturas: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No tienes libros en Lecturas."));
          } else {
            List<Map<String, dynamic>> libros = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: libros.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, 
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.6, // Ajusta la relación de aspecto para que las tarjetas tengan el mismo tamaño
              ),
              itemBuilder: (BuildContext context, int index) {
                final libro = libros[index];
                return libroCard(libro);
              },
            );
          }
        },
      ),
    );
  }
}

Widget libroCard(Map<String, dynamic> libro) {
  return Container(
    margin: const EdgeInsets.only(right: 16),
    width: 125, 
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 165, 
          width: 125, 
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              libro['imagen_libro']!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF5E8585), 
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Título del libro
        Text(
          libro['titulo']!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF083332),
            fontSize: 13,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 1),
      ],
    ),
  );
}

class ColeccionesPage extends StatelessWidget {
  final String userId;

  const ColeccionesPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Mis Colecciones",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: BibliotecaDb().getUserColecciones(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error al cargar colecciones: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No tienes libros guardados en categorías."));
          } else {
            Map<String, List<Map<String, dynamic>>> colecciones = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: colecciones.keys.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de columnas
                crossAxisSpacing: 15, // Espaciado Horizontal
                mainAxisSpacing: 10, // Espaciado vertical
              ),
              itemBuilder: (BuildContext context, int index) {
                String categoria = colecciones.keys.elementAt(index);
                List<Map<String, dynamic>> libros = colecciones[categoria] ?? [];
                return categoriaCard(context, categoria, libros);
              },
            );
          }
        },
      ),
    );
  }

  Widget categoriaCard(BuildContext context, String categoria, List<Map<String, dynamic>> libros) {
    return GestureDetector(
      onTap: () {
        showBottomSheetLibros(context, categoria, libros);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 225, 152, 152),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              categoria,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              "${libros.length} libros",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

void showBottomSheetLibros(BuildContext context, String categoria, List<Map<String, dynamic>> libros) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Libros en $categoria",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: libros.isEmpty
                  ? const Center(child: Text("No hay libros en esta categoría."))
                  : ListView.builder(
                      itemCount: libros.length,
                      itemBuilder: (BuildContext context, int index) {
                        final libro = libros[index];
                        return libroCard(libro); 
                      },
                    ),
            ),
          ],
        ),
      );
    },
  );
}


//Estructura de Proximos
class ProximosPage extends StatefulWidget {
  final String userId;

  ProximosPage({required this.userId});

  @override
  _ProximosPageState createState() => _ProximosPageState();
}

class _ProximosPageState extends State<ProximosPage> {
  late Future<List<Map<String, dynamic>>> librosFuturos;

  @override
  void initState() {
    super.initState();
    librosFuturos = BibliotecaDb().getLibrosNoAgregados(widget.userId);
  }

  Future<void> agregarALecturas(Map<String, dynamic> libro) async {
  try {
    print("Agregando libro: ${libro['titulo']}");
    await BibliotecaDb().agregarLibro(widget.userId, libro[DatabaseHelper.colIdLibro]);
    setState(() {
      // Actualiza la lista de libros futuros
      librosFuturos = BibliotecaDb().getLibrosNoAgregados(widget.userId);
    });
  } catch (e) {
    print("Error al agregar libro: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Descubre nuevas Historias",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: librosFuturos,
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error al cargar recomendaciones: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay recomendaciones disponibles."));
          } else {
            List<Map<String, dynamic>> libros = snapshot.data!;
            return SingleChildScrollView( 
              child: Column(
                children: [
                  GridView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: libros.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, 
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.6, 
                    ),
                    shrinkWrap: true, 
                    physics: const NeverScrollableScrollPhysics(), 
                    itemBuilder: (BuildContext context, int index) {
                      final libro = libros[index];
                      return ProximosCard(libro, agregarALecturas);
                    },
                  ),
                  const SizedBox(height: 20), 
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

Widget ProximosCard(Map<String, dynamic> libro, Function(Map<String, dynamic>) onAdd) {
  return GestureDetector(
    onTap: () {
      // mostrar más detalles del libro
    },
    child: Container(
      margin: const EdgeInsets.only(right: 16),
      width: 125, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 165, 
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                libro['imagen_libro']!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF5E8585), // Color de fondo en caso de error
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            libro['titulo']!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF083332),
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => onAdd(libro),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    ),
  );
}