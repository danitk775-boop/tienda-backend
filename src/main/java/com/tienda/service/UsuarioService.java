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
