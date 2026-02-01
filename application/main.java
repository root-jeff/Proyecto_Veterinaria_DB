// =========================================================================
// NOTA: Este archivo ha sido reemplazado por VeterinariaApp.java
// =========================================================================
// Para ejecutar la aplicación, usa:
//   java -cp "bin;lib/postgresql-XX.X.X.jar" VeterinariaApp
// 
// O utiliza los scripts proporcionados:
//   - Windows: ejecutar.bat
//   - Linux/Mac: ./ejecutar.sh
// =========================================================================

public class main {
    public static void main(String[] args) {
        System.out.println("╔══════════════════════════════════════════════════════════════╗");
        System.out.println("║  Este archivo ha sido reemplazado por VeterinariaApp.java   ║");
        System.out.println("╚══════════════════════════════════════════════════════════════╝");
        System.out.println();
        System.out.println("Para ejecutar la aplicación principal, usa:");
        System.out.println();
        System.out.println("  Windows:");
        System.out.println("    ejecutar.bat");
        System.out.println();
        System.out.println("  Linux/Mac:");
        System.out.println("    ./ejecutar.sh");
        System.out.println();
        System.out.println("O compila y ejecuta directamente:");
        System.out.println("  java -cp \"bin;lib/postgresql-XX.X.X.jar\" VeterinariaApp");
        System.out.println();
        
        // Intentar ejecutar VeterinariaApp si está disponible
        try {
            Class<?> appClass = Class.forName("VeterinariaApp");
            java.lang.reflect.Method mainMethod = appClass.getMethod("main", String[].class);
            mainMethod.invoke(null, (Object) args);
        } catch (Exception e) {
            System.err.println("No se pudo ejecutar VeterinariaApp.");
            System.err.println("Asegúrate de compilar primero con compilar.bat o compilar.sh");
        }
    }
}
