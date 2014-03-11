class AddWordCountColumnToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :word_count, :integer
    remove_column :versions, :word_count, :integer
  end
end
