-- 1 up
create table if not exists enum_meals (
  meal         varchar(100) primary key collate nocase not null,
  name         text collate nocase not null,
  seq          integer
);
insert into enum_meals (meal, name, seq) values ('breakfast', 'Breakfast', 1);
insert into enum_meals (meal, name, seq) values ('lunch', 'Lunch', 2);
insert into enum_meals (meal, name, seq) values ('dinner', 'Dinner', 3);
insert into enum_meals (meal, name, seq) values ('snack', 'Snack', 4);

create table if not exists enum_seasons (
  season       varchar(100) primary key collate nocase not null,
  name         text collate nocase not null,
  seq          integer
);
insert into enum_seasons (season, name, seq) values ('spring', 'Spring', 1);
insert into enum_seasons (season, name, seq) values ('summer', 'Summer', 2);
insert into enum_seasons (season, name, seq) values ('fall', 'Fall', 3);
insert into enum_seasons (season, name, seq) values ('winter', 'Winter', 4);

create table if not exists enum_allergies (
  allergy      varchar(100) primary key collate nocase not null,
  name         text collate nocase not null,
  seq          integer
);
insert into enum_allergies (allergy, name, seq) values ('gluten', 'Gluten', 1);
insert into enum_allergies (allergy, name, seq) values ('dairy', 'Dairy', 2);
insert into enum_allergies (allergy, name, seq) values ('peanut', 'Peanut', 3);
insert into enum_allergies (allergy, name, seq) values ('tree_nut', 'Tree Nut', 4);
insert into enum_allergies (allergy, name, seq) values ('egg', 'Egg', 5);
insert into enum_allergies (allergy, name, seq) values ('soy', 'Soy', 6);
insert into enum_allergies (allergy, name, seq) values ('fish', 'Fish', 7);
insert into enum_allergies (allergy, name, seq) values ('shellfish', 'Shellfish', 8);
insert into enum_allergies (allergy, name, seq) values ('wheat', 'Wheat', 9);
insert into enum_allergies (allergy, name, seq) values ('other', 'Other', 1000);

create table if not exists enum_religious_practices (
  practice     varchar(100) primary key collate nocase not null,
  name         text collate nocase not null,
  seq          integer
);
insert into enum_religious_practices (practice, name, seq) values ('kosher', 'Kosher', 1);
insert into enum_religious_practices (practice, name, seq) values ('no_beef', 'No Beef', 2);
insert into enum_religious_practices (practice, name, seq) values ('no_pork', 'No Pork', 3);
insert into enum_religious_practices (practice, name, seq) values ('no_shellfish', 'No Shellfish', 4);
insert into enum_religious_practices (practice, name, seq) values ('other', 'Other', 1000);

create table if not exists enum_dietary_restrictions (
  restriction  varchar(100) primary key collate nocase not null,
  name         text collate nocase not null,
  seq          integer
);
insert into enum_dietary_restrictions (restriction, name, seq) values ('vegetarian', 'Vegetarian', 1);
insert into enum_dietary_restrictions (restriction, name, seq) values ('vegan', 'Vegan', 2);

create table if not exists enum_food_dislikes (
  food         varchar(100) primary key collate nocase not null,
  name         text collate nocase not null,
  seq          integer
);
insert into enum_food_dislikes (food, name, seq) values ('onions', 'Onions', 1);
insert into enum_food_dislikes (food, name, seq) values ('mushrooms', 'Mushrooms', 2);
insert into enum_food_dislikes (food, name, seq) values ('peppers', 'Peppers', 3);
insert into enum_food_dislikes (food, name, seq) values ('tomatoes', 'Tomatoes', 4);
insert into enum_food_dislikes (food, name, seq) values ('other', 'Other', 1000);

create table if not exists enum_food_fears (
  food         varchar(100) primary key collate nocase not null,
  name         text collate nocase not null,
  seq          integer
);
insert into enum_food_fears (food, name, seq) values ('casseroles', 'Casseroles', 1);
insert into enum_food_fears (food, name, seq) values ('soups', 'Soups', 2);
insert into enum_food_fears (food, name, seq) values ('stews', 'Stews', 3);
insert into enum_food_fears (food, name, seq) values ('other', 'Other', 1000);

create table if not exists enum_units (
  unit         varchar(100) primary key collate nocase not null,
  name         text collate nocase not null,
  seq          integer
);
insert into enum_units (unit, name, seq) values ('cup', 'Cup', 1);
insert into enum_units (unit, name, seq) values ('tablespoon', 'Tablespoon', 2);
insert into enum_units (unit, name, seq) values ('teaspoon', 'Teaspoon', 3);
insert into enum_units (unit, name, seq) values ('pint', 'Pint', 4);
insert into enum_units (unit, name, seq) values ('quart', 'Quart', 5);
insert into enum_units (unit, name, seq) values ('gallon', 'Gallon', 6);
insert into enum_units (unit, name, seq) values ('ounce', 'Ounce', 7);
insert into enum_units (unit, name, seq) values ('pound', 'Pound', 8);
insert into enum_units (unit, name, seq) values ('gram', 'Gram', 9);
insert into enum_units (unit, name, seq) values ('kilogram', 'Kilogram', 10);
insert into enum_units (unit, name, seq) values ('liter', 'Liter', 11);
insert into enum_units (unit, name, seq) values ('milliliter', 'Milliliter', 12);
insert into enum_units (unit, name, seq) values ('other', 'Other', 1000);

