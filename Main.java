import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        OracleConnection oracle = new OracleConnection();
        Scanner scanner = new Scanner(System.in);

        System.out.println("Conectado a Oracle correctamente");
        System.out.println("Solo se permiten consultas SELECT");

        System.out.println("Escribe tu consulta SELECT: ");
        String query = scanner.nextLine();


        oracle.ejecutarConsulta(query);

        scanner.close();
    }
}