package database;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConnection {
    private static DatabaseConnection instance;
    private Connection connection;
    private String url;
    private String username;
    private String password;
    
    private DatabaseConnection() {
        try {
            // Cargar configuración
            Properties props = new Properties();
            try {
                props.load(new FileInputStream("config.properties"));
                this.url = props.getProperty("db.url");
                this.username = props.getProperty("db.username");
                this.password = props.getProperty("db.password");
            } catch (IOException e) {
                // Valores por defecto si no existe config.properties
                System.out.println("⚠ No se encontró config.properties, usando valores por defecto");
                this.url = "jdbc:postgresql://localhost:5432/veterinariadb";
                this.username = "postgres";
                this.password = "postgres";
            }
            
            // Cargar el driver de PostgreSQL
            Class.forName("org.postgresql.Driver");
            
        } catch (ClassNotFoundException e) {
            System.err.println("Error: No se encontró el driver de PostgreSQL");
            e.printStackTrace();
        }
    }
    
    public Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            try {
                connection = DriverManager.getConnection(url, username, password);
                System.out.println("✓ Conexión exitosa a la base de datos");
            } catch (SQLException e) {
                System.err.println("Error al conectar a la base de datos:");
                System.err.println("URL: " + url);
                System.err.println("Usuario: " + username);
                throw e;
            }
        }
        return connection;
    }
    
    public static DatabaseConnection getInstance() {
        if (instance == null) {
            synchronized (DatabaseConnection.class) {
                if (instance == null) {
                    instance = new DatabaseConnection();
                }
            }
        }
        return instance;
    }
    
    public void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("✓ Conexión cerrada");
            } catch (SQLException e) {
                System.err.println("Error al cerrar la conexión: " + e.getMessage());
            }
        }
    }
    
    // Método de prueba de conexión
    public boolean testConnection() {
        try {
            Connection conn = getConnection();
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }
}
