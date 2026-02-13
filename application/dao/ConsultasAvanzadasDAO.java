package dao;

import database.DatabaseConnection;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class ConsultasAvanzadasDAO {
    private Connection connection;
    
    public ConsultasAvanzadasDAO() {
        try {
            this.connection = DatabaseConnection.getInstance().getConnection();
        } catch (SQLException e) {
            System.err.println("Error al obtener conexión: " + e.getMessage());
        }
    }
    
    // Consulta avanzada 1: Estadísticas de citas por veterinario
    public void mostrarEstadisticasCitasPorVeterinario() {
        String sql = "SELECT " +
                     "v.nombre || ' ' || v.apellido AS veterinario, " +
                     "e.nombre_especialidad AS especialidad, " +
                     "COUNT(c.id_cita) AS total_citas, " +
                     "COUNT(CASE WHEN c.estado_cita = 'completada' THEN 1 END) AS citas_completadas, " +
                     "COUNT(CASE WHEN c.estado_cita = 'cancelada' THEN 1 END) AS citas_canceladas, " +
                     "COUNT(CASE WHEN c.estado_cita = 'pendiente' THEN 1 END) AS citas_pendientes " +
                     "FROM veterinarios v " +
                     "INNER JOIN especialidades e ON v.id_especialidad = e.id_especialidad " +
                     "LEFT JOIN citas c ON v.id_veterinario = c.id_veterinario " +
                     "WHERE v.estado = 'activo' " +
                     "GROUP BY v.id_veterinario, v.nombre, v.apellido, e.nombre_especialidad " +
                     "ORDER BY total_citas DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            System.out.println("\n" + "=".repeat(100));
            System.out.println("ESTADÍSTICAS DE CITAS POR VETERINARIO");
            System.out.println("=".repeat(100));
            System.out.printf("%-30s | %-25s | %6s | %10s | %10s | %10s%n",
                    "Veterinario", "Especialidad", "Total", "Completadas", "Canceladas", "Pendientes");
            System.out.println("-".repeat(100));
            
            while (rs.next()) {
                System.out.printf("%-30s | %-25s | %6d | %10d | %10d | %10d%n",
                        rs.getString("veterinario"),
                        rs.getString("especialidad"),
                        rs.getInt("total_citas"),
                        rs.getInt("citas_completadas"),
                        rs.getInt("citas_canceladas"),
                        rs.getInt("citas_pendientes"));
            }
            System.out.println("=".repeat(100));
            
        } catch (SQLException e) {
            System.err.println("Error al obtener estadísticas: " + e.getMessage());
        }
    }
    
    // Consulta avanzada 2: Top 5 mascotas con más consultas
    public void mostrarTopMascotasConMasConsultas() {
        String sql = "SELECT " +
                     "m.nombre AS mascota, " +
                     "e.nombre_especie AS especie, " +
                     "r.nombre_raza AS raza, " +
                     "c.nombre || ' ' || c.apellido AS dueño, " +
                     "COUNT(hm.id_historial) AS total_consultas, " +
                     "MAX(hm.fecha_consulta) AS ultima_consulta " +
                     "FROM mascotas m " +
                     "INNER JOIN especies e ON m.id_especie = e.id_especie " +
                     "INNER JOIN razas r ON m.id_raza = r.id_raza " +
                     "INNER JOIN clientes c ON m.id_cliente = c.id_cliente " +
                     "LEFT JOIN historial_medico hm ON m.id_mascota = hm.id_mascota " +
                     "WHERE m.estado = 'activo' " +
                     "GROUP BY m.id_mascota, m.nombre, e.nombre_especie, r.nombre_raza, c.nombre, c.apellido " +
                     "HAVING COUNT(hm.id_historial) > 0 " +
                     "ORDER BY total_consultas DESC " +
                     "LIMIT 5";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            System.out.println("\n" + "=".repeat(100));
            System.out.println("TOP 5 MASCOTAS CON MÁS CONSULTAS");
            System.out.println("=".repeat(100));
            System.out.printf("%-20s | %-15s | %-20s | %-25s | %9s | %19s%n",
                    "Mascota", "Especie", "Raza", "Dueño", "Consultas", "Última Consulta");
            System.out.println("-".repeat(100));
            
            while (rs.next()) {
                System.out.printf("%-20s | %-15s | %-20s | %-25s | %9d | %19s%n",
                        rs.getString("mascota"),
                        rs.getString("especie"),
                        rs.getString("raza"),
                        rs.getString("dueño"),
                        rs.getInt("total_consultas"),
                        rs.getTimestamp("ultima_consulta"));
            }
            System.out.println("=".repeat(100));
            
        } catch (SQLException e) {
            System.err.println("Error al obtener top mascotas: " + e.getMessage());
        }
    }
    
    // Consulta avanzada 3: Distribución de mascotas por especie
    public void mostrarDistribucionMascotasPorEspecie() {
        String sql = "SELECT " +
                     "e.nombre_especie AS especie, " +
                     "COUNT(m.id_mascota) AS total_mascotas, " +
                     "ROUND(AVG(EXTRACT(YEAR FROM AGE(m.fecha_nacimiento))), 1) AS edad_promedio, " +
                     "MIN(m.fecha_nacimiento) AS mascota_mas_vieja, " +
                     "MAX(m.fecha_nacimiento) AS mascota_mas_joven " +
                     "FROM especies e " +
                     "LEFT JOIN mascotas m ON e.id_especie = m.id_especie AND m.estado = 'activo' " +
                     "GROUP BY e.id_especie, e.nombre_especie " +
                     "HAVING COUNT(m.id_mascota) > 0 " +
                     "ORDER BY total_mascotas DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            System.out.println("\n" + "=".repeat(90));
            System.out.println("DISTRIBUCIÓN DE MASCOTAS POR ESPECIE");
            System.out.println("=".repeat(90));
            System.out.printf("%-20s | %8s | %14s | %18s | %18s%n",
                    "Especie", "Total", "Edad Promedio", "Más Vieja (Nac.)", "Más Joven (Nac.)");
            System.out.println("-".repeat(90));
            
            while (rs.next()) {
                System.out.printf("%-20s | %8d | %14.1f | %18s | %18s%n",
                        rs.getString("especie"),
                        rs.getInt("total_mascotas"),
                        rs.getDouble("edad_promedio"),
                        rs.getDate("mascota_mas_vieja"),
                        rs.getDate("mascota_mas_joven"));
            }
            System.out.println("=".repeat(90));
            
        } catch (SQLException e) {
            System.err.println("Error al obtener distribución: " + e.getMessage());
        }
    }
    
    // Métodos para GUI - Devuelven datos en formato tabla
    public Object[][] obtenerEstadisticasCitasPorVeterinario() {
        String sql = "SELECT " +
                     "v.nombre || ' ' || v.apellido AS veterinario, " +
                     "e.nombre_especialidad AS especialidad, " +
                     "COUNT(c.id_cita) AS total_citas, " +
                     "COUNT(CASE WHEN c.estado_cita = 'completada' THEN 1 END) AS citas_completadas, " +
                     "COUNT(CASE WHEN c.estado_cita = 'cancelada' THEN 1 END) AS citas_canceladas, " +
                     "COUNT(CASE WHEN c.estado_cita = 'pendiente' THEN 1 END) AS citas_pendientes " +
                     "FROM veterinarios v " +
                     "INNER JOIN especialidades e ON v.id_especialidad = e.id_especialidad " +
                     "LEFT JOIN citas c ON v.id_veterinario = c.id_veterinario " +
                     "WHERE v.estado = 'activo' " +
                     "GROUP BY v.id_veterinario, v.nombre, v.apellido, e.nombre_especialidad " +
                     "ORDER BY total_citas DESC";
        
        try (Statement stmt = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
             ResultSet rs = stmt.executeQuery(sql)) {
            
            // Contar filas
            rs.last();
            int rowCount = rs.getRow();
            rs.beforeFirst();
            
            Object[][] datos = new Object[rowCount][6];
            int i = 0;
            
            while (rs.next()) {
                datos[i][0] = rs.getString("veterinario");
                datos[i][1] = rs.getString("especialidad");
                datos[i][2] = rs.getInt("total_citas");
                datos[i][3] = rs.getInt("citas_completadas");
                datos[i][4] = rs.getInt("citas_canceladas");
                datos[i][5] = rs.getInt("citas_pendientes");
                i++;
            }
            
            return datos;
            
        } catch (SQLException e) {
            System.err.println("Error al obtener estadísticas: " + e.getMessage());
            return new Object[0][6];
        }
    }
    
    public Object[][] obtenerTopMascotasConMasConsultas() {
        String sql = "SELECT " +
                     "m.nombre AS mascota, " +
                     "e.nombre_especie AS especie, " +
                     "r.nombre_raza AS raza, " +
                     "c.nombre || ' ' || c.apellido AS dueño, " +
                     "COUNT(hm.id_historial) AS total_consultas, " +
                     "MAX(hm.fecha_consulta) AS ultima_consulta " +
                     "FROM mascotas m " +
                     "INNER JOIN especies e ON m.id_especie = e.id_especie " +
                     "INNER JOIN razas r ON m.id_raza = r.id_raza " +
                     "INNER JOIN clientes c ON m.id_cliente = c.id_cliente " +
                     "LEFT JOIN historial_medico hm ON m.id_mascota = hm.id_mascota " +
                     "WHERE m.estado = 'activo' " +
                     "GROUP BY m.id_mascota, m.nombre, e.nombre_especie, r.nombre_raza, c.nombre, c.apellido " +
                     "HAVING COUNT(hm.id_historial) > 0 " +
                     "ORDER BY total_consultas DESC " +
                     "LIMIT 5";
        
        try (Statement stmt = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
             ResultSet rs = stmt.executeQuery(sql)) {
            
            rs.last();
            int rowCount = rs.getRow();
            rs.beforeFirst();
            
            Object[][] datos = new Object[rowCount][6];
            int i = 0;
            
            while (rs.next()) {
                datos[i][0] = rs.getString("mascota");
                datos[i][1] = rs.getString("especie");
                datos[i][2] = rs.getString("raza");
                datos[i][3] = rs.getString("dueño");
                datos[i][4] = rs.getInt("total_consultas");
                datos[i][5] = rs.getDate("ultima_consulta");
                i++;
            }
            
            return datos;
            
        } catch (SQLException e) {
            System.err.println("Error al obtener top mascotas: " + e.getMessage());
            return new Object[0][6];
        }
    }
    
    public Object[][] obtenerDistribucionMascotasPorEspecie() {
        String sql = "SELECT " +
                     "e.nombre_especie AS especie, " +
                     "COUNT(m.id_mascota) AS total_mascotas, " +
                     "ROUND(AVG(EXTRACT(YEAR FROM AGE(m.fecha_nacimiento))), 1) AS edad_promedio, " +
                     "MIN(m.fecha_nacimiento) AS mascota_mas_vieja, " +
                     "MAX(m.fecha_nacimiento) AS mascota_mas_joven " +
                     "FROM especies e " +
                     "LEFT JOIN mascotas m ON e.id_especie = m.id_especie AND m.estado = 'activo' " +
                     "GROUP BY e.id_especie, e.nombre_especie " +
                     "HAVING COUNT(m.id_mascota) > 0 " +
                     "ORDER BY total_mascotas DESC";
        
        try (Statement stmt = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
             ResultSet rs = stmt.executeQuery(sql)) {
            
            rs.last();
            int rowCount = rs.getRow();
            rs.beforeFirst();
            
            Object[][] datos = new Object[rowCount][5];
            int i = 0;
            
            while (rs.next()) {
                datos[i][0] = rs.getString("especie");
                datos[i][1] = rs.getInt("total_mascotas");
                datos[i][2] = rs.getDouble("edad_promedio");
                datos[i][3] = rs.getDate("mascota_mas_vieja");
                datos[i][4] = rs.getDate("mascota_mas_joven");
                i++;
            }
            
            return datos;
            
        } catch (SQLException e) {
            System.err.println("Error al obtener distribución: " + e.getMessage());
            return new Object[0][5];
        }
    }
}
