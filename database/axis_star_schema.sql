-- ==============================================================================
-- AXIS Studio - Relational Data Warehouse Schema (Star Schema)
-- Description: DDL script to generate dimensions and fact tables
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. DIMENSION TABLES (Must be created first due to reference constraints)
-- ------------------------------------------------------------------------------

-- Dimension: Projects
CREATE TABLE dim_projects (
    project_id          VARCHAR(50) PRIMARY KEY,
    project_name        VARCHAR(100) NOT NULL,
    typology_function   VARCHAR(50),
    typology_form       VARCHAR(50),
    floors              INTEGER,
    height              NUMERIC(6,2),
    units               INTEGER,
    gross_floor_area    INTEGER,
    structural_material VARCHAR(50),
    structural_system   VARCHAR(50),
    foundation_system   VARCHAR(50)
);

-- Dimension: Employees
CREATE TABLE dim_employees (
    employee_id         VARCHAR(50) PRIMARY KEY,
    employee_name       VARCHAR(100) NOT NULL,
    office_location     VARCHAR(50),
    job_title           VARCHAR(50),
    experience_years    INTEGER,
    age                 INTEGER,
    gender              VARCHAR(20),
    email               VARCHAR(100)
);

-- Dimension: Clients
CREATE TABLE dim_clients (
    client_id           VARCHAR(50) PRIMARY KEY,
    client_name         VARCHAR(100) NOT NULL,
    client_type         VARCHAR(50),
    client_country      VARCHAR(50),
    client_state        VARCHAR(50),
    client_city         VARCHAR(50),
    email               VARCHAR(100),
    phone_number        VARCHAR(30)
);


-- ------------------------------------------------------------------------------
-- 2. FACT TABLES (Contain metrics and reference the dimensions)
-- ------------------------------------------------------------------------------

-- Fact: Project Performance
CREATE TABLE fact_project_performance (
    project_id            VARCHAR(50),
    client_id             VARCHAR(50),
    project_status        VARCHAR(30) NOT NULL,
    contract_date         DATE NOT NULL,
    completion_date       DATE,
    planned_duration_days INTEGER,
    actual_duration_days  NUMERIC(6,1),
    delay_days            NUMERIC(6,1),
    planned_cost          NUMERIC(12,2),
    final_cost            NUMERIC(12,2),
    sat_timeliness        NUMERIC(3,2),
    sat_quality           NUMERIC(3,2),
    sat_communication     NUMERIC(3,2),
    sat_overall           NUMERIC(3,2),
    
    -- Composite Primary Key to ensure row uniqueness
    PRIMARY KEY (project_id, client_id, contract_date),
    
    -- Foreign Key Constraints (Enforcing Filter Propagation)
    CONSTRAINT fk_performance_project FOREIGN KEY (project_id) REFERENCES dim_projects(project_id),
    CONSTRAINT fk_performance_client  FOREIGN KEY (client_id)  REFERENCES dim_clients(client_id)
);

-- Fact: Project Hours (Bridge table for operational labor tracking)
CREATE TABLE fact_project_hours (
    project_id       VARCHAR(50),
    employee_id      VARCHAR(50),
    role_in_project  VARCHAR(50),
    hours_logged     INTEGER NOT NULL,
    
    PRIMARY KEY (project_id, employee_id, role_in_project),
    
    -- Foreign Key Constraints
    CONSTRAINT fk_hours_project  FOREIGN KEY (project_id)  REFERENCES dim_projects(project_id),
    CONSTRAINT fk_hours_employee FOREIGN KEY (employee_id) REFERENCES dim_employees(employee_id)
);