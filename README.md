<div align="center">
  <img src="https://github.com/user-attachments/assets/f9791342-e7a5-4058-912c-e2103ade08e2" width="40%" alt="AXIS Studio Banner">

  <h1>AXIS Studio: Building Portfolio Operational Analytics</h1>

  <p><i>"Where architectural design meets data-driven performance"</i></p>
  
  <br>

  [![Python](https://img.shields.io/badge/Python-3.9+-3776AB?style=flat&logo=python&logoColor=white)](https://www.python.org/)
  [![Power BI](https://img.shields.io/badge/Visualization-Power%20BI-F2C811?style=flat&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
  [![Data Modeling](https://img.shields.io/badge/Schema-Star%20Schema-orange?style=flat)](https://en.wikipedia.org/wiki/Star_schema)
  [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=flat)](https://opensource.org/licenses/MIT)
</div>

---

# axis_portfolio_analytics
End-to-end Business Intelligence solution for **AXIS Studio, an architectural design firm** specializing in building development.  
Processes operational data via Python into a Power BI Star Schema to analyze KPIs, project delays and financial performance

---

## Data Architecture (Star Schema)

The project's analytical core is structured under a **Star Schema** data warehouse model, optimized for Business Intelligence (BI) queries and operational analytics. This architectural design decouples quantitative business metrics from descriptive entity attributes, ensuring high query performance and clean relationships.

---

### Fact Tables

#### 1. `fact_project_performance.csv`
Stores the Key Performance Indicators (KPIs) regarding financial margins, project schedules, and client satisfaction metrics for both completed and ongoing projects.

| Column | Data Type | Key Role | Description |
| :--- | :--- | :---: | :--- |
| `project_id` | `VARCHAR` | **FK** | Unique project identifier (links to `dim_projects`) |
| `client_id` | `VARCHAR` | **FK** | Unique client identifier (links to `dim_clients`) |
| `project_status` | `VARCHAR` | Attribute | Current stage of the project (`completed`, `in_progress`, `on_hold`) |
| `contract_date` | `DATE` | Temporal | Date when the contract was signed and project tracking began |
| `completion_date` | `DATE` | Temporal | Actual project handover date (blank if active or paused) |
| `planned_duration_days` | `INTEGER` | Metric | Contractual duration committed to the client |
| `actual_duration_days` | `FLOAT` | Metric | Real total days taken from contract signature to completion |
| `delay_days` | `FLOAT` | Metric | Schedule variance in days (Negative values indicate early delivery) |
| `planned_cost` | `INTEGER` | Metric | Initial budgeted construction and design cost ($ USD) |
| `final_cost` | `FLOAT` | Metric | Real total cost settled at the end of construction ($ USD) |
| `sat_timeliness` | `FLOAT` | Metric | Post-handover client satisfaction score for schedule adherence (1-5) |
| `sat_quality` | `FLOAT` | Metric | Post-handover client satisfaction score for construction quality (1-5) |
| `sat_communication` | `FLOAT` | Metric | Client satisfaction score for management and communication transparency (1-5) |
| `sat_overall` | `FLOAT` | Metric | Weighted overall client satisfaction index (1-5) |

#### 2. `fact_project_hours.csv`
A bridge fact table that logs the operational effort and detailed labor timesheets submitted by the firm's technical staff.

| Column | Data Type | Key Role | Description |
| :--- | :--- | :---: | :--- |
| `project_id` | `VARCHAR` | **FK** | Associated project identifier (links to `dim_projects`) |
| `employee_id` | `VARCHAR` | **FK** | Associated professional identifier (links to `dim_employees`) |
| `role_in_project` | `VARCHAR` | Attribute | Specific role performed during this particular project assignment |
| `hours_logged` | `INTEGER` | Metric | Total productive hours registered by the employee on this project |

---

### Dimension Tables

#### 1. `dim_projects.csv`
Contains the architectural, structural, engineering, and geometric specifications for each asset type.

| Column | Data Type | Key Role | Description |
| :--- | :--- | :---: | :--- |
| `project_id` | `VARCHAR` | **PK** | Unique primary key for the project |
| `project_name` | `VARCHAR` | Attribute | Designatory project or development name |
| `typology_function` | `VARCHAR` | Attribute | Building occupancy type (`residential`, `commercial`, `mixed_use`, `retail`) |
| `typology_form` | `VARCHAR` | Attribute | Geometric/architectural profile (`high_rise`, `mid_rise`, `low_rise`, `linear`, `courtyard`) |
| `floors` | `INTEGER` | Attribute | Total number of levels above ground |
| `height` | `FLOAT` | Attribute | Total building height measured in meters |
| `units` | `INTEGER` | Attribute | Total number of rentable/saleable units or commercial premises inside |
| `gross_floor_area` | `INTEGER` | Attribute | Gross Floor Area (GFA) measured in square feet (SqFt) |
| `structural_material` | `VARCHAR` | Attribute | Dominant framing material (`concrete`, `steel`, `wood`, `mixed`) |
| `structural_system` | `VARCHAR` | Attribute | Load-bearing assembly (`post_tensioned`, `steel`, `tunnel`, `cmu`, `mixed`) |
| `foundation_system` | `VARCHAR` | Attribute | Foundation methodology adapted to soil conditions (`shallow`, `deep`, `piles`) |

#### 2. `dim_employees.csv`
Houses the HR roster data and socio-demographic profiles of the architecture and project management talent.

| Column | Data Type | Key Role | Description |
| :--- | :--- | :---: | :--- |
| `employee_id` | `VARCHAR` | **PK** | Unique primary key for the employee |
| `employee_name` | `VARCHAR` | Attribute | Full name of the professional |
| `office_location` | `VARCHAR` | Attribute | Assigned corporate hub/regional office (`Miami`, `Costa Rica`) |
| `job_title` | `VARCHAR` | Attribute | Structural job position in the company (`direction`, `project_manager`, `drafter`, etc.) |
| `experience_years` | `INTEGER` | Attribute | Total years of experience accumulated within the AEC sector |
| `age` | `INTEGER` | Attribute | Employee age |
| `gender` | `VARCHAR` | Attribute | Registered gender of the employee |
| `email` | `VARCHAR` | Attribute | Corporate email address |

#### 3. `dim_clients.csv`
Directory of corporate clients, real estate developers, and public entities funding the projects.

| Column | Data Type | Key Role | Description |
| :--- | :--- | :---: | :--- |
| `client_id` | `VARCHAR` | **PK** | Unique primary key for the client account |
| `client_name` | `VARCHAR` | Attribute | Registered business or corporate name |
| `client_type` | `VARCHAR` | Attribute | Market segment classification (`developer`, `corporate`, `private`) |
| `client_country` | `VARCHAR` | Attribute | Origin country of the investment capital (`USA`, `Costa Rica`, `Panama`) |
| `client_state` | `VARCHAR` | Attribute | State or Province of the client's corporate headquarters |
| `client_city` | `VARCHAR` | Attribute | Base city of the client account |
| `email` | `VARCHAR` | Attribute | Main corporate point of contact email |
| `phone_number` | `VARCHAR` | Attribute | Primary contact phone number |

---

## Data Model & Relationships

The tables are interconnected using a strict **Star Schema** architectural pattern. The relationships are designed to optimize filter propagation and prevent analytical ambiguity or circular dependencies:

* **`dim_projects` to `fact_project_performance`**: One-to-Many (`1:*`) relationship via `project_id`. Filters propagate from the project dimensions (typology, materials, GFA) down to performance metrics.
* **`dim_projects` to `fact_project_hours`**: One-to-Many (`1:*`) relationship via `project_id`. Allows analyzing labor allocation and time distribution by building type.
* **`dim_clients` to `fact_project_performance`**: One-to-Many (`1:*`) relationship via `client_id`. Enables client segmentation, risk profiling, and geographical investment analysis.
* **`dim_employees` to `fact_project_hours`**: One-to-Many (`1:*`) relationship via `employee_id`. Filters tracked hours by staff role, seniority, and regional office location.

---

## Business Logic & KPI Framework

To evaluate the operational health and financial standing of AXIS Studio's building portfolio, the data architecture calculates and monitors the following core business metrics:

### 1. Financial Performance & Variance
* **Budget Variance ($):** Calculated as `final_cost - planned_cost`. It monitors economic overruns during construction execution phases.
* **Cost Predictability Index:** Evaluates budgeting accuracy across structural and material typologies (e.g., assessing if post-tensioned concrete designs yield higher variances than structural steel assemblies).

### 2. Operational Efficiency & Schedule Adherence
* **Schedule Slippage (Days):** Driven by `delay_days`. Quantifies time bottlenecks between contractual handover deadlines (`planned_duration_days`) and actual delivery dates (`actual_duration_days`).
* **Labor Density Ratio:** cross-references `hours_logged` against `gross_floor_area` (GFA) to evaluate design-hour efficiency per square foot across different building scales (high-rise vs. low-rise).

### 3. Customer Success & Quality Delivery
* **Weighted Satisfaction Index (`sat_overall`):** A composite score measuring client retention and project delivery quality, breaking down performance across communication transparency, timeliness, and structural/finishing quality.

---

## Repository Roadmap & Analytics Workflow

The project is structured in a two-phase implementation pipeline, combining Python data science libraries for Initial Exploratory Data Analysis (EDA) and Power BI for enterprise modeling:

### Phase 1: Exploratory Data Analysis
The initial core data analysis has been developed within a **Jupyter Notebook**, utilizing Python's analytics ecosystem to process the raw datasets. 
* **Data Auditing:** Ensuring data integrity, handling relational constraints, and validating tracking metrics.
* **Exploratory Visualizations:** Custom programmatic plots analyzing project delivery timelines, schedule slippage, budget variations, and client satisfaction trends directly from the source tables.

### Phase 2: Power BI Enterprise Modeling
* **Star Schema Implementation:** Establishing formal `1:*` relationships from dimension tables (`dim_projects`, `dim_clients`, `dim_employees`) to the fact tables.
* **Interactive Dashboarding:** Transforming Python-discovered insights into a dynamic, executive-ready dashboard for AXIS Studio's stakeholders.

---

## Data Privacy & Confidentiality Note
To comply with non-disclosure agreements (NDA) and protect proprietary business intelligence, all financial figures, client names, employee profiles, and specific project metrics within this repository have been fully anonymized and scaled. The structural workflows and relational schema accurately represent AXIS Studio's operational model, but the raw values do not expose real-world liabilities.

