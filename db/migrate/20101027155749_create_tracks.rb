class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string :name
      t.string :file_name
      t.string :data_type
      t.boolean :disease_specific, :default => false
      t.integer :parent_id, :default => 0
      t.string :platform
      t.string :genome_assembly
      t.string :selection_method
      t.string :selection_criteria
      t.integer :regions_count, :default => 0
      t.string :source
      t.string :source_link
      t.integer :pmid
    end
    add_index :tracks, :data_type
  end

  def self.down
    drop_table :tracks
  end
end
