class ChangeSupplementContentsAddSti < ActiveRecord::Migration
  def change
    add_column :supplement_contents, :type, :string
    add_index :supplement_contents, :type

    add_column :supplement_contents, :wiki_markup, :text
    add_index :supplement_contents, :wiki_markup
  end
end
