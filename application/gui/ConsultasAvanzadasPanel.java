package gui;

import dao.ConsultasAvanzadasDAO;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;

public class ConsultasAvanzadasPanel extends JPanel {
    private ConsultasAvanzadasDAO consultasDAO;
    private JTable tabla;
    private DefaultTableModel modelo;
    private TipoConsulta tipoConsulta;
    
    public enum TipoConsulta {
        ESTADISTICAS,
        TOP_MASCOTAS,
        DISTRIBUCION
    }
    
    public ConsultasAvanzadasPanel(TipoConsulta tipo) {
        this.tipoConsulta = tipo;
        consultasDAO = new ConsultasAvanzadasDAO();
        
        setLayout(new BorderLayout(10, 10));
        setBackground(new Color(245, 245, 250));
        setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        
        // Panel de título
        JPanel panelTitulo = new JPanel();
        Color colorTitulo = new Color(41, 128, 185);
        String textoTitulo = "";
        String[] columnas = {};
        
        switch (tipo) {
            case ESTADISTICAS:
                colorTitulo = new Color(41, 128, 185);
                textoTitulo = "Estadisticas de Citas por Veterinario";
                columnas = new String[]{"Veterinario", "Especialidad", "Total", "Completadas", "Canceladas", "Pendientes"};
                break;
            case TOP_MASCOTAS:
                colorTitulo = new Color(231, 76, 60);
                textoTitulo = "Top 5 Mascotas con Mas Consultas";
                columnas = new String[]{"Mascota", "Especie", "Raza", "Dueno", "Consultas", "Ultima Consulta"};
                break;
            case DISTRIBUCION:
                colorTitulo = new Color(39, 174, 96);
                textoTitulo = "Distribucion de Mascotas por Especie";
                columnas = new String[]{"Especie", "Total", "Edad Promedio", "Mas Vieja (Nac.)", "Mas Joven (Nac.)"};
                break;
        }
        
        panelTitulo.setBackground(colorTitulo);
        panelTitulo.setPreferredSize(new Dimension(0, 80));
        JLabel lblTitulo = new JLabel(textoTitulo);
        lblTitulo.setFont(new Font("Arial", Font.BOLD, 28));
        lblTitulo.setForeground(Color.WHITE);
        panelTitulo.add(lblTitulo);
        
        // Panel de tabla
        JPanel panelTabla = new JPanel(new BorderLayout(10, 10));
        panelTabla.setBackground(Color.WHITE);
        panelTabla.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(new Color(189, 195, 199), 1),
                BorderFactory.createEmptyBorder(20, 20, 20, 20)));
        
        // Crear tabla
        modelo = new DefaultTableModel(columnas, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };
        
        tabla = new JTable(modelo);
        tabla.setFont(new Font("Arial", Font.PLAIN, 13));
        tabla.setRowHeight(30);
        tabla.getTableHeader().setFont(new Font("Arial", Font.BOLD, 13));
        tabla.getTableHeader().setBackground(colorTitulo);
        tabla.getTableHeader().setForeground(Color.BLACK);
        tabla.getTableHeader().setOpaque(true);
        tabla.getTableHeader().setPreferredSize(new Dimension(0, 40));
        tabla.setSelectionBackground(new Color(52, 152, 219, 100));
        
        JScrollPane scrollPane = new JScrollPane(tabla);
        scrollPane.setBorder(BorderFactory.createLineBorder(new Color(189, 195, 199)));
        panelTabla.add(scrollPane, BorderLayout.CENTER);
        
        // Panel de botones
        JPanel panelBotones = new JPanel(new FlowLayout(FlowLayout.CENTER, 20, 10));
        panelBotones.setBackground(Color.WHITE);
        
        JButton btnActualizar = new JButton("Actualizar");
        btnActualizar.setFont(new Font("Arial", Font.BOLD, 14));
        btnActualizar.setBackground(colorTitulo);
        btnActualizar.setForeground(Color.WHITE);
        btnActualizar.setFocusPainted(false);
        btnActualizar.setBorderPainted(false);
        btnActualizar.setOpaque(true);
        btnActualizar.setContentAreaFilled(true);
        btnActualizar.setPreferredSize(new Dimension(150, 35));
        btnActualizar.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btnActualizar.addActionListener(e -> cargarDatos());
        panelBotones.add(btnActualizar);
        
        panelTabla.add(panelBotones, BorderLayout.SOUTH);
        
        // Agregar componentes principales
        add(panelTitulo, BorderLayout.NORTH);
        add(panelTabla, BorderLayout.CENTER);
        
        // Cargar datos automáticamente
        cargarDatos();
    }
    
    private void cargarDatos() {
        modelo.setRowCount(0);
        
        try {
            Object[][] datos = null;
            
            switch (tipoConsulta) {
                case ESTADISTICAS:
                    datos = consultasDAO.obtenerEstadisticasCitasPorVeterinario();
                    break;
                case TOP_MASCOTAS:
                    datos = consultasDAO.obtenerTopMascotasConMasConsultas();
                    break;
                case DISTRIBUCION:
                    datos = consultasDAO.obtenerDistribucionMascotasPorEspecie();
                    break;
            }
            
            if (datos != null && datos.length > 0) {
                for (Object[] fila : datos) {
                    modelo.addRow(fila);
                }
            } else {
                JOptionPane.showMessageDialog(this,
                        "No hay datos disponibles para esta consulta.",
                        "Informacion",
                        JOptionPane.INFORMATION_MESSAGE);
            }
            
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this,
                    "Error al cargar los datos: " + e.getMessage(),
                    "Error",
                    JOptionPane.ERROR_MESSAGE);
        }
    }
}
