package com.oracle.db;

import java.util.List;

import org.skife.jdbi.v2.sqlobject.Bind;
import org.skife.jdbi.v2.sqlobject.SqlQuery;
import org.skife.jdbi.v2.sqlobject.SqlUpdate;
import org.skife.jdbi.v2.sqlobject.customizers.RegisterMapper;

import com.oracle.core.Employee;

@RegisterMapper(EmployeeMapper.class)
public interface EmployeesDAO {
	@SqlQuery("select employee_id, first_name, last_name, email, phone_no, hire_date, salary from employees order by employee_id")
	List<Employee> getAllEmployees();
	
	@SqlQuery("select employee_id, first_name, last_name, email, phone_no, hire_date, salary from employees where employee_id=:employeeid")
	List<Employee> getEmployeesByEmployeeId(@Bind("employeeid") String employeeid);
	
	@SqlQuery("select employee_id, first_name, last_name, email, phone_no, hire_date, salary from employees where first_name like CONCAT('%', :firstname, '%') order by employee_id")
	List<Employee> getEmployeesByFirstName(@Bind("firstname") String firstname);
	
	@SqlQuery("select employee_id, first_name, last_name, email, phone_no, hire_date, salary from employees where email like CONCAT('%', :email, '%') order by employee_id")
	List<Employee> getEmployeesByEmail(@Bind("email") String email);
	
	@SqlUpdate("insert into employees (employee_id, first_name, last_name, email, phone_no, hire_date, salary) values (NULL, :firstname, :lastname, :email, :phoneno, DATE_FORMAT(:hiredate, '%Y-%m-%d'), :salary)")
	int insert(@Bind("firstname") String firstname, @Bind("lastname") String lastname, @Bind("email") String email, @Bind("phoneno") String phoneno, @Bind("hiredate") String hiredate, @Bind("salary") String salary);

	@SqlUpdate("update employees set first_name=:firstname, last_name=:lastname, email=:email, phone_no=:phoneno, hire_date=DATE_FORMAT(:hiredate, '%Y-%m-%d'), salary=:salary where employee_id=:employeeid")
	int update(@Bind("firstname") String firstname, @Bind("lastname") String lastname, @Bind("email") String email, @Bind("phoneno") String phoneno, @Bind("hiredate") String hiredate, @Bind("salary") String salary, @Bind("employeeid") String employeeid);

	@SqlUpdate("delete from employees where employee_id=:employeeid")
	int delete(@Bind("employeeid") String employeeid);

	void close();
}
