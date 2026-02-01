package dao;

import database.DatabaseConnection;
import model.Veterinario;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VeterinarioDAO {
    private Connection connection;
    
    public VeterinarioDAO() {
        try {
            this.connection = DatabaseConnection.getInstance().getConnection();
        } catch (SQLException e) {
            System.err.println("Error al obtener conexión: " + e.getMessage());
        }
    }
    
    // Listar veterinarios activos
    public List<Veterinario> listarVeterinariosActivos() {
        List<Veterinario> veterinarios = new ArrayList<>();
        String sql = "SELECT v.*, e.nombre_especialidad " +
                     "FROM veterinarios v " +
                     "INNER JOIN especialidades e ON v.id_especialidad = e.id_especialidad " +
                     "WHERE v.estado = 'activo' " +
                     "ORDER BY v.apellido, v.nombre";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Veterinario veterinario = new Veterinario();
                veterinario.setIdVeterinario(rs.getInt("id_veterinario"));
                veterinario.setNombre(rs.getString("nombre"));
                veterinario.setApellido(rs.getString("apellido"));
                veterinario.setIdEspecialidad(rs.getInt("id_especialidad"));
                veterinario.setTelefono(rs.getString("telefono"));
                veterinario.setEmail(rs.getString("email"));
                veterinario.setNumeroLicencia(rs.getString("numero_licencia"));
                veterinario.setFechaContratacion(rs.getDate("fecha_contratacion"));
                veterinario.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                veterinario.setEstado(rs.getString("estado"));
                veterinario.setNombreEspecialidad(rs.getString("nombre_especialidad"));
                veterinarios.add(veterinario);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar veterinarios: " + e.getMessage());
        }
        return veterinarios;
    }
    
    // Obtener veterinario por ID
    public Veterinario obtenerVeterinarioPorId(int idVeterinario) {
        String sql = "SELECT v.*, e.nombre_especialidad " +
                     "FROM veterinarios v " +
                     "INNER JOIN especialidades e ON v.id_especialidad = e.id_especialidad " +
                     "WHERE v.id_veterinario = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, idVeterinario);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Veterinario veterinario = new Veterinario();
                veterinario.setIdVeterinario(rs.getInt("id_veterinario"));
                veterinario.setNombre(rs.getString("nombre"));
                veterinario.setApellido(rs.getString("apellido"));
                veterinario.setIdEspecialidad(rs.getInt("id_especialidad"));
                veterinario.setTelefono(rs.getString("telefono"));
                veterinario.setEmail(rs.getString("email"));
                veterinario.setNumeroLicencia(rs.getString("numero_licencia"));
                veterinario.setFechaContratacion(rs.getDate("fecha_contratacion"));
                veterinario.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                veterinario.setEstado(rs.getString("estado"));
                veterinario.setNombreEspecialidad(rs.getString("nombre_especialidad"));
                return veterinario;
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener veterinario: " + e.getMessage());
        }
        return null;
    }
    
    // Verificar disponibilidad de veterinario en fecha y hora
    public boolean verificarDisponibilidad(int idVeterinario, Date fecha, Time hora) {
        String sql = "SELECT COUNT(*) as total FROM citas " +
                     "WHERE id_veterinario = ? AND fecha_cita = ? AND hora_cita = ? " +
                     "AND estado_cita NOT IN ('cancelada', 'no_asistio')";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, idVeterinario);
            stmt.setDate(2, fecha);
            stmt.setTime(3, hora);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total") == 0;
            }
        } catch (SQLException e) {
            System.err.println("Error al verificar disponibilidad: " + e.getMessage());
        }
        return false;
    }
}
