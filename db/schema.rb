# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140406110941) do

  create_table "answers", force: true do |t|
    t.integer  "question_id"
    t.text     "content"
    t.integer  "added_by"
    t.integer  "upvote"
    t.integer  "downvote"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friends", force: true do |t|
    t.integer  "user1"
    t.integer  "user2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_comments", force: true do |t|
    t.integer  "post_id"
    t.string   "comment"
    t.integer  "added_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_members", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_posts", force: true do |t|
    t.string   "content"
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_requests", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "privacy"
    t.integer  "admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "timeline_pic_file_name"
    t.string   "timeline_pic_content_type"
    t.integer  "timeline_pic_file_size"
    t.datetime "timeline_pic_updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "user_from"
    t.integer  "user_to"
    t.text     "content"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "non_verified_users", force: true do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "email"
    t.string   "password"
    t.string   "passcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "like"
    t.string   "privacy"
    t.integer  "admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_pic_file_name"
    t.string   "profile_pic_content_type"
    t.integer  "profile_pic_file_size"
    t.datetime "profile_pic_updated_at"
    t.string   "timeline_pic_file_name"
    t.string   "timeline_pic_content_type"
    t.integer  "timeline_pic_file_size"
    t.datetime "timeline_pic_updated_at"
  end

  create_table "pages_likes", force: true do |t|
    t.integer  "user_id"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages_posts", force: true do |t|
    t.string   "content"
    t.integer  "likes"
    t.integer  "page_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pending_friends", force: true do |t|
    t.integer  "user1"
    t.integer  "user2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personal_informations", force: true do |t|
    t.string   "gender"
    t.string   "city"
    t.string   "university"
    t.string   "phone"
    t.string   "birthday"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_comments", force: true do |t|
    t.integer  "post_id"
    t.integer  "likes"
    t.string   "comment"
    t.integer  "added_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_tags", force: true do |t|
    t.integer  "question_id"
    t.string   "tag_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "added_by"
    t.string   "privacy"
    t.integer  "upvote"
    t.integer  "downvote"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_pic_file_name"
    t.string   "profile_pic_content_type"
    t.integer  "profile_pic_file_size"
    t.datetime "profile_pic_updated_at"
    t.string   "timeline_pic_file_name"
    t.string   "timeline_pic_content_type"
    t.integer  "timeline_pic_file_size"
    t.datetime "timeline_pic_updated_at"
  end

  create_table "wall_comment_likes", force: true do |t|
    t.integer  "wall_comment_id"
    t.integer  "liked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wall_post_comments", force: true do |t|
    t.integer  "wall_post_id"
    t.integer  "likes"
    t.string   "comment"
    t.integer  "added_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wall_post_likes", force: true do |t|
    t.integer  "wall_post_id"
    t.integer  "liked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wall_posts", force: true do |t|
    t.string   "content"
    t.integer  "likes"
    t.integer  "from_id"
    t.integer  "to_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
