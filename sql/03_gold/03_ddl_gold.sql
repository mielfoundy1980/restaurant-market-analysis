USE db_restaurant_ratings;

-- Performance des Restaurants:

DROP VIEW IF EXISTS 6_gold_restaurant_performance;

CREATE VIEW 6_gold_restaurant_performance AS
SELECT 
    r.restaurant_id,
    r.restaurant_name AS restaurant_name,
    r.city,
    r.state,
    r.smoking_allowed,
    r.price,
    -- Concaténation des cuisines pour éviter la duplication des lignes dans le dashboard (ex: "Mexican, Burgers")
    GROUP_CONCAT(DISTINCT rc.cuisine ORDER BY rc.cuisine ASC SEPARATOR ', ') AS cuisines_offered,
    
    -- Métriques pré-calculées
    COUNT(f.rating_id) AS total_reviews,
    ROUND(AVG(f.overall_rating), 2) AS avg_overall_rating,
    ROUND(AVG(f.food_rating), 2) AS avg_food_rating,
    ROUND(AVG(f.service_rating), 2) AS avg_service_rating,
    
    -- KPI d'Excellence (Taux de notes parfaites = 2)
    ROUND((SUM(CASE WHEN f.overall_rating = 2 THEN 1 ELSE 0 END) * 100.0) / NULLIF(COUNT(f.rating_id), 0), 2) AS pct_excellence

FROM 31_silver_dim_restaurants r
LEFT JOIN 41_silver_dim_restaurant_cuisines rc 
    ON r.restaurant_id = rc.restaurant_id
LEFT JOIN 51_silver_fact_ratings f 
    ON r.restaurant_id = f.restaurant_id
GROUP BY 
    r.restaurant_id,
    r.restaurant_name,
    r.city,
    r.state,
    r.smoking_allowed,
    r.price;

-- Analyse du Comportement Consommateur:
DROP VIEW IF EXISTS 61_gold_consumer_behavior;

CREATE VIEW 61_gold_consumer_behavior AS
SELECT 
    c.consumer_id,
    c.city AS consumer_city,
    c.occupation,
    c.age,
    c.smoker AS is_smoker,
    c.transportation_method,
    c.budget,
    
    -- Volume d'activité du consommateur
    COUNT(f.rating_id) AS total_ratings_given,
    
    -- Tendance de notation (Est-il un critique sévère ou généreux ?)
    ROUND(AVG(f.overall_rating), 2) AS avg_rating_given,
    
    -- Préférence de cuisine la plus fréquente du consommateur (si disponible dans une table de préférences)
    GROUP_CONCAT(DISTINCT cp.preferred_cuisine ORDER BY cp.preferred_cuisine ASC SEPARATOR ', ') AS preferred_cuisines

FROM 11_silver_dim_consumers c
LEFT JOIN 51_silver_fact_ratings f 
    ON c.consumer_id = f.consumer_id
LEFT JOIN 21_silver_dim_consumer_preferences cp 
    ON c.consumer_id = cp.consumer_id
GROUP BY 
    c.consumer_id,
    c.city,
    c.occupation,
    c.age,
    c.smoker,
    c.transportation_method,
    c.budget;

-- Opportunités de Marché (Gap Analysis):
DROP VIEW IF EXISTS 62_gold_market_opportunities;

CREATE VIEW 62_gold_market_opportunities AS
SELECT 
    rc.cuisine AS cuisine_category,
    
    -- L'OFFRE
    COUNT(DISTINCT r.restaurant_id) AS supply_total_restaurants,
    
    -- LA DEMANDE
    COUNT(f.rating_id) AS demand_total_interactions,
    
    -- LA SATISFACTION (Taux de conversion 2/2)
    ROUND((SUM(CASE WHEN f.overall_rating = 2 THEN 1 ELSE 0 END) * 100.0) / NULLIF(COUNT(f.rating_id), 0), 2) AS excellence_ratio,
    
    -- SCORE D'OPPORTUNITÉ (Formule métier : Haute satisfaction / Faible concurrence)
    -- On multiplie le ratio d'excellence par un coefficient inversé de l'offre
    ROUND(
        ((SUM(CASE WHEN f.overall_rating = 2 THEN 1 ELSE 0 END) * 100.0) / NULLIF(COUNT(f.rating_id), 0)) 
        / NULLIF(COUNT(DISTINCT r.restaurant_id), 0), 
    2) AS market_opportunity_score

FROM 41_silver_dim_restaurant_cuisines rc
INNER JOIN 31_silver_dim_restaurants r 
    ON rc.restaurant_id = r.restaurant_id
LEFT JOIN 51_silver_fact_ratings f 
    ON r.restaurant_id = f.restaurant_id
GROUP BY 
    rc.cuisine
HAVING 
    demand_total_interactions >= 10; -- Filtre de pertinence statistique
