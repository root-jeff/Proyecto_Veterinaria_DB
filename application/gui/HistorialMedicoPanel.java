package gui;

import dao.CitaDAO;
import dao.HistorialMedicoDAO;
import dao.MascotaDAO;
import model.Cita;
import model.HistorialMedico;
import model.Mascota;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

public class HistorialMedicoPanel extends JPanel {
    private MascotaDAO mascotaDAO;
    private HistorialMedicoDAO historialDAO;
    private CitaDAO citaDAO;
    
    private JComboBox<MascotaComboItem> cmbMascotas;
    private JTextArea txtInfoMascota;
    private JTable tablaHistorial;
    private DefaultTableModel modeloHistorial;
    private JTable tablaCitas;
    private DefaultTableModel modeloCitas;
    
    public HistorialMedicoPanel() {
        mascotaDAO = new MascotaDAO();
        historialDAO = new HistorialMedicoDAO();
        citaDAO = new CitaDAO();
        
        setLayout(new BorderLayout(10, 10));
        setBackground(new Color(245, 245, 250));
        setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        
        // Panel de título
        JPanel panelTitulo = new JPanel();
        panelTitulo.setBackground(new Color(26, 188, 156));
        panelTitulo.setPreferredSize(new Dimension(0, 80));
        JLabel lblTitulo = new JLabel("Historial Medico");
        lblTitulo.setFont(new Font("Arial", Font.BOLD, 28));
        lblTitulo.setForeground(Color.WHITE);
        panelTitulo.add(lblTitulo);
        
        // Panel de selección
        JPanel panelSeleccion = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 15));
        panelSeleccion.setBackground(Color.WHITE);
        panelSeleccion.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(new Color(189, 195, 199), 1),
                BorderFactory.createEmptyBorder(10, 20, 10, 20)));
        
        JLabel lblSeleccionar = new JLabel("Seleccionar Mascota:");
        lblSeleccionar.setFont(new Font("Arial", Font.BOLD, 14));
        panelSeleccion.add(lblSeleccionar);
        
        cmbMascotas = new JComboBox<>();
        cmbMascotas.setPreferredSize(new Dimension(400, 30));
        cargarMascotas();
        panelSeleccion.add(cmbMascotas);
        
        JButton btnConsultar = new JButton("Consultar");
        btnConsultar.setFont(new Font("Arial", Font.BOLD, 14));
        btnConsultar.setBackground(new Color(26, 188, 156));
        btnConsultar.setForeground(Color.WHITE);
        btnConsultar.setFocusPainted(false);
        btnConsultar.setBorderPainted(false);
        btnConsultar.setOpaque(true);
        btnConsultar.setContentAreaFilled(true);
        btnConsultar.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btnConsultar.addActionListener(e -> consultarHistorial());
        panelSeleccion.add(btnConsultar);
        
        // Panel de información de mascota
        JPanel panelInfoMascota = new JPanel(new BorderLayout());
        panelInfoMascota.setBackground(Color.WHITE);
        panelInfoMascota.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createTitledBorder(
                        BorderFactory.createLineBorder(new Color(189, 195, 199), 1),
                        "Información de la Mascota",
                        javax.swing.border.TitledBorder.LEFT,
                        javax.swing.border.TitledBorder.TOP,
                        new Font("Arial", Font.BOLD, 12)),
                BorderFactory.createEmptyBorder(10, 10, 10, 10)));
        
        txtInfoMascota = new JTextArea(4, 50);
        txtInfoMascota.setEditable(false);
        txtInfoMascota.setFont(new Font("Monospaced", Font.PLAIN, 12));
        txtInfoMascota.setBackground(new Color(250, 250, 250));
        JScrollPane scrollInfo = new JScrollPane(txtInfoMascota);
        panelInfoMascota.add(scrollInfo, BorderLayout.CENTER);
        
        // Panel de historial médico
        JPanel panelHistorial = new JPanel(new BorderLayout());
        panelHistorial.setBackground(Color.WHITE);
        panelHistorial.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createTitledBorder(
                        BorderFactory.createLineBorder(new Color(189, 195, 199), 1),
                        "Historial de Consultas Médicas",
                        javax.swing.border.TitledBorder.LEFT,
                        javax.swing.border.TitledBorder.TOP,
                        new Font("Arial", Font.BOLD, 12)),
                BorderFactory.createEmptyBorder(10, 10, 10, 10)));
        
        String[] columnasHistorial = {"Fecha", "Veterinario", "Motivo", "Diagnóstico", "Peso", "Temp.", "Frec. Card."};
        modeloHistorial = new DefaultTableModel(columnasHistorial, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };
        tablaHistorial = new JTable(modeloHistorial);
        tablaHistorial.setFont(new Font("Arial", Font.PLAIN, 12));
        tablaHistorial.setRowHeight(25);
        tablaHistorial.getTableHeader().setFont(new Font("Arial", Font.BOLD, 12));
        tablaHistorial.getTableHeader().setBackground(new Color(26, 188, 156));
        tablaHistorial.getTableHeader().setForeground(Color.BLACK);
        tablaHistorial.getTableHeader().setOpaque(true);
        JScrollPane scrollHistorial = new JScrollPane(tablaHistorial);
        panelHistorial.add(scrollHistorial, BorderLayout.CENTER);
        
        // Panel de citas programadas
        JPanel panelCitas = new JPanel(new BorderLayout());
        panelCitas.setBackground(Color.WHITE);
        panelCitas.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createTitledBorder(
                        BorderFactory.createLineBorder(new Color(189, 195, 199), 1),
                        "Citas Programadas",
                        javax.swing.border.TitledBorder.LEFT,
                        javax.swing.border.TitledBorder.TOP,
                        new Font("Arial", Font.BOLD, 12)),
                BorderFactory.createEmptyBorder(10, 10, 10, 10)));
        
        String[] columnasCitas = {"Fecha", "Hora", "Estado", "Veterinario", "Especialidad"};
        modeloCitas = new DefaultTableModel(columnasCitas, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };
        tablaCitas = new JTable(modeloCitas);
        tablaCitas.setFont(new Font("Arial", Font.PLAIN, 12));
        tablaCitas.setRowHeight(25);
        tablaCitas.getTableHeader().setFont(new Font("Arial", Font.BOLD, 12));
        tablaCitas.getTableHeader().setBackground(new Color(155, 89, 182));
        tablaCitas.getTableHeader().setForeground(Color.BLACK);
        tablaCitas.getTableHeader().setOpaque(true);
        JScrollPane scrollCitas = new JScrollPane(tablaCitas);
        scrollCitas.setPreferredSize(new Dimension(0, 150));
        panelCitas.add(scrollCitas, BorderLayout.CENTER);
        
        // Panel central con split
        JSplitPane splitCentral = new JSplitPane(JSplitPane.VERTICAL_SPLIT, panelHistorial, panelCitas);
        splitCentral.setResizeWeight(0.7);
        splitCentral.setDividerLocation(300);
        
        // Panel contenedor
        JPanel panelContenido = new JPanel(new BorderLayout(10, 10));
        panelContenido.setBackground(new Color(245, 245, 250));
        panelContenido.add(panelSeleccion, BorderLayout.NORTH);
        panelContenido.add(panelInfoMascota, BorderLayout.CENTER);
        panelContenido.add(splitCentral, BorderLayout.SOUTH);
        
        // Agregar componentes principales
        add(panelTitulo, BorderLayout.NORTH);
        add(panelContenido, BorderLayout.CENTER);
    }
    
    private void cargarMascotas() {
        cmbMascotas.removeAllItems();
        List<Mascota> mascotas = mascotaDAO.listarMascotas();
        for (Mascota m : mascotas) {
            cmbMascotas.addItem(new MascotaComboItem(m));
        }
    }
    
    private void consultarHistorial() {
        MascotaComboItem mascotaItem = (MascotaComboItem) cmbMascotas.getSelectedItem();
        if (mascotaItem == null) {
            JOptionPane.showMessageDialog(this,
                    "Selecciona una mascota",
                    "Error",
                    JOptionPane.ERROR_MESSAGE);
            return;
        }
        
        Mascota mascota = mascotaItem.getMascota();
        
        // Mostrar información de la mascota
        StringBuilder info = new StringBuilder();
        info.append(String.format("Nombre: %s\n", mascota.getNombre()));
        info.append(String.format("Especie: %s | Raza: %s\n", mascota.getNombreEspecie(), mascota.getNombreRaza()));
        info.append(String.format("Dueño: %s\n", mascota.getNombreCliente()));
        info.append(String.format("Género: %s | Peso Actual: %s kg", mascota.getGenero(), mascota.getPesoActual()));
        txtInfoMascota.setText(info.toString());
        
        // Cargar historial médico
        List<HistorialMedico> historial = historialDAO.obtenerHistorialPorMascota(mascota.getIdMascota());
        modeloHistorial.setRowCount(0);
        
        for (HistorialMedico registro : historial) {
            Object[] fila = {
                registro.getFechaConsulta(),
                registro.getNombreVeterinario(),
                registro.getMotivoConsulta().length() > 30 ? 
                    registro.getMotivoConsulta().substring(0, 30) + "..." : registro.getMotivoConsulta(),
                registro.getDiagnostico().length() > 30 ? 
                    registro.getDiagnostico().substring(0, 30) + "..." : registro.getDiagnostico(),
                registro.getPesoRegistrado() != null ? registro.getPesoRegistrado() + " kg" : "-",
                registro.getTemperatura() != null ? registro.getTemperatura() + "°C" : "-",
                registro.getFrecuenciaCardiaca() != null ? registro.getFrecuenciaCardiaca() + " lpm" : "-"
            };
            modeloHistorial.addRow(fila);
        }
        
        // Cargar citas programadas
        List<Cita> citas = citaDAO.listarCitasPorMascota(mascota.getIdMascota());
        modeloCitas.setRowCount(0);
        
        for (Cita cita : citas) {
            Object[] fila = {
                cita.getFechaCita(),
                cita.getHoraCita(),
                cita.getEstadoCita(),
                cita.getNombreVeterinario(),
                cita.getEspecialidadVeterinario()
            };
            modeloCitas.addRow(fila);
        }
        
        // Mostrar resumen
        if (historial.isEmpty() && citas.isEmpty()) {
            JOptionPane.showMessageDialog(this,
                    "Esta mascota no tiene historial médico ni citas programadas.",
                    "Información",
                    JOptionPane.INFORMATION_MESSAGE);
        }
    }
    
    // Clase auxiliar para el ComboBox
    private class MascotaComboItem {
        private Mascota mascota;
        
        public MascotaComboItem(Mascota mascota) {
            this.mascota = mascota;
        }
        
        public Mascota getMascota() {
            return mascota;
        }
        
        @Override
        public String toString() {
            return mascota.getNombre() + " (" + mascota.getNombreEspecie() + 
                   " - " + mascota.getNombreRaza() + ") - Dueño: " + mascota.getNombreCliente();
        }
    }
}
