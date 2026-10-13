#!/bin/bash
cd /workspaces/tienda-backend
mkdir -p src/main/java/com/tienda/{dto,service,controller}
mkdir -p src/test/java/com/tienda

# ============ DTOs ============
cat > src/main/java/com/tienda/dto/LoginRequest.java << 'END'
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
END

cat > src/main/java/com/tienda/dto/LoginResponse.java << 'END'
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
END

cat > src/main/java/com/tienda/dto/RegisterRequest.java << 'END'
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
END

# ============ UsuarioService ============
cat > src/main/java/com/tienda/service/UsuarioService.java << 'END'
package com.tienda.service;

import com.tienda.dto.RegisterRequest;
import com.tienda.model.Usuario;
import com.tienda.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;

@Service
public class UsuarioService {

    @Autowired private UsuarioRepository usuarioRepository;
    @Autowired private PasswordEncoder passwordEncoder;

    @Transactional
    public Usuario registrar(RegisterRequest req) {
        if (usuarioRepository.existsByUsername(req.getUsername()))
            throw new RuntimeException("El username ya existe");
        if (usuarioRepository.existsByEmail(req.getEmail()))
            throw new RuntimeException("El email ya existe");
        Usuario u = new Usuario(req.getUsername(),
                passwordEncoder.encode(req.getPassword()),
                req.getEmail(),
                Collections.singleton("ROLE_USER"));
        return usuarioRepository.save(u);
    }
}
END

# ============ ProductoService ============
cat > src/main/java/com/tienda/service/ProductoService.java << 'END'
package com.tienda.service;

import com.tienda.model.Producto;
import com.tienda.repository.ProductoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class ProductoService {

    @Autowired private ProductoRepository productoRepository;

    public List<Producto> listarTodos() { return productoRepository.findAll(); }
    public Optional<Producto> obtenerPorId(Long id) { return productoRepository.findById(id); }

    @Transactional
    public Producto guardar(Producto p) { return productoRepository.save(p); }

    @Transactional
    public Optional<Producto> actualizar(Long id, Producto a) {
        return productoRepository.findById(id).map(p -> {
            p.setNombre(a.getNombre());
            p.setDescripcion(a.getDescripcion());
            p.setPrecio(a.getPrecio());
            p.setStock(a.getStock());
            p.setCategoria(a.getCategoria());
            p.setCodigoBarras(a.getCodigoBarras());
            return productoRepository.save(p);
        });
    }

    @Transactional
    public boolean eliminar(Long id) {
        if (productoRepository.existsById(id)) {
            productoRepository.deleteById(id);
            return true;
        }
        return false;
    }

    public List<Producto> buscarPorCategoria(String categoria) {
        return productoRepository.findByCategoriaIgnoreCase(categoria);
    }

    public List<Producto> buscarPorNombre(String nombre) {
        return productoRepository.findByNombreContainingIgnoreCase(nombre);
    }

    @Transactional
    public boolean reducirStock(Long productoId, Integer cantidad) {
        return productoRepository.findById(productoId).map(p -> {
            if (p.getStock() >= cantidad) {
                p.setStock(p.getStock() - cantidad);
                productoRepository.save(p);
                return true;
            }
            return false;
        }).orElse(false);
    }
}
END

# ============ ClienteService ============
cat > src/main/java/com/tienda/service/ClienteService.java << 'END'
package com.tienda.service;

