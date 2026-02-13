package gui;

import dao.ClienteDAO;
import dao.MascotaDAO;
import model.*;

import javax.swing.*;
import java.awt.*;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

public class RegistrarMascotaPanel extends JPanel {
    private MascotaDAO mascotaDAO;
    private ClienteDAO clienteDAO;
    
    private JComboBox<ClienteComboItem> cmbClientes;
    private JComboBox<EspecieComboItem> cmbEspecies;
    private JComboBox<RazaComboItem> cmbRazas;
    private JTextField txtNombre;
    private JTextField txtFechaNacimiento;
    private JTextField txtColor;
    private JTextField txtPeso;
    private JComboBox<String> cmbGenero;
    private JTextField txtMicrochip;
    
    public RegistrarMascotaPanel() {
        mascotaDAO = new MascotaDAO();
        clienteDAO = new ClienteDAO();
        
        setLayout(new BorderLayout(10, 10));
        setBackground(new Color(245, 245, 250));
        setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        
        // Panel de título
        JPanel panelTitulo = new JPanel();
        panelTitulo.setBackground(new Color(52, 152, 219));
        panelTitulo.setPreferredSize(new Dimension(0, 80));
        JLabel lblTitulo = new JLabel("Registrar Nueva Mascota");
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
        
        // Cliente
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.weightx = 0.3;
        panelFormulario.add(crearEtiqueta("Cliente (Dueño):"), gbc);
        
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        cmbClientes = new JComboBox<>();
        cargarClientes();
        panelFormulario.add(cmbClientes, gbc);
        
        // Especie
        gbc.gridx = 0;
        gbc.gridy = 1;
        gbc.weightx = 0.3;
        panelFormulario.add(crearEtiqueta("Especie:"), gbc);
        
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        cmbEspecies = new JComboBox<>();
        panelFormulario.add(cmbEspecies, gbc);
        
        // Raza
        gbc.gridx = 0;
        gbc.gridy = 2;
        gbc.weightx = 0.3;
        panelFormulario.add(crearEtiqueta("Raza:"), gbc);
        
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        cmbRazas = new JComboBox<>();
        panelFormulario.add(cmbRazas, gbc);
        
        // Agregar listener DESPUES de inicializar ambos combos
        cmbEspecies.addActionListener(e -> cargarRazasPorEspecie());
        
        // Cargar datos iniciales
        cargarEspecies();
        
        // Nombre
        gbc.gridx = 0;
        gbc.gridy = 3;
        gbc.weightx = 0.3;
        panelFormulario.add(crearEtiqueta("Nombre de la Mascota:"), gbc);
        
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        txtNombre = new JTextField(20);
        panelFormulario.add(txtNombre, gbc);
        
        // Fecha de Nacimiento
        gbc.gridx = 0;
        gbc.gridy = 4;
        gbc.weightx = 0.3;
        panelFormulario.add(crearEtiqueta("Fecha de Nacimiento (AAAA-MM-DD):"), gbc);
        
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        txtFechaNacimiento = new JTextField(20);
        txtFechaNacimiento.setToolTipText("Formato: 2020-01-15");
        panelFormulario.add(txtFechaNacimiento, gbc);
        
        // Color
        gbc.gridx = 0;
        gbc.gridy = 5;
        gbc.weightx = 0.3;
        panelFormulario.add(crearEtiqueta("Color:"), gbc);
        
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        txtColor = new JTextField(20);
        panelFormulario.add(txtColor, gbc);
        
        // Peso
        gbc.gridx = 0;
        gbc.gridy = 6;
        gbc.weightx = 0.3;
        panelFormulario.add(crearEtiqueta("Peso (kg):"), gbc);
        
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        txtPeso = new JTextField(20);
        panelFormulario.add(txtPeso, gbc);
        
        // Género
        gbc.gridx = 0;
        gbc.gridy = 7;
        gbc.weightx = 0.3;
        panelFormulario.add(crearEtiqueta("Género:"), gbc);
        
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        cmbGenero = new JComboBox<>(new String[]{"M - Macho", "F - Hembra", "I - Indefinido"});
        panelFormulario.add(cmbGenero, gbc);
        
        // Microchip
        gbc.gridx = 0;
        gbc.gridy = 8;
        gbc.weightx = 0.3;
        panelFormulario.add(crearEtiqueta("Número de Microchip (opcional):"), gbc);
        
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        txtMicrochip = new JTextField(20);
        panelFormulario.add(txtMicrochip, gbc);
        
        // Panel de botones
        JPanel panelBotones = new JPanel(new FlowLayout(FlowLayout.CENTER, 20, 20));
        panelBotones.setBackground(Color.WHITE);
        
        JButton btnRegistrar = crearBoton("Registrar", new Color(46, 204, 113));
        JButton btnLimpiar = crearBoton("Limpiar", new Color(52, 152, 219));
        
        btnRegistrar.addActionListener(e -> registrarMascota());
        btnLimpiar.addActionListener(e -> limpiarFormulario());
        
        panelBotones.add(btnRegistrar);
        panelBotones.add(btnLimpiar);
        
        gbc.gridx = 0;
        gbc.gridy = 9;
        gbc.gridwidth = 2;
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
    
    private void cargarClientes() {
        cmbClientes.removeAllItems();
        List<Cliente> clientes = clienteDAO.listarClientes();
        for (Cliente c : clientes) {
            cmbClientes.addItem(new ClienteComboItem(c));
        }
    }
    
    private void cargarEspecies() {
        cmbEspecies.removeAllItems();
        List<Especie> especies = mascotaDAO.listarEspecies();
        for (Especie e : especies) {
            cmbEspecies.addItem(new EspecieComboItem(e));
        }
    }
    
    private void cargarRazasPorEspecie() {
        cmbRazas.removeAllItems();
        EspecieComboItem especieItem = (EspecieComboItem) cmbEspecies.getSelectedItem();
        if (especieItem != null) {
            List<Raza> razas = mascotaDAO.listarRazasPorEspecie(especieItem.getEspecie().getIdEspecie());
            for (Raza r : razas) {
                cmbRazas.addItem(new RazaComboItem(r));
            }
        }
    }
    
    private void registrarMascota() {
        try {
            // Validar campos
            if (txtNombre.getText().trim().isEmpty()) {
                JOptionPane.showMessageDialog(this, "El nombre es obligatorio", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }
            
            ClienteComboItem clienteItem = (ClienteComboItem) cmbClientes.getSelectedItem();
            EspecieComboItem especieItem = (EspecieComboItem) cmbEspecies.getSelectedItem();
            RazaComboItem razaItem = (RazaComboItem) cmbRazas.getSelectedItem();
            
            if (clienteItem == null || especieItem == null || razaItem == null) {
                JOptionPane.showMessageDialog(this, "Selecciona todos los campos requeridos", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }
            
            String nombre = txtNombre.getText().trim();
            Date fechaNacimiento = Date.valueOf(txtFechaNacimiento.getText().trim());
            String color = txtColor.getText().trim();
            BigDecimal peso = new BigDecimal(txtPeso.getText().trim());
            char genero = cmbGenero.getSelectedItem().toString().charAt(0);
            String microchip = txtMicrochip.getText().trim().isEmpty() ? null : txtMicrochip.getText().trim();
            
            Mascota mascota = new Mascota(
                    clienteItem.getCliente().getIdCliente(),
                    nombre,
                    especieItem.getEspecie().getIdEspecie(),
                    razaItem.getRaza().getIdRaza(),
                    fechaNacimiento,
                    color,
                    peso,
                    genero
            );
            mascota.setNumeroMicrochip(microchip);
            
            if (mascotaDAO.registrarMascota(mascota)) {
                JOptionPane.showMessageDialog(this,
                        "Mascota registrada exitosamente!\n\n" + mascota.toString(),
                        "Éxito",
                        JOptionPane.INFORMATION_MESSAGE);
                limpiarFormulario();
            } else {
                JOptionPane.showMessageDialog(this,
                        "Error al registrar la mascota",
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
            }
            
        } catch (NumberFormatException e) {
            JOptionPane.showMessageDialog(this,
                    "Error: Verifica que el peso sea un número válido",
                    "Error",
                    JOptionPane.ERROR_MESSAGE);
        } catch (IllegalArgumentException e) {
            JOptionPane.showMessageDialog(this,
                    "Error: Verifica el formato de fecha (AAAA-MM-DD)",
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
        txtNombre.setText("");
        txtFechaNacimiento.setText("");
        txtColor.setText("");
        txtPeso.setText("");
        txtMicrochip.setText("");
        cmbGenero.setSelectedIndex(0);
        if (cmbClientes.getItemCount() > 0) cmbClientes.setSelectedIndex(0);
        if (cmbEspecies.getItemCount() > 0) cmbEspecies.setSelectedIndex(0);
    }
    
    // Clases auxiliares para los ComboBox
    private class ClienteComboItem {
        private Cliente cliente;
        
        public ClienteComboItem(Cliente cliente) {
            this.cliente = cliente;
        }
        
        public Cliente getCliente() {
            return cliente;
        }
        
        @Override
        public String toString() {
            return cliente.getNombre() + " " + cliente.getApellido() + " (" + cliente.getEmail() + ")";
        }
    }
    
    private class EspecieComboItem {
        private Especie especie;
        
        public EspecieComboItem(Especie especie) {
            this.especie = especie;
        }
        
        public Especie getEspecie() {
            return especie;
        }
        
        @Override
        public String toString() {
            return especie.getNombreEspecie();
        }
    }
    
    private class RazaComboItem {
        private Raza raza;
        
        public RazaComboItem(Raza raza) {
            this.raza = raza;
        }
        
        public Raza getRaza() {
            return raza;
        }
        
        @Override
        public String toString() {
            return raza.getNombreRaza();
        }
    }
}
