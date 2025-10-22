-- V41__add_image_url_to_companies.sql
ALTER TABLE companies
    ADD COLUMN image_url VARCHAR(255);