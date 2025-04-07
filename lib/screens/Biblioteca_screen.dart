import 'package:flutter/material.dart';
import 'package:proyecto_libreria/screens/custom_navbar.dart';
import 'package:proyecto_libreria/database/Biblioteca_db.dart';
import 'package:proyecto_libreria/database/Databasehelper.dart';

class BibliotecaScreen extends StatefulWidget {
  final String userId;

  const BibliotecaScreen({super.key, required this.userId});

  @override
  _BibliotecaScreenState createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBibliotecaPage(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        currentuser: widget.userId,
      ),
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

  const LecturasPage({super.key, required this.userId});

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
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: BibliotecaDb().getUserLecturas(userId),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error al cargar lecturas: ${snapshot.error}"),
              );
            } else {
              List<Map<String, dynamic>> librosGuardados = snapshot.data ?? [];

              if (librosGuardados.isEmpty) {
                return const Center(
                  child: Text("No tienes libros en Lecturas."),
                );
              } else {
                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: librosGuardados.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final libro = librosGuardados[index];
                    return libroCard(libro);
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}

Widget libroCard(Map<String, dynamic> libro) {
  return Container(
    margin: const EdgeInsets.only(right: 16),
    width: 125,
    child: SingleChildScrollView(
      // Wrap the Column in a SingleChildScrollView
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
            return Center(
              child: Text("Error al cargar colecciones: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No tienes libros guardados en categorías."),
            );
          } else {
            Map<String, List<Map<String, dynamic>>> colecciones =
                snapshot.data!;
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
                List<Map<String, dynamic>> libros =
                    colecciones[categoria] ?? [];
                return categoriaCard(context, categoria, libros);
              },
            );
          }
        },
      ),
    );
  }

  Widget categoriaCard(
    BuildContext context,
    String categoria,
    List<Map<String, dynamic>> libros,
  ) {
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
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

void showBottomSheetLibros(
  BuildContext context,
  String categoria,
  List<Map<String, dynamic>> libros,
) {
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
              child:
                  libros.isEmpty
                      ? const Center(
                        child: Text("No hay libros en esta categoría."),
                      )
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

class ProximosPage extends StatefulWidget {
  final String userId;

  ProximosPage({super.key, required this.userId});

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
      await BibliotecaDb().agregarLibro(
        widget.userId,
        libro[DatabaseHelper.colIdLibro],
      ); // Agregar el libro a la lista de guardados
      setState(() {
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
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error al cargar los próximos libros: ${snapshot.error}",
              ),
            );
          } else {
            final libros = snapshot.data ?? [];
            return ListView.builder(
              itemCount: libros.length,
              itemBuilder: (BuildContext context, int index) {
                final libro = libros[index];
                return Card(
                  child: ListTile(
                    title: Text(libro['titulo'] ?? "Sin título"),
                    subtitle: Text(libro['descripcion'] ?? "Sin descripción"),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark_add),
                      onPressed: () => agregarALecturas(libro),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
