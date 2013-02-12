# encoding: utf-8
class AddSocialToPage < ActiveRecord::Migration
  def change
    add_column :pages, :facebook, :integer
    add_column :pages, :twitter, :integer
    add_column :pages, :linkedin, :integer
    add_column :pages, :gplus, :integer
  end
end