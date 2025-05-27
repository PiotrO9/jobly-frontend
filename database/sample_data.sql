-- Sample data for Jobly application
-- Execute this AFTER creating the main schema

-- Sample companies (matching JobsView.vue examples)
INSERT INTO companies (handle, name, description, num_employees, logo_url) VALUES
('acme-corp', 'Acme Corp', 'Leading technology consulting company specializing in digital transformation', 150, 'https://via.placeholder.com/200x200/3B82F6/white?text=AC'),
('tech-solutions', 'Tech Solutions', 'Startup focused on AI and machine learning solutions', 25, 'https://via.placeholder.com/200x200/10B981/white?text=TS'),
('startupxyz', 'StartupXYZ', 'International software development company', 500, 'https://via.placeholder.com/200x200/8B5CF6/white?text=SX'),
('cloudtech-inc', 'CloudTech Inc', 'Fast-growing fintech startup', 40, 'https://via.placeholder.com/200x200/F59E0B/white?text=CT'),
('design-studio', 'Design Studio', 'Creative web and mobile development agency', 80, 'https://via.placeholder.com/200x200/EF4444/white?text=DS'),
('analytics-pro', 'Analytics Pro', 'Data analytics and business intelligence company', 120, 'https://via.placeholder.com/200x200/06B6D4/white?text=AP'),
('appworks', 'AppWorks', 'Mobile app development company', 60, 'https://via.placeholder.com/200x200/EC4899/white?text=AW'),
('innovation-labs', 'Innovation Labs', 'Product development and innovation company', 200, 'https://via.placeholder.com/200x200/84CC16/white?text=IL'),
('quality-first', 'Quality First', 'Software quality assurance company', 90, 'https://via.placeholder.com/200x200/6B7280/white?text=QF'),
('securenet', 'SecureNet', 'Cybersecurity solutions provider', 180, 'https://via.placeholder.com/200x200/F97316/white?text=SN'),
('creative-agency', 'Creative Agency', 'Digital creative and marketing agency', 45, 'https://via.placeholder.com/200x200/8B5CF6/white?text=CA'),
('ai-innovations', 'AI Innovations', 'Artificial intelligence and machine learning company', 300, 'https://via.placeholder.com/200x200/10B981/white?text=AI'),
('datacorp', 'DataCorp', 'Data management and analytics solutions', 250, 'https://via.placeholder.com/200x200/EF4444/white?text=DC'),
('enterprise-solutions', 'Enterprise Solutions', 'Enterprise software development', 400, 'https://via.placeholder.com/200x200/3B82F6/white?text=ES'),
('tech-startup', 'Tech Startup', 'Early-stage technology startup', 15, 'https://via.placeholder.com/200x200/F59E0B/white?text=TS'),
('infrastructure-co', 'Infrastructure Co', 'IT infrastructure and systems company', 220, 'https://via.placeholder.com/200x200/06B6D4/white?text=IC'),
('documentation-inc', 'Documentation Inc', 'Technical writing and documentation services', 35, 'https://via.placeholder.com/200x200/EC4899/white?text=DI'),
('gaming-studio', 'Gaming Studio', 'Video game development studio', 75, 'https://via.placeholder.com/200x200/84CC16/white?text=GS'),
('cryptotech', 'CryptoTech', 'Blockchain and cryptocurrency technology', 110, 'https://via.placeholder.com/200x200/6B7280/white?text=CT'),
('scale-systems', 'Scale Systems', 'Scalable systems and infrastructure', 280, 'https://via.placeholder.com/200x200/F97316/white?text=SS');

