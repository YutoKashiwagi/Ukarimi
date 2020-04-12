class ChangeColumnNull < ActiveRecord::Migration[5.2]
  def up
    # answers
    change_column_null :answers, :content, false
    change_column_null :answers, :question_id, false
    change_column_null :answers, :user_id, false
    # categories
    change_column_null :categories, :name, false
    # comments
    change_column_null :comments, :content, false
    change_column_null :comments, :user_id, false
    change_column_null :comments, :commentable_type, false
    change_column_null :comments, :commentable_id, false
    # likes
    change_column_null :likes, :user_id, false
    change_column_null :likes, :likable_type, false
    change_column_null :likes, :likable_id, false
    # posts
    change_column_null :posts, :user_id, false
    change_column_null :posts, :content, false
    # q_and_a_relationships
    change_column_null :q_and_a_relationships, :question_id, false
    change_column_null :q_and_a_relationships, :answer_id, false
    # questions
    change_column_null :questions, :content, false
    change_column_null :questions, :user_id, false
    change_column_null :questions, :title, false
    change_column_null :questions, :solved, false, 0
    # relationships
    change_column_null :relationships, :followee_id, false
    change_column_null :relationships, :follower_id, false
    # stocks
    change_column_null :stocks, :user_id, false
    change_column_null :stocks, :question_id, false
    # tag_relationships
    change_column_null :tag_relationships, :category_id, false
    change_column_null :tag_relationships, :taggable_type, false
    change_column_null :tag_relationships, :taggable_id, false
    # users
    change_column_null :users, :name, false
    change_column_null :users, :bunri, false, 0
    change_column_null :users, :role, false, 0
  end
  
  def down
    # answers
    change_column_null :answers, :content, true
    change_column_null :answers, :question_id, true
    change_column_null :answers, :user_id, true
    # categories
    change_column_null :categories, :name, true
    # comments
    change_column_null :comments, :content, true
    change_column_null :comments, :user_id, true
    change_column_null :comments, :commentable_type, true
    change_column_null :comments, :commentable_id, true
    # likes
    change_column_null :likes, :user_id, true
    change_column_null :likes, :likable_type, true
    change_column_null :likes, :likable_id, true
    # posts
    change_column_null :posts, :user_id, true
    change_column_null :posts, :content, true
    # q_and_a_relationships
    change_column_null :q_and_a_relationships, :question_id, true
    change_column_null :q_and_a_relationships, :answer_id, true
    # questions
    change_column_null :questions, :content, true
    change_column_null :questions, :user_id, true
    change_column_null :questions, :title, true
    change_column_null :questions, :solved, true, 0
    # relationships
    change_column_null :relationships, :followee_id, true
    change_column_null :relationships, :follower_id, true
    # stocks
    change_column_null :stocks, :user_id, true
    change_column_null :stocks, :question_id, true
    # tag_relationships
    change_column_null :tag_relationships, :category_id, true
    change_column_null :tag_relationships, :taggable_type, true
    change_column_null :tag_relationships, :taggable_id, true
    # users
    change_column_null :users, :name, true
    change_column_null :users, :bunri, true, 0
    change_column_null :users, :role, true, 0
  end
end
