
CREATE TABLE customer (
    name character varying(255) NOT NULL,
    street_number character varying(255) NOT NULL
);


ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (name, street_number);

ALTER TABLE customer OWNER TO postgres;

CREATE TABLE orders (
    date_of_receipt time without time zone NOT NULL,
    cost real,
    customer_name character varying(255),
    customer_street_number character varying
);
ALTER TABLE ONLY orders
    ADD CONSTRAINT customer_name_street FOREIGN KEY (customer_name, customer_street_number) REFERENCES customer(name, street_number);

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (date_of_receipt);


ALTER TABLE orders OWNER TO postgres;



CREATE TABLE order_item (
    name character varying(255) NOT NULL,
    order_date_of_receipt time without time zone
);

ALTER TABLE ONLY order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (name);


ALTER TABLE order_item OWNER TO postgres;

ALTER TABLE ONLY order_item
    ADD CONSTRAINT order_item_order_date_of_receipt_fkey FOREIGN KEY (order_date_of_receipt) REFERENCES orders(date_of_receipt);


INSERT INTO customer (name, street_number) VALUES ('sami', 'street1');


INSERT INTO orders (date_of_receipt, cost, customer_name, customer_street_number) VALUES ('08:00:00', 1000, 'sami', 'street1');
INSERT INTO orders (date_of_receipt, cost, customer_name, customer_street_number) VALUES ('09:00:00', 2000, 'sami', 'street1');
INSERT INTO orders (date_of_receipt, cost, customer_name, customer_street_number) VALUES ('10:00:00', 500, 'sami', 'street1');

CREATE ROLE employees WITH
  NOLOGIN;

  
  
CREATE ROLE temporary_member WITH
  NOLOGIN;


CREATE USER bill WITH
  LOGIN
	password '123456';

GRANT employees TO bill;

CREATE USER govind WITH
  LOGIN
	password '123456';

GRANT employees TO govind;

CREATE USER sheila WITH
  LOGIN
	password '123456';

GRANT employees TO sheila;

CREATE USER tracey WITH
  LOGIN
  SUPERUSER
	password '123456';

---------------------------------------------------	
GRANT SELECT ON TABLE customer TO employees;


GRANT ALL ON TABLE orders TO employees;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE orders TO temporary_member;

GRANT ALL  ON TABLE order_item TO employees;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE order_item TO temporary_member;




------------------------------------------------------
	
CREATE POLICY cost_greater_than_row_level_security ON orders FOR ALL TO tracey, govind USING ((cost >= (0)::double precision));

CREATE POLICY cost_less_than_row_level_security ON orders FOR ALL TO bill, temporary_member, sheila USING ((cost < (1000)::double precision));
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

--drop policy cost_less_than_row_level_security ON orders;
--ALTER TABLE orders DISABLE ROW LEVEL SECURITY;




--REVOKE select ON customer FROM tracey1;

--ALTER role tracey1 WITH PASSWORD '123456'

