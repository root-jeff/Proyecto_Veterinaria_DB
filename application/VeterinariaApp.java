import dao.*;
import database.DatabaseConnection;
import model.*;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.util.List;
import java.util.Scanner;

public class VeterinariaApp {
    private static Scanner scanner = new Scanner(System.in);
    private static MascotaDAO mascotaDAO = new MascotaDAO();
    private static ClienteDAO clienteDAO = new ClienteDAO();
    private static VeterinarioDAO veterinarioDAO = new VeterinarioDAO();
    private static CitaDAO citaDAO = new CitaDAO();
    private static HistorialMedicoDAO historialDAO = new HistorialMedicoDAO();
    private static ConsultasAvanzadasDAO consultasDAO = new ConsultasAvanzadasDAO();
    
    public static void main(String[] args) {
        System.out.println("\n" + "=".repeat(70));
        System.out.println("    🐾 SISTEMA DE GESTIÓN DE CLÍNICA VETERINARIA 🐾");
        System.out.println("=".repeat(70));
        
        // Probar conexión a la base de datos
        if (!DatabaseConnection.getInstance().testConnection()) {
            System.err.println("\n❌ No se pudo conectar a la base de datos");
            System.err.println("Verifica que PostgreSQL esté corriendo y que las credenciales sean correctas.");
            return;
        }
        
        boolean salir = false;
        
        while (!salir) {
            mostrarMenuPrincipal();
            int opcion = leerOpcion();
            
            switch (opcion) {
                case 1:
                    registrarNuevaMascota();
                    break;
                case 2:
                    asignarCitaVeterinario();
                    break;
                case 3:
                    consultarHistorialMascota();
                    break;
                case 4:
                    mostrarMenuConsultasAvanzadas();
                    break;
                case 5:
                    listarMascotasRegistradas();
                    break;
                case 6:
                    listarProximasCitas();
                    break;
                case 0:
                    salir = true;
                    System.out.println("\n👋 Gracias por usar el sistema. ¡Hasta pronto!");
                    break;
                default:
                    System.out.println("\n⚠ Opción no válida. Intenta de nuevo.");
            }
        }
        
        // Cerrar conexión y scanner
        DatabaseConnection.getInstance().closeConnection();
        scanner.close();
    }
    
    private static void mostrarMenuPrincipal() {
        System.out.println("\n" + "=".repeat(70));
        System.out.println("MENÚ PRINCIPAL");
        System.out.println("=".repeat(70));
        System.out.println("1. 📝 Registrar una nueva mascota");
        System.out.println("2. 📅 Asignar una cita a un veterinario");
        System.out.println("3. 📋 Consultar historial médico de una mascota");
        System.out.println("4. 📊 Visualizar consultas avanzadas");
        System.out.println("5. 🐕 Listar todas las mascotas registradas");
        System.out.println("6. 🕐 Ver próximas citas programadas");
        System.out.println("0. ❌ Salir");
        System.out.println("=".repeat(70));
        System.out.print("Selecciona una opción: ");
    }
    
    private static void mostrarMenuConsultasAvanzadas() {
        System.out.println("\n" + "=".repeat(70));
        System.out.println("CONSULTAS AVANZADAS");
        System.out.println("=".repeat(70));
        System.out.println("1. 📊 Estadísticas de citas por veterinario");
        System.out.println("2. 🏆 Top 5 mascotas con más consultas");
        System.out.println("3. 📈 Distribución de mascotas por especie");
        System.out.println("0. ⬅ Volver al menú principal");
        System.out.println("=".repeat(70));
        System.out.print("Selecciona una opción: ");
        
        int opcion = leerOpcion();
        
        switch (opcion) {
            case 1:
                consultasDAO.mostrarEstadisticasCitasPorVeterinario();
                break;
            case 2:
                consultasDAO.mostrarTopMascotasConMasConsultas();
                break;
            case 3:
                consultasDAO.mostrarDistribucionMascotasPorEspecie();
                break;
            case 0:
                return;
            default:
                System.out.println("\n⚠ Opción no válida.");
        }
        
        pausar();
    }
    