create table if not exists enum_exp_levels (
  exp_level   varchar(100) primary key collate nocase not null,
  name        text not null,
  seq         integer
);
insert into enum_exp_levels (exp_level, name, seq) values ('beginner', 'Beginner', 1);
insert into enum_exp_levels (exp_level, name, seq) values ('intermediate', 'Intermediate', 2);
insert into enum_exp_levels (exp_level, name, seq) values ('advanced', 'Advanced', 3);

create table if not exists enum_source_types (
  source_type varchar(100) primary key collate nocase not null,
  name        text not null,
  seq         integer
);
insert into enum_source_types (source_type, name, seq) values ('book', 'Book', 1);
insert into enum_source_types (source_type, name, seq) values ('website', 'Website', 2);
insert into enum_source_types (source_type, name, seq) values ('magazine', 'Magazine', 3);
insert into enum_source_types (source_type, name, seq) values ('tv_show', 'TV Show', 4);
insert into enum_source_types (source_type, name, seq) values ('other', 'Other', 5);




create table if not exists settings (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  setting     text collate nocase not null,
  value       text not null
);
create table if not exists options (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  setting_id  integer not null,
  option      text collate nocase not null,
  foreign key (setting_id) references settings (id)
);

create table if not exists recipes (
  id            integer primary key autoincrement,
  created_at    datetime default current_timestamp,
  title         text collate nocase not null,
  servings      integer not null,
  max_prep_time integer not null, -- in minutes
  exp_level     not null references exp_levels(exp_level)
);

create table if not exists recipe_meals (
  id            integer primary key autoincrement,
  created_at    datetime default current_timestamp,
  recipe_id     integer not null,
  meal          varchar(100) not null references meals(meal),
  foreign key (recipe_id) references recipes (id)
);
create table if not exists recipe_seasons (
  id            integer primary key autoincrement,
  created_at    datetime default current_timestamp,
  recipe_id     integer not null,
  season        varchar(100) not null references seasons(season),
  foreign key (recipe_id) references recipes (id)
);
create table if not exists recipe_allergies (
  id            integer primary key autoincrement,
  created_at    datetime default current_timestamp,
  recipe_id     integer not null,
  allergy       varchar(100) not null references allergies(allergy),
  foreign key (recipe_id) references recipes (id)
);
create table if not exists recipe_religious_practices (
  id            integer primary key autoincrement,
  created_at    datetime default current_timestamp,
  recipe_id     integer not null,
  practice      varchar(100) not null references religious_practices(practice),
  foreign key (recipe_id) references recipes (id)
);
create table if not exists recipe_dietary_restrictions (
  id            integer primary key autoincrement,
  created_at    datetime default current_timestamp,
  recipe_id     integer not null,
  restriction   varchar(100) not null references dietary_restrictions(restriction),
  foreign key (recipe_id) references recipes (id)
);
create table if not exists recipe_food_dislikes (
  id            integer primary key autoincrement,
  created_at    datetime default current_timestamp,
  recipe_id     integer not null,
  food          varchar(100) not null references food_dislikes(food),
  optional      integer not null default 0,
  foreign key (recipe_id) references recipes (id)
);
create table if not exists recipe_food_fears (
  id            integer primary key autoincrement,
  created_at    datetime default current_timestamp,
  recipe_id     integer not null,
  food          varchar(100) not null references food_fears(food),
  foreign key (recipe_id) references recipes (id)
);
create table if not exists recipe_ingredients (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  recipe_id   integer not null,
  quantity    integer not null,
  unit        varchar(100) not null references units(unit),
  ingredient  text collate nocase not null,
  foreign key (recipe_id) references recipes (id)
);

