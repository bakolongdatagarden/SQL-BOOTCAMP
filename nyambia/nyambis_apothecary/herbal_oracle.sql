-- Create Herbal Astrology Oracle 
SHOW DATABASES;
CREATE DATABASE herbal_astrology_oracle;
USE herbal_astrology_oracle;
SELECT
  DATABASE();
SHOW TABLES;
-- Create First Table: Herbal Astrology Oracle  
CREATE TABLE card_spreads(
  spread_name VARCHAR(100) NOT NULL,
  number_of_cards INT NOT NULL,
  explanation TEXT NOT NULL
);
DESC card_spreads;
-- Insert Information for Each Spread
INSERT INTO
  card_spreads(spread_name, number_of_cards, explanation)
VALUES
  (
    'THE CARDINAL CROSS OF THE MEDICINE WHEEL',
    5,
    '
        The Medicine Wheel symbolizes the cycles of life, the forever evolving transformations and lessons that we endure and embrace
        as we journey through life. The path for us earthlings is based on the understanding that we stand on every place on the Medicine 
        Wheel at all times, and every direction contains sacred essense energy that must be honored as we navigate the cycles of life. The 
        cardinal directions are archetypal energies, portals within life and soul, that exist as elemental spirits that guide us.
    '
  );


SELECT * FROM card_spreads;