-- Sample jobs (exactly matching JobsView.vue data structure)
INSERT INTO jobs (title, company_id, location, posted_days_ago, employment_type, experience_level, salary_min, salary_max, description, skills, requirements, benefits, equity, remote_allowed, status) VALUES
-- Job 1: Frontend Developer
(
    'Frontend Developer',
    (SELECT id FROM companies WHERE handle = 'acme-corp'),
    'New York',
    2,
    'Full-time',
    'Mid',
    100,
    140,
    'Join our front-end team and build modern web applications using the latest technologies.',
    ARRAY['Vue', 'JavaScript', 'TypeScript'],
    ARRAY['Vue.js 3+', 'TypeScript', 'Modern CSS', 'REST APIs', '3+ years experience'],
    ARRAY['Health insurance', 'Flexible hours', 'Remote work', 'Learning budget'],
    0.005,
    true,
    'active'
),
-- Job 2: Backend Engineer
(
    'Backend Engineer',
    (SELECT id FROM companies WHERE handle = 'tech-solutions'),
    'San Francisco',
    5,
    'Contract',
    'Senior',
    120,
    160,
    'Design and implement scalable APIs and backend systems.',
    ARRAY['Node.js', 'Express', 'MongoDB'],
    ARRAY['Node.js', 'Express.js', 'MongoDB', 'Microservices', '5+ years experience'],
    ARRAY['Equity package', 'Flexible hours', 'Latest equipment', 'Conference budget'],
    0.010,
    true,
    'active'
),
-- Job 3: Full Stack Developer
(
    'Full Stack Developer',
    (SELECT id FROM companies WHERE handle = 'startupxyz'),
    'Austin',
    1,
    'Full-time',
    'Junior',
    80,
    110,
    'Work on the complete technology stack in a dynamic startup environment.',
    ARRAY['React', 'Node.js', 'PostgreSQL'],
    ARRAY['React/Vue.js', 'Node.js', 'PostgreSQL', 'Full stack development'],
    ARRAY['Mentorship program', 'Learning budget', 'Stock options'],
    0.008,
    true,
    'active'
),
-- Job 4: DevOps Engineer
(
    'DevOps Engineer',
    (SELECT id FROM companies WHERE handle = 'cloudtech-inc'),
    'Seattle',
    3,
    'Full-time',
    'Senior',
    130,
    170,
    'Manage cloud infrastructure and automate deployment processes.',
    ARRAY['AWS', 'Docker', 'Kubernetes'],
    ARRAY['AWS/Azure', 'Docker', 'Kubernetes', 'Terraform', 'CI/CD'],
    ARRAY['Stock options', 'Health insurance', 'Flexible hours', 'Latest equipment'],
    0.008,
    true,
    'active'
),
-- Job 5: UX Designer
(
    'UX Designer',
    (SELECT id FROM companies WHERE handle = 'design-studio'),
    'Los Angeles',
    4,
    'Full-time',
    'Mid',
    90,
    120,
    'Create intuitive user experiences for web and mobile applications.',
    ARRAY['Figma', 'Adobe XD', 'Prototyping'],
    ARRAY['Figma/Sketch', 'User research', 'Prototyping', 'Design systems'],
    ARRAY['Creative environment', 'Latest design tools', 'Conference budget', 'Flexible hours'],
    0.002,
    false,
    'active'
),
-- Job 6: Data Scientist
(
    'Data Scientist',
    (SELECT id FROM companies WHERE handle = 'analytics-pro'),
    'Chicago',
    2,
    'Contract',
    'Senior',
    140,
    180,
    'Analyze complex datasets and build predictive models.',
    ARRAY['Python', 'Machine Learning', 'SQL'],
    ARRAY['Python', 'Pandas/NumPy', 'Machine Learning', 'Statistics', 'SQL'],
    ARRAY['Flexible hours', 'Latest equipment', 'Conference budget'],
    0.000,
    true,
    'active'
),
-- Job 7: Mobile Developer
(
    'Mobile Developer',
    (SELECT id FROM companies WHERE handle = 'appworks'),
    'Miami',
    6,
    'Full-time',
    'Mid',
    95,
    125,
    'Develop native mobile applications for iOS and Android.',
    ARRAY['React Native', 'Swift', 'Kotlin'],
    ARRAY['React Native', 'JavaScript/TypeScript', 'Mobile UI/UX', 'App Store deployment'],
    ARRAY['Health insurance', 'Flexible hours', 'Remote work', 'Learning budget'],
    0.003,
    true,
    'active'
),
-- Job 8: Product Manager
(
    'Product Manager',
    (SELECT id FROM companies WHERE handle = 'innovation-labs'),
    'Boston',
    1,
    'Full-time',
    'Senior',
    110,
    150,
    'Lead product strategy and coordinate cross-functional teams.',
    ARRAY['Product Strategy', 'Agile', 'Data Analysis'],
    ARRAY['Product management', 'Agile methodology', 'Data analysis', 'Leadership'],
    ARRAY['Health insurance', 'Stock options', 'Flexible hours', 'Learning budget'],
    0.005,
    true,
    'active'
),
-- Job 9: QA Engineer
(
    'QA Engineer',
    (SELECT id FROM companies WHERE handle = 'quality-first'),
    'Denver',
    7,
    'Full-time',
    'Junior',
    70,
    95,
    'Ensure software quality through comprehensive testing.',
    ARRAY['Selenium', 'Jest', 'Cypress'],
    ARRAY['Test automation', 'Selenium', 'Jest', 'Cypress', 'Manual testing'],
    ARRAY['Mentorship program', 'Learning budget', 'Flexible hours', 'Health insurance'],
    0.001,
    false,
    'active'
),
-- Job 10: Security Engineer
(
    'Security Engineer',
    (SELECT id FROM companies WHERE handle = 'securenet'),
    'Washington DC',
    3,
    'Full-time',
    'Senior',
    135,
    175,
    'Implement security measures and conduct vulnerability assessments.',
    ARRAY['Cybersecurity', 'Penetration Testing', 'CISSP'],
    ARRAY['Cybersecurity', 'Penetration testing', 'CISSP certification', 'Risk assessment'],
    ARRAY['Health insurance', 'Stock options', 'Flexible hours', 'Security training'],
    0.002,
    true,
    'active'
),
-- Job 11: UI Developer
(
    'UI Developer',
    (SELECT id FROM companies WHERE handle = 'creative-agency'),
    'Portland',
    2,
    'Contract',
    'Mid',
    85,
    115,
    'Build responsive user interfaces with modern frameworks.',
    ARRAY['HTML', 'CSS', 'JavaScript'],
    ARRAY['HTML5', 'CSS3', 'JavaScript', 'Responsive design', 'Modern frameworks'],
    ARRAY['Flexible hours', 'Creative environment', 'Latest tools'],
    0.000,
    true,
    'active'
),
-- Job 12: Machine Learning Engineer
(
    'Machine Learning Engineer',
    (SELECT id FROM companies WHERE handle = 'ai-innovations'),
    'San Francisco',
    4,
    'Full-time',
    'Senior',
    150,
    190,
    'Deploy machine learning models in production environments.',
    ARRAY['TensorFlow', 'PyTorch', 'MLOps'],
    ARRAY['TensorFlow', 'PyTorch', 'MLOps', 'Python', 'Model deployment'],
    ARRAY['Stock options', 'Health insurance', 'Latest equipment', 'Conference budget'],
    0.015,
    true,
    'active'
),
-- Job 13: Database Administrator
(
    'Database Administrator',
    (SELECT id FROM companies WHERE handle = 'datacorp'),
    'Phoenix',
    5,
    'Full-time',
    'Mid',
    90,
    120,
    'Manage and optimize database performance and security.',
    ARRAY['MySQL', 'PostgreSQL', 'Oracle'],
    ARRAY['MySQL', 'PostgreSQL', 'Oracle', 'Database optimization', 'Backup strategies'],
    ARRAY['Health insurance', 'Flexible hours', 'Training budget'],
    0.001,
    false,
    'active'
),
-- Job 14: Software Architect
(
    'Software Architect',
    (SELECT id FROM companies WHERE handle = 'enterprise-solutions'),
    'Dallas',
    1,
    'Full-time',
    'Senior',
    140,
    180,
    'Design scalable software architecture for enterprise applications.',
    ARRAY['System Design', 'Microservices', 'Cloud Architecture'],
    ARRAY['System design', 'Microservices', 'Cloud architecture', 'Enterprise patterns'],
    ARRAY['Stock options', 'Health insurance', 'Flexible hours', 'Architecture training'],
    0.005,
    true,
    'active'
),
-- Job 15: Frontend Intern
(
    'Frontend Intern',
    (SELECT id FROM companies WHERE handle = 'tech-startup'),
    'San Francisco',
    3,
    'Internship',
    'Junior',
    50,
    70,
    'Learn frontend development in a fast-paced startup environment.',
    ARRAY['HTML', 'CSS', 'React'],
    ARRAY['HTML/CSS', 'JavaScript basics', 'React fundamentals', 'Git'],
    ARRAY['Mentorship', 'Learning opportunities', 'Potential full-time offer'],
    0.000,
    true,
    'active'
),
-- Job 16: Systems Engineer
(
    'Systems Engineer',
    (SELECT id FROM companies WHERE handle = 'infrastructure-co'),
    'Atlanta',
    6,
    'Full-time',
    'Mid',
    100,
    130,
    'Maintain and optimize system infrastructure and networks.',
    ARRAY['Linux', 'Networking', 'Scripting'],
    ARRAY['Linux administration', 'Networking', 'Shell scripting', 'System monitoring'],
    ARRAY['Health insurance', 'Flexible hours', 'Training budget'],
    0.002,
    false,
    'active'
),
-- Job 17: Technical Writer
(
    'Technical Writer',
    (SELECT id FROM companies WHERE handle = 'documentation-inc'),
    'Remote',
    4,
    'Contract',
    'Mid',
    75,
    100,
    'Create technical documentation and user guides.',
    ARRAY['Technical Writing', 'Markdown', 'API Documentation'],
    ARRAY['Technical writing', 'Markdown', 'API documentation', 'Documentation tools'],
    ARRAY['Remote work', 'Flexible hours', 'Writing tools'],
    0.000,
    true,
    'active'
),
-- Job 18: Game Developer
(
    'Game Developer',
    (SELECT id FROM companies WHERE handle = 'gaming-studio'),
    'Los Angeles',
    2,
    'Full-time',
    'Mid',
    95,
    125,
    'Develop engaging games for multiple platforms.',
    ARRAY['Unity', 'C#', 'Game Design'],
    ARRAY['Unity', 'C#', 'Game design', '3D modeling', 'Animation'],
    ARRAY['Creative environment', 'Game development tools', 'Flexible hours'],
    0.003,
    false,
    'active'
),
-- Job 19: Blockchain Developer
(
    'Blockchain Developer',
    (SELECT id FROM companies WHERE handle = 'cryptotech'),
    'New York',
    1,
    'Full-time',
    'Senior',
    130,
    170,
    'Build decentralized applications and smart contracts.',
    ARRAY['Solidity', 'Web3', 'Ethereum'],
    ARRAY['Solidity', 'Web3', 'Ethereum', 'Smart contracts', 'DeFi'],
    ARRAY['Crypto tokens', 'Health insurance', 'Remote work', 'Conference budget'],
    0.010,
    true,
    'active'
),
-- Job 20: Site Reliability Engineer
(
    'Site Reliability Engineer',
    (SELECT id FROM companies WHERE handle = 'scale-systems'),
    'Seattle',
    5,
    'Full-time',
    'Senior',
    125,
    165,
    'Ensure system reliability and performance at scale.',
    ARRAY['Monitoring', 'Automation', 'Incident Response'],
    ARRAY['SRE practices', 'Monitoring tools', 'Automation', 'Incident response', 'Scalability'],
    ARRAY['Stock options', 'Health insurance', 'On-call compensation', 'Training budget'],
    0.004,
    true,
    'active'
);

