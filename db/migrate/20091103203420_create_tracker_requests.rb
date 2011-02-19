class CreateTrackerRequests < ActiveRecord::Migration
  
  def self.up
    create_table :tracker_requests do |t| # :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8"
      
      # current request
      
      t.string  :method, :limit => 8, :null => false
      
      t.string  :scheme, :limit => 8, :null => false
      t.string  :host,                :null => false
      t.integer :port,                :null => false
      t.string  :path,                :null => false
      t.string  :query
      t.string  :fragment
      
      t.string  :controller,          :null => false
      t.string  :action,              :null => false
      
      # client information
      
      t.string  :remote_ip,           :null => false
      t.string  :session_id
      t.string  :user_agent
      
      # referer
      
      t.string  :referer_scheme, :limit => 8
      t.string  :referer_host
      t.integer :referer_port
      t.string  :referer_path
      t.string  :referer_query
      t.string  :referer_fragment
      
      t.string  :referer_controller
      t.string  :referer_action
      
      # response
      
      t.integer :response_status
      
      # redirect
      
      t.string  :redirect_scheme, :limit => 8
      t.string  :redirect_host
      t.integer :redirect_port
      t.string  :redirect_path
      t.string  :redirect_query
      t.string  :redirect_fragment
      
      t.string  :redirect_controller
      t.string  :redirect_action
      
      # timestamp
      t.timestamp   :created_at
      
    end
  end
  
  def self.down
    drop_table :tracker_requests
  end
  
end
