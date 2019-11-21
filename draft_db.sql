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
  `Id` VARCHAR(5) NOT NULL,
  `Name` VARCHAR(45) NULL,
  `Number_of_room` INT NULL,
  `Max_number_of_residence` INT NULL,
  `Description` VARCHAR(45) NULL,
  `Admin_SSN` VARCHAR(13) NULL,
  `Electricity_rate` DOUBLE NULL,
  `Water_rate` DOUBLE NULL,
  `Room_rate` DOUBLE NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`ROOM`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `dorm`.`ROOM` (
  `Room_number` VARCHAR(5) NOT NULL,
  `Dormitory_Id` VARCHAR(5) NOT NULL,
  `Water_used` DOUBLE NULL,
  `Electricity_used` DOUBLE NULL,

  PRIMARY KEY (`Room_number`),
  

  
  CONSTRAINT `fk_ROOM_DORMITORY`
    FOREIGN KEY (`Dormitory_Id`)
    REFERENCES `dorm`.`DORMITORY` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`FURNITURE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`FURNITURE` (
  `Id` VARCHAR(5) NOT NULL,
  `type` VARCHAR(45) NULL,
  `status` VARCHAR(45) NULL,
  `Room_number` VARCHAR(5) NOT NULL,
  `Dormitory_id` VARCHAR(5) NOT NULL,
  
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
  `Degree_of_education` VARCHAR(45) NULL,
  `SSN` VARCHAR(13) NOT NULL,
  `University_entry` VARCHAR(6) NULL,  /*`semester_year eg. 012019`*/
  `First_name` VARCHAR(45) NOT NULL,
  `Last_name` VARCHAR(45) NOT NULL, 
  `Birthdate` DATE NULL,
  `Phone_number` VARCHAR(10) NULL,
  `Address` VARCHAR(200)  NULL,
  `Account_number`  VARCHAR(10) NULL,
  
  `Room_number` VARCHAR(5) NOT NULL,
  `Dormitory_id` VARCHAR(5) NOT NULL,

  PRIMARY KEY (`Id`),
  CONSTRAINT `fk_STUDENT_ROOM1`
    FOREIGN KEY (`Room_number`)
    REFERENCES `dorm`.`ROOM` (`Room_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`PARENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`PARENT` (
  `SSN` VARCHAR(13) NOT NULL,
  `First_name` VARCHAR(45) NULL,
  `Last_name` VARCHAR(45) NULL,
  `Phone_number` VARCHAR(10) NULL,
  `Student_id` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`SSN`),
  INDEX `fk_PARENT_STUDENT1_idx` (`Student_id` ASC) VISIBLE,
  CONSTRAINT `fk_PARENT_STUDENT1`
    FOREIGN KEY (`Student_id`)
    REFERENCES `dorm`.`STUDENT` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`EMPLOYEE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`EMPLOYEE` (
  `SSN` VARCHAR(13) NOT NULL,
  `First_name` VARCHAR(45) NULL,
  `Last_name` VARCHAR(45) NULL,
  `Position` VARCHAR(45) NULL,
  `Phone_number` INT NULL,
  `Birthdate` DATE NULL,
  `Address` VARCHAR(45) NULL,
  `Start_date` DATE NULL,
  `Dormitory_Id` VARCHAR(5) NOT NULL,     /* incompatible if use another type */
  PRIMARY KEY (`SSN`),
  CONSTRAINT `fk_EMPLOYEE_DORMITORY1`
    FOREIGN KEY (`Dormitory_Id`)
    REFERENCES `dorm`.`DORMITORY` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `em_dorm`
ON `dorm`.`EMPLOYEE` (`Dormitory_Id`);


-- -----------------------------------------------------
-- Table `dorm`.`ACTIVITY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`ACTIVITY` (
  `Id` VARCHAR(5) NOT NULL,
  `Date` Date NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Semester` VARCHAR(45) NOT NULL,
  `Description` VARCHAR(45) NULL,
  `Point` INT NULL,
  `Max_number_of_student` INT NULL,
  PRIMARY KEY (`Id`,`Date`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`VISITOR`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `dorm`.`VISITOR` (
  `SSN` VARCHAR(13) NOT NULL,
  `First_name` VARCHAR(45) NULL,
  `Last_name` VARCHAR(45) NULL,
  `Phone_number` INT NULL,
  `Relation` VARCHAR(45) NULL,
  `Date` DATE NOT NULL,
  `Reason` VARCHAR(45) NULL,
  `Student_id` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`SSN`,`Date`),
  
  INDEX `fk_VISITOR_STUDENT1_idx` (`Student_id` ASC) VISIBLE,
  CONSTRAINT `fk_VISITOR_STUDENT1`
    FOREIGN KEY (`Student_id`)
    REFERENCES `dorm`.`STUDENT` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`PAYMENT_HISTORY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`PAYMENT_HISTORY` (
  `Invoice_id` VARCHAR(5) NOT NULL,
  `Status` VARCHAR(45) NULL,
  `Student_id` VARCHAR(10) NOT NULL,
  `Electricity_cost` DOUBLE NULL,
  `Water_cost` DOUBLE NULL,
  `Room_rental` DOUBLE NULL,
  `Date_time_inform` DATETIME NULL,
  `Date_time_paid` DATETIME NULL,
  `Month_year` VARCHAR(45) NULL,
  PRIMARY KEY (`Invoice_id`),
  INDEX `fk_PAYMENT_HISTORY_STUDENT1_idx` (`Student_id` ASC) VISIBLE,
  CONSTRAINT `fk_PAYMENT_HISTORY_STUDENT1`
    FOREIGN KEY (`Student_id`)
    REFERENCES `dorm`.`STUDENT` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`WORK_HISTORY`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `dorm`.`WORK_HISTORY` (
  `Employee_SSN` VARCHAR(13) NOT NULL,
  `Position` VARCHAR(45) NULL,
  `Start_date` DATE NOT NULL,
  `End_date` DATE NULL,
  `Dormitory_id` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`Employee_SSN`, `Start_date`),
 
  CONSTRAINT `fk_WORK_HISTORY_EMPLOYEE1`
    FOREIGN KEY (`Employee_SSN`)
    REFERENCES `dorm`.`EMPLOYEE` (`SSN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_WORK_HISTORY_DORMITORY1`
    FOREIGN KEY (`Dormitory_id`)
    REFERENCES `dorm`.`DORMITORY` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`ATTEND_HISTORY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`ATTEND_HISTORY` (
  `Date_time` DATETIME NOT NULL,
  `Type` VARCHAR(45) NULL,
  `Student_id` VARCHAR(10) NOT NULL,
  
  
  PRIMARY KEY (`Date_time`,`Student_id`),
  
  /*INDEX `fk_ATTEND_HISTORY_STUDENT1_Idx` (`Student_id` ASC, `STUDENT_Room_number` ASC) VISIBLE, */
  CONSTRAINT `fk_ATTEND_HISTORY_STUDENT1`
    FOREIGN KEY (`Student_id` )
    REFERENCES `dorm`.`STUDENT` ( `Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`REQUEST_HISTORY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`REQUEST_HISTORY` (
  `Id` VARCHAR(5) NOT NULL,
  `Date_time` DATETIME NULL,
  `Type` VARCHAR(45) NULL,
  `Status` VARCHAR(45) NULL,
  `Description` VARCHAR(45) NULL,
  `Student_id` VARCHAR(10) NOT NULL,
  `Employee_SSN` VARCHAR(13) NOT NULL,
  
  PRIMARY KEY (`Id`),
  INDEX `fk_REQUEST_HISTORY_STUDENT1_idx` (`Student_id` ASC) VISIBLE,
  /*INDEX `fk_REQUEST_HISTORY_EMPLOYEE1_idx` (`EMPLOYEE_SSN` ASC, `EMPLOYEE_DORMITORY_Id` ASC) VISIBLE, */
  CONSTRAINT `fk_REQUEST_HISTORY_STUDENT1`
    FOREIGN KEY (`Student_id`)
    REFERENCES `dorm`.`STUDENT` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_REQUEST_HISTORY_EMPLOYEE1`
    FOREIGN KEY (`Employee_SSN`)
    REFERENCES `dorm`.`EMPLOYEE` (`SSN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dorm`.`ACTIVITY_HISTORY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dorm`.`ACTIVITY_HISTORY` (
  `Date_time` DATE NOT NULL,
  `Student_id` VARCHAR(10) NOT NULL,
  `Activity_id` VARCHAR(5) NOT NULL,
  `Status` VARCHAR(5) NULL,

  PRIMARY KEY (`Date_time`, `Student_id`, `Activity_id`),

  
  CONSTRAINT `fk_ACTIVITY_HISTORY_STUDENT1`
    FOREIGN KEY (`Student_id`)
    REFERENCES `dorm`.`STUDENT` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    
  CONSTRAINT `fk_ACTIVITY_HISTORY_ACTIVITY1`
    FOREIGN KEY (`Activity_id`,`Date_time`)
    REFERENCES `dorm`.`ACTIVITY` (`Id`,`Date`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;





