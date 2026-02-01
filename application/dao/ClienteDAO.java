package dao;

import database.DatabaseConnection;
import model.Cliente;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {
    private Connection connection;
    
    public ClienteDAO() {
        try {
            this.connection = DatabaseConnection.getInstance().getConnection();
        } catch (SQLException e) {
            System.err.println("Error al obtener conexión: " + e.getMessage());
        }
    }
    
    // Listar todos los clientes
    public List<Cliente> listarClientes() {
        List<Cliente> clientes = new ArrayList<>();
        String sql = "SELECT * FROM clientes WHERE estado = 'activo' ORDER BY apellido, nombre";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setIdCliente(rs.getInt("id_cliente"));
                cliente.setNombre(rs.getString("nombre"));
                cliente.setApellido(rs.getString("apellido"));
                cliente.setDireccionCalle(rs.getString("direccion_calle"));
                cliente.setNumeroDireccion(rs.getString("numero_direccion"));
                cliente.setIdCiudad(rs.getInt("id_ciudad"));
                cliente.setEmail(rs.getString("email"));
                cliente.setFechaRegistro(rs.getTimestamp("fecha_registro"));
                cliente.setEstado(rs.getString("estado"));
                clientes.add(cliente);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar clientes: " + e.getMessage());
        }
        return clientes;
    }
    
    // Obtener cliente por ID
    public Cliente obtenerClientePorId(int idCliente) {
        String sql = "SELECT * FROM clientes WHERE id_cliente = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, idCliente);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setIdCliente(rs.getInt("id_cliente"));
                cliente.setNombre(rs.getString("nombre"));
                cliente.setApellido(rs.getString("apellido"));
                cliente.setDireccionCalle(rs.getString("direccion_calle"));
                cliente.setNumeroDireccion(rs.getString("numero_direccion"));
                cliente.setIdCiudad(rs.getInt("id_ciudad"));
                cliente.setEmail(rs.getString("email"));
                cliente.setFechaRegistro(rs.getTimestamp("fecha_registro"));
                cliente.setEstado(rs.getString("estado"));
                return cliente;
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener cliente: " + e.getMessage());
        }
        return null;
    }
}
