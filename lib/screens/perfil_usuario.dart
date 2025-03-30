import 'package:flutter/material.dart';
import 'package:proyecto_libreria/model/Users.dart';
import 'package:proyecto_libreria/database/Databasehelper.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Users? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    Users? fetchedUser = await databaseHelper.getUserById(widget.userId);
    setState(() {
      user = fetchedUser;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 153, 242, 209),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : user == null
              ? const Center(child: Text('User not found.'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        "${user!.nombre} ${user!.apellido}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          user!.descripcion ?? "No description available",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Favorite Author
                    buildSectionTitle("Favorite Author"),
                    buildInfoText("Margaret Atwood"),
                    const SizedBox(height: 10),
                    // Most Read Book
                    buildSectionTitle("Most Read Book"),
                    buildInfoText("The Handmaid's Tale"),
                    const SizedBox(height: 20),
                    // Most Read Books
                    buildSectionTitle("Most Read Books"),
                    const SizedBox(height: 10),
                    buildBookList(),
                  ],
                ),
              ),
    );
  }

  // Widget for section title
  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // Widget for info text
  Widget buildInfoText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
    );
  }

  // Widget for book list
  Widget buildBookList() {
    List<Map<String, String>> books = [
      {
        'title': "The Handmaid's Tale",
        'author': "Margaret Atwood",
        'image': 'assets/handmaids_tale.jpg',
      },
      {'title': "1984", 'author': "George Orwell", 'image': 'assets/1984.jpg'},
      {
        'title': "Brave New World",
        'author': "Aldous Huxley",
        'image': 'assets/brave_new_world.jpg',
      },
    ];

    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            books.map((book) {
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SizedBox(
                  width: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          book['image']!,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        book['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        book['author']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
