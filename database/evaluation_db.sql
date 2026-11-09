DROP DATABASE IF EXISTS evaluation_db;

CREATE DATABASE evaluation_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE evaluation_db;
SET NAMES utf8mb4;

CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE academic_ranks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    sort_order INT NOT NULL DEFAULT 1
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role ENUM('admin','evaluatee','evaluator') NOT NULL,
    department_id INT  NULL,
    academic_rank_id INT NULL,
    position VARCHAR(100) NULL,
    phone VARCHAR(20) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id),
    FOREIGN KEY (academic_rank_id) REFERENCES academic_ranks(id)
);

CREATE TABLE evaluation_periods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE evaluation_forms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    period_id INT NOT NULL,
    academic_rank_id INT NOT NULL,
    name VARCHAR(200) NOT NULL, 
    UNIQUE (period_id, academic_rank_id),
    FOREIGN KEY (period_id) REFERENCES evaluation_periods(id) ON DELETE CASCADE,
    FOREIGN KEY (academic_rank_id) REFERENCES academic_ranks(id)
);

CREATE TABLE topics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    form_id INT NOT NULL,
    component TINYINT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NULL,
    sort_order INT NOT NULL DEFAULT 1,
    FOREIGN KEY (form_id) REFERENCES evaluation_forms(id) ON DELETE CASCADE

);

CREATE TABLE indicators (
    id INT AUTO_INCREMENT PRIMARY KEY,
    topic_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT NULL,
    weight DECIMAL(6,3) NOT NULL,
    score_type ENUM('scale','yes_no') NOT NULL DEFAULT 'scale',
    max_level TINYINT NOT NULL DEFAULT 4,
    evidence_note VARCHAR(255) NULL,
    sort_order INT NOT NULL DEFAULT 1,
    FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE CASCADE
);

CREATE TABLE evaluations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    period_id INT NOT NULL,
    form_id INT NOT NULL,
    evaluatee_id INT NOT NULL,
    status ENUM('draft','submitted','completed','reopen_requested') NOT NULL DEFAULT 'draft',
    submitted_at DATETIME NULL,
    reopen_reason TEXT NULL,
    acknowledged_at DATETIME NULL,
    UNIQUE (period_id, evaluatee_id),
    FOREIGN KEY (period_id) REFERENCES evaluation_periods(id) ON DELETE CASCADE,
    FOREIGN KEY (form_id) REFERENCES evaluation_forms(id),
    FOREIGN KEY (evaluatee_id) REFERENCES users(id)
);

CREATE TABLE self_assessments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evaluation_id INT NOT NULL,
    indicator_id INT NOT NULL,
    detail TEXT NULL,
    self_score TINYINT NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (evaluation_id, indicator_id),
    FOREIGN KEY (evaluation_id) REFERENCES evaluations(id) ON DELETE CASCADE,
    FOREIGN KEY (indicator_id) REFERENCES indicators(id) ON DELETE CASCADE
);

CREATE TABLE evidences (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evaluation_id INT NOT NULL,
    indicator_id INT NOT NULL,
    evidence_type ENUM('file','url') NOT NULL,
    file_path VARCHAR(255) NULL,
    original_name VARCHAR(255) NULL,
    url VARCHAR(500) NULL,
    uploaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (evaluation_id) REFERENCES evaluations(id) ON DELETE CASCADE,
    FOREIGN KEY (indicator_id) REFERENCES indicators(id) ON DELETE CASCADE
);

CREATE TABLE committee_assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evaluation_id INT NOT NULL,
    evaluator_id INT NOT NULL,
    committee_role ENUM('chair','member') NOT NULL DEFAULT 'member',
    overall_comment TEXT NULL,
    signature_path VARCHAR(255) NULL,
    signed_at DATETIME NULL,
    UNIQUE (evaluation_id, evaluator_id),
    FOREIGN KEY (evaluation_id) REFERENCES evaluations(id) ON DELETE CASCADE,
    FOREIGN KEY (evaluator_id) REFERENCES users(id)
);

CREATE TABLE scores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT NOT NULL,
    indicator_id INT NOT NULL,
    score TINYINT NOT NULL,
    comment TEXT NULL,
    scored_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (assignment_id, indicator_id),
    FOREIGN KEY (assignment_id) REFERENCES committee_assignments(id) ON DELETE CASCADE,
    FOREIGN KEY (indicator_id) REFERENCES indicators(id) ON DELETE CASCADE
);

CREATE TABLE grade_levels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    min_percent DECIMAL(5,2) NOT NULL
);

