drop table if exists employees;
create table employees (employee_id VARCHAR(50) primary key, first_name VARCHAR(50), last_name VARCHAR(50), email VARCHAR(50), phone_no VARCHAR(20), hire_date DATE, salary DECIMAL(8,2));
insert into employees (employee_id, first_name, last_name, email, phone_no, hire_date, salary) values ('101', 'Siva', 'Krishna', 'siva.krishna@abc.com', '9848098480', '2008-12-01', 25000.0);
insert into employees (employee_id, first_name, last_name, email, phone_no, hire_date, salary) values ('102', 'Rohan', 'Walia', 'roahn.walia@abc.com', '7848078480', '2008-11-15', 34000.0);
insert into employees (employee_id, first_name, last_name, email, phone_no, hire_date, salary) values ('103', 'Andy', 'Chow', 'andy.chow@abc.com', '6848068480', '2010-06-01', 125000.0);
insert into employees (employee_id, first_name, last_name, email, phone_no, hire_date, salary) values ('104', 'Chung', 'Wah', 'chung.wah@abc.com', '5848058480', '2009-08-21', 46000.0);
insert into employees (employee_id, first_name, last_name, email, phone_no, hire_date, salary) values ('105', 'Peter', 'Smith', 'peter.smith@abc.com', '4848048480', '2013-10-01', 74000.0);
