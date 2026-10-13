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
