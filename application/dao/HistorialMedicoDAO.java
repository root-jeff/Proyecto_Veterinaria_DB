package dao;

import database.DatabaseConnection;
import model.HistorialMedico;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HistorialMedicoDAO {
    private Connection connection;
    
    public HistorialMedicoDAO() {
        try {
            this.connection = DatabaseConnection.getInstance().getConnection();
        } catch (SQLException e) {
            System.err.println("Error al obtener conexión: " + e.getMessage());
        }
    }
    
    // Obtener historial médico de una mascota
    public List<HistorialMedico> obtenerHistorialPorMascota(int idMascota) {
        List<HistorialMedico> historial = new ArrayList<>();
        String sql = "SELECT hm.*, m.nombre AS nombre_mascota, " +
                     "v.nombre || ' ' || v.apellido AS nombre_veterinario, " +
                     "c.motivo_consulta " +
                     "FROM historial_medico hm " +
                     "INNER JOIN mascotas m ON hm.id_mascota = m.id_mascota " +
                     "INNER JOIN veterinarios v ON hm.id_veterinario = v.id_veterinario " +
                     "INNER JOIN citas c ON hm.id_cita = c.id_cita " +
                     "WHERE hm.id_mascota = ? " +
                     "ORDER BY hm.fecha_consulta DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, idMascota);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                HistorialMedico registro = new HistorialMedico();
                registro.setIdHistorial(rs.getInt("id_historial"));
                registro.setIdCita(rs.getInt("id_cita"));
                registro.setIdMascota(rs.getInt("id_mascota"));
                registro.setIdVeterinario(rs.getInt("id_veterinario"));
                registro.setFechaConsulta(rs.getTimestamp("fecha_consulta"));
                registro.setDiagnostico(rs.getString("diagnostico"));
                registro.setPesoRegistrado(rs.getBigDecimal("peso_registrado"));
                registro.setTemperatura(rs.getBigDecimal("temperatura"));
                registro.setFrecuenciaCardiaca(rs.getInt("frecuencia_cardiaca"));
                registro.setObservacionesGenerales(rs.getString("observaciones_generales"));
                
                // Campos de join
                registro.setNombreMascota(rs.getString("nombre_mascota"));
                registro.setNombreVeterinario(rs.getString("nombre_veterinario"));
                registro.setMotivoConsulta(rs.getString("motivo_consulta"));
                
                historial.add(registro);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener historial médico: " + e.getMessage());
        }
        return historial;
    }
    
    // Contar registros en el historial
    public int contarRegistrosHistorial(int idMascota) {
        String sql = "SELECT COUNT(*) as total FROM historial_medico WHERE id_mascota = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, idMascota);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Error al contar registros: " + e.getMessage());
        }
        return 0;
    }
}
