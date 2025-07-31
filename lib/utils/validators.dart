class Validators {
  // Validación para nombres (solo letras y espacios)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es obligatorio';
    }
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$').hasMatch(value)) {
      return 'Solo se permiten letras y espacios';
    }
    if (value.length < 3) {
      return 'Mínimo 3 caracteres';
    }
    return null;
  }

  // Validación para edad (número positivo)
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'La edad es obligatoria';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'Debe ser un número válido';
    }
    if (age <= 0) {
      return 'La edad debe ser mayor a 0';
    }
    if (age > 120) {
      return 'Edad no válida';
    }
    return null;
  }

  // Validación para email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es obligatorio';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingrese un email válido';
    }
    return null;
  }

  // Validación para contraseña
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value.length < 6) {
      return 'Mínimo 6 caracteres';
    }
    return null;
  }

  /// Valida que dos contraseñas coincidan
  static String? validatePasswordMatch(
      String? password,
      String? confirmPassword,
      ) {
    if (password != confirmPassword) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

}