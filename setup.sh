#!/bin/bash
set -e
cd /workspaces/tienda-backend

echo "==> Creando carpetas..."
mkdir -p src/main/java/com/tienda/config
mkdir -p src/main/java/com/tienda/dto
mkdir -p src/main/java/com/tienda/controller
mkdir -p src/main/java/com/tienda/model
mkdir -p src/main/resources
mkdir -p src/test/java/com/tienda

# ============ application.properties ============
cat > src/main/resources/application.properties << 'X'
server.port=8080
spring.main.banner-mode=off
spring.datasource.url=jdbc:h2:mem:tienda_db;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console
jwt.secret=ClaveSuperSecretaParaTiendaBackendJWTDemo2025XYZ1234567890
jwt.expiration=86400000
logging.level.com.tienda=DEBUG
X

# ============ TiendaApplication ============
cat > src/main/java/com/tienda/TiendaApplication.java << 'X'
package com.tienda;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class TiendaApplication {
    public static void main(String[] args) {
        SpringApplication.run(TiendaApplication.class, args);
        System.out.println("=========================================");
        System.out.println(" TIENDA API CORRIENDO");
        System.out.println(" http://localhost:8080");
        System.out.println(" H2: http://localhost:8080/h2-console");
        System.out.println("=========================================");
    }
}
X

# ============ MODEL: Usuario ============
cat > src/main/java/com/tienda/model/Usuario.java << 'X'
package com.tienda.model;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "usuarios")
public class Usuario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String username;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false, unique = true, length = 100)
    private String email;

    @Column(nullable = false)
    private Boolean activo = true;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "usuario_roles", joinColumns = @JoinColumn(name = "usuario_id"))
    @Column(name = "rol")
    private Set<String> roles = new HashSet<>();

    public Usuario() {}

    public Usuario(String username, String password, String email, Set<String> roles) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.roles = roles;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public Boolean getActivo() { return activo; }
    public void setActivo(Boolean activo) { this.activo = activo; }
    public Set<String> getRoles() { return roles; }
    public void setRoles(Set<String> roles) { this.roles = roles; }
}
X

# ============ MODEL: Producto ============
cat > src/main/java/com/tienda/model/Producto.java << 'X'
package com.tienda.model;

import javax.persistence.*;
import javax.validation.constraints.*;

@Entity
@Table(name = "productos")
public class Producto {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "El nombre es obligatorio")
    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(length = 255)
    private String descripcion;

    @NotNull
    @DecimalMin(value = "0.0", inclusive = false)
    @Column(nullable = false)
    private Double precio;

    @NotNull
    @Min(0)
    @Column(nullable = false)
    private Integer stock;

    @NotBlank
    @Column(nullable = false, length = 50)
    private String categoria;

    @Column(length = 50, unique = true)
    private String codigoBarras;

    public Producto() {}

    public Producto(String nombre, String descripcion, Double precio,
                    Integer stock, String categoria, String codigoBarras) {
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.precio = precio;
        this.stock = stock;
        this.categoria = categoria;
        this.codigoBarras = codigoBarras;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public Double getPrecio() { return precio; }
    public void setPrecio(Double precio) { this.precio = precio; }
    public Integer getStock() { return stock; }
    public void setStock(Integer stock) { this.stock = stock; }
    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }
    public String getCodigoBarras() { return codigoBarras; }
    public void setCodigoBarras(String codigoBarras) { this.codigoBarras = codigoBarras; }
}
X

# ============ MODEL: Cliente ============
cat > src/main/java/com/tienda/model/Cliente.java << 'X'
package com.tienda.model;

import javax.persistence.*;
import javax.validation.constraints.*;

@Entity
@Table(name = "clientes")
public class Cliente {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Column(nullable = false, length = 50)
    private String nombre;

    @NotBlank
    @Column(nullable = false, length = 50)
    private String apellido;

    @Email
    @Column(nullable = false, unique = true, length = 100)
    private String email;

    @Column(length = 20)
    private String telefono;

    @Column(length = 200)
    private String direccion;

