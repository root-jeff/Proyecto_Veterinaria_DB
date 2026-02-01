package dao;

import database.DatabaseConnection;
import model.Cita;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CitaDAO {
    private Connection connection;
    
    public CitaDAO() {
        try {
            this.connection = DatabaseConnection.getInstance().getConnection();
        } catch (SQLException e) {
            System.err.println("Error al obtener conexión: " + e.getMessage());
        }
    }
    
    // Registrar una nueva cita
    public boolean registrarCita(Cita cita) {
        String sql = "INSERT INTO citas (id_mascota, id_veterinario, fecha_cita, hora_cita, " +
                     "motivo_consulta, estado_cita, observaciones) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, cita.getIdMascota());
            stmt.setInt(2, cita.getIdVeterinario());
            stmt.setDate(3, cita.getFechaCita());
            stmt.setTime(4, cita.getHoraCita());
            stmt.setString(5, cita.getMotivoConsulta());
            stmt.setString(6, "pendiente");
            stmt.setString(7, cita.getObservaciones());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    cita.setIdCita(rs.getInt(1));
                    System.out.println("✓ Cita registrada con ID: " + cita.getIdCita());
                    return true;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al registrar cita: " + e.getMessage());
            if (e.getMessage().contains("uq_veterinario_hora")) {
                System.err.println("⚠ El veterinario ya tiene una cita programada en esa fecha y hora");
            }
        }
        return false;
    }
    
    // Listar citas por mascota
    public List<Cita> listarCitasPorMascota(int idMascota) {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, m.nombre AS nombre_mascota, " +
                     "v.nombre || ' ' || v.apellido AS nombre_veterinario, " +
                     "e.nombre_especialidad " +
                     "FROM citas c " +
                     "INNER JOIN mascotas m ON c.id_mascota = m.id_mascota " +
                     "INNER JOIN veterinarios v ON c.id_veterinario = v.id_veterinario " +
                     "INNER JOIN especialidades e ON v.id_especialidad = e.id_especialidad " +
                     "WHERE c.id_mascota = ? " +
                     "ORDER BY c.fecha_cita DESC, c.hora_cita DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, idMascota);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Cita cita = extraerCitaDeResultSet(rs);
                citas.add(cita);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar citas: " + e.getMessage());
        }
        return citas;
    }
    
    // Listar próximas citas
    public List<Cita> listarProximasCitas() {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, m.nombre AS nombre_mascota, " +
                     "v.nombre || ' ' || v.apellido AS nombre_veterinario, " +
                     "e.nombre_especialidad " +
                     "FROM citas c " +
                     "INNER JOIN mascotas m ON c.id_mascota = m.id_mascota " +
                     "INNER JOIN veterinarios v ON c.id_veterinario = v.id_veterinario " +
                     "INNER JOIN especialidades e ON v.id_especialidad = e.id_especialidad " +
                     "WHERE c.estado_cita IN ('pendiente', 'en_proceso') " +
                     "AND c.fecha_cita >= CURRENT_DATE " +
                     "ORDER BY c.fecha_cita, c.hora_cita " +
                     "LIMIT 10";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Cita cita = extraerCitaDeResultSet(rs);
                citas.add(cita);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar próximas citas: " + e.getMessage());
        }
        return citas;
    }
    
    // Método auxiliar para extraer Cita de ResultSet
    private Cita extraerCitaDeResultSet(ResultSet rs) throws SQLException {
        Cita cita = new Cita();
        cita.setIdCita(rs.getInt("id_cita"));
        cita.setIdMascota(rs.getInt("id_mascota"));
        cita.setIdVeterinario(rs.getInt("id_veterinario"));
        cita.setFechaCita(rs.getDate("fecha_cita"));
        cita.setHoraCita(rs.getTime("hora_cita"));
        cita.setMotivoConsulta(rs.getString("motivo_consulta"));
        cita.setEstadoCita(rs.getString("estado_cita"));
        cita.setObservaciones(rs.getString("observaciones"));
        cita.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
        
        // Campos de join
        cita.setNombreMascota(rs.getString("nombre_mascota"));
        cita.setNombreVeterinario(rs.getString("nombre_veterinario"));
        cita.setEspecialidadVeterinario(rs.getString("nombre_especialidad"));
        
        return cita;
    }
}
