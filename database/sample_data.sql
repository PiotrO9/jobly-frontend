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
('scale-systems', 'Scale Systems', 'Scalable systems and infrastructure', 280, 'https://via.placeholder.com/200x200/F97316/white?text=SS'),

-- Additional companies for more diversity
('global-fintech', 'Global FinTech', 'International financial technology solutions', 450, 'https://via.placeholder.com/200x200/3B82F6/white?text=GF'),
('healthtech-solutions', 'HealthTech Solutions', 'Healthcare technology and digital health platforms', 180, 'https://via.placeholder.com/200x200/10B981/white?text=HS'),
('ecommerce-platform', 'E-Commerce Platform', 'Leading online marketplace and retail technology', 350, 'https://via.placeholder.com/200x200/8B5CF6/white?text=EP'),
('media-streaming', 'Media Streaming', 'Digital media and content delivery platform', 220, 'https://via.placeholder.com/200x200/F59E0B/white?text=MS'),
('edtech-startup', 'EdTech Startup', 'Educational technology and e-learning solutions', 85, 'https://via.placeholder.com/200x200/EF4444/white?text=ET'),
('robotics-inc', 'Robotics Inc', 'Robotics and automation technology company', 160, 'https://via.placeholder.com/200x200/06B6D4/white?text=RI'),
('quantum-computing', 'Quantum Computing', 'Quantum computing research and development', 95, 'https://via.placeholder.com/200x200/EC4899/white?text=QC'),
('iot-solutions', 'IoT Solutions', 'Internet of Things and smart device technology', 140, 'https://via.placeholder.com/200x200/84CC16/white?text=IS'),
('virtual-reality', 'Virtual Reality', 'VR/AR technology and immersive experiences', 120, 'https://via.placeholder.com/200x200/6B7280/white?text=VR'),
('sustainability-tech', 'Sustainability Tech', 'Clean technology and environmental solutions', 90, 'https://via.placeholder.com/200x200/F97316/white?text=ST'),
('space-tech', 'Space Tech', 'Aerospace and space technology company', 200, 'https://via.placeholder.com/200x200/3B82F6/white?text=SP'),
('biotech-corp', 'BioTech Corp', 'Biotechnology and life sciences', 130, 'https://via.placeholder.com/200x200/10B981/white?text=BC'),
('logistics-platform', 'Logistics Platform', 'Supply chain and logistics technology', 190, 'https://via.placeholder.com/200x200/8B5CF6/white?text=LP'),
('social-network', 'Social Network', 'Social media and communication platform', 300, 'https://via.placeholder.com/200x200/F59E0B/white?text=SN'),
('travel-tech', 'Travel Tech', 'Travel and hospitality technology solutions', 110, 'https://via.placeholder.com/200x200/EF4444/white?text=TT'),
('consulting-firm', 'Consulting Firm', 'Technology consulting and digital transformation', 250, 'https://via.placeholder.com/200x200/06B6D4/white?text=CF'),
('startup-incubator', 'Startup Incubator', 'Early-stage startup accelerator and investment', 50, 'https://via.placeholder.com/200x200/EC4899/white?text=SI'),
('renewable-energy', 'Renewable Energy', 'Clean energy and renewable technology', 170, 'https://via.placeholder.com/200x200/84CC16/white?text=RE'),
('food-delivery', 'Food Delivery', 'Food delivery and restaurant technology platform', 240, 'https://via.placeholder.com/200x200/6B7280/white?text=FD'),
('automotive-tech', 'Automotive Tech', 'Automotive technology and smart vehicle solutions', 320, 'https://via.placeholder.com/200x200/F97316/white?text=AT');

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
),

