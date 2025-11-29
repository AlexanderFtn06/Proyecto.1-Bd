import java.sql.*;

public class OracleConnection {

    private String url = "jdbc:oracle:thin:@localhost:1521:XE";
    private String usuario = "tienda";
    private String contraseña = "a123456";
    private Connection connection;

    public void conectar() {
        try {
            connection = DriverManager.getConnection(url, usuario, contraseña);
            connection.setAutoCommit(true);
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

    public void registrarVenta(int idVenta, int idCliente) {
        String sql = "{ call registrar_venta(?, ?) }";
        try {
            CallableStatement cs = connection.prepareCall(sql);
            cs.setInt(1, idVenta);
            cs.setInt(2, idCliente);
            cs.execute();
            System.out.println("Venta registrada exitosamente.");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }


    public void agregarDetalleVenta(int idDetalle, int idVenta, int idProducto, int cantidad) {
        String sql = "{ call agregar_detalle_venta(?, ?, ?, ?) }";
        try {
            CallableStatement cs = connection.prepareCall(sql);
            cs.setInt(1, idDetalle);
            cs.setInt(2, idVenta);
            cs.setInt(3, idProducto);
            cs.setInt(4, cantidad);
            cs.execute();
            System.out.println("Detalle agregado exitosamente.");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }


    public void actualizarVenta(int idVenta, int idCliente) {
        String sql = "{ call actualizar_venta(?, ?) }";
        try {
            CallableStatement cs = connection.prepareCall(sql);
            cs.setInt(1, idVenta);
            cs.setInt(2, idCliente);
            cs.execute();
            System.out.println("Venta actualizada correctamente.");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public boolean existeVenta(int idVenta) {
        String sql = "SELECT COUNT(*) FROM venta WHERE id_venta = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, idVenta);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0; // true si existe
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }


    public void eliminarVenta(int idVenta) {

        // Verificar si existe
        if (!existeVenta(idVenta)) {
            System.out.println("ID no registrado");
            return;
        }

        String sql = "{ call eliminar_venta(?) }";

        try {
            CallableStatement cs = connection.prepareCall(sql);
            cs.setInt(1, idVenta);

            cs.execute();

            System.out.println("✔ Venta eliminada correctamente.");

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }




    public void mostrarVista(String vista) {
        try {
            PreparedStatement ps = connection.prepareStatement("SELECT * FROM " + vista);
            ResultSet rs = ps.executeQuery();

            ResultSetMetaData meta = rs.getMetaData();
            int colCount = meta.getColumnCount();

            while (rs.next()) {
                for (int i = 1; i <= colCount; i++) {
                    System.out.print(meta.getColumnName(i) + ": " + rs.getString(i) + " | ");
                }
                System.out.println();
            }

            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public int obtenerNuevoIdDetalle() {
        String sql = "SELECT NVL(MAX(id_detalle), 0) + 1 FROM detalle_venta";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 1;
    }


}

