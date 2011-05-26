class Tuner < ActiveRecord::Base
    belongs_to :device
    has_many   :channels

    def current_target()
        %x[hdhomerun_config #{device.ip_address} get /#{address}/target].strip
    end

    def current_frequency()
        %x[hdhomerun_config #{device.ip_address} get /#{address}/channel].strip
    end

    def current_program()
        %x[hdhomerun_config #{device.ip_address} get /#{address}/program].strip
    end

    def current_channel_name()
        frequency = %x[hdhomerun_config #{device.ip_address} get /#{address}/channel].strip
        program   = %x[hdhomerun_config #{device.ip_address} get /#{address}/program].strip
        channel   = channels.find_by_frequency_and_program_id(frequency, program)

        channel ? channel.name : 'none'
    end

    def current_channel_alias()
        frequency = %x[hdhomerun_config #{device.ip_address} get /#{address}/channel].strip
        program   = %x[hdhomerun_config #{device.ip_address} get /#{address}/program].strip
        channel   = channels.find_by_frequency_and_program_id(frequency, program)

        if channel then
            if channel.alias then
                unless channel.alias.empty? then
                    channel.alias
                end
            end
        end
    end

    def next_channel()
        current_channel = channels.find_by_name(current_channel_name)
        current_channel ? (channels[channels.index(current_channel) + 1] || channels[0]) : nil
    end

    def previous_channel()
        current_channel = channels.find_by_name(current_channel_name)
        current_channel ? channels[channels.index(current_channel) - 1] : nil
    end

    def tune_up()
        tune_to(next_channel.name)
    end

    def tune_down()
        tune_to(previous_channel.name)
    end

    def tune_to(channel_name)
        request = channels.find_by_name(channel_name)

        command = <<-eos
hdhomerun_config #{device.ip_address} set /#{address}/channel none;
hdhomerun_config #{device.ip_address} set /#{address}/channel #{request.frequency};
hdhomerun_config #{device.ip_address} set /#{address}/program #{request.program_id};
        eos

        %x[#{command}]
    end

    def stream_to(target_address)
        ip, port = target_address.strip.split(':')

        if port then
            begin
                Integer(port)
                
                if ip.match /\A(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\z/ then
                    %x[hdhomerun_config #{device.ip_address} set /#{address}/target #{ip}:#{port}]
                    return true
                else
                    puts "Incorrect target address #{params[:target_address]}..."
                end
            rescue
                puts "Incorrect parameter #{params[:target_address]}..."
            end
        end

        return false
    end

    def self.status(device_address, tuner_address)
        status = []

        status.push %x[hdhomerun_config #{device_address} get /#{tuner_address}/status].strip.split
        status.push %x[hdhomerun_config #{device_address} get /#{tuner_address}/target].strip.split

        status
    end

    def self.scan(device_address, tuner_address)
        output_filename = "db/data/#{device_address}-#{tuner_address}-channels-#{Time.now.strftime('%Y%m%d-%H%M%S')}"
        scan_filename   = "#{output_filename}.txt"
        data_filename   = "#{output_filename}.yml"
        tuner_id        = tuner_address.sub('tuner', '')

        %x[hdhomerun_config #{device_address} scan #{tuner_id} #{scan_filename}].strip

        if $?.success? then
            %x[lib/process_scan.rb #{scan_filename} > #{data_filename}]

            load "#{RAILS_ROOT}/Rakefile"

            Rake::Task["tunerie:initialize_devices" ].invoke
            Rake::Task["tunerie:remove_channels_of" ].invoke(device_address, tuner_address)
            Rake::Task["tunerie:import_channels_for"].invoke(device_address, tuner_address, data_filename)
        end
    end
end