    @NotBlank
    @Column(nullable = false, unique = true, length = 20)
    private String dni;

    public Cliente() {}

    public Cliente(String nombre, String apellido, String email,
                   String telefono, String direccion, String dni) {
        this.nombre = nombre;
        this.apellido = apellido;
        this.email = email;
        this.telefono = telefono;
        this.direccion = direccion;
        this.dni = dni;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }
    public String getDni() { return dni; }
    public void setDni(String dni) { this.dni = dni; }
}
X

# ============ MODEL: DetalleVenta ============
cat > src/main/java/com/tienda/model/DetalleVenta.java << 'X'
package com.tienda.model;

import javax.persistence.*;

@Entity
@Table(name = "detalle_ventas")
public class DetalleVenta {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "producto_id", nullable = false)
    private Producto producto;

    @Column(nullable = false)
    private Integer cantidad;

    @Column(nullable = false)
    private Double precioUnitario;

    @Column(nullable = false)
    private Double subtotal;

    public DetalleVenta() {}

    public DetalleVenta(Producto producto, Integer cantidad, Double precioUnitario) {
        this.producto = producto;
        this.cantidad = cantidad;
        this.precioUnitario = precioUnitario;
        this.subtotal = precioUnitario * cantidad;
    }

    public void recalcularSubtotal() {
        this.subtotal = this.precioUnitario * this.cantidad;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Producto getProducto() { return producto; }
    public void setProducto(Producto producto) { this.producto = producto; }
    public Integer getCantidad() { return cantidad; }
    public void setCantidad(Integer cantidad) { this.cantidad = cantidad; }
    public Double getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(Double precioUnitario) { this.precioUnitario = precioUnitario; }
    public Double getSubtotal() { return subtotal; }
    public void setSubtotal(Double subtotal) { this.subtotal = subtotal; }
}
X

# ============ DTO: LoginRequest ============
cat > src/main/java/com/tienda/dto/LoginRequest.java << 'X'
package com.tienda.dto;

import javax.validation.constraints.NotBlank;

public class LoginRequest {
    @NotBlank private String username;
    @NotBlank private String password;
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
X

# ============ DTO: LoginResponse ============
cat > src/main/java/com/tienda/dto/LoginResponse.java << 'X'
package com.tienda.dto;

import java.util.Set;

public class LoginResponse {
    private String token;
    private String username;
    private Set<String> roles;
    private String tipo = "Bearer";

    public LoginResponse(String token, String username, Set<String> roles) {
        this.token = token;
        this.username = username;
        this.roles = roles;
    }
    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public Set<String> getRoles() { return roles; }
    public void setRoles(Set<String> roles) { this.roles = roles; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
}
X

# ============ DTO: RegisterRequest ============
cat > src/main/java/com/tienda/dto/RegisterRequest.java << 'X'
package com.tienda.dto;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

public class RegisterRequest {
    @NotBlank @Size(min = 4, max = 50)
    private String username;
    @NotBlank @Size(min = 6)
    private String password;
    @NotBlank @Email
    private String email;
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
X

# ============ CONFIG: SecurityConfig ============
cat > src/main/java/com/tienda/config/SecurityConfig.java << 'X'
package com.tienda.config;

import com.tienda.security.CustomUserDetailsService;
import com.tienda.security.JwtAuthenticationFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired private CustomUserDetailsService userDetailsService;
    @Autowired private JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService).passwordEncoder(passwordEncoder());
    }

    @Override
    @Bean
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.cors().and()
            .csrf().disable()
            .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            .and()
            .authorizeRequests()
                .antMatchers("/api/auth/**").permitAll()
                .antMatchers("/h2-console/**").permitAll()
                .antMatchers(HttpMethod.GET, "/api/productos/**").permitAll()
                .anyRequest().authenticated()
            .and()
            .headers().frameOptions().sameOrigin();
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration c = new CorsConfiguration();
        c.setAllowedOriginPatterns(Arrays.asList("*"));
        c.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        c.setAllowedHeaders(Arrays.asList("*"));
        c.setAllowCredentials(true);
        UrlBasedCorsConfigurationSource s = new UrlBasedCorsConfigurationSource();
        s.registerCorsConfiguration("/**", c);
        return s;
    }
}
X

