package gui;

import database.DatabaseConnection;
import javax.swing.*;
import java.awt.*;
import java.io.File;
import javax.imageio.ImageIO;

public class VeterinariaGUI extends JFrame {
    private JPanel panelContenido;
    
    public VeterinariaGUI() {
        setTitle("Sistema de Gestion de Clinica Veterinaria");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(1200, 800);
        setLocationRelativeTo(null);
        
        // Probar conexión a la base de datos
        if (!DatabaseConnection.getInstance().testConnection()) {
            JOptionPane.showMessageDialog(this,
                    "No se pudo conectar a la base de datos.\nVerifica que PostgreSQL esté corriendo y que las credenciales sean correctas.",
                    "Error de Conexión",
                    JOptionPane.ERROR_MESSAGE);
            System.exit(1);
        }
        
        // Configurar la interfaz
        inicializarComponentes();
        crearMenuBar();
        
        setVisible(true);
    }
    
    private void inicializarComponentes() {
        // Panel principal con tarjeta de bienvenida
        panelContenido = new JPanel(new BorderLayout());
        panelContenido.setBackground(new Color(245, 245, 250));
        
        // Panel de bienvenida
        JPanel panelBienvenida = crearPanelBienvenida();
        panelContenido.add(panelBienvenida, BorderLayout.CENTER);
        
        add(panelContenido);
    }
    
    private JPanel crearPanelBienvenida() {
        JPanel panel = new JPanel(new BorderLayout(20, 20));
        panel.setBackground(new Color(245, 245, 250));
        panel.setBorder(BorderFactory.createEmptyBorder(30, 30, 30, 30));
        
        // Panel superior con logo y título
        JPanel panelTitulo = new JPanel(new GridBagLayout());
        panelTitulo.setBackground(new Color(245, 245, 250));
        
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.insets = new Insets(10, 20, 10, 20);
        
        // Cargar y mostrar logo
        try {
            File logoFile = new File("assets/logo.png");
            if (logoFile.exists()) {
                ImageIcon logoIcon = new ImageIcon(ImageIO.read(logoFile));
                Image img = logoIcon.getImage();
                Image scaledImg = img.getScaledInstance(180, 180, Image.SCALE_SMOOTH);
                logoIcon = new ImageIcon(scaledImg);
                
                JLabel lblLogo = new JLabel(logoIcon);
                panelTitulo.add(lblLogo, gbc);
                gbc.gridy++;
            }
        } catch (Exception e) {
            System.err.println("No se pudo cargar el logo: " + e.getMessage());
        }
        
        JLabel lblTitulo = new JLabel("Clinica Veterinaria");
        lblTitulo.setFont(new Font("Arial", Font.BOLD, 36));
        lblTitulo.setForeground(new Color(52, 73, 94));
        panelTitulo.add(lblTitulo, gbc);
        
        gbc.gridy++;
        JLabel lblSubtitulo = new JLabel("Sistema de Gestion Integral");
        lblSubtitulo.setFont(new Font("Arial", Font.PLAIN, 20));
        lblSubtitulo.setForeground(new Color(127, 140, 141));
        panelTitulo.add(lblSubtitulo, gbc);
        
        // Panel central con botones de acceso rápido
        JPanel panelBotones = new JPanel(new GridLayout(2, 3, 20, 20));
        panelBotones.setBackground(new Color(245, 245, 250));
        panelBotones.setBorder(BorderFactory.createEmptyBorder(40, 60, 40, 60));
        
        // Crear botones grandes para cada funcionalidad principal
        JButton btnRegistrarMascota = crearBotonGrande("Registrar\nMascota", new Color(52, 152, 219));
        JButton btnAsignarCita = crearBotonGrande("Asignar\nCita", new Color(155, 89, 182));
        JButton btnHistorial = crearBotonGrande("Historial\nMedico", new Color(26, 188, 156));
        JButton btnListarMascotas = crearBotonGrande("Listar\nMascotas", new Color(52, 152, 219));
        JButton btnProximasCitas = crearBotonGrande("Proximas\nCitas", new Color(230, 126, 34));
        JButton btnConsultas = crearBotonGrande("Consultas\nAvanzadas", new Color(41, 128, 185));
        
        // Agregar listeners
        btnRegistrarMascota.addActionListener(e -> mostrarRegistrarMascota());
        btnAsignarCita.addActionListener(e -> mostrarAsignarCita());
        btnHistorial.addActionListener(e -> mostrarHistorialMedico());
        btnListarMascotas.addActionListener(e -> mostrarListarMascotas());
        btnProximasCitas.addActionListener(e -> mostrarProximasCitas());
        btnConsultas.addActionListener(e -> mostrarMenuConsultas());
        
        panelBotones.add(btnRegistrarMascota);
        panelBotones.add(btnAsignarCita);
        panelBotones.add(btnHistorial);
        panelBotones.add(btnListarMascotas);
        panelBotones.add(btnProximasCitas);
        panelBotones.add(btnConsultas);
        
        // Panel inferior con instrucciones
        JPanel panelInstrucciones = new JPanel(new FlowLayout(FlowLayout.CENTER));
        panelInstrucciones.setBackground(new Color(245, 245, 250));
        JLabel lblInstrucciones = new JLabel("Haz clic en un boton o usa el menu superior para navegar");
        lblInstrucciones.setFont(new Font("Arial", Font.ITALIC, 14));
        lblInstrucciones.setForeground(new Color(149, 165, 166));
        panelInstrucciones.add(lblInstrucciones);
        
        panel.add(panelTitulo, BorderLayout.NORTH);
        panel.add(panelBotones, BorderLayout.CENTER);
        panel.add(panelInstrucciones, BorderLayout.SOUTH);
        
        return panel;
    }
    
