-- 1 up
create table if not exists recipes (
  id    integer primary key autoincrement,
  created_at  datetime default current_timestamp,
  active  boolean default 0,
  title text,
  recipe  text,
  shopping_list  text,
  meal text,
  meta json
);

-- 1 down
drop table if exists recipes;
