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
            System.out.println("5. Procedimientos almacenatos(ventas)");
            System.out.println("6. Mostrar productos y sus detalles (vista)");
            System.out.println("7. Mostrar ventas detalle (vista)");
            System.out.println("8. Mostrar productos con stokc bajo (vista)");
            System.out.println("9. Mostrar top 3 ventas (vista)");
            System.out.println("10. Salir");
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
                    menuProcedimientosVentas( scanner, oracleConnection);
                    break;
                case 6:
                    oracleConnection.mostrarVista("vts_productos_detalle");
                    break;
                case 7:
                    oracleConnection.mostrarVista("vts_ventas_detalle");
                    break;
                case 8:
                    oracleConnection.mostrarVista("vts_productos_stock_bajo");
                    break;
                case 9:
                    oracleConnection.mostrarVista("vts_top3_ventas_detalle");
                    break;
                case 10:
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

    public static void menuProcedimientosVentas(Scanner scanner, OracleConnection oracle) {

        boolean seguir = true;

        while (seguir) {
            System.out.println("\nProcedimientos");
            System.out.println("1. Agregar venta con detalles ");
            System.out.println("2. Actualizar venta");
            System.out.println("3. Eliminar venta");
            System.out.println("4. Volver");
            System.out.print("Seleccione una opción: ");
            int opcion = Integer.parseInt(scanner.nextLine());

            switch (opcion) {

                case 1:
                    registrarVentaConDetalles(scanner, oracle);
                    break;
                case 2:
                    actualizarVenta(scanner, oracle);
                    break;
                case 3 :
                    eliminarVenta(scanner, oracle);
                    break;
                case 4 :
                    seguir = false;
                    break;
                default :  System.out.println("Opción no válida.");
            }
        }
    }

    public static void registrarVentaConDetalles(Scanner sc, OracleConnection oc) {

        System.out.print("ID de la venta: ");
        int idVenta = Integer.parseInt(sc.nextLine());

        System.out.print("ID del cliente: ");
        int idCliente = Integer.parseInt(sc.nextLine());

        oc.registrarVenta(idVenta, idCliente);

        boolean agregarMas = true;

        while (agregarMas) {

            int idDetalle = oc.obtenerNuevoIdDetalle();

            System.out.print("ID del producto: ");
            int idProducto = Integer.parseInt(sc.nextLine());

            System.out.print("Cantidad: ");
            int cantidad = Integer.parseInt(sc.nextLine());

            oc.agregarDetalleVenta(idDetalle, idVenta, idProducto, cantidad);

            System.out.print("¿Agregar otro producto? (s/n): ");
            String opcion = sc.nextLine();

            if (!opcion.equalsIgnoreCase("s")) {
                agregarMas = false;
            }
        }

        System.out.println("Venta registrada COMPLETA con detalles.");
    }



    public static void actualizarVenta(Scanner sc, OracleConnection oc) {
        System.out.print("ID de la venta a actualizar: ");
        int idVenta = Integer.parseInt(sc.nextLine());

        System.out.print("Nuevo ID de cliente: ");
        int idCliente = Integer.parseInt(sc.nextLine());

        oc.actualizarVenta(idVenta, idCliente);
    }

    public static void eliminarVenta(Scanner sc, OracleConnection oc) {
        System.out.print("ID de la venta a eliminar: ");
        int idVenta = Integer.parseInt(sc.nextLine());

        oc.eliminarVenta(idVenta);
    }

}
