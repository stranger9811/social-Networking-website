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

ActiveRecord::Schema.define(version: 20140308164136) do

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
    t.integer  "likes"
    t.string   "privacy"
    t.integer  "admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "post_comments", force: true do |t|
    t.integer  "post_id"
    t.integer  "likes"
    t.string   "comment"
    t.integer  "added_by"
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
  end

end
