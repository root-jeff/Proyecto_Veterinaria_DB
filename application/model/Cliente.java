package model;

import java.sql.Timestamp;

public class Cliente {
    private int idCliente;
    private String nombre;
    private String apellido;
    private String direccionCalle;
    private String numeroDireccion;
    private int idCiudad;
    private String email;
    private Timestamp fechaRegistro;
    private String estado;
    
    // Constructores
    public Cliente() {}
    
    public Cliente(String nombre, String apellido, int idCiudad, String email) {
        this.nombre = nombre;
        this.apellido = apellido;
        this.idCiudad = idCiudad;
        this.email = email;
        this.estado = "activo";
    }
    
    // Getters y Setters
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    
    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }
    
    public String getDireccionCalle() { return direccionCalle; }
    public void setDireccionCalle(String direccionCalle) { this.direccionCalle = direccionCalle; }
    
    public String getNumeroDireccion() { return numeroDireccion; }
    public void setNumeroDireccion(String numeroDireccion) { this.numeroDireccion = numeroDireccion; }
    
    public int getIdCiudad() { return idCiudad; }
    public void setIdCiudad(int idCiudad) { this.idCiudad = idCiudad; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public Timestamp getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(Timestamp fechaRegistro) { this.fechaRegistro = fechaRegistro; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    @Override
    public String toString() {
        return "Cliente{" +
                "idCliente=" + idCliente +
                ", nombre='" + nombre + '\'' +
                ", apellido='" + apellido + '\'' +
                ", email='" + email + '\'' +
                ", estado='" + estado + '\'' +
                '}';
    }
}
