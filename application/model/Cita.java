package model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Cita {
    private int idCita;
    private int idMascota;
    private int idVeterinario;
    private Date fechaCita;
    private Time horaCita;
    private String motivoConsulta;
    private String estadoCita;
    private String observaciones;
    private Timestamp fechaCreacion;
    
    // Campos adicionales para joins
    private String nombreMascota;
    private String nombreVeterinario;
    private String especialidadVeterinario;
    
    // Constructores
    public Cita() {}
    
    public Cita(int idMascota, int idVeterinario, Date fechaCita, Time horaCita, String motivoConsulta) {
        this.idMascota = idMascota;
        this.idVeterinario = idVeterinario;
        this.fechaCita = fechaCita;
        this.horaCita = horaCita;
        this.motivoConsulta = motivoConsulta;
        this.estadoCita = "pendiente";
    }
    
    // Getters y Setters
    public int getIdCita() { return idCita; }
    public void setIdCita(int idCita) { this.idCita = idCita; }
    
    public int getIdMascota() { return idMascota; }
    public void setIdMascota(int idMascota) { this.idMascota = idMascota; }
    
    public int getIdVeterinario() { return idVeterinario; }
    public void setIdVeterinario(int idVeterinario) { this.idVeterinario = idVeterinario; }
    
    public Date getFechaCita() { return fechaCita; }
    public void setFechaCita(Date fechaCita) { this.fechaCita = fechaCita; }
    
    public Time getHoraCita() { return horaCita; }
    public void setHoraCita(Time horaCita) { this.horaCita = horaCita; }
    
    public String getMotivoConsulta() { return motivoConsulta; }
    public void setMotivoConsulta(String motivoConsulta) { this.motivoConsulta = motivoConsulta; }
    
    public String getEstadoCita() { return estadoCita; }
    public void setEstadoCita(String estadoCita) { this.estadoCita = estadoCita; }
    
    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
    
    public Timestamp getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(Timestamp fechaCreacion) { this.fechaCreacion = fechaCreacion; }
    
    public String getNombreMascota() { return nombreMascota; }
    public void setNombreMascota(String nombreMascota) { this.nombreMascota = nombreMascota; }
    
    public String getNombreVeterinario() { return nombreVeterinario; }
    public void setNombreVeterinario(String nombreVeterinario) { this.nombreVeterinario = nombreVeterinario; }
    
    public String getEspecialidadVeterinario() { return especialidadVeterinario; }
    public void setEspecialidadVeterinario(String especialidadVeterinario) { this.especialidadVeterinario = especialidadVeterinario; }
    
    @Override
    public String toString() {
        return "Cita{" +
                "idCita=" + idCita +
                ", mascota='" + nombreMascota + '\'' +
                ", veterinario='" + nombreVeterinario + '\'' +
                ", fechaCita=" + fechaCita +
                ", horaCita=" + horaCita +
                ", motivoConsulta='" + motivoConsulta + '\'' +
                ", estado='" + estadoCita + '\'' +
                '}';
    }
}
