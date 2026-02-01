package model;

import java.sql.Date;
import java.sql.Timestamp;
import java.math.BigDecimal;

public class Mascota {
    private int idMascota;
    private int idCliente;
    private String nombre;
    private int idEspecie;
    private int idRaza;
    private Date fechaNacimiento;
    private String color;
    private BigDecimal pesoActual;
    private char genero;
    private String numeroMicrochip;
    private String fotoUrl;
    private Timestamp fechaRegistro;
    private String estado;
    
    // Campos adicionales para joins
    private String nombreCliente;
    private String nombreEspecie;
    private String nombreRaza;
    
    // Constructores
    public Mascota() {}
    
    public Mascota(int idCliente, String nombre, int idEspecie, int idRaza, 
                   Date fechaNacimiento, String color, BigDecimal pesoActual, char genero) {
        this.idCliente = idCliente;
        this.nombre = nombre;
        this.idEspecie = idEspecie;
        this.idRaza = idRaza;
        this.fechaNacimiento = fechaNacimiento;
        this.color = color;
        this.pesoActual = pesoActual;
        this.genero = genero;
        this.estado = "activo";
    }
    
    // Getters y Setters
    public int getIdMascota() { return idMascota; }
    public void setIdMascota(int idMascota) { this.idMascota = idMascota; }
    
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    
    public int getIdEspecie() { return idEspecie; }
    public void setIdEspecie(int idEspecie) { this.idEspecie = idEspecie; }
    
    public int getIdRaza() { return idRaza; }
    public void setIdRaza(int idRaza) { this.idRaza = idRaza; }
    
    public Date getFechaNacimiento() { return fechaNacimiento; }
    public void setFechaNacimiento(Date fechaNacimiento) { this.fechaNacimiento = fechaNacimiento; }
    
    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }
    
    public BigDecimal getPesoActual() { return pesoActual; }
    public void setPesoActual(BigDecimal pesoActual) { this.pesoActual = pesoActual; }
    
    public char getGenero() { return genero; }
    public void setGenero(char genero) { this.genero = genero; }
    
    public String getNumeroMicrochip() { return numeroMicrochip; }
    public void setNumeroMicrochip(String numeroMicrochip) { this.numeroMicrochip = numeroMicrochip; }
    
    public String getFotoUrl() { return fotoUrl; }
    public void setFotoUrl(String fotoUrl) { this.fotoUrl = fotoUrl; }
    
    public Timestamp getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(Timestamp fechaRegistro) { this.fechaRegistro = fechaRegistro; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    public String getNombreCliente() { return nombreCliente; }
    public void setNombreCliente(String nombreCliente) { this.nombreCliente = nombreCliente; }
    
    public String getNombreEspecie() { return nombreEspecie; }
    public void setNombreEspecie(String nombreEspecie) { this.nombreEspecie = nombreEspecie; }
    
    public String getNombreRaza() { return nombreRaza; }
    public void setNombreRaza(String nombreRaza) { this.nombreRaza = nombreRaza; }
    
    @Override
    public String toString() {
        return "Mascota{" +
                "idMascota=" + idMascota +
                ", nombre='" + nombre + '\'' +
                ", especie='" + nombreEspecie + '\'' +
                ", raza='" + nombreRaza + '\'' +
                ", fechaNacimiento=" + fechaNacimiento +
                ", genero=" + genero +
                ", peso=" + pesoActual +
                ", estado='" + estado + '\'' +
                '}';
    }
}
