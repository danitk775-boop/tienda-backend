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
