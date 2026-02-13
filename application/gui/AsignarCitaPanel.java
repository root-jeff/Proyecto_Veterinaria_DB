package gui;

import dao.CitaDAO;
import dao.MascotaDAO;
import dao.VeterinarioDAO;
import model.Cita;
import model.Mascota;
import model.Veterinario;

import javax.swing.*;
import java.awt.*;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

public class AsignarCitaPanel extends JPanel {
    private MascotaDAO mascotaDAO;
    private VeterinarioDAO veterinarioDAO;
    private CitaDAO citaDAO;
    
    private JComboBox<MascotaComboItem> cmbMascotas;
    private JComboBox<VeterinarioComboItem> cmbVeterinarios;
    private JTextField txtFecha;
    private JTextField txtHora;
    private JTextArea txtMotivo;
    private JTextArea txtObservaciones;
    
    public AsignarCitaPanel() {
        mascotaDAO = new MascotaDAO();
        veterinarioDAO = new VeterinarioDAO();
        citaDAO = new CitaDAO();
        
        setLayout(new BorderLayout(10, 10));
        setBackground(new Color(245, 245, 250));
        setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        
        // Panel de título
        JPanel panelTitulo = new JPanel();
        panelTitulo.setBackground(new Color(155, 89, 182));
        panelTitulo.setPreferredSize(new Dimension(0, 80));
        JLabel lblTitulo = new JLabel("Asignar Cita Veterinaria");
        lblTitulo.setFont(new Font("Arial", Font.BOLD, 28));
        lblTitulo.setForeground(Color.WHITE);
        panelTitulo.add(lblTitulo);
        
        // Panel de formulario
        JPanel panelFormulario = new JPanel(new GridBagLayout());
        panelFormulario.setBackground(Color.WHITE);
        panelFormulario.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(new Color(189, 195, 199), 1),
                BorderFactory.createEmptyBorder(30, 40, 30, 40)));
        
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.insets = new Insets(10, 10, 10, 10);
        
        // Mascota
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.weightx = 0.3;
        panelFormulario.add(crearEtiqueta("Mascota:"), gbc);
        
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        cmbMascotas = new JComboBox<>();
        cargarMascotas();
        panelFormulario.add(cmbMascotas, gbc);
        
        // Veterinario
        gbc.gridx = 0;
        gbc.gridy = 1;
        gbc.weightx = 0.3;
        panelFormulario.add(crearEtiqueta("Veterinario:"), gbc);
        
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        cmbVeterinarios = new JComboBox<>();
        cargarVeterinarios();
        panelFormulario.add(cmbVeterinarios, gbc);
        
        // Fecha
        gbc.gridx = 0;
        gbc.gridy = 2;
        gbc.weightx = 0.3;
        panelFormulario.add(crearEtiqueta("Fecha (AAAA-MM-DD):"), gbc);
        
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        txtFecha = new JTextField(20);
        txtFecha.setToolTipText("Formato: 2024-12-25");
        panelFormulario.add(txtFecha, gbc);
        
        // Hora
        gbc.gridx = 0;
        gbc.gridy = 3;
        gbc.weightx = 0.3;
        panelFormulario.add(crearEtiqueta("Hora (HH:MM):"), gbc);
        
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        txtHora = new JTextField(20);
        txtHora.setToolTipText("Formato: 14:30");
        panelFormulario.add(txtHora, gbc);
        
        // Motivo
        gbc.gridx = 0;
        gbc.gridy = 4;
        gbc.weightx = 0.3;
        gbc.anchor = GridBagConstraints.NORTHWEST;
        panelFormulario.add(crearEtiqueta("Motivo de Consulta:"), gbc);
        
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        gbc.fill = GridBagConstraints.BOTH;
        gbc.weighty = 0.5;
        txtMotivo = new JTextArea(4, 20);
        txtMotivo.setLineWrap(true);
        txtMotivo.setWrapStyleWord(true);
        txtMotivo.setBorder(BorderFactory.createLineBorder(Color.GRAY));
        JScrollPane scrollMotivo = new JScrollPane(txtMotivo);
        panelFormulario.add(scrollMotivo, gbc);
        
        // Observaciones
        gbc.gridx = 0;
        gbc.gridy = 5;
        gbc.weightx = 0.3;
        gbc.weighty = 0;
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.anchor = GridBagConstraints.NORTHWEST;
        panelFormulario.add(crearEtiqueta("Observaciones (opcional):"), gbc);
        
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        gbc.fill = GridBagConstraints.BOTH;
        gbc.weighty = 0.5;
        txtObservaciones = new JTextArea(4, 20);
        txtObservaciones.setLineWrap(true);
        txtObservaciones.setWrapStyleWord(true);
        txtObservaciones.setBorder(BorderFactory.createLineBorder(Color.GRAY));
        JScrollPane scrollObservaciones = new JScrollPane(txtObservaciones);
        panelFormulario.add(scrollObservaciones, gbc);
        
        // Panel de botones
        JPanel panelBotones = new JPanel(new FlowLayout(FlowLayout.CENTER, 20, 20));
        panelBotones.setBackground(Color.WHITE);
        
        JButton btnAsignar = crearBoton("Asignar Cita", new Color(46, 204, 113));
        JButton btnLimpiar = crearBoton("Limpiar", new Color(52, 152, 219));
        
        btnAsignar.addActionListener(e -> asignarCita());
        btnLimpiar.addActionListener(e -> limpiarFormulario());
        
        panelBotones.add(btnAsignar);
        panelBotones.add(btnLimpiar);
        
        gbc.gridx = 0;
        gbc.gridy = 6;
        gbc.gridwidth = 2;
        gbc.weighty = 0;
        gbc.fill = GridBagConstraints.HORIZONTAL;
        panelFormulario.add(panelBotones, gbc);
        
        // Agregar componentes principales
        add(panelTitulo, BorderLayout.NORTH);
        
        JScrollPane scrollPane = new JScrollPane(panelFormulario);
        scrollPane.setBorder(null);
        add(scrollPane, BorderLayout.CENTER);
    }
    
    private JLabel crearEtiqueta(String texto) {
        JLabel label = new JLabel(texto);
        label.setFont(new Font("Arial", Font.BOLD, 14));
        label.setForeground(new Color(52, 73, 94));
        return label;
    }
    
    private JButton crearBoton(String texto, Color color) {
        JButton boton = new JButton(texto);
        boton.setFont(new Font("Arial", Font.BOLD, 16));
        boton.setBackground(color);
        boton.setForeground(Color.WHITE);
        boton.setFocusPainted(false);
        boton.setBorderPainted(false);
        boton.setOpaque(true);
        boton.setContentAreaFilled(true);
        boton.setPreferredSize(new Dimension(180, 45));
        boton.setCursor(new Cursor(Cursor.HAND_CURSOR));
        return boton;
    }
    
    private void cargarMascotas() {
        cmbMascotas.removeAllItems();
        List<Mascota> mascotas = mascotaDAO.listarMascotas();
        for (Mascota m : mascotas) {
            cmbMascotas.addItem(new MascotaComboItem(m));
        }
    }
    
    private void cargarVeterinarios() {
        cmbVeterinarios.removeAllItems();
        List<Veterinario> veterinarios = veterinarioDAO.listarVeterinariosActivos();
        for (Veterinario v : veterinarios) {
            cmbVeterinarios.addItem(new VeterinarioComboItem(v));
        }
    }
    
    private void asignarCita() {
        try {
            // Validar campos
            MascotaComboItem mascotaItem = (MascotaComboItem) cmbMascotas.getSelectedItem();
            VeterinarioComboItem veterinarioItem = (VeterinarioComboItem) cmbVeterinarios.getSelectedItem();
            
            if (mascotaItem == null || veterinarioItem == null) {
                JOptionPane.showMessageDialog(this,
                        "Selecciona mascota y veterinario",
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
                return;
            }
            
            if (txtMotivo.getText().trim().isEmpty()) {
                JOptionPane.showMessageDialog(this,
                        "El motivo de consulta es obligatorio",
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
                return;
            }
            
            Date fechaCita = Date.valueOf(txtFecha.getText().trim());
            Time horaCita = Time.valueOf(txtHora.getText().trim() + ":00");
            
            // Verificar disponibilidad
            int idVeterinario = veterinarioItem.getVeterinario().getIdVeterinario();
            if (!veterinarioDAO.verificarDisponibilidad(idVeterinario, fechaCita, horaCita)) {
                int respuesta = JOptionPane.showConfirmDialog(this,
                        "El veterinario no esta disponible en esa fecha y hora.\n¿Deseas continuar de todas formas?",
                        "Advertencia",
                        JOptionPane.YES_NO_OPTION,
                        JOptionPane.WARNING_MESSAGE);
                if (respuesta != JOptionPane.YES_OPTION) {
                    return;
                }
            }
            
            String motivo = txtMotivo.getText().trim();
            String observaciones = txtObservaciones.getText().trim().isEmpty() ? 
                    null : txtObservaciones.getText().trim();
            
            Cita cita = new Cita(
                    mascotaItem.getMascota().getIdMascota(),
                    idVeterinario,
                    fechaCita,
                    horaCita,
                    motivo
            );
            cita.setObservaciones(observaciones);
            
            if (citaDAO.registrarCita(cita)) {
                String mensaje = String.format(
                        "Cita asignada exitosamente!\n\n" +
                        "Mascota: %s\n" +
                        "Veterinario: Dr(a). %s %s\n" +
                        "Fecha: %s\n" +
                        "Hora: %s",
                        mascotaItem.getMascota().getNombre(),
                        veterinarioItem.getVeterinario().getNombre(),
                        veterinarioItem.getVeterinario().getApellido(),
                        fechaCita,
                        horaCita
                );
                JOptionPane.showMessageDialog(this, mensaje, "Éxito", JOptionPane.INFORMATION_MESSAGE);
                limpiarFormulario();
            } else {
                JOptionPane.showMessageDialog(this,
                        "Error al asignar la cita",
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
            }
            
        } catch (IllegalArgumentException e) {
            JOptionPane.showMessageDialog(this,
                    "Formato de fecha u hora incorrecto\nFecha: AAAA-MM-DD\nHora: HH:MM",
                    "Error",
                    JOptionPane.ERROR_MESSAGE);
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this,
                    "Error: " + e.getMessage(),
                    "Error",
                    JOptionPane.ERROR_MESSAGE);
        }
    }
    
    private void limpiarFormulario() {
        txtFecha.setText("");
        txtHora.setText("");
        txtMotivo.setText("");
        txtObservaciones.setText("");
        if (cmbMascotas.getItemCount() > 0) cmbMascotas.setSelectedIndex(0);
        if (cmbVeterinarios.getItemCount() > 0) cmbVeterinarios.setSelectedIndex(0);
    }
    
    // Clases auxiliares para los ComboBox
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
    
    private class VeterinarioComboItem {
        private Veterinario veterinario;
        
        public VeterinarioComboItem(Veterinario veterinario) {
            this.veterinario = veterinario;
        }
        
        public Veterinario getVeterinario() {
            return veterinario;
        }
        
        @Override
        public String toString() {
            return "Dr(a). " + veterinario.getNombre() + " " + veterinario.getApellido() + 
                   " - " + veterinario.getNombreEspecialidad();
        }
    }
}
