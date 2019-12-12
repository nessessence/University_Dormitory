SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'; 


CREATE SCHEMA IF NOT EXISTS `dorm` DEFAULT CHARACTER SET utf8 ;
USE `dorm` ;

-- -----------------------------------------------------
-- Schema dorm 
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `dorm`.`DORMITORY`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `dorm`.`DORMITORY` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Number_of_room` INT NOT NULL,
  `Number_of_student` INT NOT NULL,
  `Description` VARCHAR(200),
  `Electricity_rate` DOUBLE NOT NULL,
  `Water_rate` DOUBLE NOT NULL,
  `Room_rate` DOUBLE NOT NULL,
  `Admin_id` VARCHAR(13),
  
  UNIQUE(Name),
  CHECK(Number_of_room > 0),
  CHECK(Number_of_student >= 0),
  CHECK(Electricity_rate > 0),
  CHECK(Water_rate > 0),
  CHECK(Room_rate > 0),
  
  PRIMARY KEY (`Id`),
  
  CONSTRAINT `fk_DORMITORY_ADMIN1`
    FOREIGN KEY (`Admin_id`) REFERENCES `dorm`.`EMPLOYEE` (`Ssn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`ROOM`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `dorm`.`ROOM` (
  `Room_number` INT NOT NULL,
  `Dormitory_id` INT NOT NULL,
  `Water_used` DOUBLE NOT NULL,
  `Electricity_used` DOUBLE NOT NULL,
  
  CHECK(Water_used >= 0),
  CHECK(Electricity_used >= 0),

  PRIMARY KEY (`Room_number`, `Dormitory_id`),

  CONSTRAINT `fk_ROOM_DORMITORY1`
    FOREIGN KEY (`Dormitory_id`) REFERENCES `dorm`.`DORMITORY` (`Id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`FURNITURE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`FURNITURE` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Type` VARCHAR(45) NOT NULL,
  `Status` VARCHAR(45) NOT NULL,
  `Room_number` INT NOT NULL,
  `Dormitory_id` INT NOT NULL,
  
  PRIMARY KEY (`Id`),
  
  CONSTRAINT `fk_FURNITURE_ROOM1`
    FOREIGN KEY (`Room_number`)
    REFERENCES `dorm`.`ROOM` (`Room_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    
  CONSTRAINT `fk_FURNITURE_DORMITORY1`
    FOREIGN KEY (`Dormitory_id`)
    REFERENCES `dorm`.`Dormitory` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
	
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`STUDENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`STUDENT` (
  `Id` VARCHAR(10) NOT NULL,
  `Faculty` VARCHAR(45) NOT NULL,
  `Degree_of_education` VARCHAR(45) NOT NULL,
  `Ssn` VARCHAR(13) NOT NULL,
  `University_entry` VARCHAR(6) NOT NULL,  /*`semester_year eg. 012019`*/
  `First_name` VARCHAR(45) NOT NULL,
  `Last_name` VARCHAR(45) NOT NULL, 
  `Birthdate` DATE NOT NULL,
  `Phone_number` VARCHAR(10) NOT NULL,
  `Room_number` INT NOT NULL,
  `Dormitory_id` INT NOT NULL,
  `Address` VARCHAR(200)  NOT NULL,
  `Account_number`  VARCHAR(10) NOT NULL,
  
  

  CHECK(LENGTH(Id) = 10),
  CHECK(LENGTH(Ssn) = 13),
  CHECK(LENGTH(University_entry) = 6),
  CHECK(LENGTH(Phone_number) = 10),
  CHECK(LENGTH(Account_number) = 10),

  PRIMARY KEY (`Id`),

  CONSTRAINT `fk_STUDENT_ROOM1`
    FOREIGN KEY (`Room_number`) REFERENCES `dorm`.`ROOM` (`Room_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_STUDENT_DORMITORY1`
    FOREIGN KEY (`Dormitory_id`) REFERENCES `dorm`.`Dormitory` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`PARENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`PARENT` (
  `Ssn` VARCHAR(13) NOT NULL,
  `First_name` VARCHAR(45) NOT NULL,
  `Last_name` VARCHAR(45) NOT NULL,
  `Phone_number` VARCHAR(10) NOT NULL,
  `Student_id` VARCHAR(10) NOT NULL,
  
  CHECK(LENGTH(Ssn) = 13),
  CHECK(LENGTH(Phone_number) = 10),

  PRIMARY KEY (`Ssn`),
  
  -- INDEX `fk_PARENT_STUDENT1_idx` (`Student_id` ASC) VISIBLE, ???-- 
  
  CONSTRAINT `fk_PARENT_STUDENT1`
    FOREIGN KEY (`Student_id`) REFERENCES `dorm`.`STUDENT` (`Id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`EMPLOYEE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`EMPLOYEE` (
  `Ssn` VARCHAR(13) NOT NULL,
  `First_name` VARCHAR(45) NOT NULL,
  `Last_name` VARCHAR(45) NOT NULL,
  `Position` VARCHAR(45) NOT NULL,
  `Phone_number` VARCHAR(10) NOT NULL,
  `Birthdate` DATE NOT NULL,
  `Address` VARCHAR(200) NOT NULL,
  `Start_date` DATE NOT NULL,
  `Dormitory_id` INT NULL,     /* incompatible if use another type */
  
  CHECK(LENGTH(Ssn) = 13),
  CHECK(LENGTH(Phone_number) = 10),

  PRIMARY KEY (`Ssn`),
  
  CONSTRAINT `fk_EMPLOYEE_POSITION1`
    FOREIGN KEY (`Position`) REFERENCES `dorm`.`POSITION` (`Position`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    
  CONSTRAINT `fk_EMPLOYEE_DORMITORY1`
    FOREIGN KEY (`Dormitory_id`) REFERENCES `dorm`.`DORMITORY` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- INDEXING Here --
CREATE INDEX `em_dorm`
ON `dorm`.`EMPLOYEE` (`Dormitory_id`);


-- -----------------------------------------------------
-- Table `dorm`.`ACTIVITY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`ACTIVITY` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Date` Date NOT NULL,
  `Semester` VARCHAR(2) NOT NULL,
  `Description` VARCHAR(200),
  `Point` INT NOT NULL,
  `Max_number_of_student` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL, 

  CHECK(LENGTH(Semester) = 2),
  CHECK(Point > 0),
  CHECK(Max_number_of_student > 0),
  
  PRIMARY KEY (`Id`,`Date`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`VISITOR`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `dorm`.`VISITOR` (
  `Ssn` VARCHAR(13) NOT NULL,
  `Date` DATE NOT NULL,
  `Student_id` VARCHAR(10) NOT NULL,
  `First_name` VARCHAR(45) NOT NULL,
  `Last_name` VARCHAR(45) NOT NULL,
  `Relation` VARCHAR(45) NOT NULL,
  `Phone_number` VARCHAR(10) NOT NULL,
  `Reason` VARCHAR(45) NOT NULL,
  
  CHECK(LENGTH(Ssn) = 13),
  CHECK(LENGTH(Phone_number) = 10),
  
  PRIMARY KEY (`Ssn`,`Date`),
  
  -- INDEX `fk_VISITOR_STUDENT1_idx` (`Student_id` ASC) VISIBLE, 
  CONSTRAINT `fk_VISITOR_STUDENT1`
    FOREIGN KEY (`Student_id`)
    REFERENCES `dorm`.`STUDENT` (`Id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`PAYMENT_HISTORY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`PAYMENT_HISTORY` (
  `Invoice_id` INT NOT NULL AUTO_INCREMENT,
  `Status` VARCHAR(45) NOT NULL,
  `Electricity_cost` DOUBLE NOT NULL,
  `Water_cost` DOUBLE NOT NULL,
  `Room_rental` DOUBLE NOT NULL,
  `Date_time_inform` DATETIME NOT NULL,
  `Date_time_paid` DATETIME,
  `Month_year` VARCHAR(6) NOT NULL,
  `Student_id` VARCHAR(10) NOT NULL,
  
  
  CHECK(Electricity_cost > 0),
  CHECK(Water_cost > 0),
  CHECK(Room_rental > 0),
  CHECK(LENGTH(Month_year) = 6),

  PRIMARY KEY (`Invoice_id`),
  
  -- INDEX `fk_PAYMENT_HISTORY_STUDENT1_idx` (`Student_id` ASC) VISIBLE,
  CONSTRAINT `fk_PAYMENT_HISTORY_STUDENT1`
    FOREIGN KEY (`Student_id`)
    REFERENCES `dorm`.`STUDENT` (`Id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`WORK_HISTORY`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `dorm`.`WORK_HISTORY` (
  `Employee_ssn` VARCHAR(13) NOT NULL,
  `Start_date` DATE NOT NULL,
  `Position` VARCHAR(45) NOT NULL,
  `End_date` DATE,
  `Dormitory_id` INT NOT NULL,
  
  PRIMARY KEY (`Employee_ssn`,`Start_date`),
 
  CONSTRAINT `fk_WORK_HISTORY_EMPLOYEE1`
    FOREIGN KEY (`Employee_ssn`) REFERENCES `dorm`.`EMPLOYEE` (`Ssn`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
    
  CONSTRAINT `fk_WORK_HISTORY_POSITION1`
    FOREIGN KEY (`Position`) REFERENCES `dorm`.`POSITION` (`Position`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    
  CONSTRAINT `fk_WORK_HISTORY_DORMITORY1`
    FOREIGN KEY (`Dormitory_id`) REFERENCES `dorm`.`DORMITORY` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`ATTEND_HISTORY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`ATTEND_HISTORY` (
  `Student_id` VARCHAR(10) NOT NULL,
  `Date_time` DATETIME NOT NULL,
  `Type` VARCHAR(45) NOT NULL,
  
  PRIMARY KEY (`Student_id`,`Date_time`),
  
  /*INDEX `fk_ATTEND_HISTORY_STUDENT1_Idx` (`Student_id` ASC, `STUDENT_Room_number` ASC) VISIBLE, */
  CONSTRAINT `fk_ATTEND_HISTORY_STUDENT1`
    FOREIGN KEY (`Student_id` )
    REFERENCES `dorm`.`STUDENT` ( `Id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`REQUEST_HISTORY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`REQUEST_HISTORY` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Date_time` DATETIME NOT NULL,
  `Type` VARCHAR(45) NOT NULL,
  `Status` VARCHAR(45) NOT NULL,
  `Description` VARCHAR(200),
  `Student_id` VARCHAR(10) NOT NULL,
  `Employee_ssn` VARCHAR(13),
  
  PRIMARY KEY (`Id`),
  -- INDEX `fk_REQUEST_HISTORY_STUDENT1_idx` (`Student_id` ASC) VISIBLE,
  /*INDEX `fk_REQUEST_HISTORY_EMPLOYEE1_idx` (`EMPLOYEE_SSN` ASC, `EMPLOYEE_DORMITORY_Id` ASC) VISIBLE, */
  
  CONSTRAINT `fk_REQUEST_HISTORY_STUDENT1`
    FOREIGN KEY (`Student_id`) REFERENCES `dorm`.`STUDENT` (`Id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_REQUEST_HISTORY_EMPLOYEE1`
    FOREIGN KEY (`Employee_ssn`) REFERENCES `dorm`.`EMPLOYEE` (`Ssn`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`STUDENT_ACTIVITY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`STUDENT_ACTIVITY` (
  `Student_id` VARCHAR(10) NOT NULL,
  `Activity_id` INT NOT NULL,
  `Activity_date` DATE NOT NULL,
  `Status` VARCHAR(5) NOT NULL,
  
  PRIMARY KEY (`Student_id`, `Activity_id`, `Activity_date`),
  
  CONSTRAINT `fk_STUDENT_ACTIVITY_STUDENT1`
    FOREIGN KEY (`Student_id`) REFERENCES `dorm`.`STUDENT` (`Id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
    
  CONSTRAINT `fk_STUDENT_ACTIVITY_ACTIVITY1`
    FOREIGN KEY (`Activity_id`,`Activity_date`) REFERENCES `dorm`.`ACTIVITY` (`Id`,`Date`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `dorm`.`POSITION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`POSITION` (
  `Position` VARCHAR(45) NOT NULL,
  `Salary` INT NOT NULL,

  CHECK(Salary >= 0),
  
  PRIMARY KEY (`Position`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- -----------------------------------------------------
-- ADD TRIGGERS FOR INSERT, UPDATE EMPLOYEE
-- -----------------------------------------------------
-- -----------------------------------------------------

DELIMITER $$
CREATE 
	TRIGGER `trg_employee_insert` AFTER INSERT ON `EMPLOYEE`
	FOR EACH ROW BEGIN
		INSERT INTO dorm.WORK_HISTORY
		VALUE (NEW.Ssn, NEW.Start_date, NEW.Position, NULL, NEW.Dormitory_id);
    END$$
    
CREATE 
	TRIGGER `trg_employee_update` AFTER UPDATE ON `EMPLOYEE`
	FOR EACH ROW BEGIN
    
		UPDATE `WORK_HISTORY` 
		SET End_date = CURDATE()  
		WHERE Employee_ssn = NEW.Ssn AND End_date is NULL;
        
        INSERT INTO dorm.WORK_HISTORY
		VALUE (NEW.Ssn, CURDATE(), NEW.Position, NULL, NEW.Dormitory_id);
    END$$

DELIMITER ;

SET SQL_SAFE_UPDATES = 0;



-- -----------------------------------------------------
-- -----------------------------------------------------
-- ADD DATA
-- -----------------------------------------------------
-- -----------------------------------------------------

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT INTO POSITION
VALUE ('Repair Man', '30000'),
	('Officer', '25000');

INSERT INTO DORMITORY
VALUE ('1', 'Chuan Chom', '400', '1200', 'GOOD DORM', '7', '20', '4000', NULL),
	('2', 'Jum Pee', '450', '1350', 'THE DORM THAT BETTER THAN DORM A', '7', '20', '4500', NULL),
    ('3', 'Jum Paa', '500', '1500', 'THE BEST DORM EVER', '7', '20', '5000', NULL),
    ('4', 'Put Tarn', '550', '1650', 'THE BRAND NEW DORM', '7', '20', '5500', NULL),
    ('5', 'Put Sorn', '600', '1800', 'THE BRAND NEW DORM V2', '7', '20', '6000', NULL);
    
INSERT INTO ROOM
VALUE ('110', '1', '10', '200'),
	('210', '1', '10', '200'),
	('310', '1', '10', '200'),
    ('410', '1', '10', '200'),
	('510', '1', '10', '200'),
    ('110', '2', '10', '300'),
	('210', '2', '10', '300'),
	('310', '2', '10', '300'),
    ('410', '2', '10', '300'),
	('510', '2', '10', '300'),
    ('110', '3', '15', '300'),
	('210', '3', '15', '300'),
	('310', '3', '15', '300'),
    ('410', '3', '15', '300'),
	('510', '3', '15', '300'),
    ('110', '4', '15', '300'),
	('210', '4', '15', '300'),
	('310', '4', '15', '300'),
    ('410', '4', '15', '300'),
	('510', '4', '15', '300'),
    ('110', '5', '15', '300'),
	('210', '5', '15', '300'),
	('310', '5', '15', '300'),
    ('410', '5', '15', '300'),
	('510', '5', '15', '300');
    
INSERT INTO EMPLOYEE
VALUE ('1200000000001', 'Maew-a-raikodsao', 'Maewterkordernjakpai', 'Repair Man', '0800000001', '1999-11-01', 'Yak-a-sokhodsus', '2019-11-01', '1'),
	('1200000000002', 'Kai-a-raijaiboon', 'Kaiterdaikabkhaolaewjongchockdee', 'Officer', '0800000002', '1999-11-02', 'Hongnorn', '2019-11-02', '2'),
    ('1200000000003', 'Tum-a-raipaimaitung', 'Tumtooklaewteeterleukkhao', 'Repair Man', '0800000003', '1999-11-03', 'Horngnam', '2019-11-03', '3'),
    ('1200000000004', 'Mee-a-raibokmaidai', 'Meekwamlubteeyunaijai', 'Officer', '0800000004', '1999-11-04', 'Horngnanglen', '2019-11-04', '1'),
    ('1200000000005', 'Hed-a-raingaoteesud', 'Hedkerdjakkwamngao', 'Repair Man', '0800000005', '1999-11-05', 'Hongrean', '2019-11-05', '2'),
    ('1200000000006', 'Norn-a-raikeengao', 'Nornchankoryangnornkondeawyu', 'Officer', '0800000006', '1999-11-06', 'Hongsamoot', '2019-11-06', '3'),
    ('1200000000007', 'Pang-a-raiyunaihongnon', 'Pangpornyornpainaiwanteemeekwamsuk', 'Repair Man', '0800000007', '1999-11-07', 'Hong-a-harn', '2019-11-07', '1'),
    ('1200000000008', 'Chang-a-raikeehuang', 'Changkorrakkhongchangkaojaibangmai', 'Officer', '0800000008', '1999-11-08', 'Hongte', '2019-11-08', '2'),
    ('1200000000009', 'Mai-a-raiyapuak', 'Maitongruwaraokobkanbaebnhai', 'Repair Man', '0800000009', '1999-11-09', 'Hongkong', '2019-11-09', '3'),
    ('1200000000010', 'Pak-a-raipid', 'Pakmaichaiduangdaoteeprawsaeng', 'Officer', '0800000010', '1999-11-10', 'Honghongrodsiapenrainha', '2019-11-10', '1');

INSERT INTO ACTIVITY
VALUE ('1', '2019-12-05', '01', 'Day of god', '5', '100', 'Father Day'),
	('2', '2019-12-11', '01', 'Day of drunk', '10', '200', 'Last Drink');
    
INSERT INTO STUDENT
VALUE ('6000000001', 'ENGINEERING', 'BACHELOR', '1100000000001', '012017', 'Ong', 'Siro', '1999-06-01', '0890000003', '110', '1', 'address', '1111111111'),
	('6000000002', 'ENGINEERING', 'BACHELOR', '1100000000002', '012017', 'Phonw', 'Siro', '1999-06-01', '0890000003', '210', '2', 'address', '1111111111');
    
INSERT INTO FURNITURE
VALUE ('1', 'DESK', 'USING', '210', '2'),
	('2', 'TABLE', 'REPAIRING', '110', '1');

INSERT INTO PARENT
VALUE ('1300000000001', 'First', 'Kung', '0890000001', '6000000001'),
	('1300000000002', 'Faii', 'Kung', '0890000001', '6000000002');
    
INSERT INTO VISITOR
VALUE ('1400000000001', '2019-11-25', '6000000001', 'Khem', 'Kung', 'Mother', '0890000005', 'Very miss him'),
	('1400000000002', '2019-11-25', '6000000002', 'Frong', 'Kung', 'Father', '0890000005', 'Miss him so much');
    
INSERT INTO PAYMENT_HISTORY
VALUE ('1', 'UNPAID', '2000', '200', '4500', '2019-11-22', NULL, '201911', '6000000001'),
	('2', 'PAID', '2000', '200', '4000', '2019-11-22', '2019-11-22', '201911', '6000000002');
    
INSERT INTO REQUEST_HISTORY
VALUE ('1', '2019-11-22', 'VISITOR', 'Approved', 'My mother will come to visit me.', '6000000001', '1200000000001'),
	('2', '2019-11-22', 'MAINTENANCE', 'Rejected', 'My table leg is broken.', '6000000002', '1200000000002');
    
INSERT INTO ATTEND_HISTORY
VALUE ('6000000001', '2019-11-22', 'IN'),
	('6000000002', '2019-11-22', 'OUT');
    
INSERT INTO STUDENT_ACTIVITY
VALUE ('6000000001', '1', '2019-12-05', 'JOIN'),
	('6000000002', '2', '2019-12-11', 'JOIN');