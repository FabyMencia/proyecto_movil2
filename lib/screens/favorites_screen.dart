import 'package:flutter/material.dart';
import 'package:proyecto_libreria/database/Favorito_db.dart';
import 'package:proyecto_libreria/screens/Biblioteca_screen.dart';
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

      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              currentStatus ? 'Eliminado de favoritos' : 'Añadido a favoritos',
            ),
            backgroundColor: currentStatus ? Colors.blue : Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      }

      // Recargar los favoritos
      _loadFavoritos();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar favorito: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void openpdf(BuildContext context, String url) => 
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewerPage(assetPath: url)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F5F5,
      ),
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          "MIS FAVORITOS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF19ADA6),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFavoritos,
            tooltip: 'Actualizar favoritos',
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF19ADA6)),
                    SizedBox(height: 16),
                    Text(
                      "Cargando tus favoritos...",
                      style: TextStyle(
                        color: Color(0xFF5E8585),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
              : _errorMessage.isNotEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _loadFavoritos,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF19ADA6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : _favoritos.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: Color(0xFFCCCCCC),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'No tienes libros favoritos todavía',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF5E8585),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Marca libros con ♥ para verlos aquí',
                      style: TextStyle(fontSize: 14, color: Color(0xFF8E8E8E)),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navegar a la pantalla de biblioteca
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    BibliotecaScreen(userId: widget.userId),
                          ),
                        );
                      },
                      icon: const Icon(Icons.menu_book),
                      label: const Text('Explorar libros'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF19ADA6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Tus libros favoritos (${_favoritos.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF083332),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        itemCount: _favoritos.length,
                        itemBuilder: (context, index) {
                          final libro = _favoritos[index];
                          return _buildBookCard(
                            id: libro['id_libro'],
                            title: libro['titulo'],
                            year:
                                "${libro['ano_publicacion']} • ${libro['nombre_autor'] ?? 'Autor desconocido'}",
                            genres: [libro['nombre_categoria']],
                            url:
                                libro['pdf_libro'] ??
                                'lib/assets/el_principito.pdf',
                            imageUrl:
                                libro['imagen_libro'] ??
                                'https://via.placeholder.com/150',
                            isFavorite: true,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
        currentuser: widget.userId,
      ),
    );
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
    return GestureDetector(
      child: Card(
        elevation: 3,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Hero(
              tag: 'book_image_$id',
              child: ClipRRect(
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
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF083332),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      year,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
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
                                    vertical:
                                        2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
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
                            openpdf(context, url);
                          },
                          icon: const Icon(Icons.book, size: 16),
                          label: const Text(
                            "Leer",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.favorite,
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
      ),
    );
  }
}