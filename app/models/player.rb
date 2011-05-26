class Player < ActiveRecord::Base
    include HTTParty
    format :xml

    def current_state_in(status)
        status["root"]["state"]
    end

    def current_title_in(status)
        status["root"]["information"]["meta_information"]["title"]
    end

    def current_status()
        self.class.get("#{control_url}/requests/status.xml")
    end

    def current_playlist()
        list = self.class.get("#{control_url}/requests/playlist.xml")

        if list then
            (leaf = list["node"]["node"][0]["leaf"]).class == Hash ? [ leaf ] : leaf
        end
    end

    def control_url()
        "http://#{ip_address}" + (port ? ":#{port}"  : "")
    end

    def playback(content_address)
        self.class.get("#{control_url}/requests/status.xml?command=in_play&input=#{content_address}")
    end

    def playback_track(id)
        self.class.get("#{control_url}/requests/status.xml?command=pl_play&id=#{id}")
    end
end
