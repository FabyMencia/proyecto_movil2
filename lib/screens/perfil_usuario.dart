import 'package:flutter/material.dart';
import 'package:proyecto_libreria/database/Favorito_db.dart';
import 'package:proyecto_libreria/model/Users.dart';
import 'package:proyecto_libreria/database/Usuario_db.dart';
import 'package:proyecto_libreria/screens/custom_navbar.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UsuarioDB usuarioQuery = UsuarioDB();
  final Favoritodb = FavoritoDB();
  Users? user;
  bool isLoading = true;
  bool _isLoading = true;
  String _errorMessage = '';
  String errorMessage = '';
  String favoriteAuthor = 'Cargando...';
  String favoriteBook = 'Cargando...';
   List<Map<String, dynamic>> _favoritos = [];
  @override
  void initState() {
    super.initState();
    _fetchUser();
    _loadFavoriteauthorybook();
    _loadFavoritos();
  }

  Future<void> _fetchUser() async {
    try {
      Users? fetchedUser = await usuarioQuery.getUserById(widget.userId);

      setState(() {
        user = fetchedUser;
        isLoading = false;
        if (fetchedUser == null) {
          errorMessage =
              'Usuario no encontrado. Verifica que la base de datos se haya inicializado correctamente.';
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error al cargar datos: $e';
      });
    }
  }

  Future<void> _loadFavoriteauthorybook() async {
    final result = await Favoritodb.getFavoriteAuthorAndBook(widget.userId);

    setState(() {
      favoriteAuthor = result?['favorite_author'] ?? "No hay datos";
      favoriteBook = result?['favorite_book'] ?? "No hay datos";
    });
  }

  Future<void> _loadFavoritos() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final favoritos = await Favoritodb.getUserFavorites(widget.userId);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCAD9DC),
      appBar: AppBar(
        title: const Text(
          'Perfil de Usuario',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF19ADA6),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF0B837D)),
              )
              : user == null
              ? _buildErrorState()
              : _buildProfileContent(),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: Color(0xFFCAD9DC),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 70,
                color: Color(0xFFE24443),
              ),
              const SizedBox(height: 20),
              const Text(
                'Usuario no encontrado',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF083332),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                errorMessage,
                style: const TextStyle(color: Color(0xFFE24443), fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = '';
                  });
                  _fetchUser();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0B837D),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Reintentar',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return Container(
      color: Color(0xFFCAD9DC),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Sección de cabecera con fondo degradado
          _buildProfileHeader(),
          // Contenido del perfil
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Favorite Author
                _buildSectionCard(
                  title: "Autor Favorito",
                  content: favoriteAuthor,
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                // Most Read Book
                _buildSectionCard(
                  title: "Libro Más Leido",
                  content: favoriteBook,
                  icon: Icons.book,
                ),
                const SizedBox(height: 16),
                // Most Read Books
                _buildBookListSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF19ADA6), Color(0xFF0B837D)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
        child: Column(
          children: [
            // Avatar con borde
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/profile.jpg'),
                backgroundColor: Color(0xFF5E8585),
                onBackgroundImageError: (_, __) {},
              ),
            ),
            const SizedBox(height: 16),
            // Nombre de usuario
            Text(
              "${user!.nombre} ${user!.apellido}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // Descripción
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                user!.descripcion ?? "Descripcion no disponible",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Chip(
              label: Text(
                "Género: ${user!.genero}",
                style: const TextStyle(
                  color: Color(0xFF083332),
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF0B837D),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
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
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF6E949C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: const [
              Icon(Icons.bookmarks, color: Color(0xFF19ADA6), size: 22),
              SizedBox(width: 8),
              Text(
                "Libros Más Leidos",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF083332),
                ),
              ),
            ],
          ),
        ),
        Container(
          constraints: BoxConstraints(maxHeight: 240, minHeight: 200),
          child: _buildBookList(),
        ),
      ],
    );
  }

  Widget _buildBookList() {

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _favoritos.length,
      clipBehavior: Clip.antiAlias,
      itemBuilder: (context, index) {
        final books = _favoritos[index];
        return Container(
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
                    books['imagen_libro']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Color(0xFF5E8585),
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
                books['titulo']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF083332),
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),
              // Autor del libro
              Text(
                books['nombre_autor']!,
                style: const TextStyle(fontSize: 11, color: Color(0xFF6E949C)),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