import com.tienda.model.Cliente;
import com.tienda.repository.ClienteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class ClienteService {

    @Autowired private ClienteRepository clienteRepository;

    public List<Cliente> listarTodos() { return clienteRepository.findAll(); }
    public Optional<Cliente> obtenerPorId(Long id) { return clienteRepository.findById(id); }

    @Transactional
    public Cliente guardar(Cliente c) { return clienteRepository.save(c); }

    @Transactional
    public Optional<Cliente> actualizar(Long id, Cliente a) {
        return clienteRepository.findById(id).map(c -> {
            c.setNombre(a.getNombre());
            c.setApellido(a.getApellido());
            c.setEmail(a.getEmail());
            c.setTelefono(a.getTelefono());
            c.setDireccion(a.getDireccion());
            c.setDni(a.getDni());
            return clienteRepository.save(c);
        });
    }

    @Transactional
    public boolean eliminar(Long id) {
        if (clienteRepository.existsById(id)) {
            clienteRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
END

# ============ VentaService ============
cat > src/main/java/com/tienda/service/VentaService.java << 'END'
package com.tienda.service;

import com.tienda.model.Cliente;
import com.tienda.model.DetalleVenta;
import com.tienda.model.Venta;
import com.tienda.repository.ClienteRepository;
import com.tienda.repository.VentaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class VentaService {

    @Autowired private VentaRepository ventaRepository;
    @Autowired private ClienteRepository clienteRepository;
    @Autowired private ProductoService productoService;

    public List<Venta> listarTodas() { return ventaRepository.findAll(); }
    public Optional<Venta> obtenerPorId(Long id) { return ventaRepository.findById(id); }

    @Transactional
    public Venta registrarVenta(Venta venta) {
        venta.setFecha(new Date());
        venta.setEstado("COMPLETADA");
        for (DetalleVenta detalle : venta.getDetalles()) {
            detalle.recalcularSubtotal();
            boolean ok = productoService.reducirStock(
                    detalle.getProducto().getId(), detalle.getCantidad());
            if (!ok) throw new RuntimeException(
                    "Stock insuficiente para: " + detalle.getProducto().getNombre());
        }
        venta.recalcularTotal();
        return ventaRepository.save(venta);
    }

    @Transactional
    public Optional<Venta> actualizarEstado(Long id, String estado) {
        return ventaRepository.findById(id).map(v -> {
            v.setEstado(estado);
            return ventaRepository.save(v);
        });
    }

    public List<Venta> ventasPorCliente(Long clienteId) {
        return ventaRepository.findByClienteId(clienteId);
    }

    public List<Cliente> listarClientes() { return clienteRepository.findAll(); }
}
END

# ============ AuthController ============
cat > src/main/java/com/tienda/controller/AuthController.java << 'END'
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
END

# ============ ProductoController ============
cat > src/main/java/com/tienda/controller/ProductoController.java << 'END'
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
        return productoService.obtenerPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Producto> crear(@Valid @RequestBody Producto producto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(productoService.guardar(producto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Producto> actualizar(@PathVariable Long id,
                                               @Valid @RequestBody Producto producto) {
        return productoService.actualizar(id, producto)
                .map(ResponseEntity::ok)
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
END

# ============ ClienteController ============
cat > src/main/java/com/tienda/controller/ClienteController.java << 'END'
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
        return clienteService.obtenerPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Cliente> crear(@Valid @RequestBody Cliente cliente) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(clienteService.guardar(cliente));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Cliente> actualizar(@PathVariable Long id,
                                              @Valid @RequestBody Cliente cliente) {
        return clienteService.actualizar(id, cliente)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        if (clienteService.eliminar(id)) return ResponseEntity.noContent().build();
        return ResponseEntity.notFound().build();
    }
}
END

# ============ VentaController ============
cat > src/main/java/com/tienda/controller/VentaController.java << 'END'
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
        return ventaService.obtenerPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<?> registrar(@RequestBody Venta venta) {
        try {
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(ventaService.registrarVenta(venta));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/{id}/estado")
    public ResponseEntity<Venta> actualizarEstado(@PathVariable Long id,
                                                  @RequestParam String estado) {
        return ventaService.actualizarEstado(id, estado)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/cliente/{clienteId}")
    public ResponseEntity<List<Venta>> ventasPorCliente(@PathVariable Long clienteId) {
        return ResponseEntity.ok(ventaService.ventasPorCliente(clienteId));
    }
}
END

echo " TODOS los archivos creados correctamente"
find src/main/java -name "*.java" | sort


chmod +x generar_archivos.sh
./generar_archivos.sh

