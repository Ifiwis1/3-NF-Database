--Create the database for the food service company
CREATE DATABASE FoodserviceDB
--Switch to the FoodserviceDB database
USE FoodserviceDB; 
GO
--Import the 4 csv files using the import flat file function
--Create the 4 tables (indicating datatypes) for the FoodserviceDB database
--Create restaurants table
CREATE TABLE Restaurant(
Restaurant_ID int NOT NULL PRIMARY KEY,
Name nvarchar(100) NOT NULL,
City nvarchar(50) NOT NULL,
State nvarchar(50) NOT NULL,
Country nvarchar(50) NOT NULL,
Zip_Code nvarchar(10) NULL,
Latitude decimal(10,8) NOT NULL,
Longitude decimal(11,8) NOT NULL,
Alcohol_Service nvarchar(50) NOT NULL,
Smoking_Allowed nvarchar(50) NOT NULL,
Price nvarchar(50) NOT NULL,
Franchise varchar(10) NOT NULL,
Area nvarchar(50) NOT NULL,
Parking nvarchar(50) NOT NULL);

--Create the consumers table
CREATE TABLE Consumers(
Consumer_ID nvarchar(50) NOT NULL PRIMARY KEY,
City nvarchar(50) NOT NULL,
State nvarchar(50) NOT NULL,
Country nvarchar(50) NOT NULL,
Latitude decimal(10,8) NOT NULL,
Longitude decimal(11,8) NOT NULL,
Smoker varchar(5) NULL,
Drink_Level varchar(50) NOT NULL,
Transportation_Method nvarchar(50) NULL,
Marital_Status nvarchar(50) NULL,
Children nvarchar(50) NULL,
Age tinyint NOT NULL,
Occupation nvarchar(50) NULL,
Budget nvarchar(50) NULL);

--Create ratings table
CREATE TABLE Ratings(
Consumer_ID nvarchar(50) NOT NULL,
Restaurant_ID int NOT NULL,
PRIMARY KEY (Consumer_ID,Restaurant_ID),
Overall_Rating tinyint NOT NULL,
Food_Rating tinyint NOT NULL,
Service_Rating tinyint NOT NULL);

--Create restaurants cuisines table
CREATE TABLE Restaurant_Cuisines(
Restaurant_ID int NOT NULL,
Cuisine nvarchar(50) NOT NULL,
PRIMARY KEY (Restaurant_ID, Cuisine));

--Alter Ratings and Restaurant_Cuisines table to include foreign key constraints
ALTER TABLE Ratings
ADD FOREIGN KEY (Consumer_ID) REFERENCES Consumers(Consumer_ID);

ALTER TABLE Ratings
ADD FOREIGN KEY(Restaurant_ID) REFERENCES Restaurant(Restaurant_ID);

ALTER TABLE Restaurant_Cuisines
ADD FOREIGN KEY(Restaurant_ID) REFERENCES Restaurant(Restaurant_ID);


--Insert data from the imported csv files into the 4 tables
--Inserting into Restaurant table
INSERT INTO Restaurant(Restaurant_ID, Name, City, State, Country, Zip_Code, Latitude, Longitude, Alcohol_Service, Smoking_Allowed, Price, Franchise, Area, Parking)
SELECT DISTINCT Restaurant_ID, Name, City, State, Country, Zip_Code, Latitude, Longitude, Alcohol_Service, Smoking_Allowed, Price, Franchise, Area, Parking
FROM dbo.restaurants_a;

--Inserting into Consumers table
INSERT INTO Consumers(Consumer_ID, City, State, Country, Latitude, Longitude, Smoker, Drink_Level, Transportation_Method, Marital_Status, Children, Age, Occupation, Budget)
SELECT DISTINCT Consumer_ID, City, State, Country, Latitude, Longitude, Smoker, Drink_Level, Transportation_Method, Marital_Status, Children, Age, Occupation, Budget
FROM dbo.consumers_a;

--Inserting into Restaurant_Cuisines table
INSERT INTO Restaurant_Cuisines(Restaurant_ID,Cuisine)
SELECT DISTINCT Restaurant_ID,Cuisine
FROM dbo.restaurant_cuisines_a;

