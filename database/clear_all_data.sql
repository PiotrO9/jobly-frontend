-- Clear All Data Script for Supabase
-- Execute this in SQL Editor to remove all data from all tables
-- This preserves the table structure and only removes data

-- Disable foreign key checks temporarily (if supported)
-- Note: Supabase/PostgreSQL doesn't support DISABLE FOREIGN_KEY_CHECKS like MySQL
-- So we need to delete in correct order

-- Step 1: Delete from tables with foreign keys first
DELETE FROM job_category_relations;
DELETE FROM applications;
DELETE FROM saved_jobs;

-- Step 2: Delete from main tables
DELETE FROM jobs;
DELETE FROM companies;

-- Step 3: Reset sequences (auto-increment counters) to start from 1
-- This ensures new records start with ID 1
ALTER SEQUENCE IF EXISTS companies_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS jobs_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS categories_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS users_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS applications_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS saved_jobs_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS job_category_relations_id_seq RESTART WITH 1;

-- Verification: Check that all tables are empty
SELECT 'companies' as table_name, COUNT(*) as row_count FROM companies
UNION ALL
SELECT 'jobs', COUNT(*) FROM jobs
UNION ALL
SELECT 'applications', COUNT(*) FROM applications
UNION ALL
SELECT 'saved_jobs', COUNT(*) FROM saved_jobs
UNION ALL
SELECT 'job_category_relations', COUNT(*) FROM job_category_relations;

-- Success message
SELECT 'All data cleared successfully! All tables are now empty.' as status; 