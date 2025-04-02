import 'package:flutter/material.dart';
import 'package:proyecto_libreria/screens/custom_navbar.dart';
import 'package:proyecto_libreria/database/Busqueda_db.dart';

class Busqueda_screen extends StatefulWidget {
  final int? selectedCategoryId;

  const Busqueda_screen({Key? key, this.selectedCategoryId}) : super(key: key);

  @override
  _Busqueda_screenState createState() => _Busqueda_screenState();
}

class _Busqueda_screenState extends State<Busqueda_screen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  int? _selectedCategoryId;

  List<Map<String, dynamic>> categories = [
    {'id': 1, 'name': 'Ficción', 'image': 'lib/assets/ficción.jpg'},
    {'id': 2, 'name': 'Ciencia', 'image': 'lib/assets/ciencia.jpg'},
    {'id': 3, 'name': 'Historia', 'image': 'lib/assets/historia.jpg'},
    {'id': 4, 'name': 'Filosofía', 'image': 'lib/assets/filosofia.jpg'},
    {'id': 5, 'name': 'Arte', 'image': 'lib/assets/arte.jpg'},
    {'id': 6, 'name': 'Misterio', 'image': 'lib/assets/misterio.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.selectedCategoryId;
    _searchBooks();
  }

  void _searchBooks() async {
    String query = _searchController.text.trim();
    if (query.isNotEmpty || _selectedCategoryId != null) {
      var results = await LibroDB().searchBooks(
        query,
        categoryId: _selectedCategoryId,
      );
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  void _selectCategory(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _searchBooks();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _selectedCategoryId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B837D),
        title: const Text('Búsqueda de Libros'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFCAD9DC),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF5E8585),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        onChanged: (value) {
                          _searchBooks();
                        },
                        decoration: const InputDecoration(
                          hintText: 'Buscar libros...',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: _clearSearch,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _searchController.text.isEmpty && _selectedCategoryId == null
                  ? Column(
                    children: [
                      const Text(
                        'Explorar categorías',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 1.0,
                            ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return categoryButton(
                            categories[index]['id'],
                            categories[index]['name'],
                            categories[index]['image'],
                          );
                        },
                      ),
                    ],
                  )
                  : _selectedCategoryId != null
                  ? Column(
                    children: [
                      const Text(
                        'Categoría Seleccionada',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      categoryButton(
                        _selectedCategoryId!,
                        categories
                            .firstWhere(
                              (cat) => cat['id'] == _selectedCategoryId,
                            )['name']
                            .toString(),
                        categories
                            .firstWhere(
                              (cat) => cat['id'] == _selectedCategoryId,
                            )['image']
                            .toString(),
                      ),
                    ],
                  )
                  : Container(),
              const SizedBox(height: 20),
              _searchResults.isEmpty
                  ? const Center(child: Text("No se encontraron libros"))
                  : Column(
                    children:
                        _searchResults.map<Widget>((book) {
                          return ListTile(
                            title: Text(book['titulo']),
                            subtitle: Text(book['sinopsis']),
                            leading: Image.network(book['imagen_libro']),
                            onTap: () {
                              // Abrir detalles o pdf del libro
                            },
                          );
                        }).toList(),
                  ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }

  Widget categoryButton(int categoryId, String categoryName, String assetPath) {
    return GestureDetector(
      onTap: () {
        _selectCategory(categoryId);
      },
      child: Container(
        width: 120,
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.black54, // Fondo oscuro similar a Home_screen
            padding: const EdgeInsets.all(5),
            child: Text(
              categoryName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
