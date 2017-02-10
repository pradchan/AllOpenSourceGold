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
    	cfactory.setPort(Integer.parseInt(port.orElse("8128")));
	}

	@NotNull
    @Valid
    private DataSourceFactory database = new DataSourceFactory();

	@JsonProperty("database")
    public void setDataSourceFactory(DataSourceFactory database) {

	Optional<String> ipAddress = Optional.ofNullable(System.getenv("EMPLOYEES_DATABASE_HOST"));
        String URL = "jdbc:mysql://"+System.getenv("MYSQLCS_CONNECT_STRING");
		//+":"+System.getenv("MYSQLCS_MYSQL_PORT")+"/EmployeeMySQLDB"
System.out.println(URL);
        database.setUrl(URL);
		this.database = database;
    }

    @JsonProperty("database")
    public DataSourceFactory getDataSourceFactory() {
        return database;
    }

}
