import 'package:flutter/material.dart';

class DetalleLibroScreen extends StatefulWidget {
  const DetalleLibroScreen({super.key});

  @override
  State<DetalleLibroScreen> createState() => _DetalleLibroScreenState();
}

class _DetalleLibroScreenState extends State<DetalleLibroScreen> {
  bool isFavorite = false;

  // Este modelo simula los datos que obtendrías de tu base de datos
  Map<String, dynamic> bookDetails = {
    'id_libro': 1,
    'titulo': 'Cien años de soledad',
    'isbn': '9788437601138',
    'sinopsis':
        'La historia de la familia Buendía a lo largo de siete generaciones en el pueblo ficticio de Macondo. Una obra maestra del realismo mágico que explora temas de soledad, amor y la repetición cíclica de la historia.',
    'año_publicacion': '1967',
    'pdf_libro': 'assets/pdf/cien_anios.pdf',
    'imagen_libro':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSw3Brx-rX8vnshQ-BcFFnzjTGtoJzwG8ka4Q&s',
    'autor': 'Gabriel García Márquez',
    'categoria': 'Realismo mágico',
  };

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  void _checkIfFavorite() {
    setState(() {
      isFavorite = true; // Solo para demo
    });
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _downloadBook() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Descargando libro...')));
  }

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
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera con imagen, título, autor y sinopsis
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
                      // Imagen del libro
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          bookDetails['imagen_libro'],
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Título y autor (información básica)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookDetails['titulo'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF083332),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Por ${bookDetails['autor']}',
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
                              bookDetails['sinopsis'],
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

            // Botones de acción
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Botón de lectura
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF19ADA6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        // Implementar navegación a la pantalla de lectura
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Abriendo libro...')));
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
                  // Botón de descarga
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF19ADA6),
                        side: const BorderSide(color: Color(0xFF19ADA6)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: _downloadBook,
                      icon: const Icon(Icons.download),
                      label: const Text(
                        "Descargar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Información adicional
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
                    _buildInfoRow('Título', bookDetails['titulo']),
                    _buildInfoRow('Autor', bookDetails['autor']),
                    _buildInfoRow('ISBN', bookDetails['isbn']),
                    _buildInfoRow(
                        'Año de publicación', bookDetails['año_publicacion']),
                    _buildInfoRow('Categoría', bookDetails['categoria']),
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
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