    private JButton crearBotonGrande(String texto, Color color) {
        JButton boton = new JButton("<html><center>" + texto.replace("\n", "<br>") + "</center></html>");
        boton.setFont(new Font("Arial", Font.BOLD, 18));
        boton.setBackground(color);
        boton.setForeground(Color.WHITE);
        boton.setFocusPainted(false);
        boton.setBorderPainted(false);
        boton.setOpaque(true);
        boton.setContentAreaFilled(true);
        boton.setCursor(new Cursor(Cursor.HAND_CURSOR));
        boton.setPreferredSize(new Dimension(200, 120));
        
        // Efecto hover
        boton.addMouseListener(new java.awt.event.MouseAdapter() {
            @Override
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                boton.setBackground(color.brighter());
            }
            @Override
            public void mouseExited(java.awt.event.MouseEvent evt) {
                boton.setBackground(color);
            }
        });
        
        return boton;
    }
    
    private void mostrarMenuConsultas() {
        // Mostrar un diálogo para seleccionar qué consulta ver
        Object[] opciones = {
            "Estadisticas por Veterinario",
            "Top Mascotas con Mas Consultas",
            "Distribucion por Especie"
        };
        
        int seleccion = JOptionPane.showOptionDialog(
                this,
                "Selecciona el tipo de consulta que deseas visualizar:",
                "Consultas Avanzadas",
                JOptionPane.DEFAULT_OPTION,
                JOptionPane.QUESTION_MESSAGE,
                null,
                opciones,
                opciones[0]);
        
        switch (seleccion) {
            case 0:
                mostrarEstadisticas();
                break;
            case 1:
                mostrarTopMascotas();
                break;
            case 2:
                mostrarDistribucion();
                break;
        }
    }
    
    private void crearMenuBar() {
        JMenuBar menuBar = new JMenuBar();
        // Usar colores del sistema para mejor compatibilidad
        
        // Menú Inicio
        JMenu menuInicio = crearMenu("Inicio");
        menuInicio.addMenuListener(new javax.swing.event.MenuListener() {
            @Override
            public void menuSelected(javax.swing.event.MenuEvent e) {
                volverAInicio();
            }
            @Override
            public void menuDeselected(javax.swing.event.MenuEvent e) {}
            @Override
            public void menuCanceled(javax.swing.event.MenuEvent e) {}
        });
        
        // Menú Mascotas
        JMenu menuMascotas = crearMenu("Mascotas");
        JMenuItem itemRegistrarMascota = crearMenuItem("Registrar Nueva Mascota");
        JMenuItem itemListarMascotas = crearMenuItem("Listar Mascotas");
        
        itemRegistrarMascota.addActionListener(e -> mostrarRegistrarMascota());
        itemListarMascotas.addActionListener(e -> mostrarListarMascotas());
        
        menuMascotas.add(itemRegistrarMascota);
        menuMascotas.add(itemListarMascotas);
        
        // Menú Citas
        JMenu menuCitas = crearMenu("Citas");
        JMenuItem itemAsignarCita = crearMenuItem("Asignar Cita");
        JMenuItem itemProximasCitas = crearMenuItem("Proximas Citas");
        
        itemAsignarCita.addActionListener(e -> mostrarAsignarCita());
        itemProximasCitas.addActionListener(e -> mostrarProximasCitas());
        
        menuCitas.add(itemAsignarCita);
        menuCitas.add(itemProximasCitas);
        
        // Menú Historial
        JMenu menuHistorial = crearMenu("Historial");
        JMenuItem itemConsultarHistorial = crearMenuItem("Consultar Historial Medico");
        
        itemConsultarHistorial.addActionListener(e -> mostrarHistorialMedico());
        
        menuHistorial.add(itemConsultarHistorial);
        
        // Menú Consultas Avanzadas
        JMenu menuConsultas = crearMenu("Consultas");
        JMenuItem itemEstadisticas = crearMenuItem("Estadisticas por Veterinario");
        JMenuItem itemTopMascotas = crearMenuItem("Top Mascotas con Mas Consultas");
        JMenuItem itemDistribucion = crearMenuItem("Distribucion por Especie");
        
        itemEstadisticas.addActionListener(e -> mostrarEstadisticas());
        itemTopMascotas.addActionListener(e -> mostrarTopMascotas());
        itemDistribucion.addActionListener(e -> mostrarDistribucion());
        
        menuConsultas.add(itemEstadisticas);
        menuConsultas.add(itemTopMascotas);
        menuConsultas.add(itemDistribucion);
        
        // Menú Salir
        JMenu menuSalir = crearMenu("Salir");
        menuSalir.addMenuListener(new javax.swing.event.MenuListener() {
            @Override
            public void menuSelected(javax.swing.event.MenuEvent e) {
                int respuesta = JOptionPane.showConfirmDialog(
                        VeterinariaGUI.this,
                        "¿Estas seguro de que deseas salir?",
                        "Confirmar Salida",
                        JOptionPane.YES_NO_OPTION,
                        JOptionPane.QUESTION_MESSAGE);
                if (respuesta == JOptionPane.YES_OPTION) {
                    DatabaseConnection.getInstance().closeConnection();
                    System.exit(0);
                }
            }
            @Override
            public void menuDeselected(javax.swing.event.MenuEvent e) {}
            @Override
            public void menuCanceled(javax.swing.event.MenuEvent e) {}
        });
        
        // Agregar menús a la barra
        menuBar.add(menuInicio);
        menuBar.add(menuMascotas);
        menuBar.add(menuCitas);
        menuBar.add(menuHistorial);
        menuBar.add(menuConsultas);
        menuBar.add(Box.createHorizontalGlue());
        menuBar.add(menuSalir);
        
        setJMenuBar(menuBar);
    }
    
    private JMenu crearMenu(String texto) {
        JMenu menu = new JMenu(texto);
        // Usar color del sistema para mejor visibilidad
        menu.setFont(new Font("Arial", Font.BOLD, 14));
        return menu;
    }
    
    private JMenuItem crearMenuItem(String texto) {
        JMenuItem item = new JMenuItem(texto);
        item.setFont(new Font("Arial", Font.PLAIN, 13));
        return item;
    }
    
    // Métodos para mostrar diferentes paneles
    private void mostrarRegistrarMascota() {
        cambiarPanel(new RegistrarMascotaPanel());
    }
    
    private void mostrarListarMascotas() {
        cambiarPanel(new ListarMascotasPanel());
    }
    
    private void mostrarAsignarCita() {
        cambiarPanel(new AsignarCitaPanel());
    }
    
    private void mostrarProximasCitas() {
        cambiarPanel(new ProximasCitasPanel());
    }
    
    private void mostrarHistorialMedico() {
        cambiarPanel(new HistorialMedicoPanel());
    }
    
    private void mostrarEstadisticas() {
        cambiarPanel(new ConsultasAvanzadasPanel(ConsultasAvanzadasPanel.TipoConsulta.ESTADISTICAS));
    }
    
    private void mostrarTopMascotas() {
        cambiarPanel(new ConsultasAvanzadasPanel(ConsultasAvanzadasPanel.TipoConsulta.TOP_MASCOTAS));
    }
    
    private void mostrarDistribucion() {
        cambiarPanel(new ConsultasAvanzadasPanel(ConsultasAvanzadasPanel.TipoConsulta.DISTRIBUCION));
    }
    
    private void cambiarPanel(JPanel nuevoPanel) {
        panelContenido.removeAll();
        panelContenido.add(nuevoPanel, BorderLayout.CENTER);
        panelContenido.revalidate();
        panelContenido.repaint();
    }
    
    private void volverAInicio() {
        panelContenido.removeAll();
        panelContenido.add(crearPanelBienvenida(), BorderLayout.CENTER);
        panelContenido.revalidate();
        panelContenido.repaint();
    }
    
    public static void main(String[] args) {
        // Configurar Look and Feel
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Iniciar la aplicación en el EDT
        SwingUtilities.invokeLater(() -> new VeterinariaGUI());
    }
}
