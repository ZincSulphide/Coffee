conn sysdba/sysdba as sysdba;
drop user root cascade;
create user root identified by 1234;
grant dba to root;
grant connect to root;
conn root/1234;

set lin 1000;
set pagesize 1000;
SET SERVEROUTPUT ON;

CREATE DATABASE COFFEE;
USE COFFEE;

CREATE TABLE ADMIN(
    USERNAME VARCHAR(50) PRIMARY KEY,
    EMAIL VARCHAR(50),
    PASSWORD VARCHAR(50),
    CONTACT_INFO VARCHAR(50)
);

CREATE TABLE CUSTOMER(
    CUSTOMER_ID INT AUTO_INCREMENT PRIMARY KEY,
    USERNAME VARCHAR(50),
    EMAIL VARCHAR(50),
    PASSWORD VARCHAR(50),
    CUSTOMER_TYPE VARCHAR(50) DEFAULT 'New'
);

CREATE TABLE RESERVATION(
    DATE_TIME DATE,
    PERSON_COUNT INT,
    CUSTOMER_ID INT
);

CREATE TABLE MENU(
    NAME VARCHAR(50) PRIMARY KEY,
    DESCRIPTION VARCHAR(100) NOT NULL,
    PRICE DOUBLE,
    RATING DOUBLE CHECK (RATING >= 0.0),
    PICTURE BLOB
);

CREATE TABLE TRANSACTIONS(
    TRANSACTION_ID INT AUTO_INCREMENT PRIMARY KEY,
    AMOUNT DOUBLE,
    ITEM_PURCHASED VARCHAR(50),
    CUSTOMER_ID INT,
    STATUS VARCHAR(50),
    CONSTRAINT fk FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER (CUSTOMER_ID),
    CONSTRAINT fk2 FOREIGN KEY (ITEM_PURCHASED) REFERENCES MENU (NAME)
);

CREATE TABLE SPECIALS(
    DAY VARCHAR(50) PRIMARY KEY,
    NAME VARCHAR(50),
    CONSTRAINT fk3 FOREIGN KEY (NAME) REFERENCES MENU (NAME)
);

CREATE TABLE INVENTORY(
    NAME VARCHAR(50) PRIMARY KEY,
    QUANTITY INT DEFAULT 0,
    DATE_ADDED DATE,
    LIFE_TIME INT CHECK (LIFE_TIME > 0)
);

CREATE SEQUENCE CUSTOMER_ID_GENERATOR
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE TRANSACTION_ID_GENERATOR
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE TRIGGER CUSTOMER_TRIGGER
BEFORE INSERT ON CUSTOMER
FOR EACH ROW
BEGIN
   SELECT CUSTOMER_ID_GENERATOR.NEXTVAL
   INTO :NEW.CUSTOMER_ID
   FROM dual;
END;
/

CREATE OR REPLACE TRIGGER TRANSACTION_TRIGGER
BEFORE INSERT ON TRANSACTIONS
FOR EACH ROW
BEGIN
   SELECT TRANSACTION_ID_GENERATOR.NEXTVAL
   INTO :NEW.TRANSACTION_ID
   FROM dual;
END;
/

DELIMITER //

CREATE PROCEDURE REMOVE_EXPIRED_ITEMS()
BEGIN
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE expired_item_name VARCHAR(255);

    -- Declare a cursor for the SELECT statement
    DECLARE expired_items_cursor CURSOR FOR
        SELECT NAME
        FROM INVENTORY
        WHERE DATE_ADDED + INTERVAL LIFE_TIME DAY < NOW();

    -- Declare an exception handler to exit the loop when no more rows are found
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open the cursor
    OPEN expired_items_cursor;

    -- Start a loop to fetch and delete expired items
    expired_items_loop: LOOP
        -- Fetch the next row into the variables
        FETCH expired_items_cursor INTO expired_item_name;

        -- Check if no more rows
        IF done THEN
            LEAVE expired_items_loop;
        END IF;

        -- Delete the expired item
        DELETE FROM INVENTORY WHERE NAME = expired_item_name;
        -- You can uncomment the following line if you want to print a message
        -- SELECT CONCAT('Removed expired item: ', expired_item_name) AS Message;

    END LOOP;

    -- Close the cursor
    CLOSE expired_items_cursor;

    -- Commit the changes
    COMMIT;
END //

DELIMITER ;

--oracle
CREATE OR REPLACE TRIGGER check_reservation_limit
BEFORE INSERT ON RESERVATION
FOR EACH ROW
DECLARE
    total_person_count INT;
BEGIN
    -- Calculate the total person count for the given customer
    SELECT COALESCE(SUM(PERSON_COUNT), 0) -- returns first non-null value
    INTO total_person_count
    FROM RESERVATION
    WHERE CUSTOMER_ID = :NEW.CUSTOMER_ID;

    -- Check if the new reservation will exceed the limit of 100 persons
    IF (total_person_count + :NEW.PERSON_COUNT) > 100 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Exceeded maximum allowed person count (100) for the customer.');
    END IF;
    
END;
/

--mysql
DELIMITER //
CREATE TRIGGER check_reservation_limit BEFORE INSERT ON RESERVATION
FOR EACH ROW
BEGIN
    DECLARE total_person_count INT;

    -- Calculate the total person count for the given customer
    SELECT COALESCE(SUM(PERSON_COUNT), 0)
    INTO total_person_count
    FROM RESERVATION
    WHERE CUSTOMER_ID = NEW.CUSTOMER_ID;

    -- Check if the new reservation will exceed the limit of 100 persons
    IF (total_person_count + NEW.PERSON_COUNT) > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Exceeded maximum allowed person count (100) for the customer.';
    END IF;
END;
//
DELIMITER ;



DELIMITER //

CREATE TRIGGER update_customer_type_trigger
AFTER INSERT ON TRANSACTIONS
FOR EACH ROW
BEGIN
    DECLARE total_spending DOUBLE;
    DECLARE total_transactions INT;

    -- Calculate the total spending for the customer
    SELECT SUM(t.AMOUNT * m.PRICE)
    INTO total_spending
    FROM TRANSACTIONS t
    JOIN MENU m ON t.ITEM_PURCHASED = m.NAME
    WHERE t.CUSTOMER_ID = NEW.CUSTOMER_ID;

    -- Calculate the total number of transactions for the customer
    SELECT COUNT(*)
    INTO total_transactions
    FROM TRANSACTIONS
    WHERE CUSTOMER_ID = NEW.CUSTOMER_ID;

    -- Check conditions for updating customer type
    IF total_spending > 10000 AND total_transactions > 5 THEN
        UPDATE CUSTOMER
        SET CUSTOMER_TYPE = 'Regular'
        WHERE CUSTOMER_ID = NEW.CUSTOMER_ID;
    END IF;
END //

DELIMITER ;
