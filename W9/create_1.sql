drop database employee;
create database employee;

\c employee

CREATE TABLE dept
(
    dept_name VARCHAR(50) NOT NULL,
    dept_no INT NOT NULL,
    no_of_emp INT NOT NULL,
    PRIMARY KEY(dept_no)
);

CREATE TABLE employee_details
(
    email VARCHAR(50) NOT NULL,
    name VARCHAR(50) NOT NULL,
    id INT NOT NULL,
    phone_no CHAR(10) NOT NULL,
    birthdate DATE NOT NULL,
    dept_no INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(dept_no) REFERENCES dept(dept_no)
);

-- trigger to increase number of employees in the department that the insertion was made in
CREATE OR REPLACE FUNCTION increment() RETURNS TRIGGER AS
$$
BEGIN
  UPDATE dept set no_of_emp=no_of_emp+1 where new.dept_no=dept.dept_no; 
    RETURN new;
END;
$$
language plpgsql;

CREATE TRIGGER increment_number
     AFTER INSERT ON employee_details
     FOR EACH ROW
     EXECUTE PROCEDURE increment();

-- trigger to decrease number of employees in the department that the deletion was made in
CREATE OR REPLACE FUNCTION decrement() RETURNS TRIGGER AS
$$
BEGIN
  UPDATE dept set no_of_emp=no_of_emp-1 where old.dept_no=dept.dept_no;
    RETURN new;
END;
$$
language plpgsql;

CREATE TRIGGER decrement_number
    AFTER DELETE ON employee_details
    FOR EACH ROW
    EXECUTE PROCEDURE decrement();