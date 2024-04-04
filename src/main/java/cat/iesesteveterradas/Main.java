package cat.iesesteveterradas;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.basex.api.client.ClientSession;
import org.basex.core.*;
import org.basex.core.cmd.XQuery;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Main {
    private static final Logger logger = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) throws IOException {
        // Initialize connection details
        String host = "127.0.0.1";
        int port = 1984;
        String username = "admin"; // Default username
        String password = "admin"; // Default password

        // Directorio de entrada
        File inputDirectory = new File("./data/input");
        // Directorio de salida
        File outputDirectory = new File("./data/output");
        // Verificar si el directorio de salida existe, si no, crearlo
        if (!outputDirectory.exists()) {
            outputDirectory.mkdirs();
        }

        // Obtener la lista de archivos en el directorio de entrada
        File[] files = inputDirectory.listFiles();

        // Establecer una conexión con el servidor BaseX
        try (ClientSession session = new ClientSession(host, port, username, password)) {
            logger.info("Connected to BaseX server.");

            // Iterar sobre cada archivo en el directorio de entrada
            for (File file : files) {
                // Verificar que el archivo sea un archivo de consulta
                System.out.println(file.toPath());
                if (file.isFile() && file.getName().toLowerCase().endsWith(".xq")) {
                    System.out.println("condicion");
                    // Obtener el contenido de la consulta
                    String query = Files.readString(file.toPath());
                    // Obtener el nombre del archivo sin la extensión
                    String fileNameWithoutExtension = file.getName().substring(0, file.getName().lastIndexOf("."));
                    logger.info("Executing query from file: " + fileNameWithoutExtension);

                    // Ejecutar la consulta
                    String result = session.execute(new XQuery(query));

                    // Guardar el resultado como un archivo XML en el directorio de salida
                    String outputFilePath = outputDirectory.getAbsolutePath() + File.separator + fileNameWithoutExtension + ".xml";
                    try (FileWriter writer = new FileWriter(outputFilePath)) {
                        writer.write(result);
                    } catch (IOException e) {
                        logger.error("Error writing output file: " + e.getMessage());
                    }

                    logger.info("Query result saved as: " + outputFilePath);
                }
            }
        } catch (BaseXException e) {
            logger.error("Error connecting or executing the query: " + e.getMessage());
        } catch (IOException e) {
            logger.error(e.getMessage());
        }
    }
}
