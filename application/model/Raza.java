package model;

public class Raza {
    private int idRaza;
    private int idEspecie;
    private String nombreRaza;
    private String tamañoPromedio;
    private String caracteristicas;
    
    // Constructores
    public Raza() {}
    
    public Raza(int idRaza, String nombreRaza, int idEspecie) {
        this.idRaza = idRaza;
        this.nombreRaza = nombreRaza;
        this.idEspecie = idEspecie;
    }
    
    // Getters y Setters
    public int getIdRaza() { return idRaza; }
    public void setIdRaza(int idRaza) { this.idRaza = idRaza; }
    
    public int getIdEspecie() { return idEspecie; }
    public void setIdEspecie(int idEspecie) { this.idEspecie = idEspecie; }
    
    public String getNombreRaza() { return nombreRaza; }
    public void setNombreRaza(String nombreRaza) { this.nombreRaza = nombreRaza; }
    
    public String getTamañoPromedio() { return tamañoPromedio; }
    public void setTamañoPromedio(String tamañoPromedio) { this.tamañoPromedio = tamañoPromedio; }
    
    public String getCaracteristicas() { return caracteristicas; }
    public void setCaracteristicas(String caracteristicas) { this.caracteristicas = caracteristicas; }
    
    @Override
    public String toString() {
        return "Raza{" +
                "idRaza=" + idRaza +
                ", nombreRaza='" + nombreRaza + '\'' +
                ", tamañoPromedio='" + tamañoPromedio + '\'' +
                '}';
    }
}