-- Link jobs with categories (updated for new job titles)
INSERT INTO job_category_relations (job_id, category_id) VALUES
-- Frontend Developer
((SELECT id FROM jobs WHERE title = 'Frontend Developer'), (SELECT id FROM job_categories WHERE name = 'Frontend')),
-- Backend Engineer
((SELECT id FROM jobs WHERE title = 'Backend Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Full Stack Developer
((SELECT id FROM jobs WHERE title = 'Full Stack Developer'), (SELECT id FROM job_categories WHERE name = 'Full Stack')),
((SELECT id FROM jobs WHERE title = 'Full Stack Developer'), (SELECT id FROM job_categories WHERE name = 'Frontend')),
((SELECT id FROM jobs WHERE title = 'Full Stack Developer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- DevOps Engineer
((SELECT id FROM jobs WHERE title = 'DevOps Engineer'), (SELECT id FROM job_categories WHERE name = 'DevOps')),
-- UX Designer
((SELECT id FROM jobs WHERE title = 'UX Designer'), (SELECT id FROM job_categories WHERE name = 'Design')),
-- Data Scientist
((SELECT id FROM jobs WHERE title = 'Data Scientist'), (SELECT id FROM job_categories WHERE name = 'Data Science')),
-- Mobile Developer
((SELECT id FROM jobs WHERE title = 'Mobile Developer'), (SELECT id FROM job_categories WHERE name = 'Mobile')),
((SELECT id FROM jobs WHERE title = 'Mobile Developer'), (SELECT id FROM job_categories WHERE name = 'Frontend')),
-- Product Manager
((SELECT id FROM jobs WHERE title = 'Product Manager'), (SELECT id FROM job_categories WHERE name = 'Product')),
-- QA Engineer
((SELECT id FROM jobs WHERE title = 'QA Engineer'), (SELECT id FROM job_categories WHERE name = 'QA')),
-- Security Engineer
((SELECT id FROM jobs WHERE title = 'Security Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- UI Developer
((SELECT id FROM jobs WHERE title = 'UI Developer'), (SELECT id FROM job_categories WHERE name = 'Frontend')),
((SELECT id FROM jobs WHERE title = 'UI Developer'), (SELECT id FROM job_categories WHERE name = 'Design')),
-- Machine Learning Engineer
((SELECT id FROM jobs WHERE title = 'Machine Learning Engineer'), (SELECT id FROM job_categories WHERE name = 'Data Science')),
((SELECT id FROM jobs WHERE title = 'Machine Learning Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Database Administrator
((SELECT id FROM jobs WHERE title = 'Database Administrator'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Software Architect
((SELECT id FROM jobs WHERE title = 'Software Architect'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Frontend Intern
((SELECT id FROM jobs WHERE title = 'Frontend Intern'), (SELECT id FROM job_categories WHERE name = 'Frontend')),
-- Systems Engineer
((SELECT id FROM jobs WHERE title = 'Systems Engineer'), (SELECT id FROM job_categories WHERE name = 'DevOps')),
-- Technical Writer
((SELECT id FROM jobs WHERE title = 'Technical Writer'), (SELECT id FROM job_categories WHERE name = 'Marketing')),
-- Game Developer
((SELECT id FROM jobs WHERE title = 'Game Developer'), (SELECT id FROM job_categories WHERE name = 'Frontend')),
-- Blockchain Developer
((SELECT id FROM jobs WHERE title = 'Blockchain Developer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Site Reliability Engineer
((SELECT id FROM jobs WHERE title = 'Site Reliability Engineer'), (SELECT id FROM job_categories WHERE name = 'DevOps')); 