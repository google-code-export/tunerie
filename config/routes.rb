Tunerie::Application.routes.draw do
    match 'tuner(/index.:format)' => 'tuner#index', :as => :tuner
    match 'tuner/channel/:device_address/:tuner_address(/:channel_name)'  => 'tuner#channel', :as => :channel
    match 'tuner/channel/:device_address/:tuner_address(.:format)'  => 'tuner#channel', :as => :channel
    match 'tuner/target/:device_address/:tuner_address(/:target_address)' => 'tuner#target', :as => :target
    match 'tuner/get_player_status' => 'tuner#get_player_status', :as => :get_player_status
    match 'tuner/target_player/:player_address(/:content_address)' => 'tuner#target_player', :as => :target_player
    match 'tuner/playback_track/:player_address/:id' => 'tuner#playback_track', :as => :playback_track
    match 'tuner/tune_up/:device_address/:tuner_address' => 'tuner#tune_up', :as => :tune_up
    match 'tuner/tune_down/:device_address/:tuner_address' => 'tuner#tune_down', :as => :tune_down
    match 'tuner/setup' => 'tuner#setup', :as => :setup

    root :to => 'tuner#index'
end
