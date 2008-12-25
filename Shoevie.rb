Shoes.app( :title => 'Shoe_vie v.0.0.1a', :width => 450, :height => 600, :resizable => true, :margin => 20 ) do

	background "#343".."#eee"
	stroke rgb(0.5, 0.5, 0.7)
	fill rgb(1.0, 1.0, 0.9)

	
	@vid = nil

	@downloading = false
	
	stack(:margin => 10) do
		
		@download_stack = stack(:stroke => black, :strokewidth => 5)do
			
			@rect_download_stack = rect(0, 0, 430, 250, 10)
			@rect_download_stack.style(:stroke => black, :strokewidth => 5)
			
			stack do
				@url_movie_flow = flow(:top => 5, :left => 15) do
					@rect = rect(0, 0, 400, 20, 10)
					@url_para = para "Url:\t"
					@url_para.style(:left => 30)
					@url_movie = edit_line :width => 350, :height => 20, :top => 5
					@rect.height = @url_movie.style[:height] + 10
					#@url_movie_flow .style(:left => 5, :top => 5)
				end
				@name_to_save_flow = flow(:left => 30) do
					@rect = rect(0, 0, 400, 20, 10)
					@name_para = para "Name to save: "
					@name_para.style( :left => 30)
					# TODO - create a dialog for movie finding
					# until now this widget serve to find a local movie
					@file_name_save = edit_line :width => 255, :height => 20, :top => 5
					@rect.height = @file_name_save.style[:height] + 10
					@rect.left = 15
					#@name_to_save_flow. style(:left => 20)
				end
				@start_donwnload_button_flow = flow do
					@button_start_download = button "Start download"
					@button_start_download .style(:width => 350, :left => 35)
					@button_start_download.click  { @downloading = true;@para.text = "@downloading: ",@downloading;hide_download_stack;start_download_movie}
				end
				@stop_donwnload_button_flow = flow do
					@button_stop_download = button "Cancel download"
					@button_stop_download .style(:width => 350, :left => 35)
					@button_stop_download.click  { @downloading = false;@para.text = "@downloading: ",@downloading;hide_download_stack;stop_download_movie}
					#@button_stop_download.click  { @downloading = false;@para.text = "@downloading: ",@downloading;(@stop_donwnload_button_flow.style(:hidden => true);@start_donwnload_button_flow.style(:hidden => false));stop_download_movie}
				end
				@status_download_stack = stack do
					flow do
						@status_head = para "Status: "
						@status = para
					end
					
					flow do
						@rect = rect(0, 0, 400, 20, 10)
						@progress_download = para  "Progress\t"
						@progress_download.left = 20
						@p_download = progress :width => 200, :height => 20, :top => 5
						@rect.left = @p_download.left
						@rect.top = @p_download.top
						@rect.height = @p_download.style[:height] + 10
					end
				end
			end
			@status_download_flow = flow do
				@rect = rect(15, 5, 400, 30, 10)
				@rect.style(:stroke => red, :strokewidth => 5)
				@status_download_para = para "Downloads Status\t\t",
					#link("hide")  { @status_download_stack.hide if @downloading == false; @downloading = !@downloading;@para.text = @downloading }, ", ",
					#link("show")  { @status_download_stack.show if @downloading == true; @downloading = !@downloading;@para.text = @downloading }
					#link("hide")  { @downloading = !@downloading;@para.text = @downloading; hide_download_stack }, ", ",
					link("hide")  { @status_download_stack.hide }, ", ",
					#link("show")  { @downloading = !@downloading;@para.text = @downloading; hide_download_stack }
					link("show")  { @status_download_stack.show}, " or ",
					link("toggle")  { @status_download_stack.toggle}
				@status_download_para.style(:left => 30)
			end
		end

		
		
		@downloads_flow = flow do
			@rect = rect(15, 5, 400, 30, 10)
			@rect.style(:stroke => red, :strokewidth => 5)
			
			@downloads_para = para "Downloads\t\t\t\t",
				link("hide")  { @download_stack.hide }, ", ",
				link("show")  { @download_stack.show }, " or ",
				link("toggle")  { @download_stack.toggle}
			@downloads_para.style(:left => 30)	
		end
		@controls_all_stack = stack do
			@rect = rect(0, 70, 430, 100, 10)
			@rect.style(:stroke => yellow, :strokewidth => 5)
			@time = para
			stack do
				flow(:top => 25, :left => 15) do
					@rect = rect(10, -50, 400, 30, 10)
					@rect.style(:stroke => black, :strokewidth => 5)
					@progress_time = para  "Time progress\t\t"
					@progress_time.left = 30
					@p_time = progress :width => 200, :height => 20, :top => 5
					@rect.left = @p_time.left
					@rect.top = @p_time.top
					@rect.height = @p_time.style[:height] + 10
				end

				@time_ellapsed =
					animate do |i|
						@time.text = "Time ellapsed: ", @vid.time / 1000 < 10 ? "0" + (@vid.time / 1000).to_s : @vid.time / 1000, " seconds"
						@p_time.fraction = (@vid.position)
					end
				
				@controls_stack = stack do
					@rect = rect(15, 0, 400, 30, 10)
					@rect.style(:stroke => red, :strokewidth => 5)
					
					@controls = para "Controls: ",
						#link("play")  { @vid = video @file_name_to_save if !@file_name_to_save.nil?; @vid.play; @time_ellapsed  }, ", ",
						#link("play")  { @vid.play; @time_ellapsed ; @vid = video @file_name_save.text}, ", ",
						#link("play")  { @vid = video 'movie.flv'}, ", ",
						link("play")  { play_movie}, ", ",
						link("pause") { @vid.pause }, ", ",
						link("stop")  { @vid.stop }, ", ",
						link("hide")  { @vid.hide }, ", ",
						link("show")  { @vid.show }, ", ",
						link("+5 sec") { @vid.time += 5000 if (@vid.time < @vid.length - 6000) }, ", ",
						link("-5 sec") { @vid.time -= 5000 if (@vid.time > 6000) }
					@controls.left = 30
					#@rect.left = @controls.left
					@rect.top = @controls.top 
				end
			end
		end
	end
	def start_download_movie
		@default_url = "http://whytheluckystiff.net/o..e/adventure_time.flv"
		
		@url_movie.text == '' ? @url = @default_url : @url = @url_movie.text
		@file_name_save.text == '' ? @file_name_to_save = 'movie.flv' : @file_name_to_save = @file_name_save.text
		
		@status.text = "Fetching #{@file_name_to_save}"
		@download = download @url,  :save =>  @file_name_to_save,
				# TODO	- search for local movies, list, etc
				# FIXME 	- free @vid from :start
				:start => proc { |dl| @status.text = "Connecting..." ; @vid = video @file_name_to_save if !@file_name_to_save.nil?},
				:progress => proc { |dl| @status.text = "#{dl.percent}% complete";  animate(24) {|i| @p_download.fraction = (dl.percent % 100) / 100.0}},
				:finish => proc { |dl| @status.text = "Download finished" },
				:error => proc { |dl, err| @status.text = "Error: #{err}" }
	end

	def stop_download_movie	
		@download .abort
		#@download.remove
	end
	
	def play_movie
		@para.text ="Playing"
		@vid = video @file_name_to_save if !@file_name_to_save.nil?
		#@vid = video 'movie.flv'
		@vid.play
		@time_ellapsed
	end
	
		
		def hide_download_stack
			# @status_download_stack style: hidden if @downloading == false
			@downloading == false ? @status_download_stack.style(:hidden => true) : @status_download_stack.style(:hidden => false)#Ok
			# @stop_donwnload_button_flow and @start_donwnload_button_flow if @downloading == false
			@downloading == false ? (@stop_donwnload_button_flow.style(:hidden => true);@start_donwnload_button_flow.style(:hidden => false)) : (@stop_donwnload_button_flow.style(:hidden => false);@start_donwnload_button_flow.style(:hidden => true))
			#(@stop_donwnload_button_flow.style(:hidden => true);@start_donwnload_button_flow.style(:hidden => false)) if (@downloading == false)
			#(@stop_donwnload_button_flow.style(:hidden => false);@start_donwnload_button_flow.style(:hidden => true)) if(@downloading == true) 
		end
			
	
	def initalize
		hide_download_stack
	end
	initalize
	@para = para ####################################################################
end