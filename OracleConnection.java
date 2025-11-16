import java.sql.*;

public class OracleConnection {

    private String url = "jdbc:oracle:thin:@localhost:1521:XE";
    private String usuario = "tienda";
    private String contraseña = "a123456";
    private Connection connection;

    public void conectar() {
        try {
            connection = DriverManager.getConnection(url, usuario, contraseña);
            System.out.println("Conectado correctamente a la base de datos.");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void cerrarConexion() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("Conexión cerrada correctamente");
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void insertarProducto(int id_producto, String nombre_prod, double precio_prod, int stock, int id_categoria, int id_proveedor) {
        String sql = "INSERT INTO producto (id_producto, nombre_prod, precio_prod, stock, id_categoria, id_proveedor) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, id_producto);
            preparedStatement.setString(2, nombre_prod);
            preparedStatement.setDouble(3, precio_prod);
            preparedStatement.setInt(4, stock);
            preparedStatement.setInt(5, id_categoria);
            preparedStatement.setInt(6, id_proveedor);

            int filas = preparedStatement.executeUpdate();

            System.out.println("Producto insertado. Filas afectadas: " + filas);
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void actualizarProducto(int id_producto,String nombre_prod, double precio_prod, int stock, int id_categoria, int id_proveedor) {
        String sql = "UPDATE producto SET nombre_prod = ?, precio_prod = ?, stock = ?, id_categoria = ?, id_proveedor = ? WHERE id_producto = ?";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, nombre_prod);
            preparedStatement.setDouble(2, precio_prod);
            preparedStatement.setInt(3, stock);
            preparedStatement.setInt(4, id_categoria);
            preparedStatement.setInt(5, id_proveedor);
            preparedStatement.setInt(6, id_producto);

            int filas = preparedStatement.executeUpdate();
            System.out.println("Producto actualizado. Filas afectadas: " + filas);

            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void eliminarProductoPorNombre(String nombre_prod) {
        String sql = "DELETE FROM producto WHERE nombre_prod = ?";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, nombre_prod);

            int filas = preparedStatement.executeUpdate();
            System.out.println("Producto eliminado. Filas afectadas: " + filas);

            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void ejecutarConsulta(String query) {
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            ResultSet resultSet = preparedStatement.executeQuery();

            ResultSetMetaData meta = resultSet.getMetaData();
            int colCount = meta.getColumnCount();

            boolean hayDatos = false;
            while (resultSet.next()) {
                hayDatos = true;
                for (int i = 1; i <= colCount; i++) {
                    System.out.print(meta.getColumnName(i) + ": " + resultSet.getString(i) + "\t");
                }
                System.out.println();
            }
            if (!hayDatos) {
                System.out.println("No se encontraron datos.");
            }

            resultSet.close();
            preparedStatement.close();

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void insertarDatos(String query) {
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            int filas = preparedStatement.executeUpdate();
            System.out.println("Inserción exitosa. Filas afectadas: " + filas);
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void actualizarDatos(String query) {
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            int filas = preparedStatement.executeUpdate();
            System.out.println("Actualización exitosa. Filas afectadas: " + filas);
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void eliminarDatos(String query) {
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            int filas = preparedStatement.executeUpdate();
            System.out.println("Eliminación exitosa. Filas afectadas: " + filas);
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
