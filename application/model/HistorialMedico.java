package model;

import java.sql.Timestamp;
import java.math.BigDecimal;

public class HistorialMedico {
    private int idHistorial;
    private int idCita;
    private int idMascota;
    private int idVeterinario;
    private Timestamp fechaConsulta;
    private String diagnostico;
    private BigDecimal pesoRegistrado;
    private BigDecimal temperatura;
    private Integer frecuenciaCardiaca;
    private String observacionesGenerales;
    
    // Campos adicionales para joins
    private String nombreMascota;
    private String nombreVeterinario;
    private String motivoConsulta;
    
    // Constructores
    public HistorialMedico() {}
    
    // Getters y Setters
    public int getIdHistorial() { return idHistorial; }
    public void setIdHistorial(int idHistorial) { this.idHistorial = idHistorial; }
    
    public int getIdCita() { return idCita; }
    public void setIdCita(int idCita) { this.idCita = idCita; }
    
    public int getIdMascota() { return idMascota; }
    public void setIdMascota(int idMascota) { this.idMascota = idMascota; }
    
    public int getIdVeterinario() { return idVeterinario; }
    public void setIdVeterinario(int idVeterinario) { this.idVeterinario = idVeterinario; }
    
    public Timestamp getFechaConsulta() { return fechaConsulta; }
    public void setFechaConsulta(Timestamp fechaConsulta) { this.fechaConsulta = fechaConsulta; }
    
    public String getDiagnostico() { return diagnostico; }
    public void setDiagnostico(String diagnostico) { this.diagnostico = diagnostico; }
    
    public BigDecimal getPesoRegistrado() { return pesoRegistrado; }
    public void setPesoRegistrado(BigDecimal pesoRegistrado) { this.pesoRegistrado = pesoRegistrado; }
    
    public BigDecimal getTemperatura() { return temperatura; }
    public void setTemperatura(BigDecimal temperatura) { this.temperatura = temperatura; }
    
    public Integer getFrecuenciaCardiaca() { return frecuenciaCardiaca; }
    public void setFrecuenciaCardiaca(Integer frecuenciaCardiaca) { this.frecuenciaCardiaca = frecuenciaCardiaca; }
    
    public String getObservacionesGenerales() { return observacionesGenerales; }
    public void setObservacionesGenerales(String observacionesGenerales) { this.observacionesGenerales = observacionesGenerales; }
    
    public String getNombreMascota() { return nombreMascota; }
    public void setNombreMascota(String nombreMascota) { this.nombreMascota = nombreMascota; }
    
    public String getNombreVeterinario() { return nombreVeterinario; }
    public void setNombreVeterinario(String nombreVeterinario) { this.nombreVeterinario = nombreVeterinario; }
    
    public String getMotivoConsulta() { return motivoConsulta; }
    public void setMotivoConsulta(String motivoConsulta) { this.motivoConsulta = motivoConsulta; }
    
    @Override
    public String toString() {
        return "HistorialMedico{" +
                "idHistorial=" + idHistorial +
                ", mascota='" + nombreMascota + '\'' +
                ", veterinario='" + nombreVeterinario + '\'' +
                ", fechaConsulta=" + fechaConsulta +
                ", diagnostico='" + diagnostico + '\'' +
                ", peso=" + pesoRegistrado +
                ", temperatura=" + temperatura +
                '}';
    }
}
