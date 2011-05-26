namespace :tunerie do
    desc "Discover and initialize devices"
    task :initialize_devices => :environment do
        result = %x[hdhomerun_config discover]
        next unless $?.success?

        result.split("\n").each do |line|
            address, ip_address = line.sub("hdhomerun device",'').sub("found at", '').split

            if Device.find_by_address(address) then
                puts "Device #{address} at #{ip_address} skipped..."
            else
                device = Device.new
                device.address            = address
                device.ip_address         = ip_address
                device.name               = "SiliconDust HDHomeRun #{address} at #{ip_address}"
                device.model_number       = %x[hdhomerun_config #{address} get /sys/model    ].strip
                device.features           = %x[hdhomerun_config #{address} get /sys/features ].strip
                device.firmware_version   = %x[hdhomerun_config #{address} get /sys/version  ].strip
                device.firmware_copyright = %x[hdhomerun_config #{address} get /sys/copyright].strip
                device.save

                puts "Device #{address} at #{ip_address} created..."

                tuner_index = 0

                begin
                    tuner_status = %x[hdhomerun_config #{address} get /tuner#{tuner_index}/status]

                    unless no_more = ($? != 0)
                        device.tuners.create :address => "tuner#{tuner_index}"
                        puts "-> Tuner tuner#{tuner_index} created..."
                        tuner_index += 1
                    end
                end until no_more
            end
        end
    end

    desc "Scan and initialize channels of a device tuner"
    task :initialize_channels_of, [ :device_address, :tuner_address ] => :environment do |name, args|
        Tuner.scan(args[:device_address], args[:tuner_address])
    end

    desc "Import channels information from existing data files"
    task :import_channels => :environment do
        Device.all.each do |device|
            device.tuners.each do |tuner|
                data_filename = "db/data/#{device.address}-#{tuner.address}-channels.yml"

                if File.exist? data_filename then
                    data = []
                    
                    File.open(data_filename) do |data_file| 
                        YAML.load_documents(data_file) { |document| data.push document }
                    end

                    channels, aliases = data

                    channels.keys.each do |name|
                        tuner.channels.create(
                                              :name        => name,
                                              :alias       => (aliases ? aliases[name] : nil),
                                              :frequency   => channels[name][0],
                                              :program_id  => channels[name][1],
                                              :description => channels[name][2]
                                              )

                        puts "Channel #{name} for device #{device.address} #{tuner.address} created..."
                    end
                end
            end
        end
    end

    desc "Remove all existing channels information"
    task :remove_channels => :environment do
        Device.all.each do |device|
            device.tuners.each do |tuner|
                tuner.channels = []
            end
        end

        Channel.destroy_all
    end

    desc "Remove existing channels information of a device tuner"
    task :remove_channels_of, [ :device_address, :tuner_address ] => :environment do |name, args|
        device_address = args[:device_address]
        tuner_address  = args[:tuner_address]
 
        device = Device.find_by_address(device_address)
        tuner  = device.tuners.find_by_address(tuner_address) if device
 
        if tuner && device then
            tuner.channels.each do |channel|
                channel.destroy
            end

            tuner.channels = []
        else
            puts "Tuner or device not found"
        end
    end

    desc "Import channels information for a device tuner"
    task :import_channels_for, [ :device_address, :tuner_address, :data_filename ] => :environment do |name, args|
        device_address = args[:device_address]
        tuner_address  = args[:tuner_address]
        data_filename  = args[:data_filename]

        device = Device.find_by_address(device_address)
        tuner  = device.tuners.find_by_address(tuner_address) if device

        import_channels_for(device, tuner, data_filename)
    end

    def import_channels_for(device, tuner, data_filename)
        if tuner && tuner.channels.count > 0 then
            puts "Tuner channels are not empty"
            return
        end

        if (File.exist? data_filename) && tuner && device then
            data = []
            
            File.open(data_filename) do |data_file| 
                YAML.load_documents(data_file) { |document| data.push document }
            end

            channels, aliases = data

            channels.keys.each do |name|
                tuner.channels.create(
                                      :name        => name,
                                      :alias       => (aliases ? aliases[name] : nil),
                                      :frequency   => channels[name][0],
                                      :program_id  => channels[name][1],
                                      :description => channels[name][2]
                                      )

                puts "Channel #{name} for device #{device.address} #{tuner.address} created..."
            end
        else
            puts "Data file [#{data_filename}], tuner [#{tuner}], or device [#{device}] not found"
        end
    end
end
