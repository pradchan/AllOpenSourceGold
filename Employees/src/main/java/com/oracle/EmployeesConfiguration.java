package com.oracle;

import java.util.Optional;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonProperty;

import io.dropwizard.Configuration;
import io.dropwizard.db.DataSourceFactory;
import io.dropwizard.jetty.ConnectorFactory;
import io.dropwizard.jetty.HttpConnectorFactory;
import io.dropwizard.server.DefaultServerFactory;
import io.dropwizard.server.ServerFactory;

public class EmployeesConfiguration extends Configuration {

	public EmployeesConfiguration() {
		Optional<String> port = Optional.ofNullable(System.getenv("PORT"));
    	DefaultServerFactory factory = (DefaultServerFactory) getServerFactory();
    	HttpConnectorFactory cfactory = (HttpConnectorFactory) factory.getApplicationConnectors().get(0);
    	cfactory.setPort(Integer.parseInt(port.orElse("8126")));
	}

	@NotNull
    @Valid
    private DataSourceFactory database = new DataSourceFactory();

	@JsonProperty("database")
    public void setDataSourceFactory(DataSourceFactory database) {

		final String URL = "jdbc:mysql://";
	    final String LOCAL_USERNAME = "root";
	    final String LOCAL_PASSWORD = "Welc0me_2017";
	    final String LOCAL_DEFAULT_CONNECT_DESCRIPTOR = "140.86.34.69:3306/EmployeeMySQLDB";

	    final Optional<String> DBAAS_USERNAME = Optional.ofNullable(System.getenv("MYSQLCS_USER_NAME"));
	    final Optional<String> DBAAS_PASSWORD = Optional.ofNullable(System.getenv("MYSQLCS_USER_PASSWORD"));
	    final Optional<String> DBAAS_DEFAULT_CONNECT_DESCRIPTOR = Optional.ofNullable(System.getenv("MYSQLCS_CONNECT_STRING"));
	    
	    String finalUrl = URL + DBAAS_DEFAULT_CONNECT_DESCRIPTOR.orElse(LOCAL_DEFAULT_CONNECT_DESCRIPTOR)+"?autoReconnect=true&verifyServerCertificate=false&useSSL=false";
	    
	    database.setUrl(finalUrl);
	    database.setUser(DBAAS_USERNAME.orElse(LOCAL_USERNAME));
	    database.setPassword(DBAAS_PASSWORD.orElse(LOCAL_PASSWORD));

	    System.out.println("URL: "+database.getUrl());
	    System.out.println("User: "+database.getUser());
	    System.out.println("Password: "+database.getPassword());
	    System.out.println(database.getProperties());

//		Optional<String> ipAddress = Optional.ofNullable(System.getenv("EMPLOYEES_DATABASE_HOST"));
//        String URL = "jdbc:mysql://"+ipAddress.orElse("192.168.99.100")+":3307/hr";
		this.database = database;
    }

    @JsonProperty("database")
    public DataSourceFactory getDataSourceFactory() {
        return database;
    }

}
