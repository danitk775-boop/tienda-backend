package com.tienda.service;

import com.tienda.model.Producto;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ProductoService {
    
    private List<Producto> productos = new ArrayList<>();
    private Long contadorId = 1L;
    
    public ProductoService() {
        productos.add(new Producto(contadorId++, "Laptop HP", 
                "Laptop 14 pulgadas, 8GB RAM", 899.99, 10, "Electrónica", "HP001"));
        productos.add(new Producto(contadorId++, "Teclado Mecánico", 
                "Teclado RGB con switches azules", 45.50, 25, "Periféricos", "TEC001"));
        productos.add(new Producto(contadorId++, "Mouse Logitech", 
                "Mouse inalámbrico ergonómico", 29.99, 30, "Periféricos", "MOU001"));
        productos.add(new Producto(contadorId++, "Monitor Samsung", 
                "Monitor 24 pulgadas Full HD", 199.99, 8, "Electrónica", "MON001"));
        productos.add(new Producto(contadorId++, "Audífonos Sony", 
                "Audífonos Bluetooth con cancelación", 89.99, 15, "Audio", "AUD001"));
    }
    
    public List<Producto> listarTodos() {
        return new ArrayList<>(productos);
    }
    
    public Optional<Producto> obtenerPorId(Long id) {
        return productos.stream()
                .filter(p -> p.getId().equals(id))
                .findFirst();
    }
    
    public Producto guardar(Producto producto) {
        producto.setId(contadorId++);
        productos.add(producto);
        return producto;
    }
    
    public Optional<Producto> actualizar(Long id, Producto productoActualizado) {
        return obtenerPorId(id).map(p -> {
            p.setNombre(productoActualizado.getNombre());
            p.setDescripcion(productoActualizado.getDescripcion());
            p.setPrecio(productoActualizado.getPrecio());
            p.setStock(productoActualizado.getStock());
            p.setCategoria(productoActualizado.getCategoria());
            p.setCodigoBarras(productoActualizado.getCodigoBarras());
            return p;
        });
    }
    
    public boolean eliminar(Long id) {
        return productos.removeIf(p -> p.getId().equals(id));
    }
    
    public List<Producto> buscarPorCategoria(String categoria) {
        return productos.stream()
                .filter(p -> p.getCategoria().equalsIgnoreCase(categoria))
                .collect(Collectors.toList());
    }
    
    public boolean reducirStock(Long productoId, Integer cantidad) {
        return obtenerPorId(productoId).map(p -> {
            if (p.getStock() >= cantidad) {
                p.setStock(p.getStock() - cantidad);
                return true;
            }
            return false;
        }).orElse(false);
    }
}
