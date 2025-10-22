-- ======================================================
-- 🔹 Create document_verifications table
-- ======================================================

CREATE TABLE IF NOT EXISTS document_verifications (
    id SERIAL PRIMARY KEY,

    employee_document_id INT NOT NULL,
    version_id INT NOT NULL,
    verified_by INT NOT NULL,
    verified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarks VARCHAR(200),
    status VARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'VERIFIED', 'REJECTED')),

    created_by INT NULL,
    last_modified_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    version INT DEFAULT 1 NOT NULL,

    CONSTRAINT fk_employee_document
        FOREIGN KEY (employee_document_id)
        REFERENCES employee_documents (id)
        ON DELETE CASCADE,

    CONSTRAINT fk_document_version
        FOREIGN KEY (version_id)
        REFERENCES employee_document_versions (id)
        ON DELETE CASCADE,

    CONSTRAINT fk_verified_by
        FOREIGN KEY (verified_by)
        REFERENCES users (id)
        ON DELETE CASCADE
);


-- ======================================================
-- 🔹 Create document_expiry_alerts table
-- ======================================================

CREATE TABLE IF NOT EXISTS document_expiry_alerts (
    id SERIAL PRIMARY KEY,

    employee_document_id INT NOT NULL,
    alert_date TIMESTAMP,
    sent_to INT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL CHECK (status IN ('SCHEDULED', 'SENT', 'FAILED')),

    created_by INT NULL,
    last_modified_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    version INT DEFAULT 1 NOT NULL,

    CONSTRAINT fk_employee_document_alert
        FOREIGN KEY (employee_document_id)
        REFERENCES employee_documents (id)
        ON DELETE CASCADE,

    CONSTRAINT fk_sent_to_user
        FOREIGN KEY (sent_to)
        REFERENCES users (id)
        ON DELETE CASCADE
);
