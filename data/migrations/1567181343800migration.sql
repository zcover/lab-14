STAGE ONE:
 >>>>Created database lab14_normal using template from lab14,
 CREATE DATABASE lab14_normal WITH TEMPLATE lab14;



 >>>>Verified lab14_normal had all same files as lab14
 SELECT COUNT (*) FROM books;


STAGE TWO:(migration)

1.
CREATE TABLE BOOKSHELVES (id SERIAL PRIMARY KEY, name VARCHAR(255));
>>>>This query will create a second table in the lab14_normal database named bookshelves. Confirm the success >>of this command by typing 
\d bookshelves 
>>in your SQL shell. You should see the bookshelves table schema, as shown above.

2.
INSERT INTO bookshelves(name) SELECT DISTINCT bookshelf FROM books;
>>>>This query will use a simple subquery to retrieve unique bookshelf values from the books table and insert each one into the bookshelves table in the name column. This is a great pattern for copying lots of data between tables.
>>Confirm the success of this command by typing 
SELECT COUNT(*) FROM bookshelves;
>>in your SQL shell. The number should be greater than zero.

3.
ALTER TABLE books ADD COLUMN bookshelf_id INT;
>>>>This query will add a column to the books table named bookshelf_id. This will connect each book to a specific bookshelf in the other table.
>>Confirm the success of this command by typing 
\d books
>> in your SQL shell. The table schema should now include a column for bookshelf_id, in addition to the column for the string bookshelf; 

the bookshelf column will be removed in Query 5.

4.
UPDATE books SET bookshelf_id=shelf.id FROM (SELECT * FROM bookshelves) AS shelf WHERE books.bookshelf = shelf.name;
>>>>This query will prepare a connection between the two tables. It works by running a subquery for every row in the books table. The subquery finds the bookshelf row that has a name matching the current book’s bookshelf value. The id of that bookshelf row is then set as the value of the bookshelf_id property in the current book row.
>>Confirm the success of this command by typing 
SELECT bookshelf_id FROM books;
>> in your SQL shell. The result should display a column containing the unique ids for the bookshelves. The numbers should match the total number returned from Query 2 when you confirmed the success of the insertion of names into the bookshelves table.

5.
ALTER TABLE books DROP COLUMN bookshelf;
>>>>This query will modify the books table by removing the column named bookshelf. Now that the books table contains a bookshelf_id column which will become a foreign key, your table does not need to contain a string representing each bookshelf.
>>Confirm the success of this command by typing 
\d books
>> in your SQL shell. The books table schema should be updated to reflect the schema provided above, without the bookshelf column.

6.
ALTER TABLE books ADD CONSTRAINT fk_bookshelves FOREIGN KEY (bookshelf_id) REFERENCES bookshelves(id);
>>>>This query will modify the data type of the bookshelf_id in the books table, setting it as a foreign key which references the primary key in the bookshelves table. Now PostgreSQL knows HOW these 2 tables are connected.
>>Confirm the success of this command by typing 
\d books
>> in your SQL shell. You should see details about the foreign key constraints, as shown in the schema above.



!!!   Addition of a migrations folder   !!!

Create a /data folder in the root of your repository that contains a folder named migrations. This folder will contain a series of files that represent a change log of your database configuration. You will create a file to document today’s database migration steps.

The naming convention will follow the pattern of timestamp-description.sql. This file should contain the SQL queries executed, in order, with comments to describe the purpose of each query. The easiest way to obtain the current timestamp is to open the developer tools in a browser window and type Date.now();. This naming convention will ensure your team keeps track of how and when the database is changing over the life of a project.