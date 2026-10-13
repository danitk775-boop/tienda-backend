<div align="center">

# 🛒 Tienda Backend

### Sistema de Gestión de Tienda — API REST con Spring Boot

</div>

---

## Descripción

> **API REST completa** para la gestión de una tienda, desarrollada con **Spring Boot**, **Spring Security**, **JWT** y **JPA/Hibernate**. Permite administrar productos, clientes y ventas mediante endpoints seguros autenticados con tokens JWT.

### Características principales

- 🔐 **Autenticación JWT** con tokens firmados HS256
- 👥 **Usuarios en base de datos** con roles (ADMIN / USER)
- 📦 **CRUD completo** de productos, clientes y ventas
- 🛡️ **Spring Security** con filtros por petición
- 💾 **Persistencia con JPA/Hibernate** sobre H2
- 🧪 **9 tests unitarios** con JUnit 5 + MockMvc
- 📊 **Consola H2** integrada para inspección de datos

---

## Tecnologías utilizadas

| | Tecnología | Versión | Rol |
|:-:|:-----------|:-------:|:----|
| ☕ | **Java** | 11 | Lenguaje base |
| 🌱 | **Spring Boot** | 2.7.0 | Framework principal |
| 🔐 | **Spring Security** | 5.7 | Autenticación/Autorización |
| 🎫 | **JJWT** | 0.11.5 | Generación de tokens JWT |
| 💾 | **Spring Data JPA** | 2.7 | Persistencia ORM |
| 🗄️ | **H2 Database** | 2.x | BD en memoria |
| 🔨 | **Maven** | 3.x | Build & dependencias |
| 🧪 | **JUnit 5** | 5.x | Testing |

---

## 🏗️ Arquitectura del proyecto

```text
📦 tienda-backend
 ┣ 📂 src/main/java/com/tienda
 ┃ ┣ 📜 TiendaApplication.java
 ┃ ┣ 📂 config
 ┃ ┃ ┣ 📜 SecurityConfig.java
 ┃ ┃ ┗ 📜 DataInitializer.java
 ┃ ┣ 📂 controller
 ┃ ┃ ┣ 📜 AuthController.java
 ┃ ┃ ┣ 📜 ProductoController.java
 ┃ ┃ ┣ 📜 ClienteController.java
 ┃ ┃ ┣ 📜 VentaController.java
 ┃ ┃ ┗ 📜 DbDebugController.java
 ┃ ┣ 📂 dto
 ┃ ┃ ┣ 📜 LoginRequest.java
 ┃ ┃ ┣ 📜 LoginResponse.java
 ┃ ┃ ┗ 📜 RegisterRequest.java
 ┃ ┣ 📂 model
 ┃ ┃ ┣ 📜 Usuario.java
 ┃ ┃ ┣ 📜 Producto.java
 ┃ ┃ ┣ 📜 Cliente.java
 ┃ ┃ ┣ 📜 Venta.java
 ┃ ┃ ┗ 📜 DetalleVenta.java
 ┃ ┣ 📂 repository
 ┃ ┃ ┣ 📜 UsuarioRepository.java
 ┃ ┃ ┣ 📜 ProductoRepository.java
 ┃ ┃ ┣ 📜 ClienteRepository.java
 ┃ ┃ ┗ 📜 VentaRepository.java
 ┃ ┣ 📂 security
 ┃ ┃ ┣ 📜 JwtUtil.java
 ┃ ┃ ┣ 📜 JwtAuthenticationFilter.java
 ┃ ┃ ┗ 📜 CustomUserDetailsService.java
 ┃ ┗ 📂 service
 ┃   ┣ 📜 UsuarioService.java
 ┃   ┣ 📜 ProductoService.java
 ┃   ┣ 📜 ClienteService.java
 ┃   ┗ 📜 VentaService.java
 ┗ 📂 src/test/java/com/tienda/controller
   ┣ 📜 AuthControllerTest.java
   ┣ 📜 ProductoControllerTest.java
   ┣ 📜 ClienteControllerTest.java
   ┗ 📜 VentaControllerTest.java

🔐 Seguridad con JWT
🔄 Flujo de autenticación

┌──────────┐                    ┌──────────────┐                ┌──────────────┐
│ Cliente  │ ─── 1. Login ────▶ │ AuthController│ ──▶ 2. Verifica│  BD Usuario  │
│          │                    │               │                │              │
│          │ ◀── 3. Token ───── │  JwtUtil      │ ◀── OK ─────── │  (BCrypt)    │
│          │                    └──────────────┘                └──────────────┘
│          │
│          │ ─── 4. Request + Bearer Token ───▶ ┌────────────────────┐
│          │                                     │  JwtAuthFilter     │
│          │ ◀── 5. Respuesta autorizada ───────  │  Valida y autoriza │
└──────────┘                                     └────────────────────┘

Características:

   Tokens firmados con HS256

⏰ Expiración configurable (24h por defecto)
🔑 Contraseñas hasheadas con BCrypt
👥 Roles desde base de datos (ROLE_ADMIN, ROLE_USER)










