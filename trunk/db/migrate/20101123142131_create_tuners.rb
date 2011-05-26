class CreateTuners < ActiveRecord::Migration
    def self.up
        create_table :tuners do |t|
            t.string  :address
            t.integer :device_id
            
            t.timestamps
        end
    end

    def self.down
        drop_table :tuners
    end
end
