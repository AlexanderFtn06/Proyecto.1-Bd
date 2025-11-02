import java.sql.*;

public class OracleConnection {


    private String url = "jdbc:oracle:thin:@localhost:1521:XE";
    private String usuario = "tienda";
    private String contraseña = "a123456";


    public void ejecutarConsulta(String query) {

        try (Connection connection = DriverManager.getConnection(url, usuario, contraseña)) {

            if (!query.toUpperCase().startsWith("SELECT")) {
                System.out.println("Solo se permiten consultas SELECT");
                return;
            }

            Statement statementmt = connection.createStatement();
            ResultSet resultSet = statementmt.executeQuery(query);

            ResultSetMetaData meta = resultSet.getMetaData();
            int col = meta.getColumnCount();

            System.out.println(" Resultados:");

            boolean hayDatos = false;

            while (resultSet.next()) {
                hayDatos = true;

                for (int i = 1; i <= col; i++) {
                    System.out.print(meta.getColumnName(i) + ": " + resultSet.getString(i) + "   ");
                }
                System.out.println();
            }

            if (!hayDatos) {
                System.out.println("No se encontraron datos.");
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
