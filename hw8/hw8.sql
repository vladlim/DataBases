--1.

CREATE OR REPLACE PROCEDURE NEW_JOB(
    p_job_id IN VARCHAR,
    p_job_title IN VARCHAR,
    p_min_salary IN INTEGER
)
LANGUAGE plpgsql
AS
$$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM jobs WHERE job_id = p_job_id) THEN
        INSERT INTO jobs (job_id, job_title, min_salary, max_salary)
        VALUES (p_job_id, p_job_title, p_min_salary, p_min_salary * 2);
    ELSE
        RAISE NOTICE 'Job ID % already exists.', p_job_id;
    END IF;
END;
$$;


--2.

CREATE OR REPLACE PROCEDURE ADD_JOB_HIST(
    p_employee_id INTEGER,
    p_new_job_id VARCHAR(10)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_min_salary INTEGER;
BEGIN
    SELECT min_salary INTO v_min_salary
    FROM jobs
    WHERE job_id = p_new_job_id;

    INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
    VALUES (p_employee_id, (SELECT hire_date FROM employees WHERE employee_id = p_employee_id), CURRENT_DATE, p_new_job_id,
            (SELECT department_id FROM employees WHERE employee_id = p_employee_id));

    UPDATE employees
    SET job_id = p_new_job_id,
        salary = v_min_salary + 500,
        hire_date = CURRENT_DATE
    WHERE employee_id = p_employee_id;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'Employee not found';
END;
$$;

CALL ADD_JOB_HIST(106, 'SY_ANAL');


--3.

CREATE OR REPLACE PROCEDURE UPD_JOBSAL(
    p_job_id VARCHAR(10),
    p_new_min_salary INTEGER,
    p_new_max_salary INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_new_max_salary < p_new_min_salary THEN
        RAISE EXCEPTION 'Maximum salary cannot be less than minimum salary';
    END IF;

    UPDATE jobs
    SET min_salary = p_new_min_salary,
        max_salary = p_new_max_salary
    WHERE job_id = p_job_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error while updating the salary for job_id: %', p_job_id;
END;
$$;

CALL UPD_JOBSAL('SY_ANAL', 7000, 14000);


--4.

CREATE OR REPLACE FUNCTION GET_YEARS_SERVICE(p_employee_id INT)
RETURNS INT AS
$$
DECLARE
    v_years_service INT;
BEGIN
    SELECT EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM hire_date)
    INTO v_years_service
    FROM employees
    WHERE employee_id = p_employee_id;

    IF v_years_service IS NULL THEN
        RAISE EXCEPTION 'Employee with ID % does not exist', p_employee_id;
    END IF;

    RETURN v_years_service;
END;
$$ LANGUAGE plpgsql;


--5.

CREATE OR REPLACE FUNCTION GET_JOB_COUNT(p_employee_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    v_job_count INTEGER;
BEGIN
    SELECT COUNT(DISTINCT job_id) INTO v_job_count
    FROM job_history
    WHERE employee_id = p_employee_id
    UNION
    SELECT COUNT(DISTINCT job_id)
    FROM employees
    WHERE employee_id = p_employee_id;

    RETURN v_job_count;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'Employee not found';
END;

$$ LANGUAGE plpgsql;

SELECT GET_JOB_COUNT(176);


--6.

CREATE OR REPLACE FUNCTION check_salary_range()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.min_salary > NEW.max_salary THEN
        RAISE EXCEPTION 'Minimum salary cannot be greater than maximum salary';
    END IF;

    IF EXISTS (SELECT 1 FROM employees WHERE job_id = OLD.job_id AND (salary < NEW.min_salary OR salary > NEW.max_salary)) THEN
        RAISE EXCEPTION 'Employee salary falls outside new salary range';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER CHECK_SAL_RANGE
BEFORE UPDATE ON jobs
FOR EACH ROW
EXECUTE FUNCTION check_salary_range();

UPDATE jobs
SET min_salary = 5000, max_salary = 7000
WHERE job_id = 'SY_ANAL';


