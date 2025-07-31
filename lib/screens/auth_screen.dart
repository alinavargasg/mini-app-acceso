import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_app_acceso/auth/auth_service.dart';
import '../utils/validators.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _clearInputs();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _clearInputs() {
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
    _ageController.clear();
    _confirmPasswordController.clear();
  }

  void _toggleAuthMode() {
    _formKey.currentState?.reset();
    _clearInputs();
    FocusScope.of(context).unfocus();
    setState(() => _isLogin = !_isLogin);
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await _handleLogin();
      } else {
        await _handleRegistration();
      }
    } on FirebaseAuthException catch (e) {
      _showAuthError(e);
    } catch (e) {
      _showGenericError(e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogin() async {
    //try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return; // <- Verificación crucial
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    //}
  }

  Future<void> _handleRegistration() async {
    final user = await _auth.registerUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
    );

    if (user != null) {
      _showSuccessMessage('¡Registro exitoso!');
      _toggleAuthMode();
    }
  }

  void _showAuthError(FirebaseAuthException e) {
    final errorMessage = _getErrorMessage(e);
    _showErrorMessage(errorMessage);
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'wrong-password':
      case 'user-not-found':
        return 'Credenciales incorrectas';
      case 'email-already-in-use':
        return 'El correo ya está registrado';
      default:
        return 'Error: ${e.message}';
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showGenericError(dynamic error) {
    _showErrorMessage('Error inesperado: $error');
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: Validators.validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
      obscureText: _obscurePassword,
      validator: Validators.validatePassword,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Confirmar contraseña',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: _toggleConfirmPasswordVisibility,
        ),
      ),
      obscureText: _obscureConfirmPassword,
      validator: (value) => Validators.validatePasswordMatch(
        _passwordController.text,
        value,
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Nombre completo',
        prefixIcon: Icon(Icons.person),
      ),
      validator: Validators.validateName,
    );
  }

  Widget _buildAgeField() {
    return TextFormField(
      controller: _ageController,
      decoration: const InputDecoration(
        labelText: 'Edad',
        prefixIcon: Icon(Icons.numbers),
      ),
      keyboardType: TextInputType.number,
      validator: Validators.validateAge,
    );
  }

  Widget _buildAuthButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submit,
      child: Text(_isLogin ? 'Iniciar Sesión' : 'Registrarse'),
    );
  }

  Widget _buildToggleAuthButton() {
    return TextButton(
      onPressed: _isLoading ? null : _toggleAuthMode,
      child: Text(_isLogin
          ? '¿No tienes cuenta? Regístrate'
          : '¿Ya tienes cuenta? Inicia sesión'),
    );
  }

  Widget _buildRegistrationFields() {
    if (_isLogin) return const SizedBox.shrink();

    return Column(
      children: [
        _buildConfirmPasswordField(),
        const SizedBox(height: 16),
        _buildNameField(),
        const SizedBox(height: 16),
        _buildAgeField(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Iniciar Sesión' : 'Registrarse')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                _buildRegistrationFields(),
                const SizedBox(height: 20),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  Column(
                    children: [
                      _buildAuthButton(),
                      _buildToggleAuthButton(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}