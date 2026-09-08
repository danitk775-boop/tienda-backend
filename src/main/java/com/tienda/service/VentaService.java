package com.tienda.service;

import com.tienda.model.Cliente;
import com.tienda.model.DetalleVenta;
import com.tienda.model.Venta;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class VentaService {
    
    private List<Venta> ventas = new ArrayList<>();
    private List<Cliente> clientes = new ArrayList<>();
    private Long contadorVentaId = 1L;
    private Long contadorClienteId = 1L;
    private Long contadorDetalleId = 1L;
    
    @Autowired
    private ProductoService productoService;
    
    public VentaService() {
        clientes.add(new Cliente(contadorClienteId++, "Juan", "Pérez", 
                "juan.perez@email.com", "987654321", "Av. Principal 123", "12345678"));
        clientes.add(new Cliente(contadorClienteId++, "María", "García", 
                "maria.garcia@email.com", "987654322", "Calle Secundaria 456", "87654321"));
        clientes.add(new Cliente(contadorClienteId++, "Carlos", "López", 
                "carlos.lopez@email.com", "987654323", "Av. Tercera 789", "11223344"));
    }
    
    public List<Venta> listarTodas() {
        return new ArrayList<>(ventas);
    }
    
    public Optional<Venta> obtenerPorId(Long id) {
        return ventas.stream()
                .filter(v -> v.getId().equals(id))
                .findFirst();
    }
    
    public Venta registrarVenta(Venta venta) {
        venta.setId(contadorVentaId++);
        venta.setFecha(new Date());
        venta.setEstado("COMPLETADA");
        
        for (DetalleVenta detalle : venta.getDetalles()) {
            detalle.setId(contadorDetalleId++);
            productoService.reducirStock(
                detalle.getProducto().getId(), 
                detalle.getCantidad()
            );
        }
        
        venta.setTotal(venta.getDetalles().stream()
                .mapToDouble(DetalleVenta::getSubtotal)
                .sum());
        
        ventas.add(venta);
        return venta;
    }
    
    public Optional<Venta> actualizarEstado(Long id, String estado) {
        return obtenerPorId(id).map(v -> {
            v.setEstado(estado);
            return v;
        });
    }
    
    public List<Venta> ventasPorCliente(Long clienteId) {
        return ventas.stream()
                .filter(v -> v.getCliente().getId().equals(clienteId))
                .collect(Collectors.toList());
    }
    
    public List<Cliente> listarClientes() {
        return new ArrayList<>(clientes);
    }
    
    public Optional<Cliente> obtenerClientePorId(Long id) {
        return clientes.stream()
                .filter(c -> c.getId().equals(id))
                .findFirst();
    }
}
