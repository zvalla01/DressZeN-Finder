CREATE DATABASE dresszenfinder5;
USE dresszenfinder5;
-- Create Users table
CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    size VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL,
    gender ENUM('male', 'female'),
    age INT,
    password VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);
-- Create Outfit table
CREATE TABLE outfit (
    outfit_id INT NOT NULL AUTO_INCREMENT,
    occasion ENUM('casual', 'formal', 'sport', 'business', 'party') NOT NULL,
    PRIMARY KEY (outfit_id)
);
-- Create User_Comments table
CREATE TABLE user_Comments (
    comment_id INT NOT NULL AUTO_INCREMENT,
    user_id INT,
    outfit_id INT,
    content TEXT NOT NULL,
    comment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (comment_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (outfit_id) REFERENCES outfit(outfit_id) ON DELETE CASCADE
);
-- Create Interested_In table
CREATE TABLE interested_In (
    user_id INT,
    outfit_id INT,
    PRIMARY KEY (user_id, outfit_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (outfit_id) REFERENCES outfit(outfit_id) ON DELETE CASCADE
);
-- Create Clothing_Item table
CREATE TABLE clothing_item (
    cloth_id INT PRIMARY KEY AUTO_INCREMENT,
    size VARCHAR(20),
    color VARCHAR(255),
    cloth_description TEXT,
    brand_id INT,
    image_url TEXT,
    season ENUM('winter', 'autumn', 'spring', 'summer'),
    type ENUM('top', 'bottom', 'accessory', 'shoes')
);
-- Create Wardrobe table
CREATE TABLE wardrobe (
    user_id INT,
    cloth_id INT,
    PRIMARY KEY (user_id, cloth_id),
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (cloth_id) REFERENCES clothing_item(cloth_id) ON DELETE CASCADE
);
-- Create brands table
CREATE TABLE brands (
    brand_id INT NOT NULL AUTO_INCREMENT,
    brand_name VARCHAR(50),
    brand_website TEXT,
    type ENUM('luxury', 'sportswear', 'fast fashion') NOT NULL,
    PRIMARY KEY (brand_id)
);
INSERT INTO brands (brand_name, brand_website, type)
VALUES ('CHANEL', 'https://www.chanel.com', 'Luxury'),
    ('DIOR', 'https://www.dior.com', 'Luxury'),
    ('ADIDAS', 'https://www.adidas.com', 'Sportswear'),
    ('NIKE', 'https://www.nike.com', 'Sportswear'),
    ('ZARA', 'https://www.zara.com', 'Fast Fashion'),
    ('H&M', 'https://www.hm.com', 'Fast Fashion'),
    (
        'LOUIS VUITTON',
        'https://www.louisvuitton.com',
        'Luxury'
    ),
    ('GUCCI', 'https://www.gucci.com', 'Luxury'),
    (
        'UNIQLO',
        'https://www.uniqlo.com',
        'Fast Fashion'
    ),
    ('PUMA', 'https://www.puma.com', 'Sportswear'),
    (
        'LULULEMON',
        'https://www.lululemon.com',
        'Sportswear'
    ),
    (
        'BALENCIAGA',
        'https://www.balenciaga.com',
        'Luxury'
    ),
    (
        'RALPH LAUREN',
        'https://www.ralphlauren.com',
        'Luxury'
    ),
    (
        'MARC JACOBS',
        'https://www.marcjacobs.com',
        'Luxury'
    ),
    (
        'BERSHKA',
        'https://www.bershka.com',
        'Fast Fashion'
    ),
    (
        'PULL&BEAR',
        'https://www.pullandbear.com',
        'Fast Fashion'
    ),
    (
        'STRADIVARIUS',
        'https://www.stradivarius.com',
        'Fast Fashion'
    );
-- Create User_Rating table
CREATE TABLE user_Rating (
    user_id INT,
    cloth_id INT,
    rating TINYINT CHECK (
        rating >= 1
        AND rating <= 5
    ),
    PRIMARY KEY (user_id, cloth_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (cloth_id) REFERENCES clothing_item(cloth_id) ON DELETE CASCADE
);
-- Create Outfit_Clothing_Item table
CREATE TABLE outfit_clothing_Item (
    outfit_id INT,
    cloth_id INT,
    PRIMARY KEY (outfit_id, cloth_id),
    FOREIGN KEY (outfit_id) REFERENCES outfit(outfit_id) ON DELETE CASCADE,
    FOREIGN KEY (cloth_id) REFERENCES clothing_item(cloth_id) ON DELETE CASCADE
);
-- Create belongs_to table
CREATE TABLE belongs_to (
    cloth_id INT,
    brand_id INT,
    PRIMARY KEY (cloth_id, brand_id),
    FOREIGN KEY (cloth_id) REFERENCES clothing_item(cloth_id) ON DELETE CASCADE,
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id) ON DELETE CASCADE
);
ALTER TABLE users
MODIFY username VARCHAR(50) NULL,
    MODIFY size VARCHAR(30) NULL,
    MODIFY email VARCHAR(50) NULL,
    MODIFY gender ENUM('male', 'female') NULL,
    MODIFY age INT NULL,
    MODIFY password VARCHAR(255) NULL;
USE dresszenfinder5;
SELECT *
FROM users;
drop DATABASE dresszenfinder5;