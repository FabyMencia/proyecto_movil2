import 'package:flutter/material.dart';
import 'package:proyecto_libreria/database/Databasehelper.dart';
import 'package:proyecto_libreria/database/Favorito_db.dart';
import 'package:proyecto_libreria/screens/Pdfview_screen.dart';

class DetalleLibroScreen extends StatefulWidget {
  final int libroId;
  final String userId;

  const DetalleLibroScreen({
    super.key,
    required this.libroId,
    required this.userId,
  });

  @override
  State<DetalleLibroScreen> createState() => _DetalleLibroScreenState();
}

class _DetalleLibroScreenState extends State<DetalleLibroScreen> {
  bool isFavorite = false;
  bool isLoading = true;
  Map<String, dynamic> bookDetails = {};
  final FavoritoDB _favoritoDb = FavoritoDB();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadBookDetails();
    _checkIfFavorite();
  }

  Future<void> _loadBookDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

      final db = await _dbHelper.database;

      final bookResult = await db.rawQuery(
        '''
      SELECT 
        l.*, 
        a.${DatabaseHelper.colNombreAutor} as autor,
        c.${DatabaseHelper.colNombreCategoria} as categoria
      FROM ${DatabaseHelper.libroTable} l
      LEFT JOIN ${DatabaseHelper.autorTable} a ON l.${DatabaseHelper.colIdAutor} = a.${DatabaseHelper.colIdAutor}
      LEFT JOIN ${DatabaseHelper.categoriaTable} c ON l.${DatabaseHelper.colIdCategoria} = c.${DatabaseHelper.colIdCategoria}
      WHERE l.${DatabaseHelper.colIdLibro} = ?
    ''',
        [widget.libroId],
      );

      if (!mounted) return;

      if (bookResult.isNotEmpty) {
        setState(() {
          bookDetails = bookResult.first;
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar detalles del libro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _checkIfFavorite() async {
    try {
      final db = await _dbHelper.database;

      final favoriteResult = await db.query(
        DatabaseHelper.favoritosTable,
        where:
            '${DatabaseHelper.colIdUsuario} = ? AND ${DatabaseHelper.colIdLibro} = ?',
        whereArgs: [widget.userId, widget.libroId],
      );

      if (!mounted) return;

      setState(() {
        isFavorite =
            favoriteResult.isNotEmpty &&
            favoriteResult.first[DatabaseHelper.colEsFavorito] == 1;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al verificar favoritos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      await _favoritoDb.toggleFavorite(
        widget.libroId,
        widget.userId,
        !isFavorite,
      );

      if (!mounted) return;

      setState(() {
        isFavorite = !isFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite ? 'Añadido a favoritos' : 'Eliminado de favoritos',
          ),
          backgroundColor:
              isFavorite ? Colors.green : const Color.fromARGB(255, 56, 56, 56),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar favoritos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void openpdf(BuildContext context, String url) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(assetPath: url)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "DETALLE DEL LIBRO",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        backgroundColor: const Color(0xFF19ADA6),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookDetails.isEmpty
              ? const Center(
                  child: Text('No se encontró información del libro'),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: const Color(0xFFE8F5F5),
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    bookDetails['imagen_libro'] ??
                                        'https://via.placeholder.com/150',
                                    width: 120,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 120,
                                        height: 180,
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
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bookDetails['titulo'] ?? 'Sin título',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF083332),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Por ${bookDetails['autor'] ?? 'Autor desconocido'}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Sinopsis',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF083332),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        bookDetails['sinopsis'] ??
                                            'No hay sinopsis disponible',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF19ADA6),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed: () {
                                  final pdfUrl = bookDetails['pdf_libro'];
                                  if (pdfUrl != null && pdfUrl.isNotEmpty) {
                                    openpdf(context, pdfUrl);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Este libro no tiene PDF disponible'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.book),
                                label: const Text(
                                  "Leer",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: isFavorite
                                      ? Colors.red
                                      : const Color(0xFF19ADA6),
                                  side: BorderSide(
                                    color: isFavorite
                                        ? Colors.red
                                        : const Color(0xFF19ADA6),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed: _toggleFavorite,
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                                label: Text(
                                  isFavorite
                                      ? "Quitar de favoritos"
                                      : "Añadir a favoritos",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Información del libro',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF083332),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                'Título',
                                bookDetails['titulo'] ?? 'No disponible',
                              ),
                              _buildInfoRow(
                                'Autor',
                                bookDetails['autor'] ?? 'No disponible',
                              ),
                              _buildInfoRow(
                                'ISBN',
                                bookDetails['isbn'] ?? 'No disponible',
                              ),
                              _buildInfoRow(
                                'Año de publicación',
                                bookDetails['ano_publicacion']?.toString() ??
                                    'No disponible',
                              ),
                              _buildInfoRow(
                                'Categoría',
                                bookDetails['categoria'] ?? 'No disponible',
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}


