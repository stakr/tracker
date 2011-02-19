module Stakr #:nodoc:
  module Tracker #:nodoc:
    module Controller
      
      def self.included(base) #:nodoc:
        base.class_eval do
          around_filter :track_request
        end
      end
      
      def track_request #:nodoc:
        yield
      ensure
        attributes = {}
        
        # current request
        
        attributes[:method]     = request.method.to_s.upcase
        
        attributes[:scheme]     = request.ssl? ? 'https' : 'http'
        attributes[:host]       = request.host
        attributes[:port]       = request.port
        begin
          c = URI.split(request.request_uri)
          attributes[:path]     = c[5]
          attributes[:query]    = c[7]
          attributes[:fragment] = c[8]
        rescue
          attributes[:path]     = request.path
          attributes[:query]    = request.query_string
        end
        
        attributes[:controller] = controller_path
        attributes[:action]     = params[:action]
        
        # client information
        
        attributes[:remote_ip]  = request.remote_ip
        attributes[:session_id] = request.session_options[:id]
        attributes[:user_agent] = request.headers["User-Agent"]
        
        # referer
        
        if referer = request.headers["Referer"]
          begin
            
            r = URI.split(referer)
            attributes[:referer_scheme]   = r[0]
            attributes[:referer_host]     = r[2]
            attributes[:referer_port]     = r[3].blank? ? ((r[0] == 'https') ? 443 : 80) : r[3]
            attributes[:referer_path]     = r[5]
            attributes[:referer_query]    = r[7]
            attributes[:referer_fragment] = r[8]
            
            if current_application?(r)
              begin
                referer_params = recognized_params(r)
                attributes[:referer_controller] = referer_params[:controller]
                attributes[:referer_action]     = referer_params[:action]
              rescue
                # do nothing
              end
            end
            
          rescue
            # do nothing
          end
        end
        
        # response
        
        attributes[:response_status]  = response.status
        
        # redirect
        
        if (response.status.to_i / 100 == 3) && (location = response.location)
          begin
            
            l = URI.split(location) rescue nil
            attributes[:redirect_scheme]   = l[0]
            attributes[:redirect_host]     = l[2]
            attributes[:redirect_port]     = l[3].blank? ? ((l[0] == 'https') ? 443 : 80) : l[3]
            attributes[:redirect_path]     = l[5]
            attributes[:redirect_query]    = l[7]
            attributes[:redirect_fragment] = l[8]
            
            if current_application?(l)
              begin
                redirect_params = recognized_params(l)
                attributes[:redirect_controller] = redirect_params[:controller]
                attributes[:redirect_action]     = redirect_params[:action]
              rescue
                # do nothing
              end
            end
            
          rescue
            # do nothing
          end
        end
        
        # store request
        TrackerRequest.create!(attributes)
        
      end
      
      private
        
        def current_application?(url)
          (url[2] == request.host) && (url[3].blank? ? ((url[0] == 'https') ? 443 : 80) : url[3])
        end
        
        def recognized_params(url)
          ActionController::Routing::Routes.recognize_path(url[5])
        end
      
    end
  end
end
