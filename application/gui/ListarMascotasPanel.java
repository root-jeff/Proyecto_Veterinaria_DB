package gui;

import dao.MascotaDAO;
import model.Mascota;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

public class ListarMascotasPanel extends JPanel {
    private MascotaDAO mascotaDAO;
    private JTable tablaMascotas;
    private DefaultTableModel modelo;
    private JLabel lblTotal;
    
    public ListarMascotasPanel() {
        mascotaDAO = new MascotaDAO();
        
        setLayout(new BorderLayout(10, 10));
        setBackground(new Color(245, 245, 250));
        setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        
        // Panel de título
        JPanel panelTitulo = new JPanel();
        panelTitulo.setBackground(new Color(52, 152, 219));
        panelTitulo.setPreferredSize(new Dimension(0, 80));
        JLabel lblTitulo = new JLabel("Mascotas Registradas");
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
        String[] columnas = {"ID", "Nombre", "Especie", "Raza", "Género", "Peso (kg)", "Dueño"};
        modelo = new DefaultTableModel(columnas, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };
        
        tablaMascotas = new JTable(modelo);
        tablaMascotas.setFont(new Font("Arial", Font.PLAIN, 13));
        tablaMascotas.setRowHeight(30);
        tablaMascotas.getTableHeader().setFont(new Font("Arial", Font.BOLD, 14));
        tablaMascotas.getTableHeader().setBackground(new Color(52, 152, 219));
        tablaMascotas.getTableHeader().setForeground(Color.BLACK);
        tablaMascotas.getTableHeader().setOpaque(true);
        tablaMascotas.getTableHeader().setPreferredSize(new Dimension(0, 40));
        
        // Ajustar anchos de columnas
        tablaMascotas.getColumnModel().getColumn(0).setPreferredWidth(50);
        tablaMascotas.getColumnModel().getColumn(1).setPreferredWidth(150);
        tablaMascotas.getColumnModel().getColumn(2).setPreferredWidth(120);
        tablaMascotas.getColumnModel().getColumn(3).setPreferredWidth(150);
        tablaMascotas.getColumnModel().getColumn(4).setPreferredWidth(70);
        tablaMascotas.getColumnModel().getColumn(5).setPreferredWidth(90);
        tablaMascotas.getColumnModel().getColumn(6).setPreferredWidth(200);
        
        JScrollPane scrollPane = new JScrollPane(tablaMascotas);
        scrollPane.setBorder(BorderFactory.createLineBorder(new Color(189, 195, 199)));
        panelTabla.add(scrollPane, BorderLayout.CENTER);
        
        // Panel de información
        JPanel panelInfo = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 10));
        panelInfo.setBackground(Color.WHITE);
        lblTotal = new JLabel("Total de mascotas: 0");
        lblTotal.setFont(new Font("Arial", Font.BOLD, 14));
        lblTotal.setForeground(new Color(52, 73, 94));
        panelInfo.add(lblTotal);
        
        JButton btnActualizar = new JButton("Actualizar");
        btnActualizar.setFont(new Font("Arial", Font.BOLD, 13));
        btnActualizar.setBackground(new Color(52, 152, 219));
        btnActualizar.setForeground(Color.WHITE);
        btnActualizar.setFocusPainted(false);
        btnActualizar.setBorderPainted(false);
        btnActualizar.setOpaque(true);
        btnActualizar.setContentAreaFilled(true);
        btnActualizar.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btnActualizar.addActionListener(e -> cargarMascotas());
        panelInfo.add(btnActualizar);
        
        panelTabla.add(panelInfo, BorderLayout.SOUTH);
        
        // Agregar componentes principales
        add(panelTitulo, BorderLayout.NORTH);
        add(panelTabla, BorderLayout.CENTER);
        
        // Cargar datos iniciales
        cargarMascotas();
    }
    
    private void cargarMascotas() {
        modelo.setRowCount(0);
        List<Mascota> mascotas = mascotaDAO.listarMascotas();
        
        for (Mascota m : mascotas) {
            Object[] fila = {
                m.getIdMascota(),
                m.getNombre(),
                m.getNombreEspecie(),
                m.getNombreRaza(),
                m.getGenero(),
                m.getPesoActual(),
                m.getNombreCliente()
            };
            modelo.addRow(fila);
        }
        
        lblTotal.setText("Total de mascotas: " + mascotas.size());
        
        if (mascotas.isEmpty()) {
            JOptionPane.showMessageDialog(this,
                    "No hay mascotas registradas en el sistema.",
                    "Información",
                    JOptionPane.INFORMATION_MESSAGE);
        }
    }
}
