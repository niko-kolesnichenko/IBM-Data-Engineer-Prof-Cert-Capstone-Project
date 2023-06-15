-- This script was generated by a beta version of the ERD tool in pgAdmin 4.
-- Please log an issue at https://redmine.postgresql.org/projects/pgadmin4/issues/new if you find any bugs, including reproduction steps.
BEGIN;


CREATE TABLE public."softcartDimCategory"
(
    category_id integer NOT NULL,
    category_name character varying(5) NOT NULL,
    PRIMARY KEY (category_id)
);

CREATE TABLE public."softcartDimCountry"
(
    country_id smallint NOT NULL,
    country_name character varying(56) NOT NULL,
    PRIMARY KEY (country_id)
);

CREATE TABLE public."softcartDimDate"
(
    date_id integer NOT NULL,
    day smallint NOT NULL,
    weekday smallint NOT NULL,
    weekday_name character varying(9) NOT NULL,
    month smallint NOT NULL,
    month_name character varying(9) NOT NULL,
    year smallint NOT NULL,
    quarter smallint NOT NULL,
    quarter_name character varying(2) NOT NULL,
    PRIMARY KEY (date_id)
);

CREATE TABLE public."softcartDimItem"
(
    item_id integer NOT NULL,
    item_name character varying(300) NOT NULL,
    PRIMARY KEY (item_id)
);

CREATE TABLE public."softcartFactSales"
(
    order_id integer NOT NULL,
    item_id integer NOT NULL,
    country_id smallint NOT NULL,
    date_id integer NOT NULL,
    category_id integer NOT NULL,
    price numeric(62) NOT NULL,
    PRIMARY KEY (order_id)
);

ALTER TABLE public."softcartFactSales"
    ADD FOREIGN KEY (country_id)
    REFERENCES public."softcartDimCountry" (country_id)
    NOT VALID;


ALTER TABLE public."softcartFactSales"
    ADD FOREIGN KEY (item_id)
    REFERENCES public."softcartDimItem" (item_id)
    NOT VALID;


ALTER TABLE public."softcartFactSales"
    ADD FOREIGN KEY (date_id)
    REFERENCES public."softcartDimDate" (date_id)
    NOT VALID;


ALTER TABLE public."softcartFactSales"
    ADD FOREIGN KEY (category_id)
    REFERENCES public."softcartDimCategory" (category_id)
    NOT VALID;

END;