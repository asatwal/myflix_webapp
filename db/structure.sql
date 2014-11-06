CREATE TABLE "categories" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "invitations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email_address" varchar(255), "full_name" varchar(255), "message" text, "inviter_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "queue_items" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "position" integer, "user_id" integer, "video_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "relationships" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "follower_id" integer, "leader_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "reviews" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "comment" text, "rating" integer, "user_id" integer, "reviewable_type" varchar(255), "reviewable_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email_address" varchar(255), "full_name" varchar(255), "password_digest" varchar(255), "created_at" datetime, "updated_at" datetime, "token" varchar(255));
CREATE TABLE "videos" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "description" text, "small_cover_url" varchar(255), "large_cover_url" varchar(255), "created_at" datetime, "updated_at" datetime, "category_id" integer);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20140829150644');

INSERT INTO schema_migrations (version) VALUES ('20140829195506');

INSERT INTO schema_migrations (version) VALUES ('20140903172048');

INSERT INTO schema_migrations (version) VALUES ('20140903183638');

INSERT INTO schema_migrations (version) VALUES ('20140907192746');

INSERT INTO schema_migrations (version) VALUES ('20140912160908');

INSERT INTO schema_migrations (version) VALUES ('20140918125938');

INSERT INTO schema_migrations (version) VALUES ('20141005132008');

INSERT INTO schema_migrations (version) VALUES ('20141010174118');

INSERT INTO schema_migrations (version) VALUES ('20141016112229');