create table if not exists recipe_sources (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  recipe_id   integer not null,
  source_type not null references source_types(source_type),
  source      text not null,
  foreign key (recipe_id) references recipes (id)
);
create table if not exists recipe_categories (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  recipe_id   integer not null,
  category    text collate nocase not null,
  foreign key (recipe_id) references recipes (id)
);
create table if not exists steps (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  recipe_id   integer not null,
  step_number integer not null,
  instruction text not null,
  foreign key (recipe_id) references recipes (id)
);
create table if not exists tags (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  recipe_id   integer not null,
  tag_type    varchar(100), --enum('meal', 'cuisine', 'diet', 'allergy') not null,
  tag         text collate nocase not null,
  foreign key (recipe_id) references recipes (id)
);
create table if not exists notes (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  recipe_id   integer not null,
  note        text not null,
  foreign key (recipe_id) references recipes (id)
);
create table if not exists images (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  recipe_id   integer not null,
  image       text not null,
  foreign key (recipe_id) references recipes (id)
);
create table if not exists ratings (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  recipe_id   integer not null,
  rating      integer not null,
  foreign key (recipe_id) references recipes (id)
);
create table if not exists reviews (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  recipe_id   integer not null,
  review      text not null,
  foreign key (recipe_id) references recipes (id)
);
create table if not exists users (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  admin       integer not null default 0,
  active      integer not null default 1,
  username    text collate nocase not null unique,
  password    text not null,
  email       text collate nocase not null unique,
  name        text collate nocase not null,
  birthday    date
);
create table if not exists user_preferences (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  user_id     integer not null,
  variety     varchar(100), --enum('none', 'low', 'medium', 'high') not null,
  leftovers   varchar(100), --enum('yes', 'no') not null,
  vegetarian  varchar(100), --enum('yes', 'no') not null,
  cooking_exp varchar(100), --enum('none', 'low', 'medium', 'high') not null,
  max_decisions varchar(100), --enum('several', 'few', 'none') not null,
  meal_plan_day_assignment varchar(100), --enum('automatic', 'manual') not null,
  foreign key (user_id) references users (id)
);
create table if not exists user_meal_settings (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  user_id     integer not null,
  meal_type   varchar(100), --enum('breakfast', 'lunch', 'dinner', 'snack') not null,
  num_meals   integer not null,
  max_prep_time varchar(100), --enum('little', 'some', 'lots') not null,
  weekday_size varchar(100), --enum('small', 'medium', 'large') not null,
  weekend_size varchar(100), --enum('small', 'medium', 'large') not null,
  foreign key (user_id) references users (id)
);
create table if not exists user_snack_settings (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  user_id     integer not null,
  num_snacks  integer not null,
  foreign key (user_id) references users (id)
);
create table if not exists user_allergies (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  user_id     integer not null,
  allergy     text collate nocase not null,
  foreign key (user_id) references users (id)
);
create table if not exists user_food_dislikes (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  user_id     integer not null,
  food        text collate nocase not null,
  foreign key (user_id) references users (id)
);
create table if not exists user_religious_practices (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  user_id     integer not null,
  practice    text collate nocase not null,
  foreign key (user_id) references users (id)
);
create table if not exists user_fear_foods (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  user_id     integer not null,
  food        text collate nocase not null,
  foreign key (user_id) references users (id)
);
create table if not exists user_favorites (
  id          integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  user_id     integer not null,
  recipe_id   integer not null,
  foreign key (user_id) references users (id),
  foreign key (recipe_id) references recipes (id)
);
insert into users (admin, active, username, password, email, name, birthday) values (1, 1, 'admin', 'admin', 'a@a.com', 'Admin', '2020-01-01');
insert into users (admin, active, username, password, email, name, birthday) values (0, 1, 'user', 'user', 'u@u.com', 'User', '2020-01-01');
insert into user_preferences (user_id, variety, leftovers, vegetarian, cooking_exp, max_decisions, meal_plan_day_assignment) values (1, 'high', 'yes', 'no', 'high', 'several', 'automatic');
insert into user_meal_settings (user_id, meal_type, num_meals, max_prep_time, weekday_size, weekend_size) values (1, 'breakfast', 1, 'little', 'small', 'small');
insert into user_snack_settings (user_id, num_snacks) values (1, 1);
insert into user_allergies (user_id, allergy) values (1, 'test');
insert into user_food_dislikes (user_id, food) values (1, 'test');
insert into user_religious_practices (user_id, practice) values (1, 'test');
insert into user_fear_foods (user_id, food) values (1, 'test');
insert into recipes (title, servings, max_prep_time, exp_level) values ('Test Recipe', 4, 30, 'beginner');
insert into recipe_sources (recipe_id, source_type, source) values (1, 'website', 'https://www.example.com');
insert into recipe_categories (recipe_id, category) values (1, 'test');
insert into recipe_ingredients (recipe_id, quantity, unit, ingredient) values (1, 1, 'test', 'test');
insert into steps (recipe_id, step_number, instruction) values (1, 1, 'test');
insert into tags (recipe_id, tag_type, tag) values (1, 'meal', 'test');
insert into notes (recipe_id, note) values (1, 'test');
insert into images (recipe_id, image) values (1, 'test');
insert into ratings (recipe_id, rating) values (1, 5);
insert into reviews (recipe_id, review) values (1, 'test');
insert into user_favorites (user_id, recipe_id) values (1, 1);
insert into user_favorites (user_id, recipe_id) values (2, 1);
insert into user_favorites (user_id, recipe_id) values (3, 1);


-- 1 down
drop table if exists recipes;
drop table if exists recipe_sources;
drop table if exists recipe_categories;
drop table if exists recipe_ingredients;
drop table if exists ingredients;
drop table if exists steps;
drop table if exists tags;
drop table if exists notes;
drop table if exists images;
drop table if exists ratings;
drop table if exists reviews;
drop table if exists users;
drop table if exists user_favorites;
