drop database order_details;
create database order_details;

\c order_details

CREATE TABLE order_item
(
  item_name VARCHAR(50) NOT NULL,
  quantity INT NOT NULL,
  unit_price INT NOT NULL
);

CREATE TABLE order_summary
(
  number_of_items INT NOT NULL,
  total_price INT NOT NULL
);

CREATE OR REPLACE FUNCTION increment() RETURNS TRIGGER AS
$$
BEGIN
  UPDATE order_summary set number_of_items=number_of_items+1;
  UPDATE order_summary set total_price=total_price+new.quantity*new.unit_price;
    RETURN new;
END;
$$
language plpgsql;

CREATE TRIGGER increment_number
     AFTER INSERT ON order_item
     FOR EACH ROW
     EXECUTE PROCEDURE increment();


CREATE OR REPLACE FUNCTION decrement() RETURNS TRIGGER AS
$$
BEGIN
  UPDATE order_summary set number_of_items=number_of_items-1;
  UPDATE order_summary set total_price=total_price-old.quantity*old.unit_price;
  RETURN new;
END;
$$
language plpgsql;

CREATE TRIGGER decrement_number
     AFTER DELETE ON order_item
     FOR EACH ROW
     EXECUTE PROCEDURE decrement();

insert into order_summary values(0,0);