    // FUNCIONALIDAD 1: Registrar una nueva mascota
    private static void registrarNuevaMascota() {
        System.out.println("\n" + "=".repeat(70));
        System.out.println("📝 REGISTRAR NUEVA MASCOTA");
        System.out.println("=".repeat(70));
        
        // Seleccionar cliente
        System.out.println("\n--- Clientes disponibles ---");
        List<Cliente> clientes = clienteDAO.listarClientes();
        if (clientes.isEmpty()) {
            System.out.println("⚠ No hay clientes registrados en el sistema.");
            return;
        }
        
        for (int i = 0; i < clientes.size(); i++) {
            Cliente c = clientes.get(i);
            System.out.printf("%d. %s %s (%s)%n", 
                    i + 1, c.getNombre(), c.getApellido(), c.getEmail());
        }
        
        System.out.print("\nSelecciona el cliente (número): ");
        int indiceCliente = leerOpcion() - 1;
        if (indiceCliente < 0 || indiceCliente >= clientes.size()) {
            System.out.println("⚠ Cliente no válido.");
            return;
        }
        Cliente clienteSeleccionado = clientes.get(indiceCliente);
        
        // Seleccionar especie
        System.out.println("\n--- Especies disponibles ---");
        List<Especie> especies = mascotaDAO.listarEspecies();
        for (int i = 0; i < especies.size(); i++) {
            System.out.printf("%d. %s%n", i + 1, especies.get(i).getNombreEspecie());
        }
        
        System.out.print("\nSelecciona la especie (número): ");
        int indiceEspecie = leerOpcion() - 1;
        if (indiceEspecie < 0 || indiceEspecie >= especies.size()) {
            System.out.println("⚠ Especie no válida.");
            return;
        }
        Especie especieSeleccionada = especies.get(indiceEspecie);
        
        // Seleccionar raza
        System.out.println("\n--- Razas disponibles ---");
        List<Raza> razas = mascotaDAO.listarRazasPorEspecie(especieSeleccionada.getIdEspecie());
        if (razas.isEmpty()) {
            System.out.println("⚠ No hay razas registradas para esta especie.");
            return;
        }
        
        for (int i = 0; i < razas.size(); i++) {
            System.out.printf("%d. %s%n", i + 1, razas.get(i).getNombreRaza());
        }
        
        System.out.print("\nSelecciona la raza (número): ");
        int indiceRaza = leerOpcion() - 1;
        if (indiceRaza < 0 || indiceRaza >= razas.size()) {
            System.out.println("⚠ Raza no válida.");
            return;
        }
        Raza razaSeleccionada = razas.get(indiceRaza);
        
        // Datos de la mascota
        scanner.nextLine(); // Limpiar buffer
        System.out.print("\nNombre de la mascota: ");
        String nombre = scanner.nextLine();
        
        System.out.print("Fecha de nacimiento (YYYY-MM-DD): ");
        String fechaStr = scanner.nextLine();
        Date fechaNacimiento = Date.valueOf(fechaStr);
        
        System.out.print("Color: ");
        String color = scanner.nextLine();
        
        System.out.print("Peso actual (kg): ");
        BigDecimal peso = new BigDecimal(scanner.nextLine());
        
        System.out.print("Género (M/F/I): ");
        char genero = scanner.nextLine().toUpperCase().charAt(0);
        
        System.out.print("Número de microchip (opcional, enter para omitir): ");
        String microchip = scanner.nextLine();
        if (microchip.trim().isEmpty()) microchip = null;
        
        // Crear y registrar mascota
        Mascota mascota = new Mascota(
                clienteSeleccionado.getIdCliente(),
                nombre,
                especieSeleccionada.getIdEspecie(),
                razaSeleccionada.getIdRaza(),
                fechaNacimiento,
                color,
                peso,
                genero
        );
        mascota.setNumeroMicrochip(microchip);
        
        if (mascotaDAO.registrarMascota(mascota)) {
            System.out.println("\n✅ Mascota registrada exitosamente!");
            System.out.println(mascota);
        } else {
            System.out.println("\n❌ Error al registrar la mascota.");
        }
        
        pausar();
    }
    
