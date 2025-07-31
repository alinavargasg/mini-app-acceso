# 📱 Mini App de Autenticación con Flutter & Firebase

La aplicación móvil tiene las siguientes funcionalidades:
-	Permite registrarse como usuario, para lo cual, será necesario ingresar credenciales (usuario y contraseña) y datos personales (Nombre, edad y correo electrónico).
-	Permite autenticarse a través del uso de un usuario y una contraseña válidos.

## 🚀 Características Principales

- **Autenticación** con Firebase Auth
- **Formulario de registro** con validaciones (Firebase: Realtime Database)
  - Nombre completo (solo caracteres válidos)
  - Edad (número positivo)
  - Email (formato válido)
  - Contraseña (mínimo 6 caracteres)
- **Pantalla de inicio personalizada** con mensaje de Bienvenida
- **Logout**
- **Persistencia de sesión**
- **Manejo de errores** completo

## 🛠 Stack Tecnológico

| Tecnología       | Uso                          |
|------------------|------------------------------|
| Flutter          | Framework principal (v3.19+) |
| Firebase Auth    | Autenticación de usuarios    |
| Realtime Database| Almacenamiento de datos      |
| Provider         | Gestión de estado            |

## 📸 Capturas de Pantalla

| Login | Registro | Home |
|-------|----------|------|
| <img src="screenshots/form_inicio_sesion.jpg" width="200"> | <img src="screenshots/formulario_registro.jpg" width="200"> | <img src="screenshots/pantalla_inicio.jpg" width="200"> |

## Otras capturas de pantalla de la app

| <img src="screenshots/icono_de_acceso.jpg" width="100"> | <img src="screenshots/validacion1_inicio_sesion.jpg" width="100"> | <img src="screenshots/validacion2_inicio_sesion.jpg" width="100"> |<img src="screenshots/validacion1_registro.jpg" width="100"> |<img src="screenshots/validacion2_registro.jpg" width="100">|<img src="screenshots/validacion3_registro.jpg" width="100">|<img src="screenshots/registro_exitoso.jpg" width="100">|

## Capturas de pantalla correspondientes a Firebase

| Usuarios registrados | Configuracion validacion email | Datos tiempo real |
|-------|----------|------|
| <img src="screenshots/firebase_1.jpg" width="200"> | <img src="screenshots/firebase_2.jpg" width="200"> | <img src="screenshots/firebase_3.jpg" width="200"> |

## 🔧 Configuración

1. **Clona el repositorio**
   ```bash
   git clone https://github.com/alinavargasg/mini-app-acceso
   cd mini-app-acceso