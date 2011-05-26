class Device < ActiveRecord::Base
    has_many :tuners, :dependent => :destroy

    def self.discover()
        result = %x[hdhomerun_config discover].strip.split

        if $?.success? then
            device_address    = result[2]
            device_ip_address = result[5]

            searching_for_tuner  = true
            tuner_id          = 0
            tuners            = []

            while searching_for_tuner do
                result = %x[hdhomerun_config #{device_address} get /tuner#{tuner_id}/status].strip.split
                
                if $?.success? then
                    tuners.push tuner_id
                    tuner_id += 1
                else
                    searching_for_tuner = false
                end
            end

            puts "Device #{device_address} found at #{device_ip_address} with #{tuners.count} tuners"

            { 'device_address' => device_address, 'device_ip_address' => device_ip_address, 'tuners_count' => tuners.count }
        end
    end
end
