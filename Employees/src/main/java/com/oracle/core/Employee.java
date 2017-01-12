package com.oracle.core;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Employee {
	@JsonProperty
	private String employee_id;
	@JsonProperty
	private String first_name;
	@JsonProperty
	private String last_name;
	@JsonProperty
	private String email;
	@JsonProperty
	private String phone_no;
	@JsonProperty
	private String hire_date;
	@JsonProperty
	private String salary;
	
	public Employee() {
		this.employee_id = "";
		this.first_name = "";
		this.last_name = "";
		this.email = "";
		this.phone_no = "";
		this.hire_date = "";
		this.salary = "";
	}

	@Override
	public String toString() {
		return "Employee [employee_id=" + employee_id + ", first_name=" + first_name + ", last_name=" + last_name
				+ ", email=" + email + ", phone_no=" + phone_no + ", hire_date=" + hire_date + ", salary=" + salary
				+ "]";
	}

	public String getEmployee_id() {
		return employee_id;
	}

	public String getFirst_name() {
		return first_name;
	}

	public String getLast_name() {
		return last_name;
	}

	public String getEmail() {
		return email;
	}

	public String getPhone_no() {
		return phone_no;
	}

	public String getHire_date() {
		return hire_date;
	}

	public String getSalary() {
		return salary;
	}

	public Employee(String employee_id, String first_name, String last_name, String email, String phone_no, String hire_date, String salary) {
		this.employee_id = employee_id;
		this.first_name = first_name;
		this.last_name = last_name;
		this.email = email;
		this.phone_no = phone_no;
		this.hire_date = hire_date;
		this.salary = salary;
	}

}
