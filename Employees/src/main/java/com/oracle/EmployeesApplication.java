package com.oracle;

import org.skife.jdbi.v2.DBI;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.oracle.db.EmployeesDAO;
import com.oracle.resources.EmployeesResource;

import io.dropwizard.Application;
import io.dropwizard.jdbi.DBIFactory;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;

public class EmployeesApplication extends Application<EmployeesConfiguration> {

	private static final Logger LOGGER = LoggerFactory.getLogger(EmployeesApplication.class);
	
    public static void main(final String[] args) throws Exception {
        new EmployeesApplication().run(args);
    }

    @Override
    public String getName() {
        return "Employees";
    }

    @Override
    public void initialize(final Bootstrap<EmployeesConfiguration> bootstrap) {
        // TODO: application initialization
    }

    @Override
    public void run(final EmployeesConfiguration configuration,
                    final Environment environment) {
    	LOGGER.info("Registering EmployeesResource...");
    	final DBIFactory factory = new DBIFactory();
        final DBI jdbi = factory.build(environment, configuration.getDataSourceFactory(), "mysql");
        final EmployeesDAO dao = jdbi.onDemand(EmployeesDAO.class);
    	environment.jersey().register(new EmployeesResource(dao));
    }

}