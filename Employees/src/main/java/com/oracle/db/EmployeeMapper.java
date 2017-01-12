package com.oracle.db;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.skife.jdbi.v2.StatementContext;
import org.skife.jdbi.v2.tweak.ResultSetMapper;

import com.oracle.core.Employee;

public class EmployeeMapper implements ResultSetMapper<Employee> {

	@Override
	public Employee map(int arg0, ResultSet arg1, StatementContext arg2) throws SQLException {
		Employee employee = new Employee(arg1.getString("employee_id"), arg1.getString("first_name"), arg1.getString("last_name"), arg1.getString("email"), arg1.getString("phone_no"), arg1.getString("hire_date"), arg1.getString("salary"));
		return employee;
	}
}