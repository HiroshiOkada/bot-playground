.separator ", "
create table greet_table ( id integer primary key, greeting text, target text );
insert into greet_table values (1, 'hello', 'world');
select greeting, target from greet_table;

