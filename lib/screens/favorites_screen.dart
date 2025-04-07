import 'package:flutter/material.dart';
import 'package:proyecto_libreria/database/Favorito_db.dart';
import 'package:proyecto_libreria/screens/custom_navbar.dart';
import 'package:proyecto_libreria/screens/Pdfview_screen.dart';

class FavoritosScreen extends StatefulWidget {
  final String userId;

  const FavoritosScreen({super.key, required this.userId});

  @override
  _FavoritosScreenState createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final FavoritoDB _favoritoQuery = FavoritoDB();
  List<Map<String, dynamic>> _favoritos = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadFavoritos();
  }

  Future<void> _loadFavoritos() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final favoritos = await _favoritoQuery.getUserFavorites(widget.userId);

      setState(() {
        _favoritos = favoritos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar favoritos: $e';
      });
    }
  }

  Future<void> _toggleFavorite(int bookId, bool currentStatus) async {
    try {
      await _favoritoQuery.toggleFavorite(
        bookId,
        widget.userId,
        !currentStatus,
      );
      // Recargar los favoritos
      _loadFavoritos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar favorito: $e')),
      );
    }
  }

  void openpdf(BuildContext context, String url) => Navigator.of(context).push(
    MaterialPageRoute(
      builder:
          (context) => PDFViewerPage(
            assetPath:
               url,
          ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "FAVORITOS",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        backgroundColor: const Color(0xFF19ADA6),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadFavoritos,
            tooltip: 'Actualizar favoritos',
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_errorMessage, style: TextStyle(color: Colors.red)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loadFavoritos,
                      child: Text('Reintentar'),
                    ),
                  ],
                ),
              )
              : _favoritos.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                    SizedBox(height: 20),
                    Text(
                      'No tienes libros favoritos todavía',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navegar a la pantalla de todos los libros, biblioteca
                      },
                      child: Text('Explorar libros'),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: _favoritos.length,
                  itemBuilder: (context, index) {
                    final libro = _favoritos[index];
                    return _buildBookCard(
                      id: libro['id_libro'],
                      title: libro['titulo'],
                      year:
                          "${libro['ano_publicacion']} • ${_getPaisdeAutor(libro['nombre_autor'])}",
                      genres: [libro['nombre_categoria']],
                        url: libro['pdf_libro']??'lib/assets/el_principito.pdf',
                      imageUrl:
                          libro['imagen_libro'] ??
                          'https://via.placeholder.com/150',
                      isFavorite: true,
                    );
                  },
                ),
              ),
      bottomNavigationBar:  CustomBottomNavBar(currentIndex: 3,currentuser: widget.userId,),
    );
  }

  String _getPaisdeAutor(String author) {
    // Solo de ejemplo, sino se tendría que usar una tabla de pais
    if (author.contains('García Márquez')) return 'Colombia';
    if (author.contains('Rowling')) return 'Reino Unido';
    if (author.contains('King')) return 'Estados Unidos';
    if (author.contains('Orwell')) return 'Reino Unido';
    if (author.contains('Saint-Exupéry')) return 'Francia';
    if (author.contains('Tolkien')) return 'Reino Unido';
    return 'Desconocido';
  }

  Widget _buildBookCard({
    required int id,
    required String title,
    required String year,
    required List<String> genres,
    required String imageUrl,
    required bool isFavorite,
   required String url,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              imageUrl,
              width: 90,
              height: 130,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 90,
                  height: 130,
                  color: Colors.grey.shade300,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF083332),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    year,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children:
                        genres
                            .map(
                              (genre) => Chip(
                                label: Text(
                                  genre,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF5E8585),
                                  ),
                                ),
                                backgroundColor: const Color(0xFFCAD9DC),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF19ADA6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          // Aquí irías a la pantalla para leer el libro
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Abriendo libro: $title')),
                          );
                          openpdf(context,url);
                        },
                        child: const Text(
                          "Leer",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 24,
                        ),
                        onPressed: () => _toggleFavorite(id, isFavorite),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
