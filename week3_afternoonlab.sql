CREATE TABLE `address` (
  `address_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(50) NOT NULL,
  `district` VARCHAR(20) NOT NULL,
  `city_id` SMALLINT NOT NULL,
  `postal_code` VARCHAR(10) DEFAULT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `last_update` TIMESTAMP
);

CREATE TABLE `city` (
  `city_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `city` VARCHAR(50) NOT NULL,
  `country_id` SMALLINT NOT NULL,
  `last_update` TIMESTAMP
);

CREATE TABLE `country` (
  `country_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `country` VARCHAR(50) NOT NULL,
  `last_update` TIMESTAMP
);

CREATE TABLE `customer` (
  `customer_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `store_id` TINYINT NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(50) DEFAULT NULL,
  `address_id` SMALLINT NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT TRUE,
  `create_date` DATETIME NOT NULL,
  `last_update` TIMESTAMP
);

CREATE TABLE `film` (
  `film_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(128) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `release_year` YEAR DEFAULT NULL,
  `language_id` TINYINT NOT NULL,
  `rental_duration` TINYINT NOT NULL DEFAULT 3,
  `rental_rate` DECIMAL(4,2) NOT NULL DEFAULT 4.99,
  `length` SMALLINT DEFAULT NULL,
  `replacement_cost` DECIMAL(5,2) NOT NULL DEFAULT 19.99,
  `rating` ENUM ('G', 'PG', 'PG-13', 'R', 'NC-17') DEFAULT "G",
  `Trailers` BOOLEAN NOT NULL DEFAULT TRUE,
  `Commentaries` BOOLEAN NOT NULL DEFAULT TRUE,
  `Deleted Scenes` BOOLEAN NOT NULL DEFAULT TRUE,
  `Behind The Scene` BOOLEAN NOT NULL DEFAULT TRUE,
  `last_update` TIMESTAMP
);

CREATE TABLE `film_actor` (
  `actor_id` SMALLINT NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `film_id` SMALLINT NOT NULL,
  `last_update` TIMESTAMP,
  PRIMARY KEY (`actor_id`, `film_id`)
);

CREATE TABLE `film_category` (
  `film_id` SMALLINT NOT NULL,
  `category_id` TINYINT NOT NULL,
  `last_update` TIMESTAMP,
  `name` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`film_id`)
);

CREATE TABLE `inventory` (
  `inventory_id` MEDIUMINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `film_id` SMALLINT NOT NULL,
  `store_id` TINYINT NOT NULL,
  `last_update` TIMESTAMP
);

CREATE TABLE `language` (
  `language_id` TINYINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `name` CHAR(20) NOT NULL,
  `last_update` TIMESTAMP
);

CREATE TABLE `payment` (
  `payment_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `customer_id` SMALLINT NOT NULL,
  `staff_id` TINYINT NOT NULL,
  `rental_id` INT DEFAULT NULL,
  `amount` DECIMAL(5,2) NOT NULL,
  `payment_date` DATETIME NOT NULL,
  `last_update` TIMESTAMP
);

CREATE TABLE `rental` (
  `rental_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `rental_date` DATETIME NOT NULL,
  `inventory_id` MEDIUMINT NOT NULL,
  `customer_id` SMALLINT NOT NULL,
  `return_date` DATETIME DEFAULT NULL,
  `staff_id` TINYINT NOT NULL,
  `last_update` TIMESTAMP
);

CREATE TABLE `staff` (
  `staff_id` TINYINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `address_id` SMALLINT NOT NULL,
  `picture` BLOB DEFAULT NULL,
  `email` VARCHAR(50) DEFAULT NULL,
  `store_id` TINYINT NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT TRUE,
  `username` VARCHAR(16) NOT NULL,
  `password` VARCHAR(40) DEFAULT NULL,
  `last_update` TIMESTAMP
);

CREATE TABLE `store` (
  `store_id` TINYINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `manager_staff_id` TINYINT NOT NULL,
  `address_id` SMALLINT NOT NULL,
  `last_update` TIMESTAMP
);

ALTER TABLE `address` ADD FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `city` ADD FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `customer` ADD FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `customer` ADD FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `film` ADD FOREIGN KEY (`language_id`) REFERENCES `language` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `film_actor` ADD FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `film_category` ADD FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `inventory` ADD FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `inventory` ADD FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `payment` ADD FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `payment` ADD FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `payment` ADD FOREIGN KEY (`rental_id`) REFERENCES `rental` (`rental_id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `rental` ADD FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`inventory_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `rental` ADD FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `rental` ADD FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `staff` ADD FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `staff` ADD FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `store` ADD FOREIGN KEY (`manager_staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `store` ADD FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

CREATE INDEX `idx_fk_city_id` ON `address` (`city_id`);

CREATE INDEX `idx_fk_country_id` ON `city` (`country_id`);

CREATE INDEX `idx_fk_store_id` ON `customer` (`store_id`);

CREATE INDEX `idx_fk_address_id` ON `customer` (`address_id`);

CREATE INDEX `idx_last_name` ON `customer` (`last_name`);

CREATE INDEX `idx_title` ON `film` (`title`);

CREATE INDEX `idx_fk_language_id` ON `film` (`language_id`);

CREATE INDEX `idx_fk_film_id` ON `film_actor` (`film_id`);

CREATE INDEX `idx_fk_film_id` ON `inventory` (`film_id`);

CREATE INDEX `idx_store_id_film_id` ON `inventory` (`store_id`, `film_id`);

CREATE INDEX `idx_fk_staff_id` ON `payment` (`staff_id`);

CREATE INDEX `idx_fk_customer_id` ON `payment` (`customer_id`);

CREATE UNIQUE INDEX `rental_index_14` ON `rental` (`rental_date`, `inventory_id`, `customer_id`);

CREATE INDEX `idx_fk_inventory_id` ON `rental` (`inventory_id`);

CREATE INDEX `idx_fk_customer_id` ON `rental` (`customer_id`);

CREATE INDEX `idx_fk_staff_id` ON `rental` (`staff_id`);

CREATE INDEX `idx_fk_store_id` ON `staff` (`store_id`);

CREATE INDEX `idx_fk_address_id` ON `staff` (`address_id`);

CREATE UNIQUE INDEX `idx_unique_manager` ON `store` (`manager_staff_id`);

CREATE INDEX `idx_fk_address_id` ON `store` (`address_id`);