--Inserting into Ratings table
INSERT INTO Ratings(Consumer_ID,Restaurant_ID,Overall_Rating,Food_Rating,Service_Rating)
SELECT DISTINCT Consumer_ID,Restaurant_ID,Overall_Rating,Food_Rating,Service_Rating
FROM dbo.ratings_a;

--Query Restaurant table
SELECT *
FROM Restaurant;
--Query Consumers table
SELECT *
FROM Consumers;
--Query Restaurant_Cuisines table
SELECT *
FROM Restaurant_Cuisines;
--Query Ratings table
SELECT *
FROM Ratings;

--Drop all the imported tables
DROP TABLE dbo.consumers_a, dbo.ratings_a, dbo.restaurant_cuisines_a, dbo.restaurants_a;



--PART 2--
--QUESTION 1
--List of restaurants with a medium price range, open area serving Mexican food.
SELECT r.Name AS Mexican_Restaurants_Medium_Price
FROM Restaurant AS r INNER JOIN Restaurant_Cuisines AS rc
ON r.Restaurant_ID = rc.Restaurant_ID
WHERE r.Price = 'Medium' AND r.Area = 'Open' AND rc.Cuisine = 'Mexican';

--QUESTION 2
--Compare results of restaurants that have Overall rating of 1 and Italian cuisine with the one that serves Mexican cuisine
SELECT
--Total number of restaurants with overall rating of 1 and serve Mexican food
	(SELECT COUNT(DISTINCT r.Restaurant_ID)
	FROM Restaurant AS r INNER JOIN Restaurant_Cuisines AS rc 
	ON r.Restaurant_ID = rc.Restaurant_ID INNER JOIN Ratings AS ra
	ON rc.Restaurant_ID = ra.Restaurant_ID
	WHERE ra.Overall_Rating = '1' AND rc.Cuisine = 'Mexican') AS Mexican_Rated_Restaurants,

	--Total number of restaurants with overall rating of 1 and serve Italian food
	(SELECT COUNT(DISTINCT r.Restaurant_ID)
	FROM Restaurant AS r INNER JOIN Restaurant_Cuisines AS rc 
	ON r.Restaurant_ID = rc.Restaurant_ID INNER JOIN Ratings AS ra
	ON rc.Restaurant_ID = ra.Restaurant_ID
	WHERE ra.Overall_Rating = '1' AND rc.Cuisine = 'Italian') AS Italian_Rated_Restaurants;

----Compare both results above: Mexican = 87, Italian = 11
--More people visited and rated the mexican restaurants. Most consumers live in mexico and like to eat mexican meals
----Query to get number of Italian cuisine restaurant: 4
SELECT
	(SELECT COUNT(*) AS No_of_Italian_restaurants
	FROM Restaurant AS r INNER JOIN Restaurant_Cuisines AS rc 
	ON r.Restaurant_ID = rc.Restaurant_ID
	WHERE rc.Cuisine = 'Italian'),
	--Query to get number of Mexican cuisine restaurant: 28
	(SELECT COUNT(*) AS No_of_Mexican_restaurants
	FROM Restaurant AS r INNER JOIN Restaurant_Cuisines AS rc 
	ON r.Restaurant_ID = rc.Restaurant_ID
	WHERE rc.Cuisine = 'Mexican');

--QUESTION 3
--Average age of consumers who have given a 0 service rating
SELECT  ROUND(AVG(Age), 0) AS Average_Age
FROM Consumers AS c INNER JOIN Ratings AS ra
ON c.Consumer_ID=ra.Consumer_ID
WHERE ra.Service_Rating = 0;

--QUESTION 4
--List of restaurants ranked by the youngest consumer, Sorted by food_rating from high to low
SELECT r.Name, ra.Food_Rating, c.Consumer_ID, c.Age
FROM Restaurant AS r INNER JOIN Ratings AS ra
ON r.Restaurant_ID = ra.Restaurant_ID INNER JOIN Consumers AS c
ON ra.Consumer_ID = c.Consumer_ID
WHERE Age = (
	SELECT MIN(Age) 
	FROM Consumers)
ORDER BY ra.Food_Rating DESC;