    // FUNCIONALIDAD 2: Asignar una cita a un veterinario
    private static void asignarCitaVeterinario() {
        System.out.println("\n" + "=".repeat(70));
        System.out.println("📅 ASIGNAR CITA A VETERINARIO");
        System.out.println("=".repeat(70));
        
        // Seleccionar mascota
        System.out.println("\n--- Mascotas disponibles ---");
        List<Mascota> mascotas = mascotaDAO.listarMascotas();
        if (mascotas.isEmpty()) {
            System.out.println("⚠ No hay mascotas registradas en el sistema.");
            return;
        }
        
        for (int i = 0; i < mascotas.size(); i++) {
            Mascota m = mascotas.get(i);
            System.out.printf("%d. %s (%s - %s) - Dueño: %s%n", 
                    i + 1, m.getNombre(), m.getNombreEspecie(), 
                    m.getNombreRaza(), m.getNombreCliente());
        }
        
        System.out.print("\nSelecciona la mascota (número): ");
        int indiceMascota = leerOpcion() - 1;
        if (indiceMascota < 0 || indiceMascota >= mascotas.size()) {
            System.out.println("⚠ Mascota no válida.");
            return;
        }
        Mascota mascotaSeleccionada = mascotas.get(indiceMascota);
        
        // Seleccionar veterinario
        System.out.println("\n--- Veterinarios disponibles ---");
        List<Veterinario> veterinarios = veterinarioDAO.listarVeterinariosActivos();
        if (veterinarios.isEmpty()) {
            System.out.println("⚠ No hay veterinarios disponibles.");
            return;
        }
        
        for (int i = 0; i < veterinarios.size(); i++) {
            Veterinario v = veterinarios.get(i);
            System.out.printf("%d. Dr(a). %s %s - %s%n", 
                    i + 1, v.getNombre(), v.getApellido(), v.getNombreEspecialidad());
        }
        
        System.out.print("\nSelecciona el veterinario (número): ");
        int indiceVeterinario = leerOpcion() - 1;
        if (indiceVeterinario < 0 || indiceVeterinario >= veterinarios.size()) {
            System.out.println("⚠ Veterinario no válido.");
            return;
        }
        Veterinario veterinarioSeleccionado = veterinarios.get(indiceVeterinario);
        
        // Datos de la cita
        scanner.nextLine(); // Limpiar buffer
        System.out.print("\nFecha de la cita (YYYY-MM-DD): ");
        String fechaStr = scanner.nextLine();
        Date fechaCita = Date.valueOf(fechaStr);
        
        System.out.print("Hora de la cita (HH:MM): ");
        String horaStr = scanner.nextLine() + ":00";
        Time horaCita = Time.valueOf(horaStr);
        
        // Verificar disponibilidad
        if (!veterinarioDAO.verificarDisponibilidad(veterinarioSeleccionado.getIdVeterinario(), fechaCita, horaCita)) {
            System.out.println("\n⚠ El veterinario no está disponible en esa fecha y hora.");
            System.out.print("¿Deseas continuar de todas formas? (S/N): ");
            String respuesta = scanner.nextLine();
            if (!respuesta.equalsIgnoreCase("S")) {
                return;
            }
        }
        
        System.out.print("Motivo de la consulta: ");
        String motivo = scanner.nextLine();
        
        System.out.print("Observaciones (opcional, enter para omitir): ");
        String observaciones = scanner.nextLine();
        if (observaciones.trim().isEmpty()) observaciones = null;
        
        // Crear y registrar cita
        Cita cita = new Cita(
                mascotaSeleccionada.getIdMascota(),
                veterinarioSeleccionado.getIdVeterinario(),
                fechaCita,
                horaCita,
                motivo
        );
        cita.setObservaciones(observaciones);
        
        if (citaDAO.registrarCita(cita)) {
            System.out.println("\n✅ Cita asignada exitosamente!");
            System.out.println("Mascota: " + mascotaSeleccionada.getNombre());
            System.out.println("Veterinario: Dr(a). " + veterinarioSeleccionado.getNombre() + " " + veterinarioSeleccionado.getApellido());
            System.out.println("Fecha: " + fechaCita);
            System.out.println("Hora: " + horaCita);
        } else {
            System.out.println("\n❌ Error al asignar la cita.");
        }
        
        pausar();
    }
    
