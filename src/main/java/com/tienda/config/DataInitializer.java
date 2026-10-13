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
