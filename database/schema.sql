-- Jobly Database Schema
-- Execute this SQL in Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Companies table
CREATE TABLE companies (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    handle VARCHAR(25) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    num_employees INTEGER,
    logo_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Jobs table (compatible with JobsView.vue structure)
CREATE TABLE jobs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    location VARCHAR(100),
    posted_days_ago INTEGER DEFAULT 0, -- Track how many days ago job was posted
    employment_type VARCHAR(20) DEFAULT 'Full-time' CHECK (employment_type IN ('Full-time', 'Part-time', 'Contract', 'Internship')),
    experience_level VARCHAR(20) DEFAULT 'Mid' CHECK (experience_level IN ('Junior', 'Mid', 'Senior', 'Lead')),
    salary_min INTEGER, -- Minimum salary in thousands (PLN)
    salary_max INTEGER, -- Maximum salary in thousands (PLN)
    currency VARCHAR(3) DEFAULT 'PLN',
    description TEXT,
    skills TEXT[], -- Array of required skills
    requirements TEXT[],
    benefits TEXT[],
    equity DECIMAL(4,3) CHECK (equity >= 0 AND equity <= 1),
    remote_allowed BOOLEAN DEFAULT false,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'closed', 'draft')),
    views_count INTEGER DEFAULT 0,
    applications_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User profiles table (extends Supabase auth.users)
CREATE TABLE user_profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    username VARCHAR(30) UNIQUE,
    bio TEXT,
    avatar_url TEXT,
    location VARCHAR(100),
    website_url TEXT,
    linkedin_url TEXT,
    github_url TEXT,
    skills TEXT[],
    experience_years INTEGER,
    resume_url TEXT,
    is_recruiter BOOLEAN DEFAULT false,
    company_id UUID REFERENCES companies(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Job applications table
CREATE TABLE applications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'interview', 'accepted', 'rejected')),
    cover_letter TEXT,
    resume_url TEXT,
    applied_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, job_id)
);

-- Saved jobs table (user bookmarks)
CREATE TABLE saved_jobs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, job_id)
);

-- Job categories/tags
CREATE TABLE job_categories (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    color VARCHAR(7) DEFAULT '#3B82F6', -- hex color
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Many-to-many relationship between jobs and categories
CREATE TABLE job_category_relations (
    job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES job_categories(id) ON DELETE CASCADE,
    PRIMARY KEY (job_id, category_id)
);

-- Indexes for better performance
CREATE INDEX idx_jobs_company_id ON jobs(company_id);
CREATE INDEX idx_jobs_status ON jobs(status);
CREATE INDEX idx_jobs_created_at ON jobs(created_at DESC);
CREATE INDEX idx_applications_user_id ON applications(user_id);
CREATE INDEX idx_applications_job_id ON applications(job_id);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_saved_jobs_user_id ON saved_jobs(user_id);
CREATE INDEX idx_user_profiles_company_id ON user_profiles(company_id);

-- Updated at triggers
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Function to calculate posted_days_ago
CREATE OR REPLACE FUNCTION calculate_posted_days_ago()
RETURNS TRIGGER AS $$
BEGIN
    NEW.posted_days_ago = EXTRACT(DAY FROM NOW() - NEW.created_at)::INTEGER;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_companies_updated_at BEFORE UPDATE ON companies FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_jobs_updated_at BEFORE UPDATE ON jobs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON user_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_applications_updated_at BEFORE UPDATE ON applications FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger to calculate posted_days_ago on SELECT
CREATE TRIGGER calculate_posted_days_trigger BEFORE INSERT OR UPDATE ON jobs FOR EACH ROW EXECUTE FUNCTION calculate_posted_days_ago();

-- Row Level Security (RLS) Policies
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_category_relations ENABLE ROW LEVEL SECURITY;

-- Companies policies
CREATE POLICY "Companies are viewable by everyone" ON companies FOR SELECT USING (true);
CREATE POLICY "Companies are editable by authenticated recruiters" ON companies FOR ALL USING (
    auth.role() = 'authenticated' AND 
    EXISTS (SELECT 1 FROM user_profiles WHERE id = auth.uid() AND is_recruiter = true AND company_id = companies.id)
);

-- Jobs policies
CREATE POLICY "Jobs are viewable by everyone" ON jobs FOR SELECT USING (status = 'active');
CREATE POLICY "Jobs are manageable by company recruiters" ON jobs FOR ALL USING (
    auth.role() = 'authenticated' AND 
    EXISTS (SELECT 1 FROM user_profiles WHERE id = auth.uid() AND is_recruiter = true AND company_id = jobs.company_id)
);

-- User profiles policies
CREATE POLICY "User profiles are viewable by everyone" ON user_profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON user_profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON user_profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Applications policies
CREATE POLICY "Users can view own applications" ON applications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can create own applications" ON applications FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own applications" ON applications FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Recruiters can view applications for their jobs" ON applications FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM jobs j 
        JOIN user_profiles up ON up.company_id = j.company_id 
        WHERE j.id = applications.job_id AND up.id = auth.uid() AND up.is_recruiter = true
    )
);

-- Saved jobs policies
CREATE POLICY "Users can manage own saved jobs" ON saved_jobs FOR ALL USING (auth.uid() = user_id);

-- Job categories policies (read-only for regular users, manageable by admins)
CREATE POLICY "Job categories are viewable by everyone" ON job_categories FOR SELECT USING (true);
CREATE POLICY "Job category relations are viewable by everyone" ON job_category_relations FOR SELECT USING (true);

-- Insert some default job categories
INSERT INTO job_categories (name, description, color) VALUES
('Frontend', 'Frontend development roles', '#3B82F6'),
('Backend', 'Backend development roles', '#10B981'),
('Full Stack', 'Full stack development roles', '#8B5CF6'),
('DevOps', 'DevOps and infrastructure roles', '#F59E0B'),
('Data Science', 'Data science and analytics roles', '#EF4444'),
('Mobile', 'Mobile app development roles', '#06B6D4'),
('Design', 'UI/UX and design roles', '#EC4899'),
('Product', 'Product management roles', '#84CC16'),
('QA', 'Quality assurance roles', '#6B7280'),
('Marketing', 'Marketing and growth roles', '#F97316'); 