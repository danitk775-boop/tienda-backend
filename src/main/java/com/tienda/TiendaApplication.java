package com.tienda;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class TiendaApplication {
    public static void main(String[] args) {
        SpringApplication.run(TiendaApplication.class, args);
        System.out.println("=========================================");
        System.out.println("TIENDA API CORRIENDO");
        System.out.println("http://localhost:8080");
        System.out.println("=========================================");
    }
}
