# 🏆 Pokémon VGC Data Warehouse: Advanced Competitive Analytics

This project is an end-to-end analytical pipeline designed to extract, model, and analyze massive usage data from competitive Pokémon VGC (Smogon Chaos format logs). 

As a former VGC player, I know the "business logic" and the metrics that actually matter when building competitive teams. The goal of this project isn't just to write basic queries, but to apply **Data Engineering** to create an engine capable of discovering complex synergies and meta trends in an automated way.

---

## 🏗️ Architecture & Data Modeling (The *How*)

The project combines the **Medallion Architecture** with classic dimensional modeling (**Kimball**), ensuring the data is ready to be consumed by any BI tool:

1. **Bronze Layer (Raw):** Raw tabular data extracted and flattened via Python from deeply nested JSONs.
2. **Silver Layer (Core/Staging):** Cleaning, standardization applying the DRY principle via **Jinja Macros**, and maintaining a normalized relational model.
   * *Key decision:* Resolving *Many-to-Many* relationships (like the Tera Type mechanic) using **Bridge Tables**, paving the way without duplicating records.
3. **Gold / Platinum Layer (Data Marts):** Construction of the dimensional model (**Star Schema**) and complex analytical models oriented towards business value.
   * The main Fact Table (`fct_usage`) is built here, cleanly decoupled thanks to the bridge tables from the previous layer.
   * `mart_synergy_cores`: Uses directional *Self-Joins* (basic graph theory) to identify *3-Cliques* (cores of 3 Pokémon with high mathematical synergy).
   * `mart_niche_techs`: Transforms horizontal data into *Tall Data* format via `UNION ALL` to feed distribution charts of "Anti-Meta" strategies.

---

## 🛠️ Tech Stack (The *Why*)

I opted for a "Modern Data Stack" adapted to maximize local performance:

* **Python (Pandas):** For the initial ingestion and transformation of the JSONs. *(Note: The original orchestration code is kept private for competitive advantage, but sample CSVs are provided in the Bronze layer to reproduce the pipeline).*
* **DuckDB:** Columnar OLAP engine. Its performance processing hundreds of thousands of rows in local memory is exceptional, eliminating the need for heavy infrastructure.
* **dbt (Data Build Tool):** For data transformation using SQL. It allows applying software engineering best practices to data: modularity, referential integrity testing (`relationships`, `not_null`), and version control.
* **GitHub Actions (CI/CD):** Pipeline configured to run linting and SQL compilation (`dbt compile`) on every push to the main branch.

---

## ☁️ Why isn't it deployed in the Cloud?

The project is consciously designed to run 100% locally. Since the historical VGC data volume fits perfectly into the memory and CPU of a modern computer, using Cloud tools (like Snowflake or BigQuery) would add unnecessary network latency, infrastructure complexity, and costs, falling into the **Over-engineering** trap. 

DuckDB offers the same analytical power at zero cost, making it the ideal choice for this specific competitive niche.

---

## 🚀 How to run this project locally

To test the data modeling, the repository includes a sample dataset in the `data/bronze/` folder corresponding to a specific tournament regulation.

**1. Clone the repository and set up the environment:**
```bash
git clone (https://github.com/ehm435/VGC_Data_Warehouse)
cd vgc_database
pip install -r requirements.txt

duckdb vgc_project.duckdb -init init_bronze.sql -batch

cd vgc_dbt
dbt deps
dbt build