    // FUNCIONALIDAD 3: Consultar historial de una mascota
    private static void consultarHistorialMascota() {
        System.out.println("\n" + "=".repeat(70));
        System.out.println("📋 CONSULTAR HISTORIAL MÉDICO");
        System.out.println("=".repeat(70));
        
        // Seleccionar mascota
        System.out.println("\n--- Mascotas disponibles ---");
        List<Mascota> mascotas = mascotaDAO.listarMascotas();
        if (mascotas.isEmpty()) {
            System.out.println("⚠ No hay mascotas registradas en el sistema.");
            pausar();
            return;
        }
        
        for (int i = 0; i < mascotas.size(); i++) {
            Mascota m = mascotas.get(i);
            System.out.printf("%d. %s (%s - %s) - Dueño: %s%n", 
                    i + 1, m.getNombre(), m.getNombreEspecie(), 
                    m.getNombreRaza(), m.getNombreCliente());
        }
        
        System.out.print("\nSelecciona la mascota (número): ");
        int indiceMascota = leerOpcion() - 1;
        if (indiceMascota < 0 || indiceMascota >= mascotas.size()) {
            System.out.println("⚠ Mascota no válida.");
            pausar();
            return;
        }
        Mascota mascotaSeleccionada = mascotas.get(indiceMascota);
        
        // Obtener historial médico
        List<HistorialMedico> historial = historialDAO.obtenerHistorialPorMascota(mascotaSeleccionada.getIdMascota());
        
        System.out.println("\n" + "=".repeat(100));
        System.out.println("HISTORIAL MÉDICO DE: " + mascotaSeleccionada.getNombre().toUpperCase());
        System.out.println("Especie: " + mascotaSeleccionada.getNombreEspecie() + " | Raza: " + mascotaSeleccionada.getNombreRaza());
        System.out.println("Dueño: " + mascotaSeleccionada.getNombreCliente());
        System.out.println("=".repeat(100));
        
        if (historial.isEmpty()) {
            System.out.println("\n⚠ Esta mascota no tiene historial médico registrado.");
        } else {
            System.out.println("\nTotal de consultas: " + historial.size());
            System.out.println("-".repeat(100));
            
            for (int i = 0; i < historial.size(); i++) {
                HistorialMedico registro = historial.get(i);
                System.out.printf("\n[CONSULTA #%d]%n", i + 1);
                System.out.println("Fecha: " + registro.getFechaConsulta());
                System.out.println("Veterinario: " + registro.getNombreVeterinario());
                System.out.println("Motivo: " + registro.getMotivoConsulta());
                System.out.println("Diagnóstico: " + registro.getDiagnostico());
                
                if (registro.getPesoRegistrado() != null) {
                    System.out.println("Peso: " + registro.getPesoRegistrado() + " kg");
                }
                if (registro.getTemperatura() != null) {
                    System.out.println("Temperatura: " + registro.getTemperatura() + "°C");
                }
                if (registro.getFrecuenciaCardiaca() != null) {
                    System.out.println("Frecuencia cardíaca: " + registro.getFrecuenciaCardiaca() + " lpm");
                }
                if (registro.getObservacionesGenerales() != null) {
                    System.out.println("Observaciones: " + registro.getObservacionesGenerales());
                }
                
                System.out.println("-".repeat(100));
            }
        }
        
        // Mostrar también las citas programadas
        List<Cita> citas = citaDAO.listarCitasPorMascota(mascotaSeleccionada.getIdMascota());
        System.out.println("\n--- CITAS PROGRAMADAS ---");
        if (citas.isEmpty()) {
            System.out.println("⚠ No hay citas programadas para esta mascota.");
        } else {
            for (Cita cita : citas) {
                System.out.printf("• %s %s - %s con %s (%s)%n",
                        cita.getFechaCita(),
                        cita.getHoraCita(),
                        cita.getEstadoCita(),
                        cita.getNombreVeterinario(),
                        cita.getEspecialidadVeterinario());
            }
        }
        
        System.out.println("=".repeat(100));
        pausar();
    }
    
