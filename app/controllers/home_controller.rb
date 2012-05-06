class HomeController < ActionController::Base
  protect_from_forgery
  
   def index   
     debugger
   	session[:oauth] = Koala::Facebook::OAuth.new("346388618750225", "68829e886776fdb6ae7d709d0d32230c", Facebook::CALLBACK_URL + '/home/callback')
		@auth_url =  session[:oauth].url_for_oauth_code(:permissions=>"read_stream") 	
		puts session.to_s + "<<< session"

  	respond_to do |format|
			 format.html {  }
		 end
  end

	def callback
  	if params[:code]
  		# acknowledge code and get access token from FB
		  session[:access_token] = session[:oauth].get_access_token(params[:code])
		end		

		 # auth established, now do a graph call:

		@api = Koala::Facebook::API.new(session[:access_token])
		begin
			@graph_data = @api.get_object("/me/statuses", "fields"=>"message")
		rescue Exception=>ex
			puts ex.message
		end

  
 		respond_to do |format|
		 format.html {   }			 
		end


	end
end