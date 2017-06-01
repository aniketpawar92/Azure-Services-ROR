class WaypointController < ApplicationController
	protect_from_forgery with: :null_session
	require 'json'

	def waypoint
		# $connection_string = (ActiveRecord::Base.configurations["azure_dayplanner_db"])
		# @adapter_name = $connection_string["adapter"]
		# @database_name = $connection_string["database"]
		# @host_name = $connection_string["host"]
		# @username = $connection_string["username"]
		# @password = $connection_string["password"]
		# @port = $connection_string["port"]

		# $connection = ActiveRecord::Base.establish_connection(adapter: @adapter_name, database: @database_name, host: @host_name, username: @username, password: @password, port: @port)
		# $connection = ActiveRecord::Base.establish_connection("postgres://postgres%40postgresql3jx7gzpurh7yi:pg%4012345@postgresql3jx7gzpurh7yi.postgres.database.azure.com:5432/dayplanner?sslmode=require")
		
		
		# # $connection_string = (ActiveRecord::Base.configurations["azure_dayplanner_db"])
		# # @database_url = $connection_string["azure_db_url"]
		
		# $connection = ActiveRecord::Base.establish_connection("postgres://postgres%40postgresql3jx7gzpurh7yi:pg%4012345@postgresql3jx7gzpurh7yi.postgres.database.azure.com:5432/dayplanner?sslmode=require")
		# # $connection = ActiveRecord::Base.establish_connection(@database_url)
		
		if request.post?
			if params
				title = params[:title]
				meeting_date =  params[:meeting_date]
				start_time = params[:start_time]
				end_time = params[:end_time]
				loc_name= params[:loc_name]
				latitude = params[:lat]
				longitude = params[:long]
				query = "INSERT INTO engagements(loc_name, title, date, start_time, end_time, location) VALUES ('#{loc_name}', '#{title}', '#{meeting_date}', '#{start_time}', '#{end_time}', ST_GeographyFromText('point(#{longitude} #{latitude})'));";
				$request = ActiveRecord::Base.connection.execute(query)
				objLocationArray = Array.new
				$results.each{|r| objLocationArray.push(r)}
				@data=objLocationArray
				respond_to do |format|
					format.html
					format.json { render json: $results }  # respond with the created JSON object
				end
			end
		else
			if params[:date]
			
			datavalue = '[{
							"name": "azure-index-data",
							"fields": [
											{
												"name": "loc_id",
												"type": "Edm.String",
												"searchable": false,
												"filterable": false,
												"retrievable": true,
												"sortable": false,
												"facetable": false,
												"key": true,
												"analyzer": null
											}
										]
						}]'
				
				puts "================="
				headers = { 'api-key' => '0056EBFF01B474C0756578D890EDC628', 'Content-Type' => 'application/json' }
				me_endpt = URI('https://aniket.search.windows.net/indexes/azure-search-data/?api-version=2016-09-01')
				puts "************************"
				
				request = Net::HTTP::Put.new(me_endpt, headers)
				puts request
				
				request.body = datavalue.to_json
				
				# request.use_ssl = true
				# # JSON.parse(http.get(me_endpt, headers).body)
				
				 # @json = JSON.parse(request.body.read)
				
				# # JSON.parse(http.request(me_endpt, headers).body)
				# response = (http.request(me_endpt, headers).body).to_json
				
				
				# request.body =   []
				# puts request				
				response = http.request(request)
				puts "#################################"
				# puts response
			end
		end
	end

	def create

	end
	def show

	end
end