# ============ CONFIG: DataInitializer ============
cat > src/main/java/com/tienda/config/DataInitializer.java << 'X'
package com.tienda.config;

import com.tienda.model.Cliente;
import com.tienda.model.Producto;
import com.tienda.model.Usuario;
import com.tienda.repository.ClienteRepository;
import com.tienda.repository.ProductoRepository;
import com.tienda.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.Set;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired private UsuarioRepository usuarioRepository;
    @Autowired private ProductoRepository productoRepository;
    @Autowired private ClienteRepository clienteRepository;
    @Autowired private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        if (usuarioRepository.count() == 0) {
            Set<String> a = new HashSet<>();
            a.add("ROLE_ADMIN");
            a.add("ROLE_USER");
            usuarioRepository.save(new Usuario("admin",
                    passwordEncoder.encode("admin123"), "admin@tienda.com", a));
            Set<String> u = new HashSet<>();
            u.add("ROLE_USER");
            usuarioRepository.save(new Usuario("user",
                    passwordEncoder.encode("user123"), "user@tienda.com", u));
            System.out.println(">>> Usuarios: admin/admin123, user/user123");
        }
        if (productoRepository.count() == 0) {
            productoRepository.save(new Producto("Laptop HP","Laptop 14 pulgadas 8GB RAM",899.99,10,"Electronica","HP001"));
            productoRepository.save(new Producto("Teclado Mecanico","Teclado RGB",45.50,25,"Perifericos","TEC001"));
            productoRepository.save(new Producto("Mouse Logitech","Mouse inalambrico",29.99,30,"Perifericos","MOU001"));
            productoRepository.save(new Producto("Monitor Samsung","24 pulgadas Full HD",199.99,8,"Electronica","MON001"));
            productoRepository.save(new Producto("Audifonos Sony","Bluetooth cancelacion",89.99,15,"Audio","AUD001"));
            System.out.println(">>> 5 productos cargados");
        }
        if (clienteRepository.count() == 0) {
            clienteRepository.save(new Cliente("Juan","Perez","juan@email.com","987654321","Av. Principal 123","12345678"));
            clienteRepository.save(new Cliente("Maria","Garcia","maria@email.com","987654322","Calle Secundaria 456","87654321"));
            clienteRepository.save(new Cliente("Carlos","Lopez","carlos@email.com","987654323","Av. Tercera 789","11223344"));
            System.out.println(">>> 3 clientes cargados");
        }
    }
}
X

# ============ CONTROLLER: AuthController ============
cat > src/main/java/com/tienda/controller/AuthController.java << 'X'
package com.tienda.controller;

