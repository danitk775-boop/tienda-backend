package com.tienda.controller;

import com.tienda.repository.ClienteRepository;
import com.tienda.repository.ProductoRepository;
import com.tienda.repository.UsuarioRepository;
import com.tienda.repository.VentaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/db-info")
@CrossOrigin(origins = "*")
public class DbDebugController {

    @Autowired private UsuarioRepository usuarioRepository;
    @Autowired private ProductoRepository productoRepository;
    @Autowired private ClienteRepository clienteRepository;
    @Autowired private VentaRepository ventaRepository;

    @GetMapping
    public Map<String, Object> info() {
        Map<String, Object> m = new HashMap<>();
        m.put("motor", "H2 Database");
        m.put("modo", "En memoria");
        m.put("jdbc_url", "jdbc:h2:mem:tienda_db");
        m.put("tablas", new String[]{
            "usuarios", "usuario_roles", "productos",
            "clientes", "ventas", "detalle_ventas"
        });
        m.put("total_usuarios", usuarioRepository.count());
        m.put("total_productos", productoRepository.count());
        m.put("total_clientes", clienteRepository.count());
        m.put("total_ventas", ventaRepository.count());
        m.put("usuarios", usuarioRepository.findAll());
        m.put("productos", productoRepository.findAll());
        m.put("clientes", clienteRepository.findAll());
        return m;
    }
}
