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
