/*
G33
Sanjarbek Yuldashev
V-2 Social Media Platform

Draw sql link
https://drawsql.app/teams/sanjarbek-yuldashev/diagrams/social-media
*/



--Creating tables :
CREATE TABLE "comments"(
                           "id" bigserial NOT NULL,
                           "post_id" bigint NOT NULL,
                           "comment" VARCHAR(255) NOT NULL,
                           "user_id" BIGINT NOT NULL
);
ALTER TABLE
    "comments" ADD PRIMARY KEY("id");
CREATE TABLE "Likes"(
                        "id" bigserial NOT NULL,
                        "post_id" bigint NOT NULL,
                        "type" VARCHAR(255) default 'Like',
                        "user_id" BIGINT NOT NULL
);
ALTER TABLE
    "Likes" ADD PRIMARY KEY("id");
CREATE TABLE "Post"(
                       "id" bigserial       NOT NULL,
                       "tags" VARCHAR(255)       NOT NULL,
                       "comment_id" BIGINT  default null,
                       "like_id" BIGINT     default null,
                       "user_id" BIGINT       NOT NULL
);
ALTER TABLE
    "Post" ADD PRIMARY KEY("id");

CREATE TABLE "User"(
                       "id" bigserial NOT NULL,
                       "name" VARCHAR(255) NOT NULL,
                       "phone_number" VARCHAR(255) NOT NULL,
                       "column_4" BIGINT NOT NULL
);
ALTER TABLE
    "User" ADD PRIMARY KEY("id");
CREATE TABLE "Followers"(
                            "id" bigserial NOT NULL,
                            "user_id" BIGINT NOT NULL,
                            "following_user" BIGINT NOT NULL
);
ALTER TABLE
    "Followers" ADD PRIMARY KEY("id");
ALTER TABLE
    "Followers" ADD CONSTRAINT "followers_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "User"("id");
ALTER TABLE
    "Followers" ADD CONSTRAINT "followers_following_id_foreign" FOREIGN KEY("following_user") REFERENCES "User"("id");

ALTER TABLE
    "Post" ADD CONSTRAINT "post_like_id_foreign" FOREIGN KEY("like_id") REFERENCES "Likes"("id");
ALTER TABLE
    "Post" ADD CONSTRAINT "post_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "User"("id");
ALTER TABLE
    "Post" ADD CONSTRAINT "post_comment_id_foreign" FOREIGN KEY("comment_id") REFERENCES "comments"("id");

ALTER TABLE
    "comments" ADD CONSTRAINT "comments_post_id_foreign" FOREIGN KEY("post_id") REFERENCES "Post"("id");
ALTER TABLE
    "comments" ADD CONSTRAINT "comments_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "User"("id");

ALTER TABLE
    "Likes" ADD CONSTRAINT "likes_posts_id_foreign" FOREIGN KEY("post_id") REFERENCES "Post"("id");
ALTER TABLE
    "Likes" ADD CONSTRAINT "likes_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "User"("id");


drop table comments;
--inserting data:
insert into "User" (name, phone_number, column_4) VALUES
                                                      ('Doniyor', '+998974903007','1'),
                                                      ('Ali',     '+998975446437','1'),
                                                      ('Dilmurod','+998874434307','1'),
                                                      ('Diyor', '+998374434357','1'),
                                                      ('Kelinoyi', '+998874367647','2'),
                                                      ('Zaxro', '+998876878957','2'),
                                                      ('Qiz', '+998866543875','2'),
                                                      ('Selena Gomes', '+998856776765','2'),
                                                      ('Jonny Dep', '+998812354547','1'),
                                                      ('Ronaldo', '+998854668679','1');
--Mini Brain
--add_following
create or replace procedure follow
        (u_following_user bigint,
                                     u_user bigint)
        language plpgsql
        as
        $$
begin
insert into "Followers" (user_id, following_user) VALUES (u_user, u_following_user);
end;
        $$;

call follow(u_following_user := 3, u_user := 2);
call follow(u_following_user := 3, u_user := 1);
call follow(u_following_user := 3, u_user := 3);
call follow(u_following_user := 3, u_user := 4);
call follow(u_following_user := 1, u_user := 7);
call follow(u_following_user := 1, u_user := 2);
call follow(u_following_user := 1, u_user := 5);
call follow(u_following_user := 1, u_user := 8);


--post_new()
create or replace procedure post_new
        (
          u_tags varchar ,
         u_user bigint)
            language plpgsql
        as
        $$
begin
insert into "Post" (tags, user_id) VALUES (u_tags,u_user);
end;
        $$;

call post_new('Bla bla bla', 1);
call post_new('Heeheehwehe', 3);
call post_new('Assalom', 2);
call post_new('Javlonchik oke', 4);
call post_new('Noooooo', 1);
call post_new('THe forest wejwejwewkenasneanm', 6);
call post_new('Sochnaya dolinaa', 5);
call post_new('Hehehehehehesadasdadasdsadasds', 7);

--add_like_comment
create or replace procedure add_like_comment(p_post_id bigint ,p_like_type varchar,
                                                     p_comment varchar , p_user_id bigint)
        language plpgsql
        as
        $$
begin
insert into "Likes"(post_id, type, user_id) VALUES (p_post_id,p_like_type,p_user_id);
insert into "comments"(post_id, comment, user_id) VALUES (p_post_id, p_comment,p_user_id);
end;
        $$;
call add_like_comment(p_post_id := 3, p_like_type := 'Like', p_comment := 'Hi bro ', p_user_id :=   2);
call add_like_comment(p_post_id := 2, p_like_type := 'Like', p_comment := 'Hi bro ', p_user_id :=   1);
call add_like_comment(p_post_id := 1, p_like_type := 'Dislike', p_comment := 'no bro ', p_user_id :=2);
call add_like_comment(p_post_id := 4, p_like_type := 'Like', p_comment := 'Love bro ', p_user_id := 7);
call add_like_comment(p_post_id := 6, p_like_type := 'Like', p_comment := 'Hdsi bro ', p_user_id :=   6);
call add_like_comment(p_post_id := 2, p_like_type := 'Like', p_comment := 'H3443bro ', p_user_id :=   5);

--Tasks :
--1)
create or replace function search_posts_by_tags(title varchar)
        returns table(    s_id              bigint,
                          s_tags            VARCHAR(255),
                          s_comment_id      BIGINT,
                          s_like_id         BIGINT,
                          s_user_id         BIGINT     )
        language plpgsql
        as
        $$
begin
select * from "Post"
where "tags" ilike '%' || title || '%';
end;
        $$;
select * from search_posts_by_tags( 'asas');

--2)


CREATE OR REPLACE procedure remove_post(p_post_id bigint)
        language plpgsql
        as
        $$
begin
delete from "Post" where id=p_post_id;
delete from "Likes" where post_id=p_post_id;
delete from "comments" where post_id=p_post_id;
end;
        $$;
call remove_post()

--3)
create or replace view show_posts
        as select id,tags, count(user_id) from  "Post";


--4)
--sorry, I didn't added the date for posts
--that is why i couldn't do this task, i ned more time than expected to do this task


