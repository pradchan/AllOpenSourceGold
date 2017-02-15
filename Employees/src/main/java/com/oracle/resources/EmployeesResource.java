package com.oracle.resources;

import java.util.List;

import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.oracle.core.Employee;
import com.oracle.db.EmployeesDAO;

@Path("/employees")
@Produces(MediaType.APPLICATION_JSON)
public class EmployeesResource {

	Logger log = LoggerFactory.getLogger(EmployeesResource.class);

	EmployeesDAO dao;
	
    public EmployeesResource(EmployeesDAO dao) {
        this.dao = dao;
    }
    
	@GET
    public Response getAllEmployees() {
		List<Employee> list = dao.getAllEmployees();
		dao.close();
		if (list.size() == 0) {
			//String msg = "{'status':'No records found...'}";
			return Response.ok().build();
		}
		return Response.ok(list).build();
    }

	@GET
	@Path("/employeeid/{employeeid}")
    public Response getEmployeesByEmployeeId(@PathParam("employeeid") String employeeid) {
		List<Employee> list = dao.getEmployeesByEmployeeId(employeeid);
		dao.close();
		if (list.size() == 0) {
			//String msg = "{'status':'No records found...'}";
			return Response.ok().build();
		}
		return Response.ok(list).build();
    }

	@GET
	@Path("/firstname/{firstname}")
    public Response getEmployeesByFirstName(@PathParam("firstname") String firstname) {
		List<Employee> list = dao.getEmployeesByFirstName(firstname);
		dao.close();
		if (list.size() == 0) {
			//String msg = "{'status':'No records found...'}";
			return Response.ok().build();
		}
		return Response.ok(list).build();
    }

	@GET
	@Path("/email/{email}")
    public Response getEmployeesByEmail(@PathParam("email") String email) {
		List<Employee> list = dao.getEmployeesByEmail(email);
		dao.close();
		if (list.size() == 0) {
			//String msg = "{'status':'No records found...'}";
			return Response.ok().build();
		}
		return Response.ok(list).build();
    }

	@POST
	public Response insertEmployee(Employee employee) {
		int result = dao.insert(employee.getFirst_name(), employee.getLast_name(), employee.getEmail(), employee.getPhone_no(), employee.getHire_date(), employee.getSalary());
		dao.close();
		String msg = (result == 1) ? "{\"status\":\"Successfully inserted...\"}" : "{\"status\":\"Failed to insert...\"}";
		return Response.ok(msg).build();
	}

	@PUT
	@Path("/{employeeid}")
	public Response updateEmployee(Employee employee, @PathParam("employeeid") String employeeid) {
		int result = dao.update(employee.getFirst_name(), employee.getLast_name(), employee.getEmail(), employee.getPhone_no(), employee.getHire_date(), employee.getSalary(), employeeid);
		dao.close();
		String msg = (result == 1) ? "{\"status\":\"Successfully updated...\"}" : "{\"status\":\"Failed to update...\"}";
		return Response.ok(msg).build();
	}

	@DELETE
	@Path("/{employeeid}")
	public Response deleteEmployee(@PathParam("employeeid") String employeeid) {
		int result = dao.delete(employeeid);
		dao.close();
		String msg = (result == 1) ? "{\"status\":\"Successfully deleted...\"}" : "{\"status\":\"Failed to delete...\"}";
		return Response.ok(msg).build();
	}
}
