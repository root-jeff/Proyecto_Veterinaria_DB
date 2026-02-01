package model;

public class Especie {
    private int idEspecie;
    private String nombreEspecie;
    private String descripcion;
    
    // Constructores
    public Especie() {}
    
    public Especie(int idEspecie, String nombreEspecie) {
        this.idEspecie = idEspecie;
        this.nombreEspecie = nombreEspecie;
    }
    
    // Getters y Setters
    public int getIdEspecie() { return idEspecie; }
    public void setIdEspecie(int idEspecie) { this.idEspecie = idEspecie; }
    
    public String getNombreEspecie() { return nombreEspecie; }
    public void setNombreEspecie(String nombreEspecie) { this.nombreEspecie = nombreEspecie; }
    
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    
    @Override
    public String toString() {
        return "Especie{" +
                "idEspecie=" + idEspecie +
                ", nombreEspecie='" + nombreEspecie + '\'' +
                '}';
    }
}
