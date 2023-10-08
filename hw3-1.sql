/*Create countries table*/
CREATE TABLE countries (
	country_code char(2) PRIMARY KEY,
	country_name text UNIQUE
);


/*Insert data*/
INSERT INTO countries (country_code, country_name)
	VALUES ('us','United States'), ('mx','Mexico'), ('au','Australia'),
	('gb','United Kingdom'), ('de','Germany'), ('ll','Loompaland');


/*Create table cities with reference to countries*/
CREATE TABLE cities (
	name text NOT NULL,
	postal_code varchar(9) CHECK (postal_code <> ''),
	country_code char(2) REFERENCES countries,
	PRIMARY KEY (country_code, postal_code)
);


INSERT INTO cities
	VALUES ('Portland','87200','us');


/*Update postal_code*/
UPDATE cities
	SET postal_code = '97206'
	WHERE name = 'Portland';


/*Create table venues with auto increment attribute*/
CREATE TABLE venues (
	venue_id SERIAL PRIMARY KEY,
	name varchar(255),
	street_address text,
	type char(7) CHECK ( type in ('public','private') ) DEFAULT 'public',
	postal_code varchar(9),
	country_code char(2),
	FOREIGN KEY (country_code, postal_code)
	REFERENCES cities (country_code, postal_code) MATCH FULL
);


/*Insert data into venues*/
INSERT INTO venues (name, postal_code, country_code)
	VALUES ('Crystal Ballroom', '97206', 'us'),
	('Voodoo Doughnut', '97206', 'us');


/*Create table events*/
CREATE TABLE IF NOT EXISTS events (
	event_id SERIAL PRIMARY KEY,
	title varchar(100),
	starts timestamp,
	ends timestamp,
	venue_id int REFERENCES venues
);


/*Insert data*/
INSERT INTO events (title, starts, ends, venue_id)
	VALUES ('Fight Club','2018-02-15 17:30:00', '2018-02-15 19:30:00', 2), 
	('April Fools Day','2018-04-01 00:00:00', '2018-04-01 23:59:00', NULL),
	('Christmas Day','2018-12-25 00:00:00', '2018-12-25 23:59:00', NULL);
	

/*Create add_event procedure*/
CREATE OR REPLACE FUNCTION add_event(
  title text,
  starts timestamp,
  ends timestamp,
  venue text,
  postal varchar(9),
  country char(2))
RETURNS boolean AS $$
DECLARE
  did_insert boolean := false;
  found_count integer;
  the_venue_id integer;
BEGIN
  SELECT venue_id INTO the_venue_id
  FROM venues v
  WHERE v.postal_code=postal AND v.country_code=country AND v.name ILIKE venue
  LIMIT 1;

  IF the_venue_id IS NULL THEN
    INSERT INTO venues (name, postal_code, country_code)
    VALUES (venue, postal, country)
    RETURNING venue_id INTO the_venue_id;

    did_insert := true;
  END IF;

  -- Note: this is a notice, not an error as in some programming languages
  RAISE NOTICE 'Venue found %', the_venue_id;

  INSERT INTO events (title, starts, ends, venue_id)
  VALUES (title, starts, ends, the_venue_id);

  RETURN did_insert;
END;
$$ LANGUAGE plpgsql;


/*Insert more data*/
insert into countries (country_code, country_name)
	VALUES ('id', 'Indonesia'),
	('fr', 'France'),
	('kr', 'South Korea'),
	('ph', 'Philippines'),
	('es', 'Spain'),
	('br', 'Brazil'),
	('ng', 'Nigeria'),
	('pt', 'Portugal'),
	('pl', 'Poland'),
	('cn', 'China'),
	('kz', 'Kazakhstan'),
	('lk', 'Sri Lanka'),
	('pe', 'Peru'),
	('ve', 'Venezuela'),
	('tm', 'Turkmenistan'),
	('ru', 'Russia'),
	('za', 'South Africa'),
	('mg', 'Madagascar'),
	('dk', 'Denmark'),
	('jp', 'Japan'),
	('me', 'Montenegro'),
	('bw', 'Botswana'),
	('fo', 'Faroe Islands'),
	('ke', 'Kenia'),
	('gy', 'Guyana'),
	('co', 'Colombia'),
	('md', 'Moldova'),
	('ca', 'Canada'),
	('no', 'Norway'),
	('cz', 'Czechia');
	
	
