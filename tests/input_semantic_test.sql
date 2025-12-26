-- 1. Valid query (should PASS)
SELECT id, name FROM users;

-- 2. Invalid column (should FAIL)
SELECT salary FROM users;

-- 3. Type mismatch in INSERT (should FAIL)
INSERT INTO users (id, name) VALUES ('abc', 10);

-- 4. Column count mismatch (should FAIL)
INSERT INTO users (id, name) VALUES (1);

-- 5. Invalid table (should FAIL)
SELECT id FROM employees;

-- 6. Valid query (should PASS)
SELECT age FROM users;