-- Additional Jobs for Enhanced Database
-- Job 21: FinTech Backend Developer
(
    'FinTech Backend Developer',
    (SELECT id FROM companies WHERE handle = 'global-fintech'),
    'London',
    3,
    'Full-time',
    'Senior',
    110,
    150,
    'Build secure and scalable financial services backend systems.',
    ARRAY['Java', 'Spring Boot', 'Microservices', 'Kafka'],
    ARRAY['Java/Spring Boot', 'Microservices architecture', 'Financial regulations', 'High-frequency trading'],
    ARRAY['Stock options', 'Health insurance', 'Financial services bonus', 'Flexible hours'],
    0.006,
    true,
    'active'
),
-- Job 22: Healthcare Data Analyst
(
    'Healthcare Data Analyst',
    (SELECT id FROM companies WHERE handle = 'healthtech-solutions'),
    'Boston',
    4,
    'Full-time',
    'Mid',
    85,
    115,
    'Analyze healthcare data to improve patient outcomes and operational efficiency.',
    ARRAY['SQL', 'Python', 'Healthcare Analytics', 'HIPAA'],
    ARRAY['SQL', 'Python', 'Healthcare domain knowledge', 'HIPAA compliance', 'Statistical analysis'],
    ARRAY['Health insurance', 'Flexible hours', 'Healthcare benefits', 'Learning budget'],
    0.003,
    false,
    'active'
),
-- Job 23: E-commerce Platform Engineer
(
    'E-commerce Platform Engineer',
    (SELECT id FROM companies WHERE handle = 'ecommerce-platform'),
    'San Francisco',
    2,
    'Full-time',
    'Senior',
    130,
    170,
    'Scale e-commerce platform to handle millions of transactions.',
    ARRAY['Python', 'Django', 'Redis', 'Elasticsearch'],
    ARRAY['Python/Django', 'High-scale systems', 'Redis', 'Elasticsearch', 'Payment systems'],
    ARRAY['Stock options', 'Health insurance', 'Employee discount', 'Flexible hours'],
    0.008,
    true,
    'active'
),
-- Job 24: Video Streaming Engineer
(
    'Video Streaming Engineer',
    (SELECT id FROM companies WHERE handle = 'media-streaming'),
    'Los Angeles',
    1,
    'Full-time',
    'Senior',
    140,
    180,
    'Optimize video delivery and streaming infrastructure for millions of users.',
    ARRAY['CDN', 'Video Encoding', 'Streaming Protocols', 'AWS'],
    ARRAY['CDN optimization', 'Video encoding', 'Streaming protocols', 'AWS/GCP', 'Performance optimization'],
    ARRAY['Stock options', 'Health insurance', 'Media benefits', 'Conference budget'],
    0.010,
    true,
    'active'
),
-- Job 25: EdTech Frontend Developer
(
    'EdTech Frontend Developer',
    (SELECT id FROM companies WHERE handle = 'edtech-startup'),
    'Austin',
    3,
    'Full-time',
    'Mid',
    90,
    120,
    'Create engaging educational interfaces for students and teachers.',
    ARRAY['React', 'TypeScript', 'Educational UX'],
    ARRAY['React', 'TypeScript', 'Educational technology', 'Accessibility', 'Mobile-first design'],
    ARRAY['Health insurance', 'Learning budget', 'Education benefits', 'Flexible hours'],
    0.005,
    true,
    'active'
),
-- Job 26: Robotics Software Engineer
(
    'Robotics Software Engineer',
    (SELECT id FROM companies WHERE handle = 'robotics-inc'),
    'Detroit',
    6,
    'Full-time',
    'Senior',
    120,
    160,
    'Develop software for autonomous robotics systems.',
    ARRAY['ROS', 'C++', 'Computer Vision', 'Machine Learning'],
    ARRAY['ROS framework', 'C++', 'Computer vision', 'Machine learning', 'Robotics systems'],
    ARRAY['Stock options', 'Health insurance', 'Research budget', 'Latest equipment'],
    0.007,
    false,
    'active'
),
-- Job 27: Quantum Algorithm Developer
(
    'Quantum Algorithm Developer',
    (SELECT id FROM companies WHERE handle = 'quantum-computing'),
    'Cambridge',
    5,
    'Full-time',
    'Senior',
    150,
    200,
    'Develop quantum algorithms for next-generation computing.',
    ARRAY['Quantum Computing', 'Python', 'Qiskit', 'Mathematics'],
    ARRAY['Quantum computing', 'Advanced mathematics', 'Python', 'Qiskit', 'Research experience'],
    ARRAY['Research budget', 'Health insurance', 'Conference budget', 'Publication opportunities'],
    0.012,
    true,
    'active'
),
-- Job 28: IoT Solutions Architect
(
    'IoT Solutions Architect',
    (SELECT id FROM companies WHERE handle = 'iot-solutions'),
    'San Jose',
    4,
    'Full-time',
    'Senior',
    135,
    175,
    'Design end-to-end IoT solutions for smart cities and industry.',
    ARRAY['IoT Architecture', 'Edge Computing', 'MQTT', 'Cloud Platforms'],
    ARRAY['IoT architecture', 'Edge computing', 'MQTT', 'Cloud platforms', 'Sensor networks'],
    ARRAY['Stock options', 'Health insurance', 'Innovation time', 'Technical conferences'],
    0.008,
    true,
    'active'
),
-- Job 29: VR/AR Developer
(
    'VR/AR Developer',
    (SELECT id FROM companies WHERE handle = 'virtual-reality'),
    'San Francisco',
    2,
    'Full-time',
    'Mid',
    100,
    130,
    'Create immersive virtual and augmented reality experiences.',
    ARRAY['Unity', 'Unreal Engine', 'C#', '3D Graphics'],
    ARRAY['Unity/Unreal Engine', 'C#', '3D graphics', 'VR/AR SDKs', 'Immersive design'],
    ARRAY['Creative environment', 'Latest VR equipment', 'Flexible hours', 'Health insurance'],
    0.004,
    false,
    'active'
),
-- Job 30: Sustainability Data Scientist
(
    'Sustainability Data Scientist',
    (SELECT id FROM companies WHERE handle = 'sustainability-tech'),
    'Portland',
    3,
    'Full-time',
    'Senior',
    125,
    155,
    'Use data science to drive environmental sustainability initiatives.',
    ARRAY['Python', 'Environmental Data', 'Climate Modeling', 'GIS'],
    ARRAY['Python', 'Environmental science', 'Climate modeling', 'GIS', 'Sustainability metrics'],
    ARRAY['Health insurance', 'Environmental impact bonus', 'Conference budget', 'Flexible hours'],
    0.006,
    true,
    'active'
),
-- Job 31: Space Software Engineer
(
    'Space Software Engineer',
    (SELECT id FROM companies WHERE handle = 'space-tech'),
    'Houston',
    7,
    'Full-time',
    'Senior',
    140,
    180,
    'Develop mission-critical software for space exploration.',
    ARRAY['C++', 'Real-time Systems', 'Embedded Systems', 'Space Systems'],
    ARRAY['C++', 'Real-time systems', 'Embedded programming', 'Space systems', 'Safety-critical software'],
    ARRAY['Stock options', 'Health insurance', 'Space mission participation', 'Technical training'],
    0.009,
    false,
    'active'
),
-- Job 32: Bioinformatics Engineer
(
    'Bioinformatics Engineer',
    (SELECT id FROM companies WHERE handle = 'biotech-corp'),
    'San Diego',
    4,
    'Full-time',
    'Mid',
    95,
    125,
    'Develop computational tools for biological research and drug discovery.',
    ARRAY['Python', 'Bioinformatics', 'Machine Learning', 'Genomics'],
    ARRAY['Python', 'Bioinformatics', 'Machine learning', 'Genomics', 'Life sciences'],
    ARRAY['Health insurance', 'Research opportunities', 'Conference budget', 'Flexible hours'],
    0.005,
    true,
    'active'
),
-- Job 33: Logistics Optimization Engineer
(
    'Logistics Optimization Engineer',
    (SELECT id FROM companies WHERE handle = 'logistics-platform'),
    'Chicago',
    2,
    'Full-time',
    'Senior',
    115,
    145,
    'Optimize supply chain and logistics operations using advanced algorithms.',
    ARRAY['Operations Research', 'Python', 'Optimization', 'Supply Chain'],
    ARRAY['Operations research', 'Python', 'Optimization algorithms', 'Supply chain', 'Logistics'],
    ARRAY['Stock options', 'Health insurance', 'Logistics benefits', 'Performance bonus'],
    0.007,
    true,
    'active'
),
-- Job 34: Social Platform Backend Engineer
(
    'Social Platform Backend Engineer',
    (SELECT id FROM companies WHERE handle = 'social-network'),
    'Menlo Park',
    1,
    'Full-time',
    'Senior',
    145,
    185,
    'Build scalable backend systems for social networking platform.',
    ARRAY['Distributed Systems', 'NoSQL', 'Caching', 'Microservices'],
    ARRAY['Distributed systems', 'NoSQL databases', 'Caching strategies', 'Microservices', 'High-scale systems'],
    ARRAY['Stock options', 'Health insurance', 'Social impact projects', 'Cafeteria'],
    0.011,
    true,
    'active'
),
-- Job 35: Travel Recommendation Engineer
(
    'Travel Recommendation Engineer',
    (SELECT id FROM companies WHERE handle = 'travel-tech'),
    'San Francisco',
    3,
    'Full-time',
    'Mid',
    105,
    135,
    'Build recommendation systems for personalized travel experiences.',
    ARRAY['Machine Learning', 'Recommendation Systems', 'Python', 'Travel Domain'],
    ARRAY['Machine learning', 'Recommendation systems', 'Python', 'Travel industry', 'Personalization'],
    ARRAY['Travel benefits', 'Health insurance', 'Flexible hours', 'Learning budget'],
    0.006,
    true,
    'active'
),
-- Job 36: Technology Consultant
(
    'Technology Consultant',
    (SELECT id FROM companies WHERE handle = 'consulting-firm'),
    'New York',
    2,
    'Full-time',
    'Senior',
    120,
    160,
    'Advise clients on digital transformation and technology strategy.',
    ARRAY['Strategy', 'Digital Transformation', 'Leadership', 'Technology Assessment'],
    ARRAY['Technology strategy', 'Digital transformation', 'Client management', 'Leadership', 'Business analysis'],
    ARRAY['Travel opportunities', 'Health insurance', 'Professional development', 'Consulting bonus'],
    0.004,
    false,
    'active'
),
-- Job 37: Startup Mentor
(
    'Startup Mentor',
    (SELECT id FROM companies WHERE handle = 'startup-incubator'),
    'Palo Alto',
    1,
    'Part-time',
    'Senior',
    80,
    120,
    'Mentor early-stage startups in technology and business development.',
    ARRAY['Mentoring', 'Startup Experience', 'Business Development', 'Technology Strategy'],
    ARRAY['Startup experience', 'Mentoring', 'Business development', 'Technology strategy', 'Entrepreneurship'],
    ARRAY['Equity in startups', 'Networking opportunities', 'Flexible schedule', 'Impact on innovation'],
    0.015,
    true,
    'active'
),
-- Job 38: Renewable Energy Software Engineer
(
    'Renewable Energy Software Engineer',
    (SELECT id FROM companies WHERE handle = 'renewable-energy'),
    'Denver',
    5,
    'Full-time',
    'Mid',
    95,
    125,
    'Develop software for smart grid and renewable energy systems.',
    ARRAY['Energy Systems', 'IoT', 'Data Analytics', 'Grid Technology'],
    ARRAY['Energy systems', 'IoT', 'Data analytics', 'Grid technology', 'Renewable energy'],
    ARRAY['Green energy benefits', 'Health insurance', 'Environmental impact', 'Flexible hours'],
    0.005,
    true,
    'active'
),
-- Job 39: Food Delivery Algorithm Engineer
(
    'Food Delivery Algorithm Engineer',
    (SELECT id FROM companies WHERE handle = 'food-delivery'),
    'San Francisco',
    2,
    'Full-time',
    'Senior',
    130,
    165,
    'Optimize delivery routes and logistics for food delivery platform.',
    ARRAY['Algorithms', 'Optimization', 'Geospatial Data', 'Real-time Systems'],
    ARRAY['Algorithm optimization', 'Geospatial data', 'Real-time systems', 'Logistics', 'Route optimization'],
    ARRAY['Food credits', 'Stock options', 'Health insurance', 'Flexible hours'],
    0.008,
    true,
    'active'
),
-- Job 40: Automotive Software Engineer
(
    'Automotive Software Engineer',
    (SELECT id FROM companies WHERE handle = 'automotive-tech'),
    'Detroit',
    4,
    'Full-time',
    'Senior',
    110,
    145,
    'Develop software for autonomous vehicles and smart car systems.',
    ARRAY['Automotive Systems', 'Real-time Programming', 'Safety Systems', 'Embedded C++'],
    ARRAY['Automotive systems', 'Real-time programming', 'Safety-critical systems', 'Embedded C++', 'AUTOSAR'],
    ARRAY['Stock options', 'Health insurance', 'Automotive benefits', 'Technical training'],
    0.007,
    false,
    'active'
),