--QUESTION 5
--Stored Procedure to update the service rating of all restaurants if their parking is either yes or public
--Code to check if stored procedure works--
--This returns the number of restaurants with service rating of NOT 2 and parking is either yes or public
SELECT COUNT(*) AS No_of_restaurants
FROM 
	(SELECT r.Name, r.Parking, ra.Service_Rating
	FROM Restaurant AS r INNER JOIN Ratings AS ra
	ON r.Restaurant_ID = ra.Restaurant_ID
	WHERE (r.Parking = 'Yes' OR r.Parking = 'Public') AND ra.Service_Rating != 2) AS No_of_restaurants;

--Create the stored procedure
CREATE PROCEDURE update_service_rating
AS
	BEGIN
		UPDATE Ratings
		SET Service_Rating = 2
		WHERE Restaurant_ID IN (
			SELECT Restaurant_ID
			FROM Restaurant
			WHERE Parking = 'Yes' OR Parking = 'Public');
	END;


--Execute the update_service_rating procedure
EXEC update_service_rating;

--Rerun query again to confirm correctness of the update_service_rating procedure
--This returns the number of restaurants with service rating of NOT 2 and parking is either yes or public
SELECT COUNT(*) AS No_of_restaurants
FROM 
	(SELECT r.Name, r.Parking, ra.Service_Rating
	FROM Restaurant AS r INNER JOIN Ratings AS ra
	ON r.Restaurant_ID = ra.Restaurant_ID
	WHERE (r.Parking = 'Yes' OR r.Parking = 'Public') AND ra.Service_Rating != 2) AS No_of_restaurants;

--QUESTION 6
---PERSONAL QUERIES---

--QUESTION 6a
--Stored procedure to return a restaurant's ratings
--The results are based on the data afetr the execution of the update_service_rating stored procedure
CREATE PROCEDURE restaurant_review @restaurant int
AS
	BEGIN
		SELECT r.Restaurant_ID,r.Name, ra.Consumer_ID, ra.Overall_Rating, ra.Food_Rating, ra.Service_Rating
		FROM Restaurant AS r INNER JOIN Ratings AS ra
		ON r.Restaurant_ID = ra.Restaurant_ID 
		WHERE r.Restaurant_ID = @restaurant
		ORDER BY ra.Overall_Rating DESC;
	END;

--Execute the restaurant_review procedure
EXEC restaurant_review @restaurant= 132560;

EXEC restaurant_review @restaurant= 132583 ;

--QUESTION 6b
--See list of resturants that need to include kid's meal in the menu

SELECT Restaurant_ID, Name
FROM Restaurant AS r
WHERE EXISTS (
				SELECT 1
				FROM Ratings ra
				WHERE ra.Restaurant_ID = r.Restaurant_ID
				AND ra.Consumer_ID IN (
										SELECT Consumer_ID
										FROM Consumers
										WHERE Children = 'Kids'));

--QUESTION 6c
--Restaurants that cook good food but need to improve on their service
--The ratings are 0,1,2 so 1 is assumed to be average. 
--The results are based on the data afetr the execution of the update_service_rating stored procedure

SELECT r.Restaurant_ID, r.Name, AVG(ra.Overall_Rating) AS Average_Overall_Rating, AVG(ra.Food_Rating) AS Average_Food_Rating, 
		AVG(ra.Service_Rating) AS Average_Service_Rating
FROM Restaurant AS r INNER JOIN Ratings AS ra 
ON r.Restaurant_ID = ra.Restaurant_ID
GROUP BY r.Restaurant_ID, r.Name
HAVING AVG(ra.Food_Rating) >= 1 AND AVG(ra.Service_Rating) < 1;	
	
--QUESTION 6d
--Check how many smokers use the smoking restaurant based on the reviews provided
--This shows that smokers don't necessarily go to restaurants that allow smoking, so restaurants can survive without it
--Out of 26 smokers, only 6 used the restaurants that allow smoking
SELECT COUNT(DISTINCT Consumer_ID) AS Smokers_count
FROM Ratings
WHERE Restaurant_ID IN (--9 restaurants that allow smoking
						SELECT Restaurant_ID 
						FROM Restaurant
						WHERE Smoking_Allowed = 'Yes') 
	AND Consumer_ID  IN (--26 smoker consumers
						SELECT Consumer_ID 
						FROM Consumers 
						WHERE Smoker = 'Yes');


