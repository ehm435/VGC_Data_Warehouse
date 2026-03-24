-- ==============================================================================
-- Bronce initialization
-- Read the CSVs y create the tables in DuckDB
-- ==============================================================================

CREATE SCHEMA IF NOT EXISTS bronze;

CREATE OR REPLACE TABLE bronze.vgc_meta AS SELECT * FROM read_csv_auto('data/bronze/vgc_meta.csv');
CREATE OR REPLACE TABLE bronze.vgc_spreads AS SELECT * FROM read_csv_auto('data/bronze/vgc_spreads.csv');
CREATE OR REPLACE TABLE bronze.vgc_moves AS SELECT * FROM read_csv_auto('data/bronze/vgc_moves.csv');
CREATE OR REPLACE TABLE bronze.vgc_items AS SELECT * FROM read_csv_auto('data/bronze/vgc_items.csv');
CREATE OR REPLACE TABLE bronze.vgc_abilities AS SELECT * FROM read_csv_auto('data/bronze/vgc_abilities.csv');
CREATE OR REPLACE TABLE bronze.vgc_teammates AS SELECT * FROM read_csv_auto('data/bronze/vgc_teammates.csv');
CREATE OR REPLACE TABLE bronze.vgc_teratypes AS SELECT * FROM read_csv_auto('data/bronze/vgc_teratypes.csv');