-- More diverse roles across different experience levels and types
-- Job 41: Junior React Developer
(
    'Junior React Developer',
    (SELECT id FROM companies WHERE handle = 'acme-corp'),
    'Remote',
    1,
    'Full-time',
    'Junior',
    65,
    85,
    'Join our frontend team as a junior developer and grow your React skills.',
    ARRAY['React', 'JavaScript', 'HTML/CSS'],
    ARRAY['React basics', 'JavaScript ES6+', 'HTML/CSS', 'Git', 'Responsive design'],
    ARRAY['Mentorship program', 'Health insurance', 'Learning budget', 'Remote work'],
    0.002,
    true,
    'active'
),
-- Job 42: Senior DevOps Architect
(
    'Senior DevOps Architect',
    (SELECT id FROM companies WHERE handle = 'enterprise-solutions'),
    'Seattle',
    3,
    'Full-time',
    'Senior',
    150,
    190,
    'Design and implement enterprise-scale DevOps architecture and practices.',
    ARRAY['Kubernetes', 'Terraform', 'Jenkins', 'AWS'],
    ARRAY['Kubernetes', 'Terraform', 'Jenkins', 'AWS/Azure', 'DevOps culture', 'Architecture design'],
    ARRAY['Stock options', 'Health insurance', 'Architecture training', 'Conference budget'],
    0.010,
    true,
    'active'
),
-- Job 43: Contract UI/UX Designer
(
    'Contract UI/UX Designer',
    (SELECT id FROM companies WHERE handle = 'design-studio'),
    'Remote',
    2,
    'Contract',
    'Mid',
    75,
    105,
    'Design user interfaces and experiences for mobile and web applications.',
    ARRAY['Figma', 'Design Systems', 'User Research', 'Prototyping'],
    ARRAY['Figma/Sketch', 'Design systems', 'User research', 'Prototyping', 'Mobile design'],
    ARRAY['Flexible hours', 'Design tools budget', 'Portfolio development', 'Remote work'],
    0.000,
    true,
    'active'
),
-- Job 44: Part-time QA Automation Engineer
(
    'Part-time QA Automation Engineer',
    (SELECT id FROM companies WHERE handle = 'quality-first'),
    'Phoenix',
    4,
    'Part-time',
    'Mid',
    60,
    80,
    'Develop and maintain automated testing frameworks and test suites.',
    ARRAY['Selenium', 'TestNG', 'Java', 'API Testing'],
    ARRAY['Selenium WebDriver', 'TestNG/JUnit', 'Java', 'API testing', 'Test automation frameworks'],
    ARRAY['Flexible schedule', 'Health insurance', 'Testing tools', 'Professional development'],
    0.001,
    true,
    'active'
),
-- Job 45: Internship - Machine Learning
(
    'Machine Learning Intern',
    (SELECT id FROM companies WHERE handle = 'ai-innovations'),
    'San Francisco',
    1,
    'Internship',
    'Junior',
    45,
    65,
    'Learn machine learning fundamentals while working on real projects.',
    ARRAY['Python', 'Machine Learning Basics', 'Data Analysis'],
    ARRAY['Python basics', 'Statistics', 'Machine learning fundamentals', 'Data analysis', 'Jupyter'],
    ARRAY['Mentorship', 'Learning opportunities', 'Potential full-time offer', 'Research exposure'],
    0.000,
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
((SELECT id FROM jobs WHERE title = 'Site Reliability Engineer'), (SELECT id FROM job_categories WHERE name = 'DevOps')),

-- Additional job category relations for new jobs
-- FinTech Backend Developer
((SELECT id FROM jobs WHERE title = 'FinTech Backend Developer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Healthcare Data Analyst
((SELECT id FROM jobs WHERE title = 'Healthcare Data Analyst'), (SELECT id FROM job_categories WHERE name = 'Data Science')),
-- E-commerce Platform Engineer
((SELECT id FROM jobs WHERE title = 'E-commerce Platform Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Video Streaming Engineer
((SELECT id FROM jobs WHERE title = 'Video Streaming Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- EdTech Frontend Developer
((SELECT id FROM jobs WHERE title = 'EdTech Frontend Developer'), (SELECT id FROM job_categories WHERE name = 'Frontend')),
-- Robotics Software Engineer
((SELECT id FROM jobs WHERE title = 'Robotics Software Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Quantum Algorithm Developer
((SELECT id FROM jobs WHERE title = 'Quantum Algorithm Developer'), (SELECT id FROM job_categories WHERE name = 'Data Science')),
-- IoT Solutions Architect
((SELECT id FROM jobs WHERE title = 'IoT Solutions Architect'), (SELECT id FROM job_categories WHERE name = 'Backend')),
((SELECT id FROM jobs WHERE title = 'IoT Solutions Architect'), (SELECT id FROM job_categories WHERE name = 'DevOps')),
-- VR/AR Developer
((SELECT id FROM jobs WHERE title = 'VR/AR Developer'), (SELECT id FROM job_categories WHERE name = 'Frontend')),
-- Sustainability Data Scientist
((SELECT id FROM jobs WHERE title = 'Sustainability Data Scientist'), (SELECT id FROM job_categories WHERE name = 'Data Science')),
-- Space Software Engineer
((SELECT id FROM jobs WHERE title = 'Space Software Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Bioinformatics Engineer
((SELECT id FROM jobs WHERE title = 'Bioinformatics Engineer'), (SELECT id FROM job_categories WHERE name = 'Data Science')),
((SELECT id FROM jobs WHERE title = 'Bioinformatics Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Logistics Optimization Engineer
((SELECT id FROM jobs WHERE title = 'Logistics Optimization Engineer'), (SELECT id FROM job_categories WHERE name = 'Data Science')),
((SELECT id FROM jobs WHERE title = 'Logistics Optimization Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Social Platform Backend Engineer
((SELECT id FROM jobs WHERE title = 'Social Platform Backend Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Travel Recommendation Engineer
((SELECT id FROM jobs WHERE title = 'Travel Recommendation Engineer'), (SELECT id FROM job_categories WHERE name = 'Data Science')),
((SELECT id FROM jobs WHERE title = 'Travel Recommendation Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Technology Consultant
((SELECT id FROM jobs WHERE title = 'Technology Consultant'), (SELECT id FROM job_categories WHERE name = 'Product')),
-- Startup Mentor
((SELECT id FROM jobs WHERE title = 'Startup Mentor'), (SELECT id FROM job_categories WHERE name = 'Product')),
-- Renewable Energy Software Engineer
((SELECT id FROM jobs WHERE title = 'Renewable Energy Software Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Food Delivery Algorithm Engineer
((SELECT id FROM jobs WHERE title = 'Food Delivery Algorithm Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
((SELECT id FROM jobs WHERE title = 'Food Delivery Algorithm Engineer'), (SELECT id FROM job_categories WHERE name = 'Data Science')),
-- Automotive Software Engineer
((SELECT id FROM jobs WHERE title = 'Automotive Software Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Junior React Developer
((SELECT id FROM jobs WHERE title = 'Junior React Developer'), (SELECT id FROM job_categories WHERE name = 'Frontend')),
-- Senior DevOps Architect
((SELECT id FROM jobs WHERE title = 'Senior DevOps Architect'), (SELECT id FROM job_categories WHERE name = 'DevOps')),
-- Contract UI/UX Designer
((SELECT id FROM jobs WHERE title = 'Contract UI/UX Designer'), (SELECT id FROM job_categories WHERE name = 'Design')),
-- Part-time QA Automation Engineer
((SELECT id FROM jobs WHERE title = 'Part-time QA Automation Engineer'), (SELECT id FROM job_categories WHERE name = 'QA')),
-- Machine Learning Intern
((SELECT id FROM jobs WHERE title = 'Machine Learning Intern'), (SELECT id FROM job_categories WHERE name = 'Data Science'));

-- Sample user profiles for the application
-- IMPORTANT: These INSERT statements will fail because the UUIDs don't exist in auth.users
-- In production, user_profiles are created automatically when users sign up through Supabase Auth

-- OPTION 1: Create test users through Supabase Auth Dashboard first, then insert profiles
-- OPTION 2: Use the following approach for testing with existing auth.users

-- First, let's create some auth.users entries (this may not work due to RLS policies)
-- You should create these users through the Supabase Auth interface instead

-- COMMENTED OUT - Uncomment only after creating corresponding auth.users
/*
INSERT INTO user_profiles (id, email, first_name, last_name, username, bio, location, skills, experience_years, is_recruiter) VALUES
('11111111-1111-1111-1111-111111111111', 'john.doe@email.com', 'John', 'Doe', 'johndoe', 'Frontend developer passionate about Vue.js and modern web technologies', 'New York, NY', ARRAY['Vue.js', 'JavaScript', 'TypeScript', 'CSS'], 3, false),
('22222222-2222-2222-2222-222222222222', 'jane.dev@email.com', 'Jane', 'Developer', 'janedeveloper', 'Full-stack developer with experience in both frontend and backend technologies', 'San Francisco, CA', ARRAY['React', 'Node.js', 'Python', 'PostgreSQL'], 5, false),
('33333333-3333-3333-3333-333333333333', 'admin@jobly.com', 'Admin', 'User', 'adminuser', 'Platform administrator', 'Remote', ARRAY['Management', 'Technology Strategy'], 10, true),
('44444444-4444-4444-4444-444444444444', 'alex.eng@email.com', 'Alex', 'Engineer', 'alexengineeer', 'DevOps engineer specializing in cloud infrastructure and automation', 'Seattle, WA', ARRAY['AWS', 'Docker', 'Kubernetes', 'Terraform'], 4, false),
('55555555-5555-5555-5555-555555555555', 'sarah.design@email.com', 'Sarah', 'Designer', 'sarahdesigner', 'UX/UI designer focused on creating intuitive and beautiful user experiences', 'Los Angeles, CA', ARRAY['Figma', 'Adobe XD', 'User Research', 'Prototyping'], 4, false),
('66666666-6666-6666-6666-666666666666', 'mike.mgr@email.com', 'Mike', 'Manager', 'mikemanager', 'Product manager with a passion for building innovative tech products', 'Boston, MA', ARRAY['Product Strategy', 'Agile', 'Data Analysis', 'Leadership'], 7, false),
('77777777-7777-7777-7777-777777777777', 'emily.data@email.com', 'Emily', 'Data Scientist', 'emilydatascientist', 'Data scientist specializing in machine learning and predictive analytics', 'Chicago, IL', ARRAY['Python', 'Machine Learning', 'SQL', 'Statistics'], 6, false),
('88888888-8888-8888-8888-888888888888', 'david.devops@email.com', 'David', 'DevOps', 'daviddevops', 'Senior DevOps engineer with expertise in scalable infrastructure', 'Austin, TX', ARRAY['Linux', 'Monitoring', 'CI/CD', 'Scripting'], 8, false),
('99999999-9999-9999-9999-999999999999', 'lisa.qa@email.com', 'Lisa', 'QA Engineer', 'lisaqaengineer', 'QA engineer passionate about test automation and quality assurance', 'Denver, CO', ARRAY['Selenium', 'Jest', 'Test Automation', 'Quality Assurance'], 3, false),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'tom.fullstack@email.com', 'Tom', 'Full Stack', 'tomfullstack', 'Full-stack developer with experience across the entire technology stack', 'Portland, OR', ARRAY['React', 'Node.js', 'PostgreSQL', 'AWS'], 5, false);
*/

-- Alternative: Query existing auth.users and use their IDs for user_profiles
-- To see existing users: SELECT id, email FROM auth.users;

-- Sample applications from users to jobs
-- COMMENTED OUT - Uncomment only after creating user_profiles
/*
INSERT INTO applications (user_id, job_id, status, cover_letter) VALUES
-- John Doe applications
('11111111-1111-1111-1111-111111111111', (SELECT id FROM jobs WHERE title = 'Frontend Developer'), 'pending', 'I am excited to apply for the Frontend Developer position. My experience with Vue.js aligns perfectly with your requirements.'),
('11111111-1111-1111-1111-111111111111', (SELECT id FROM jobs WHERE title = 'Junior React Developer'), 'pending', 'Looking to expand my skills from Vue.js to React in a supportive environment.'),
('11111111-1111-1111-1111-111111111111', (SELECT id FROM jobs WHERE title = 'EdTech Frontend Developer'), 'interview', 'Passionate about combining education and technology to create meaningful learning experiences.'),

-- Jane Developer applications
('22222222-2222-2222-2222-222222222222', (SELECT id FROM jobs WHERE title = 'Full Stack Developer'), 'pending', 'My experience spans both frontend and backend development, making me a perfect fit for this full-stack role.'),
('22222222-2222-2222-2222-222222222222', (SELECT id FROM jobs WHERE title = 'Backend Engineer'), 'interview', 'I have extensive experience with Node.js and scalable backend systems.'),
('22222222-2222-2222-2222-222222222222', (SELECT id FROM jobs WHERE title = 'E-commerce Platform Engineer'), 'pending', 'E-commerce platforms require robust architecture, which I have experience building.'),

-- Alex Engineer applications
('44444444-4444-4444-4444-444444444444', (SELECT id FROM jobs WHERE title = 'DevOps Engineer'), 'pending', 'DevOps is my passion. I love automating processes and improving system reliability.'),
('44444444-4444-4444-4444-444444444444', (SELECT id FROM jobs WHERE title = 'Senior DevOps Architect'), 'pending', 'Ready to take on architectural challenges in DevOps and lead infrastructure design.'),
('44444444-4444-4444-4444-444444444444', (SELECT id FROM jobs WHERE title = 'Site Reliability Engineer'), 'interview', 'SRE combines my love for development with operations and system reliability.'),

-- Sarah Designer applications
('55555555-5555-5555-5555-555555555555', (SELECT id FROM jobs WHERE title = 'UX Designer'), 'pending', 'User experience is at the heart of great products. I would love to contribute to your design team.'),
('55555555-5555-5555-5555-555555555555', (SELECT id FROM jobs WHERE title = 'UI Developer'), 'interview', 'My design background combined with frontend skills makes me unique in implementing designs.'),
('55555555-5555-5555-5555-555555555555', (SELECT id FROM jobs WHERE title = 'Contract UI/UX Designer'), 'pending', 'Interested in contributing to your design projects on a contract basis.'),

-- Mike Manager applications
('66666666-6666-6666-6666-666666666666', (SELECT id FROM jobs WHERE title = 'Product Manager'), 'pending', 'Product management allows me to bridge technology and business needs effectively.'),
('66666666-6666-6666-6666-666666666666', (SELECT id FROM jobs WHERE title = 'Technology Consultant'), 'interview', 'My experience in product strategy would be valuable in consulting engagements.'),
('66666666-6666-6666-6666-666666666666', (SELECT id FROM jobs WHERE title = 'Startup Mentor'), 'pending', 'I enjoy mentoring early-stage startups and helping them navigate product challenges.'),

-- Emily Data Scientist applications
('77777777-7777-7777-7777-777777777777', (SELECT id FROM jobs WHERE title = 'Data Scientist'), 'pending', 'Data science is my passion. I love extracting insights from complex datasets.'),
('77777777-7777-7777-7777-777777777777', (SELECT id FROM jobs WHERE title = 'Machine Learning Engineer'), 'interview', 'Deploying ML models in production is where I excel, combining data science with engineering.'),
('77777777-7777-7777-7777-777777777777', (SELECT id FROM jobs WHERE title = 'Healthcare Data Analyst'), 'pending', 'Healthcare data analysis offers the opportunity to improve patient outcomes through data.'),
('77777777-7777-7777-7777-777777777777', (SELECT id FROM jobs WHERE title = 'Sustainability Data Scientist'), 'pending', 'Combining data science with environmental impact is deeply meaningful to me.'),

-- David DevOps applications
('88888888-8888-8888-8888-888888888888', (SELECT id FROM jobs WHERE title = 'DevOps Engineer'), 'pending', 'Senior DevOps engineer looking for new challenges in infrastructure automation.'),
('88888888-8888-8888-8888-888888888888', (SELECT id FROM jobs WHERE title = 'Systems Engineer'), 'pending', 'My systems engineering background complements my DevOps expertise perfectly.'),
('88888888-8888-8888-8888-888888888888', (SELECT id FROM jobs WHERE title = 'IoT Solutions Architect'), 'interview', 'IoT architecture requires the intersection of systems and DevOps knowledge.'),

-- Lisa QA Engineer applications
('99999999-9999-9999-9999-999999999999', (SELECT id FROM jobs WHERE title = 'QA Engineer'), 'pending', 'Quality assurance is crucial for delivering excellent software products.'),
('99999999-9999-9999-9999-999999999999', (SELECT id FROM jobs WHERE title = 'Part-time QA Automation Engineer'), 'pending', 'Interested in part-time automation work to balance professional and personal life.'),

-- Tom Full Stack applications
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', (SELECT id FROM jobs WHERE title = 'Full Stack Developer'), 'pending', 'Full-stack development allows me to work across the entire technology stack.'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', (SELECT id FROM jobs WHERE title = 'Frontend Developer'), 'interview', 'While I am full-stack, I have a particular passion for frontend technologies.'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', (SELECT id FROM jobs WHERE title = 'Backend Engineer'), 'pending', 'Backend engineering is a core part of my full-stack expertise.'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', (SELECT id FROM jobs WHERE title = 'Software Architect'), 'pending', 'Ready to move into architecture and design scalable systems.');
*/

-- Sample saved jobs (bookmarks)
-- COMMENTED OUT - Uncomment only after creating user_profiles
/*
INSERT INTO saved_jobs (user_id, job_id) VALUES
-- John Doe saved jobs
('11111111-1111-1111-1111-111111111111', (SELECT id FROM jobs WHERE title = 'Frontend Developer')),
('11111111-1111-1111-1111-111111111111', (SELECT id FROM jobs WHERE title = 'UI Developer')),
('11111111-1111-1111-1111-111111111111', (SELECT id FROM jobs WHERE title = 'Junior React Developer')),

-- Jane Developer saved jobs  
('22222222-2222-2222-2222-222222222222', (SELECT id FROM jobs WHERE title = 'Full Stack Developer')),
('22222222-2222-2222-2222-222222222222', (SELECT id FROM jobs WHERE title = 'Software Architect')),
('22222222-2222-2222-2222-222222222222', (SELECT id FROM jobs WHERE title = 'Machine Learning Engineer')),

-- Alex Engineer saved jobs
('44444444-4444-4444-4444-444444444444', (SELECT id FROM jobs WHERE title = 'DevOps Engineer')),
('44444444-4444-4444-4444-444444444444', (SELECT id FROM jobs WHERE title = 'Site Reliability Engineer')),
('44444444-4444-4444-4444-444444444444', (SELECT id FROM jobs WHERE title = 'Systems Engineer')),

-- Sarah Designer saved jobs
('55555555-5555-5555-5555-555555555555', (SELECT id FROM jobs WHERE title = 'UX Designer')),
('55555555-5555-5555-5555-555555555555', (SELECT id FROM jobs WHERE title = 'Contract UI/UX Designer')),
('55555555-5555-5555-5555-555555555555', (SELECT id FROM jobs WHERE title = 'Product Manager')),

-- Emily Data Scientist saved jobs
('77777777-7777-7777-7777-777777777777', (SELECT id FROM jobs WHERE title = 'Data Scientist')),
('77777777-7777-7777-7777-777777777777', (SELECT id FROM jobs WHERE title = 'Machine Learning Engineer')),
('77777777-7777-7777-7777-777777777777', (SELECT id FROM jobs WHERE title = 'Quantum Algorithm Developer')),
('77777777-7777-7777-7777-777777777777', (SELECT id FROM jobs WHERE title = 'Bioinformatics Engineer')),

-- Tom Full Stack saved jobs
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', (SELECT id FROM jobs WHERE title = 'Full Stack Developer')),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', (SELECT id FROM jobs WHERE title = 'Frontend Developer')),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', (SELECT id FROM jobs WHERE title = 'Backend Engineer'));
*/

-- Additional sample data for more realistic testing
-- More companies in different industries
INSERT INTO companies (handle, name, description, num_employees, logo_url) VALUES
('finbank-corp', 'FinBank Corp', 'Traditional banking with digital transformation initiatives', 2500, 'https://via.placeholder.com/200x200/1F2937/white?text=FB'),
('retail-giant', 'Retail Giant', 'Large retail corporation with e-commerce focus', 50000, 'https://via.placeholder.com/200x200/7C3AED/white?text=RG'),
('pharma-innovations', 'Pharma Innovations', 'Pharmaceutical research and drug development', 800, 'https://via.placeholder.com/200x200/059669/white?text=PI'),
('sports-tech', 'Sports Tech', 'Sports analytics and athlete performance technology', 120, 'https://via.placeholder.com/200x200/DC2626/white?text=ST'),
('music-streaming', 'Music Streaming', 'Digital music platform and audio technology', 350, 'https://via.placeholder.com/200x200/7C2D12/white?text=MS');

-- Additional diverse jobs
INSERT INTO jobs (title, company_id, location, posted_days_ago, employment_type, experience_level, salary_min, salary_max, description, skills, requirements, benefits, equity, remote_allowed, status) VALUES
-- Banking Technology Jobs
(
    'Banking Software Developer',
    (SELECT id FROM companies WHERE handle = 'finbank-corp'),
    'Charlotte',
    3,
    'Full-time',
    'Mid',
    95,
    125,
    'Develop secure banking applications and financial systems.',
    ARRAY['Java', 'Spring Framework', 'Banking Systems', 'Security'],
    ARRAY['Java', 'Spring Framework', 'Banking domain', 'Security protocols', 'Financial regulations'],
    ARRAY['Banking benefits', 'Health insurance', '401k matching', 'Stability'],
    0.001,
    false,
    'active'
),
(
    'Financial Data Engineer',
    (SELECT id FROM companies WHERE handle = 'finbank-corp'),
    'New York',
    5,
    'Full-time',
    'Senior',
    130,
    165,
    'Build data pipelines for financial analytics and reporting.',
    ARRAY['SQL', 'Python', 'ETL', 'Financial Data'],
    ARRAY['SQL', 'Python', 'ETL processes', 'Financial data', 'Data warehousing'],
    ARRAY['Financial sector benefits', 'Health insurance', 'Retirement plan', 'Bonus structure'],
    0.002,
    true,
    'active'
),
-- Retail Technology Jobs
(
    'E-commerce Frontend Developer',
    (SELECT id FROM companies WHERE handle = 'retail-giant'),
    'Seattle',
    2,
    'Full-time',
    'Mid',
    105,
    135,
    'Build customer-facing e-commerce applications and shopping experiences.',
    ARRAY['React', 'TypeScript', 'E-commerce', 'Performance Optimization'],
    ARRAY['React', 'TypeScript', 'E-commerce platforms', 'Performance optimization', 'A/B testing'],
    ARRAY['Employee discount', 'Stock options', 'Health insurance', 'Retail benefits'],
    0.004,
    true,
    'active'
),
(
    'Supply Chain Software Engineer',
    (SELECT id FROM companies WHERE handle = 'retail-giant'),
    'Bentonville',
    1,
    'Full-time',
    'Senior',
    120,
    155,
    'Optimize supply chain operations through software solutions.',
    ARRAY['Java', 'Microservices', 'Supply Chain', 'Optimization'],
    ARRAY['Java', 'Microservices', 'Supply chain systems', 'Optimization algorithms', 'Logistics'],
    ARRAY['Retail benefits', 'Stock options', 'Health insurance', 'Supply chain exposure'],
    0.005,
    false,
    'active'
),
-- Pharmaceutical Technology Jobs
(
    'Clinical Data Analyst',
    (SELECT id FROM companies WHERE handle = 'pharma-innovations'),
    'Boston',
    4,
    'Full-time',
    'Mid',
    90,
    120,
    'Analyze clinical trial data to support drug development.',
    ARRAY['R', 'SAS', 'Clinical Data', 'Statistics'],
    ARRAY['R/SAS', 'Clinical data analysis', 'Statistics', 'Regulatory knowledge', 'Life sciences'],
    ARRAY['Pharmaceutical benefits', 'Health insurance', 'Research opportunities', 'Conference budget'],
    0.003,
    false,
    'active'
),
-- Sports Technology Jobs
(
    'Sports Analytics Engineer',
    (SELECT id FROM companies WHERE handle = 'sports-tech'),
    'Los Angeles',
    2,
    'Full-time',
    'Mid',
    100,
    130,
    'Develop analytics tools for sports performance and fan engagement.',
    ARRAY['Python', 'Machine Learning', 'Sports Analytics', 'Data Visualization'],
    ARRAY['Python', 'Machine learning', 'Sports domain knowledge', 'Data visualization', 'Statistics'],
    ARRAY['Sports tickets', 'Health insurance', 'Flexible hours', 'Athlete interaction'],
    0.006,
    true,
    'active'
),
-- Music Technology Jobs
(
    'Audio Software Engineer',
    (SELECT id FROM companies WHERE handle = 'music-streaming'),
    'Stockholm',
    3,
    'Full-time',
    'Senior',
    115,
    150,
    'Develop audio processing and music recommendation algorithms.',
    ARRAY['C++', 'Audio Processing', 'DSP', 'Machine Learning'],
    ARRAY['C++', 'Digital signal processing', 'Audio algorithms', 'Machine learning', 'Music theory'],
    ARRAY['Music benefits', 'Stock options', 'Health insurance', 'Creative environment'],
    0.008,
    true,
    'active'
);

-- Job category relations for new jobs
INSERT INTO job_category_relations (job_id, category_id) VALUES
-- Banking Software Developer
((SELECT id FROM jobs WHERE title = 'Banking Software Developer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Financial Data Engineer
((SELECT id FROM jobs WHERE title = 'Financial Data Engineer'), (SELECT id FROM job_categories WHERE name = 'Data Science')),
((SELECT id FROM jobs WHERE title = 'Financial Data Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- E-commerce Frontend Developer
((SELECT id FROM jobs WHERE title = 'E-commerce Frontend Developer'), (SELECT id FROM job_categories WHERE name = 'Frontend')),
-- Supply Chain Software Engineer
((SELECT id FROM jobs WHERE title = 'Supply Chain Software Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend')),
-- Clinical Data Analyst
((SELECT id FROM jobs WHERE title = 'Clinical Data Analyst'), (SELECT id FROM job_categories WHERE name = 'Data Science')),
-- Sports Analytics Engineer
((SELECT id FROM jobs WHERE title = 'Sports Analytics Engineer'), (SELECT id FROM job_categories WHERE name = 'Data Science')),
-- Audio Software Engineer
((SELECT id FROM jobs WHERE title = 'Audio Software Engineer'), (SELECT id FROM job_categories WHERE name = 'Backend'));

-- =============================================================================
-- INSTRUCTIONS FOR ADDING TEST USERS AND DATA
-- =============================================================================

-- STEP 1: Create test users through Supabase Auth
-- Go to Authentication > Users in Supabase Dashboard and create users with these emails:
-- - john.doe@email.com
-- - jane.dev@email.com  
-- - admin@jobly.com
-- - alex.eng@email.com
-- - sarah.design@email.com
-- - mike.mgr@email.com
-- - emily.data@email.com
-- - david.devops@email.com
-- - lisa.qa@email.com
-- - tom.fullstack@email.com

-- STEP 2: Get the UUIDs of created users
-- SELECT id, email FROM auth.users ORDER BY created_at DESC;

-- STEP 3: Replace the UUIDs in the commented sections above with real UUIDs from auth.users

-- STEP 4: Uncomment and execute the user_profiles, applications, and saved_jobs sections

-- ALTERNATIVE: Use this query to create user_profiles for existing auth.users
-- INSERT INTO user_profiles (id, email, first_name, last_name, username, is_recruiter)
-- SELECT 
--     id, 
--     email,
--     'Test',
--     'User',
--     REPLACE(SPLIT_PART(email, '@', 1), '.', ''),
--     false
-- FROM auth.users 
-- WHERE email NOT LIKE '%@supabase.io'  -- Exclude system users
-- ON CONFLICT (id) DO NOTHING;

-- This will create basic profiles for all existing authenticated users
-- You can then manually update the profiles with more detailed information 