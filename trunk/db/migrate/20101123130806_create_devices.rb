class CreateDevices < ActiveRecord::Migration
    def self.up
        create_table :devices do |t|
            t.string :name
            t.string :address
            t.string :ip_address
            t.string :model_number
            t.text   :features
            t.string :firmware_version
            t.string :firmware_copyright

            t.timestamps
        end
    end

    def self.down
        drop_table :devices
    end
end
