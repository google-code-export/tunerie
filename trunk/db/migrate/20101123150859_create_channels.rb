class CreateChannels < ActiveRecord::Migration
    def self.up
        create_table :channels do |t|
            t.string  :name
            t.string  :alias
            t.string  :frequency
            t.string  :program_id
            t.text    :description
            t.string  :website_url
            t.string  :program_feed_url
            t.integer :tuner_id

            t.timestamps
        end
    end

    def self.down
        drop_table :channels
    end
end