    // Funcionalidad adicional: Listar mascotas
    private static void listarMascotasRegistradas() {
        System.out.println("\n" + "=".repeat(100));
        System.out.println("🐕 MASCOTAS REGISTRADAS");
        System.out.println("=".repeat(100));
        
        List<Mascota> mascotas = mascotaDAO.listarMascotas();
        
        if (mascotas.isEmpty()) {
            System.out.println("⚠ No hay mascotas registradas en el sistema.");
        } else {
            System.out.printf("%-5s | %-20s | %-15s | %-20s | %6s | %12s | %-30s%n",
                    "ID", "Nombre", "Especie", "Raza", "Género", "Peso (kg)", "Dueño");
            System.out.println("-".repeat(100));
            
            for (Mascota m : mascotas) {
                System.out.printf("%-5d | %-20s | %-15s | %-20s | %6s | %12s | %-30s%n",
                        m.getIdMascota(),
                        m.getNombre(),
                        m.getNombreEspecie(),
                        m.getNombreRaza(),
                        m.getGenero(),
                        m.getPesoActual(),
                        m.getNombreCliente());
            }
            System.out.println("-".repeat(100));
            System.out.println("Total de mascotas: " + mascotas.size());
        }
        
        System.out.println("=".repeat(100));
        pausar();
    }
    
    // Funcionalidad adicional: Ver próximas citas
    private static void listarProximasCitas() {
        System.out.println("\n" + "=".repeat(110));
        System.out.println("🕐 PRÓXIMAS CITAS PROGRAMADAS");
        System.out.println("=".repeat(110));
        
        List<Cita> citas = citaDAO.listarProximasCitas();
        
        if (citas.isEmpty()) {
            System.out.println("⚠ No hay citas programadas próximamente.");
        } else {
            System.out.printf("%-5s | %-12s | %-8s | %-20s | %-30s | %-20s%n",
                    "ID", "Fecha", "Hora", "Mascota", "Veterinario", "Motivo");
            System.out.println("-".repeat(110));
            
            for (Cita c : citas) {
                System.out.printf("%-5d | %-12s | %-8s | %-20s | %-30s | %-20s%n",
                        c.getIdCita(),
                        c.getFechaCita(),
                        c.getHoraCita(),
                        c.getNombreMascota(),
                        c.getNombreVeterinario(),
                        c.getMotivoConsulta().substring(0, Math.min(20, c.getMotivoConsulta().length())));
            }
            System.out.println("-".repeat(110));
            System.out.println("Total de citas: " + citas.size());
        }
        
        System.out.println("=".repeat(110));
        pausar();
    }
    
    // Métodos auxiliares
    private static int leerOpcion() {
        try {
            return Integer.parseInt(scanner.nextLine());
        } catch (NumberFormatException e) {
            return -1;
        }
    }
    
    private static void pausar() {
        System.out.print("\nPresiona ENTER para continuar...");
        scanner.nextLine();
    }
}
