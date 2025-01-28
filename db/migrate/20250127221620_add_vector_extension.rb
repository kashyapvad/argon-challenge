# db/migrate/20250127000000_add_pgvector_extension.rb

class AddVectorExtension < ActiveRecord::Migration[7.2]
  def change
    enable_extension 'vector' unless extension_enabled?('vector')
  end
end
