import 'package:flutter/material.dart';

class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildBookCard(
              title: "Cien años de soledad",
              year: "1967 • Colombia",
              genres: ["Ficción", "Realismo mágico"],
              imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSw3Brx-rX8vnshQ-BcFFnzjTGtoJzwG8ka4Q&s",
            ),
            _buildBookCard(
              title: "El señor de los anillos",
              year: "1954 • Reino Unido",
              genres: ["Fantasía", "Aventura"],
              imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIr1UuugXCIim35lyIBMaHQXLXtZqUQnnxDg&s",
            ),
            _buildBookCard(
              title: "Harry Potter y la piedra filosofal",
              year: "1997 • Reino Unido",
              genres: ["Fantasía", "Juvenil"],
              imageUrl: "https://m.media-amazon.com/images/I/51MFJN8JBFL._AC_UF1000,1000_QL80_.jpg",
            ),
            _buildBookCard(
              title: "El principito",
              year: "1943 • Francia",
              genres: ["Fábula", "Literatura infantil"],
              imageUrl: "https://m.media-amazon.com/images/I/71AVK5VIAzL._AC_UF1000,1000_QL80_.jpg",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard({
    required String title,
    required String year,
    required List<String> genres,
    required String imageUrl,
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
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF083332)),
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
                    children: genres
                        .map((genre) => Chip(
                              label: Text(genre, style: const TextStyle(fontSize: 11, color: Color(0xFF5E8585))),
                              backgroundColor: const Color(0xFFCAD9DC),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ))
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () {},
                        child: const Text("Leer", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                      const Icon(Icons.favorite, color: Colors.red, size: 24),
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

