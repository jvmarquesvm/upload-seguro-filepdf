package com.exemplo;

import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

import java.io.File;

/**
 * Servidor Tomcat Embutido para rodar a aplicação JSP sem precisar de instalação externa de servidor.
 */
public class Main {
    public static void main(String[] args) throws Exception {
        int port = 8080;
        String webappDirLocation = "src/main/webapp/";
        Tomcat tomcat = new Tomcat();

        tomcat.setPort(port);
        tomcat.getConnector(); // Inicializa o conector HTTP padrão

        File webappDir = new File(webappDirLocation);
        StandardContext ctx = (StandardContext) tomcat.addWebapp("", webappDir.getAbsolutePath());

        // Adiciona classes compiladas ao classpath do Tomcat embutido
        File additionWebInfClasses = new File("target/classes");
        if (additionWebInfClasses.exists()) {
            WebResourceRoot resources = new StandardRoot(ctx);
            resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                    additionWebInfClasses.getAbsolutePath(), "/"));
            ctx.setResources(resources);
        }

        System.out.println("=================================================");
        System.out.println(" Servidor JSP iniciado com sucesso em Java 17!");
        System.out.println(" Acesse no navegador: http://localhost:" + port);
        System.out.println(" Pressione Ctrl+C para encerrar o servidor.");
        System.out.println("=================================================");

        tomcat.start();
        tomcat.getServer().await();
    }
}
