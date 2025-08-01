import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    // Capturamos las instancias necesarias ANTES de cualquier operación async
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await FirebaseAuth.instance.signOut();

      // Verificamos el estado de navigator
      if (navigator.mounted) {
        await navigator.pushReplacementNamed('/login');
      }
    } catch (e) {
      // Verificamos el estado de messenger
      if (messenger.mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Error al cerrar sesión: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }

      // Opcional: Registrar el error
      debugPrint('Error durante logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Usuario';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen de bienvenida
            Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            Image.asset(
              'assets/images/welcome.jpg', // Asegúrate de tener esta imagen en tu carpeta assets
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),

            // Mensaje de bienvenida personalizado
            Text(
              '¡Bienvenido, $email!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Gracias por usar nuestra aplicación',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            // Botón de logout grande
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              onPressed: () => _signOut(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}