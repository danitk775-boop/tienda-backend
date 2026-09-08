package com.tienda.model;

import java.util.Date;
import java.util.List;

public class Venta {
    private Long id;
    private Date fecha;
    private Cliente cliente;
    private List<DetalleVenta> detalles;
    private Double total;
    private String metodoPago;
    private String estado;

    public Venta() {}

    public Venta(Long id, Date fecha, Cliente cliente, 
                 List<DetalleVenta> detalles, String metodoPago) {
        this.id = id;
        this.fecha = fecha;
        this.cliente = cliente;
        this.detalles = detalles;
        this.metodoPago = metodoPago;
        this.estado = "PENDIENTE";
        this.total = detalles.stream()
                .mapToDouble(DetalleVenta::getSubtotal)
                .sum();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Date getFecha() { return fecha; }
    public void setFecha(Date fecha) { this.fecha = fecha; }
    public Cliente getCliente() { return cliente; }
    public void setCliente(Cliente cliente) { this.cliente = cliente; }
    public List<DetalleVenta> getDetalles() { return detalles; }
    public void setDetalles(List<DetalleVenta> detalles) { this.detalles = detalles; }
    public Double getTotal() { return total; }
    public void setTotal(Double total) { this.total = total; }
    public String getMetodoPago() { return metodoPago; }
    public void setMetodoPago(String metodoPago) { this.metodoPago = metodoPago; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}
