package dao;

import database.DatabaseConnection;
import model.Mascota;
import model.Especie;
import model.Raza;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MascotaDAO {
    private Connection connection;
    
    public MascotaDAO() {
        try {
            this.connection = DatabaseConnection.getInstance().getConnection();
        } catch (SQLException e) {
            System.err.println("Error al obtener conexión: " + e.getMessage());
        }
    }
    
    // Registrar una nueva mascota
    public boolean registrarMascota(Mascota mascota) {
        String sql = "INSERT INTO mascotas (id_cliente, nombre, id_especie, id_raza, fecha_nacimiento, " +
                     "color, peso_actual, genero, numero_microchip, estado) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, mascota.getIdCliente());
            stmt.setString(2, mascota.getNombre());
            stmt.setInt(3, mascota.getIdEspecie());
            stmt.setInt(4, mascota.getIdRaza());
            stmt.setDate(5, mascota.getFechaNacimiento());
            stmt.setString(6, mascota.getColor());
            stmt.setBigDecimal(7, mascota.getPesoActual());
            stmt.setString(8, String.valueOf(mascota.getGenero()));
            stmt.setString(9, mascota.getNumeroMicrochip());
            stmt.setString(10, "activo");
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    mascota.setIdMascota(rs.getInt(1));
                    System.out.println("✓ Mascota registrada con ID: " + mascota.getIdMascota());
                    return true;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al registrar mascota: " + e.getMessage());
        }
        return false;
    }
    
    // Obtener mascota por ID con información completa
    public Mascota obtenerMascotaPorId(int idMascota) {
        String sql = "SELECT m.*, e.nombre_especie, r.nombre_raza, " +
                     "c.nombre || ' ' || c.apellido AS nombre_cliente " +
                     "FROM mascotas m " +
                     "INNER JOIN especies e ON m.id_especie = e.id_especie " +
                     "INNER JOIN razas r ON m.id_raza = r.id_raza " +
                     "INNER JOIN clientes c ON m.id_cliente = c.id_cliente " +
                     "WHERE m.id_mascota = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, idMascota);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extraerMascotaDeResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener mascota: " + e.getMessage());
        }
        return null;
    }
    
    // Listar todas las mascotas
    public List<Mascota> listarMascotas() {
        List<Mascota> mascotas = new ArrayList<>();
        String sql = "SELECT m.*, e.nombre_especie, r.nombre_raza, " +
                     "c.nombre || ' ' || c.apellido AS nombre_cliente " +
                     "FROM mascotas m " +
                     "INNER JOIN especies e ON m.id_especie = e.id_especie " +
                     "INNER JOIN razas r ON m.id_raza = r.id_raza " +
                     "INNER JOIN clientes c ON m.id_cliente = c.id_cliente " +
                     "WHERE m.estado = 'activo' " +
                     "ORDER BY m.id_mascota";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                mascotas.add(extraerMascotaDeResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar mascotas: " + e.getMessage());
        }
        return mascotas;
    }
    
    // Obtener especies disponibles
    public List<Especie> listarEspecies() {
        List<Especie> especies = new ArrayList<>();
        String sql = "SELECT * FROM especies ORDER BY nombre_especie";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Especie especie = new Especie();
                especie.setIdEspecie(rs.getInt("id_especie"));
                especie.setNombreEspecie(rs.getString("nombre_especie"));
                especie.setDescripcion(rs.getString("descripcion"));
                especies.add(especie);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar especies: " + e.getMessage());
        }
        return especies;
    }
    
    // Obtener razas por especie
    public List<Raza> listarRazasPorEspecie(int idEspecie) {
        List<Raza> razas = new ArrayList<>();
        String sql = "SELECT * FROM razas WHERE id_especie = ? ORDER BY nombre_raza";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, idEspecie);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Raza raza = new Raza();
                raza.setIdRaza(rs.getInt("id_raza"));
                raza.setIdEspecie(rs.getInt("id_especie"));
                raza.setNombreRaza(rs.getString("nombre_raza"));
                raza.setTamañoPromedio(rs.getString("tamaño_promedio"));
                raza.setCaracteristicas(rs.getString("caracteristicas"));
                razas.add(raza);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar razas: " + e.getMessage());
        }
        return razas;
    }
    
    // Método auxiliar para extraer Mascota de ResultSet
    private Mascota extraerMascotaDeResultSet(ResultSet rs) throws SQLException {
        Mascota mascota = new Mascota();
        mascota.setIdMascota(rs.getInt("id_mascota"));
        mascota.setIdCliente(rs.getInt("id_cliente"));
        mascota.setNombre(rs.getString("nombre"));
        mascota.setIdEspecie(rs.getInt("id_especie"));
        mascota.setIdRaza(rs.getInt("id_raza"));
        mascota.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
        mascota.setColor(rs.getString("color"));
        mascota.setPesoActual(rs.getBigDecimal("peso_actual"));
        mascota.setGenero(rs.getString("genero").charAt(0));
        mascota.setNumeroMicrochip(rs.getString("numero_microchip"));
        mascota.setFotoUrl(rs.getString("foto_url"));
        mascota.setFechaRegistro(rs.getTimestamp("fecha_registro"));
        mascota.setEstado(rs.getString("estado"));
        
        // Campos de join
        mascota.setNombreEspecie(rs.getString("nombre_especie"));
        mascota.setNombreRaza(rs.getString("nombre_raza"));
        mascota.setNombreCliente(rs.getString("nombre_cliente"));
        
        return mascota;
    }
}
