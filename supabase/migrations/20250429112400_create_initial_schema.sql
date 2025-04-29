-- Create divisions table
CREATE TABLE divisions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL
);

-- Create departments table
CREATE TABLE departments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL,
    division_id UUID REFERENCES divisions(id) ON DELETE CASCADE
);

-- Create sections table
CREATE TABLE sections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL,
    department_id UUID REFERENCES departments(id) ON DELETE CASCADE
);

-- Create job_grades table
CREATE TABLE job_grades (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    level1 TEXT NOT NULL,
    level2 TEXT,
    UNIQUE (level1, level2)
);

-- Create skill_hierarchy table
CREATE TABLE skill_hierarchy (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    type TEXT NOT NULL, -- e.g., 'SkillArea', 'SkillGroup', 'Skill', 'SSL'
    parent_id UUID REFERENCES skill_hierarchy(id) ON DELETE SET NULL, -- Allow root nodes
    skill_difficulty TEXT -- Can be at Skill/Sub-skill level
);

-- Create skill_department linking table
CREATE TABLE skill_department (
    skill_id UUID REFERENCES skill_hierarchy(id) ON DELETE CASCADE,
    department_id UUID REFERENCES departments(id) ON DELETE CASCADE,
    PRIMARY KEY (skill_id, department_id)
);

-- Create skill_job_grade_attributes table
CREATE TABLE skill_job_grade_attributes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    skill_id UUID REFERENCES skill_hierarchy(id) ON DELETE CASCADE,
    job_grade_id UUID REFERENCES job_grades(id) ON DELETE CASCADE,
    expectation TEXT, -- Job-grade specific remarks/descriptions
    UNIQUE (skill_id, job_grade_id)
);

-- Enable Row Level Security (RLS) on relevant tables
-- Note: Specific policies will be defined later based on application requirements.
ALTER TABLE skill_hierarchy ENABLE ROW LEVEL SECURITY;
ALTER TABLE skill_job_grade_attributes ENABLE ROW LEVEL SECURITY;

-- Optional: Add indexes for performance on frequently queried columns
CREATE INDEX idx_departments_division_id ON departments(division_id);
CREATE INDEX idx_sections_department_id ON sections(department_id);
CREATE INDEX idx_skill_hierarchy_parent_id ON skill_hierarchy(parent_id);
CREATE INDEX idx_skill_department_skill_id ON skill_department(skill_id);
CREATE INDEX idx_skill_department_department_id ON skill_department(department_id);
CREATE INDEX idx_skill_job_grade_attributes_skill_id ON skill_job_grade_attributes(skill_id);
CREATE INDEX idx_skill_job_grade_attributes_job_grade_id ON skill_job_grade_attributes(job_grade_id);