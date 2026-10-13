package com.tienda.model;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "ventas")
public class Venta {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(nullable = false)
    private Date fecha;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "cliente_id", nullable = false)
    private Cliente cliente;

    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
    @JoinColumn(name = "venta_id")
    private List<DetalleVenta> detalles = new ArrayList<>();

    @Column(nullable = false)
    private Double total;

    @Column(length = 30)
    private String metodoPago;

    @Column(length = 20)
    private String estado;

    public Venta() {}
    public Venta(Date fecha, Cliente cliente, List<DetalleVenta> detalles, String metodoPago) {
        this.fecha = fecha;
        this.cliente = cliente;
        this.detalles = detalles;
        this.metodoPago = metodoPago;
        this.estado = "PENDIENTE";
        recalcularTotal();
    }

    public void recalcularTotal() {
        this.total = (detalles == null) ? 0.0 :
                detalles.stream().mapToDouble(DetalleVenta::getSubtotal).sum();
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
