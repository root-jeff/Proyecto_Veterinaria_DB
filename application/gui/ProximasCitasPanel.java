package gui;

import dao.CitaDAO;
import model.Cita;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

public class ProximasCitasPanel extends JPanel {
    private CitaDAO citaDAO;
    private JTable tablaCitas;
    private DefaultTableModel modelo;
    private JLabel lblTotal;
    
    public ProximasCitasPanel() {
        citaDAO = new CitaDAO();
        
        setLayout(new BorderLayout(10, 10));
        setBackground(new Color(245, 245, 250));
        setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        
        // Panel de título
        JPanel panelTitulo = new JPanel();
        panelTitulo.setBackground(new Color(230, 126, 34));
        panelTitulo.setPreferredSize(new Dimension(0, 80));
        JLabel lblTitulo = new JLabel("Proximas Citas Programadas");
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
        String[] columnas = {"ID", "Fecha", "Hora", "Mascota", "Veterinario", "Motivo"};
        modelo = new DefaultTableModel(columnas, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };
        
        tablaCitas = new JTable(modelo);
        tablaCitas.setFont(new Font("Arial", Font.PLAIN, 13));
        tablaCitas.setRowHeight(30);
        tablaCitas.getTableHeader().setFont(new Font("Arial", Font.BOLD, 14));
        tablaCitas.getTableHeader().setBackground(new Color(230, 126, 34));
        tablaCitas.getTableHeader().setForeground(Color.BLACK);
        tablaCitas.getTableHeader().setOpaque(true);
        tablaCitas.getTableHeader().setPreferredSize(new Dimension(0, 40));
        
        // Ajustar anchos de columnas
        tablaCitas.getColumnModel().getColumn(0).setPreferredWidth(50);
        tablaCitas.getColumnModel().getColumn(1).setPreferredWidth(100);
        tablaCitas.getColumnModel().getColumn(2).setPreferredWidth(80);
        tablaCitas.getColumnModel().getColumn(3).setPreferredWidth(150);
        tablaCitas.getColumnModel().getColumn(4).setPreferredWidth(200);
        tablaCitas.getColumnModel().getColumn(5).setPreferredWidth(250);
        
        JScrollPane scrollPane = new JScrollPane(tablaCitas);
        scrollPane.setBorder(BorderFactory.createLineBorder(new Color(189, 195, 199)));
        panelTabla.add(scrollPane, BorderLayout.CENTER);
        
        // Panel de información
        JPanel panelInfo = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 10));
        panelInfo.setBackground(Color.WHITE);
        lblTotal = new JLabel("Total de citas: 0");
        lblTotal.setFont(new Font("Arial", Font.BOLD, 14));
        lblTotal.setForeground(new Color(52, 73, 94));
        panelInfo.add(lblTotal);
        
        JButton btnActualizar = new JButton("Actualizar");
        btnActualizar.setFont(new Font("Arial", Font.BOLD, 13));
        btnActualizar.setBackground(new Color(230, 126, 34));
        btnActualizar.setForeground(Color.WHITE);
        btnActualizar.setFocusPainted(false);
        btnActualizar.setBorderPainted(false);
        btnActualizar.setOpaque(true);
        btnActualizar.setContentAreaFilled(true);
        btnActualizar.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btnActualizar.addActionListener(e -> cargarCitas());
        panelInfo.add(btnActualizar);
        
        panelTabla.add(panelInfo, BorderLayout.SOUTH);
        
        // Agregar componentes principales
        add(panelTitulo, BorderLayout.NORTH);
        add(panelTabla, BorderLayout.CENTER);
        
        // Cargar datos iniciales
        cargarCitas();
    }
    
    private void cargarCitas() {
        modelo.setRowCount(0);
        List<Cita> citas = citaDAO.listarProximasCitas();
        
        for (Cita c : citas) {
            Object[] fila = {
                c.getIdCita(),
                c.getFechaCita(),
                c.getHoraCita(),
                c.getNombreMascota(),
                c.getNombreVeterinario(),
                c.getMotivoConsulta().length() > 40 ? 
                    c.getMotivoConsulta().substring(0, 40) + "..." : c.getMotivoConsulta()
            };
            modelo.addRow(fila);
        }
        
        lblTotal.setText("Total de citas: " + citas.size());
        
        if (citas.isEmpty()) {
            JOptionPane.showMessageDialog(this,
                    "No hay citas programadas próximamente.",
                    "Información",
                    JOptionPane.INFORMATION_MESSAGE);
        }
    }
}
