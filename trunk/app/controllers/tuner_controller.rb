class TunerController < ApplicationController
    before_filter :find_device, :setup_growl, :except => [ :index, :setup ]

    def index()
        @devices = Device.all
        @players = Player.all

        respond_to do |format|
            format.html
        end
    end

    def target()
        if params[:target_address] then
            if @tuner.stream_to(params[:target_address]) then
                notify "#{params[:target_address]}"
                redirect_to channel_url
                return
            end
        end

        refresh_program_info

        respond_to do |format|
            format.html
        end
    end

    def channel()
        @tuner.tune_to(params[:channel_name]) if params[:channel_name]
        refresh_program_info
        notify "#{@channel.alias || @channel_name}" if params[:channel_name]

        respond_to do |format|
            format.html
        end
    end

    def tune_up()
        @tuner.tune_up
        redirect_to channel_url
    end

    def tune_down()
        @tuner.tune_down
        redirect_to channel_url
    end

    def setup()
        @discovered = Device.discover

        respond_to do |format|
            format.html
        end
    end

    private

    def find_device()
        @device_address = params[:device_address]
        @tuner_address  = params[:tuner_address]
        @device         = Device.find_by_address(@device_address)
        @tuner          = @device.tuners.find_by_address(@tuner_address)
        @channels       = @tuner.channels
    end

    def refresh_program_info()
        @target        = @tuner.current_target
        @frequency     = @tuner.current_frequency
        @program       = @tuner.current_program
        @channel       = @channels.find_by_frequency_and_program_id(@frequency, @program)
        @channel_name  = @channel ? @channel.name  : ''
        @channel_alias = @channel ? @channel.alias : ''
    end

    def setup_growl()
        if GROWL_CONFIG['send_notifications'] then
            @growl = Growl.new GROWL_CONFIG['server'], application_name.downcase, [ "#{application_name} Notifications" ], [ "#{application_name} Notifications" ], GROWL_CONFIG['password']
        end
    end

    def notify(message)
        @growl.notify("#{application_name} Notifications", application_name, message) if @growl
    end
end
