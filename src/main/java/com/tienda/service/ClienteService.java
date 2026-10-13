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