INSERT INTO cities
	VALUES ('Gulao', '981343','cn'),
	('Łysomice', '87-148','pl'),
	('Mogoditshane', '49862','bw'),
	('Argir', '165','fo'),
	('Paucar', '147813','pe'),
	('Yekimovichi', '216533','ru'),
	('Tumpang Satu', '430518','id'),
	('Cipaku', '57088','id'),
	('Kertasari', '473044','id'),
	('Tangshan', '507718','cn'),
	('Sikeshu', '963690','cn'),
	('Guishan', '40454','cn'),
	('Fushi', '453163','cn'),
	('Simao', '252087','cn'),
	('Hualin', '815874','cn'),
	('Mandera', '172667','ke'),
	('Lethem', '408922','gy'),
	('Fresnes', '94269 CDX','fr'),
	('Changtan', '906298','cn'),
	('Sanpai', '263869','cn'),
	('Coyaima', '735037','co'),
	('Pagelaran', '303435','id'),
	('Saharna', 'MD-5431','md'),
	('Laingsburg', '6901','za'),
	('Kamensk-Shakhtinskiy', '396458','ru'),
	('Fermont', 'J1E','ca'),
	('Vigo', '5110','ph'),
	('Rancho Nuevo', '91275','mx'),
	('Żabnica', '34-382','pl'),		
	('Jishan', '461823','cn'),
	('Wielichowo', '64-050','pl'),
	('Oslo', '789','no'),
	('Lasiana', '35155','id'),
	('Yunlu', '237665','cn'),
	('Oliveira', '3660-622','pt'),
	('Jiazhi', '75694','cn'),
	('Boticas', '5460-304','pt'),
	('Escada', '55500-000','br'),	
	('Kralupy nad Vltavou', '278 01','cz'),
	('Bayang', '565067','cn'),
	('Krajan Pakel', '492898','id'),
	('Dianbu', '939969','cn'),
	('Huangpu', '26796','cn'),
	('Dumlan', '8119','ph'),
	('Cernay', '68704 CDX','fr'),
	('Louisville', '40287','us'),
	('Pacarkeling', '168289','id'),
	('Yumaguzino', '453337','ru'),
	('Shangyi', '940342','cn'),
	('Pomiechówek', '05-180','pl'),
	('Hornówek', '05-080','pl'),
	('Tegalgunung', '394849','id'),
	('Łęki Szlacheckie', '97-352','pl'),
	('Pretana', '697724','id'),
	('Zalanga', '134844','ng'),
	('Ciherang', '719534','id'),
	('Niny', '357906','ru'),
	('Sępopol', '11-210','pl'),
	('Bogotá', '111831','co'),
	('Omaha', '68134','us'),
	('Klampok', '436432','id'),
	('Morbatoh', '337194','id'),
	('Guadalupe Victoria', '75694','mx'),
	('Paço', '4910-060','pt'),
	('Banjar Delodrurung', '407683','id'),
	('Weizhou', '997162','cn'),
	('Claye-Souilly', '77414 CDX','fr'),
	('Binjiang', '190856','cn'),
	('Rabah', '566876','ng'),
	('Liuyuan', '925795','cn'),
	('Nagrog', '166144','id'),
	('Qiaoshi', '636194','cn'),
	('Muqui', '939793','pe'),
	('Soras', '837825','pe'),
	('Cikotok', '979282','id'),
	('Wailolong', '853370','id'),
	('São Paio de Gramaços', '3400-696','pt'),
	('Huntington', '25709','us'),
	('Shanghu', '553011','cn'),
	('Dafeng', '392729','cn'),
	('Egindika', '11237','kz'),
	('Pantin', '93691 CDX','fr'),
	('Lücheng', '132502','cn'),
	('Yiyang', '358669','cn'),
	('Dawan', '551173','cn'),
	('Chapecó', '89800-000','br'),
	('Marquard', '9610','za'),
	('Malibago', '6213','ph'),
	('Ciparay', '924458','id'),
	('Jega', '625476','ng'),
	('Huayllo', '650272','pe'),
	('Tanenofunan', '565506','id'),
	('Katuli', '4212','ph'),
	('Santiaoshi', '153229','cn'),
	('Sangpi', '355414','cn'),
	('Richmond', '23242','us'),
	('Changzhi', '605531','cn'),
	('Zhuangxing', '207550','cn'),
	('Geser', '766797','id'),
	('Lupon', '6405','ph'),
	('Palca', '735032','pe'),
	('Terre Haute', '47812','us'),
	('Pangal Sur', '3313','ph'),
	('Sergiyev Posad', '141309','ru'),
	('Campos Novos', '89620-000','br'),
	('Woniuhe', '150458','cn'),
	('Yanshi', '598680','cn'),
	('Xujiaqiao', '865540','cn');