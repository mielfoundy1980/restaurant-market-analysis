USE db_restaurant_ratings;

-- Désactiver temporairement la vérification des clés étrangères
SET FOREIGN_KEY_CHECKS = 0;

-- ---------------------------------------------------------
-- 1. DIMENSION CONSUMERS (SILVER)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS 11_silver_dim_consumers;
CREATE TABLE 11_silver_dim_consumers (
	consumer_id VARCHAR(50) PRIMARY KEY,
	city VARCHAR(100),
	state VARCHAR(100),
	country VARCHAR(100),
	latitude DECIMAL(12, 9),
	longitude DECIMAL(12, 9),
	smoker VARCHAR(50),
	drink_level VARCHAR(50),
	transportation_method VARCHAR(50),
	marital_status VARCHAR(50),
	children VARCHAR(50),
	age INT,
	occupation VARCHAR(100),
	budget VARCHAR(50)
);

INSERT INTO 11_silver_dim_consumers
SELECT
	TRIM(consumer_id),
	TRIM(city),
	TRIM(state),
	TRIM(country),
	CAST(TRIM(latitude) AS DECIMAL(12, 9)),
	CAST(TRIM(longitude) AS DECIMAL(12, 9)),
	COALESCE(TRIM(smoker), 'Unknown') AS smoker,
	TRIM(drink_level),
	COALESCE(TRIM(transportation_method), 'Unknown') AS transportation_method,
	COALESCE(TRIM(marital_status), 'Unknown') AS marital_status,
	COALESCE(TRIM(children), 'Unknown') AS children,
	CAST(TRIM(age) AS SIGNED),
	COALESCE(TRIM(occupation), 'Unknown') AS occupation,
	COALESCE(TRIM(budget), 'Unknown') AS budget
FROM 1_bronze_dim_consumers;


-- ---------------------------------------------------------
-- 2. DIMENSION CONSUMER PREFERENCES (SILVER)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS 21_silver_dim_consumer_preferences;
CREATE TABLE 21_silver_dim_consumer_preferences (
	preference_id INT PRIMARY KEY AUTO_INCREMENT,
	consumer_id VARCHAR(50),
	preferred_cuisine VARCHAR(100),
	CONSTRAINT fk_silver_consumer_pref FOREIGN KEY (consumer_id) REFERENCES 11_silver_dim_consumers(consumer_id)
);

INSERT INTO 21_silver_dim_consumer_preferences (preference_id, consumer_id, preferred_cuisine)
SELECT 
	preference_id,
	TRIM(consumer_id),
	TRIM(preferred_cuisine)
FROM 2_bronze_dim_consumer_preferences;


-- ---------------------------------------------------------
-- 3. DIMENSION RESTAURANTS (SILVER)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS 31_silver_dim_restaurants;
CREATE TABLE 31_silver_dim_restaurants (
	restaurant_id VARCHAR(50) PRIMARY KEY,
	restaurant_name VARCHAR(255),
	city VARCHAR(100),
	state VARCHAR(100),
	country VARCHAR(100),
	zip_code VARCHAR(50),
	latitude DECIMAL(12, 9),
	longitude DECIMAL(12, 9),
	alcohol_service VARCHAR(50),
	smoking_allowed VARCHAR(50),
	price VARCHAR(50),
	franchise VARCHAR(50),
	restaurant_area VARCHAR(50),
	parking VARCHAR(50)
);

INSERT INTO 31_silver_dim_restaurants
SELECT
	TRIM(restaurant_id),
	TRIM(`name`),
	TRIM(city),
	TRIM(state),
	TRIM(country),
	COALESCE(REPLACE(TRIM(zip_code), '.0', ''), 'Not available'),
	CAST(TRIM(latitude) AS DECIMAL(12, 9)),
	CAST(TRIM(longitude) AS DECIMAL(12, 9)),
	COALESCE(TRIM(alcohol_service), 'No alcohol'),
	TRIM(smoking_allowed),
	TRIM(price),
	TRIM(franchise),
	TRIM(`area`),
	COALESCE(TRIM(parking), 'Unknown')
FROM 3_bronze_dim_restaurants;


-- ---------------------------------------------------------
-- 4. DIMENSION RESTAURANT CUISINES (SILVER)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS 41_silver_dim_restaurant_cuisines;
CREATE TABLE 41_silver_dim_restaurant_cuisines (
	cuisine_id INT PRIMARY KEY AUTO_INCREMENT,
	restaurant_id VARCHAR(50),
	cuisine VARCHAR(100),
	CONSTRAINT fk_silver_restaurant_cuisine FOREIGN KEY (restaurant_id) REFERENCES 31_silver_dim_restaurants(restaurant_id)
);

INSERT INTO 41_silver_dim_restaurant_cuisines (cuisine_id, restaurant_id, cuisine)
SELECT
	cuisine_id,
	TRIM(restaurant_id),
	TRIM(cuisine)
FROM 4_bronze_dim_restaurant_cuisines;


-- ---------------------------------------------------------
-- 5. FACT RATINGS (SILVER)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS 51_silver_fact_ratings;
CREATE TABLE 51_silver_fact_ratings (
	rating_id INT PRIMARY KEY AUTO_INCREMENT,
	consumer_id VARCHAR(50),
	restaurant_id VARCHAR(50),
	overall_rating INT,
	overall_rating_label VARCHAR(50),
	food_rating INT,
	food_rating_label VARCHAR(50),
	service_rating INT,
	service_rating_label VARCHAR(50),
	CONSTRAINT fk_silver_consumer_rating FOREIGN KEY (consumer_id) REFERENCES 11_silver_dim_consumers(consumer_id),
	CONSTRAINT fk_silver_restaurant_rating FOREIGN KEY (restaurant_id) REFERENCES 31_silver_dim_restaurants(restaurant_id)
);

INSERT INTO 51_silver_fact_ratings (rating_id, consumer_id, restaurant_id, overall_rating, overall_rating_label, food_rating, food_rating_label, service_rating, service_rating_label)
SELECT
	rating_id,
	TRIM(consumer_id),
	TRIM(restaurant_id),
	CAST(overall_rating AS SIGNED),
	CASE
		WHEN CAST(overall_rating AS SIGNED) = 2 THEN 'Highly Satisfactory'
		WHEN CAST(overall_rating AS SIGNED) = 1 THEN 'Satisfactory'
		ELSE 'Unsatisfactory'
	END,
	CAST(food_rating AS SIGNED),
	CASE
		WHEN CAST(food_rating AS SIGNED) = 2 THEN 'Highly Satisfactory'
		WHEN CAST(food_rating AS SIGNED) = 1 THEN 'Satisfactory'
		ELSE 'Unsatisfactory'
	END,
	CAST(service_rating AS SIGNED),
	CASE
		WHEN CAST(service_rating AS SIGNED) = 2 THEN 'Highly Satisfactory'
		WHEN CAST(service_rating AS SIGNED) = 1 THEN 'Satisfactory'
		ELSE 'Unsatisfactory'
	END
FROM 5_bronze_fact_ratings;

-- Réactiver la vérification des clés étrangères
SET FOREIGN_KEY_CHECKS = 1;