import com.tienda.dto.LoginRequest;
import com.tienda.dto.LoginResponse;
import com.tienda.dto.RegisterRequest;
import com.tienda.model.Usuario;
import com.tienda.repository.UsuarioRepository;
import com.tienda.security.CustomUserDetailsService;
import com.tienda.security.JwtUtil;
import com.tienda.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    @Autowired private AuthenticationManager authenticationManager;
    @Autowired private JwtUtil jwtUtil;
    @Autowired private CustomUserDetailsService userDetailsService;
    @Autowired private UsuarioService usuarioService;
    @Autowired private UsuarioRepository usuarioRepository;

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest req) {
        try {
            authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(req.getUsername(), req.getPassword()));
        } catch (Exception e) {
            return ResponseEntity.status(401).body("Credenciales incorrectas");
        }
        UserDetails ud = userDetailsService.loadUserByUsername(req.getUsername());
        Usuario u = usuarioRepository.findByUsername(req.getUsername()).orElseThrow();
        String token = jwtUtil.generateToken(ud.getUsername(), u.getRoles());
        return ResponseEntity.ok(new LoginResponse(token, ud.getUsername(), u.getRoles()));
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@Valid @RequestBody RegisterRequest req) {
        try {
            Usuario u = usuarioService.registrar(req);
            return ResponseEntity.status(201).body("Usuario creado: " + u.getUsername());
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
X

# ============ CONTROLLER: ProductoController ============
cat > src/main/java/com/tienda/controller/ProductoController.java << 'X'
package com.tienda.controller;

import com.tienda.model.Producto;
import com.tienda.service.ProductoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/productos")
@CrossOrigin(origins = "*")
public class ProductoController {

    @Autowired private ProductoService productoService;

    @GetMapping
    public ResponseEntity<List<Producto>> listarTodos() {
        return ResponseEntity.ok(productoService.listarTodos());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Producto> obtenerPorId(@PathVariable Long id) {
        return productoService.obtenerPorId(id).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Producto> crear(@Valid @RequestBody Producto p) {
        return ResponseEntity.status(HttpStatus.CREATED).body(productoService.guardar(p));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Producto> actualizar(@PathVariable Long id, @Valid @RequestBody Producto p) {
        return productoService.actualizar(id, p).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        if (productoService.eliminar(id)) return ResponseEntity.noContent().build();
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/categoria/{categoria}")
    public ResponseEntity<List<Producto>> porCategoria(@PathVariable String categoria) {
        return ResponseEntity.ok(productoService.buscarPorCategoria(categoria));
    }

    @GetMapping("/buscar")
    public ResponseEntity<List<Producto>> buscar(@RequestParam String nombre) {
        return ResponseEntity.ok(productoService.buscarPorNombre(nombre));
    }
}
X

# ============ CONTROLLER: ClienteController ============
cat > src/main/java/com/tienda/controller/ClienteController.java << 'X'
package com.tienda.controller;

import com.tienda.model.Cliente;
import com.tienda.service.ClienteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/clientes")
@CrossOrigin(origins = "*")
public class ClienteController {

    @Autowired private ClienteService clienteService;

    @GetMapping
    public ResponseEntity<List<Cliente>> listarTodos() {
        return ResponseEntity.ok(clienteService.listarTodos());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Cliente> obtenerPorId(@PathVariable Long id) {
        return clienteService.obtenerPorId(id).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Cliente> crear(@Valid @RequestBody Cliente c) {
        return ResponseEntity.status(HttpStatus.CREATED).body(clienteService.guardar(c));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Cliente> actualizar(@PathVariable Long id, @Valid @RequestBody Cliente c) {
        return clienteService.actualizar(id, c).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        if (clienteService.eliminar(id)) return ResponseEntity.noContent().build();
        return ResponseEntity.notFound().build();
    }
}
X

# ============ CONTROLLER: VentaController ============
cat > src/main/java/com/tienda/controller/VentaController.java << 'X'
package com.tienda.controller;

import com.tienda.model.Venta;
import com.tienda.service.VentaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ventas")
@CrossOrigin(origins = "*")
public class VentaController {

    @Autowired private VentaService ventaService;

    @GetMapping
    public ResponseEntity<List<Venta>> listarTodas() {
        return ResponseEntity.ok(ventaService.listarTodas());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Venta> obtenerPorId(@PathVariable Long id) {
        return ventaService.obtenerPorId(id).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<?> registrar(@RequestBody Venta venta) {
        try {
            return ResponseEntity.status(HttpStatus.CREATED).body(ventaService.registrarVenta(venta));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/{id}/estado")
    public ResponseEntity<Venta> actualizarEstado(@PathVariable Long id, @RequestParam String estado) {
        return ventaService.actualizarEstado(id, estado).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/cliente/{clienteId}")
    public ResponseEntity<List<Venta>> ventasPorCliente(@PathVariable Long clienteId) {
        return ResponseEntity.ok(ventaService.ventasPorCliente(clienteId));
    }
}
X

echo ""
echo "==================================================="
echo " ✅ TODOS los archivos fueron creados"
echo "==================================================="
echo ""
echo "Verificando..."
find src/main/java -name "*.java" | sort
echo ""
echo "Total de archivos Java:"
find src/main/java -name "*.java" | wc -l
