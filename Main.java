import java.util.Scanner;
public class Main {

    public static void main(String[] args) {

        OracleConnection oracleConnection = new OracleConnection();
        Scanner scanner = new Scanner(System.in);
        oracleConnection.conectar();

        boolean ejecutar = true;

        while (ejecutar) {
            System.out.println("1. Insertar producto");
            System.out.println("2. Actualizar producto");
            System.out.println("3. Eliminar producto por nombre");
            System.out.println("4. Ejecutar SQL manual");
            System.out.println("5. Salir");
            System.out.print("Seleccione una opción: ");
            int opcion = Integer.parseInt(scanner.nextLine());

            switch (opcion) {
                case 1:
                    insertarProducto(scanner , oracleConnection);
                    break;
                case 2:
                    actualizarProducto(scanner , oracleConnection);
                    break;
                case 3:
                    eliminarProducto(scanner , oracleConnection);
                    break;
                case 4:
                    ejecutarQuery(scanner, oracleConnection);
                    break;
                case 5:
                    ejecutar = false;
                    break;
                default:
                    System.out.println("Opción no válida.");
            }
        }

        oracleConnection.cerrarConexion();
    }

    public static void insertarProducto(Scanner scanner, OracleConnection oracleConnection) {
        System.out.print("ID del producto: ");
        int id = Integer.parseInt(scanner.nextLine());

        System.out.print("Nombre: ");
        String nombre = scanner.nextLine();

        System.out.print("Precio: ");
        double precio = Double.parseDouble(scanner.nextLine());

        System.out.print("Stock: ");
        int stock = Integer.parseInt(scanner.nextLine());

        System.out.print("ID Categoría: ");
        int idCategoria = Integer.parseInt(scanner.nextLine());

        System.out.print("ID Proveedor: ");
        int idProveedor = Integer.parseInt(scanner.nextLine());

        oracleConnection.insertarProducto(id, nombre, precio, stock, idCategoria, idProveedor);
    }



    public static void actualizarProducto(Scanner scanner, OracleConnection oracleConnection) {
        System.out.print("ID del producto a actualizar: ");
        int id = Integer.parseInt(scanner.nextLine());

        System.out.print("Nuevo nombre: ");
        String nombre = scanner.nextLine();

        System.out.print("Nuevo precio: ");
        double precio = Double.parseDouble(scanner.nextLine());

        System.out.print("Nuevo stock: ");
        int stock = Integer.parseInt(scanner.nextLine());

        System.out.print("Nueva ID Categoría: ");
        int idCategoria = Integer.parseInt(scanner.nextLine());

        System.out.print("Nueva ID Proveedor: ");
        int idProveedor = Integer.parseInt(scanner.nextLine());

        oracleConnection.actualizarProducto(id, nombre, precio, stock, idCategoria, idProveedor);
    }

    public static void eliminarProducto(Scanner scanner, OracleConnection oracleConnection) {
        System.out.print("Nombre del producto a eliminar: ");
        String nombre = scanner.nextLine();
        oracleConnection.eliminarProductoPorNombre(nombre);
    }

    public static void ejecutarQuery(Scanner scanner, OracleConnection oracleConnection) {
        System.out.println("Escriba su sentencia SQL:");
        String query = scanner.nextLine();

        String tipo = query.trim().toLowerCase();

        if (tipo.startsWith("select")) {
            oracleConnection.ejecutarConsulta(query);
        } else if (tipo.startsWith("insert")) {
            oracleConnection.insertarDatos(query);
        } else if (tipo.startsWith("update")) {
            oracleConnection.actualizarDatos(query);
        } else if (tipo.startsWith("delete")) {
            oracleConnection.eliminarDatos(query);
        } else {
            System.out.println("Tipo de query no reconocido.");
        }
    }
}
