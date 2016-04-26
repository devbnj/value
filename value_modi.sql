DROP TABLE IF EXISTS pword_temp;
CREATE TABLE IF NOT EXISTS pword_temp SELECT * FROM pword;
ALTER TABLE pword ADD table_owner VARCHAR(50), ADD role VARCHAR(20), ADD responsibility VARCHAR(20);
                                 
