#! /usr/bin/ruby

scan = File.open(ARGV[0])

channels    = []
record_open = nil
dont_push   = nil

current_scan_line, current_lock_line, current_tsid_line, current_programs = nil

begin
    while true do
        line = scan.readline
        
        if line =~ /SCANNING/ then
            if record_open then
                dont_push = true unless (current_tsid_line && current_programs)

                unless dont_push then
                    channels.push({ current_scan_line => [ current_lock_line, current_tsid_line, current_programs ] })
                else
                    dont_push = nil
                end

                current_scan_line, current_lock_line, current_tsid_line, current_programs = nil
            else
                record_open = true
            end

            current_scan_line = line
        elsif line =~ /LOCK/ then
            current_lock_line = line
            
            if line =~ /LOCK: none/ then
                dont_push = true
            end
        elsif line =~ /TSID/ then
            current_tsid_line = line
        elsif line =~ /PROGRAM/ then
            unless line =~ /encrypted/ || line =~ /control/ || line =~ /no data/ then
                current_programs ||= []
                current_programs.push line
            end
        end
    end
rescue EOFError
    scan.close
end

program_aliases = []

puts "---"

puts ""
puts "# Channel lineup"
puts ""

channels.each do |record|
    record.keys.each do |line|
        cable_id = line.split[3].split(':')[1].chop
        encoder  = record[line][0].split[1]

        record[line][2].each do |program|
            program_alias = nil
            program_info  = program.split
            program_id    = program_info[1].chop

            if program_info.count == 4 then
                program_alias = program_info[3]
                program_name  = 'Channel ' + program_alias
            else
                program_name = 'No description'
            end

            channel_name = sprintf "CHANNEL-%03d-%-4d", cable_id, program_id 

            printf "%s : [ \"%s:%s\", %4d, \"%s\" ]\n", 
                channel_name, encoder, cable_id, program_id, program_name

            if program_alias then
                program_aliases.push(sprintf "%s : %s\n", channel_name, program_alias)
            end
        end
    end
end

if program_aliases.count > 0 then
    puts "---"
    puts ""
    puts "# Channel aliases"
    puts ""

    program_aliases.each do |entry|
        puts entry
    end
end

puts "..."
