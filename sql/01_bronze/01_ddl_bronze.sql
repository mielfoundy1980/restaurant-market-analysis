USE db_restaurant_ratings;

-- Désactiver temporairement la vérification des clés étrangères
SET FOREIGN_KEY_CHECKS = 0;

-- ---------------------------------------------------------
-- 1. DIMENSION CONSUMERS (BRONZE)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS 1_bronze_dim_consumers;
CREATE TABLE 1_bronze_dim_consumers
(
	consumer_id VARCHAR(50) PRIMARY KEY,
	city VARCHAR(100),
	state VARCHAR(100),
	country VARCHAR(100),
	latitude VARCHAR(50),
	longitude VARCHAR(50),
	smoker VARCHAR(50),
	drink_level VARCHAR(50),
	transportation_method VARCHAR(50),
	marital_status VARCHAR(50),
	children VARCHAR(50),
	age VARCHAR(50),
	occupation VARCHAR(100),
	budget VARCHAR(50)
);

-- ---------------------------------------------------------
-- 2. DIMENSION CONSUMER PREFERENCES (BRONZE)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS 2_bronze_dim_consumer_preferences;
CREATE TABLE 2_bronze_dim_consumer_preferences
(
	preference_id INT PRIMARY KEY AUTO_INCREMENT,
	consumer_id VARCHAR(50),
	preferred_cuisine VARCHAR(100),
	CONSTRAINT fk_consumer_pref FOREIGN KEY (consumer_id) REFERENCES 1_bronze_dim_consumers(consumer_id)
);

-- ---------------------------------------------------------
-- 3. DIMENSION RESTAURANTS (BRONZE)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS 3_bronze_dim_restaurants;
CREATE TABLE 3_bronze_dim_restaurants
(
	restaurant_id VARCHAR(50) PRIMARY KEY,
	`name` VARCHAR(255), -- MODIFICATION ICI : Passé à 255 caractères
	city VARCHAR(100),
	state VARCHAR(100),
	country VARCHAR(100),
	zip_code VARCHAR(50),
	latitude VARCHAR(50),
	longitude VARCHAR(50),
	alcohol_service VARCHAR(50),
	smoking_allowed VARCHAR(50),
	price VARCHAR(50),
	franchise VARCHAR(50),
	`area` VARCHAR(50),
	parking VARCHAR(50)
);

-- ---------------------------------------------------------
-- 4. DIMENSION RESTAURANT CUISINES (BRONZE)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS 4_bronze_dim_restaurant_cuisines;
CREATE TABLE 4_bronze_dim_restaurant_cuisines
(
	cuisine_id INT PRIMARY KEY AUTO_INCREMENT,
	restaurant_id VARCHAR(50),
	cuisine VARCHAR(100),
	CONSTRAINT fk_restaurant_cuisine FOREIGN KEY (restaurant_id) REFERENCES 3_bronze_dim_restaurants(restaurant_id)
);

-- ---------------------------------------------------------
-- 5. FACT RATINGS (BRONZE)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS 5_bronze_fact_ratings;
CREATE TABLE 5_bronze_fact_ratings
(
	rating_id INT PRIMARY KEY AUTO_INCREMENT,
	consumer_id VARCHAR(50),
	restaurant_id VARCHAR(50),
	overall_rating VARCHAR(50),
	food_rating VARCHAR(50),
	service_rating VARCHAR(50),
	CONSTRAINT fk_consumer_rating FOREIGN KEY (consumer_id) REFERENCES 1_bronze_dim_consumers(consumer_id),
	CONSTRAINT fk_restaurant_rating FOREIGN KEY (restaurant_id) REFERENCES 3_bronze_dim_restaurants(restaurant_id)
);

-- Réactiver la vérification des clés étrangères
SET FOREIGN_KEY_CHECKS = 1;
