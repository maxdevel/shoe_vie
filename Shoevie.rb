Shoes.app :title => 'Shoe_vie v.0.0.1', :width => 450, :height => 600, :resizable => true do

	# This NOW BLOCK the app
	#attr_accessor @file_name_to_save

	background "#eee"
	stroke rgb(0.5, 0.5, 0.7)
	fill rgb(1.0, 1.0, 0.9)

	@rect = rect(0, 0, 448, 255, 10)
	@vid = nil

	stack :margin => 4 do
		
		stack do
			flow do
				@rect = rect(0, 0, 400, 20, 10)
				para "Url:\t"
				@url_movie = edit_line :width => 350, :height => 20, :top => 5
				@rect.height = @url_movie.style[:height] + 10
			end
			flow do
				@rect = rect(0, 0, 400, 20, 10)
				para "Name to save: "
				# TODO - create a dialog for movie finding
				# until now this widget serve to find a local movie
				@file_name_save = edit_line :width => 255, :height => 20, :top => 5
				@rect.height = @file_name_save.style[:height] + 10
			end
			@button_download = button "Download"
			@button_download.click  {download_movie}
			
		end

		@time = para
		
		flow do
			@rect = rect(0, 0, 400, 20, 10)
			@progress_time = para  "Time progress\t\t"
			@progress_time.left = 20
			@p_time = progress :width => 200, :height => 20, :top => 5
			@rect.left = @p_time.left
			@rect.top = @p_time.top
			@rect.height = @p_time.style[:height] + 10
		end
		
		flow do
			@rect = rect(0, 0, 400, 20, 10)
			@progress_download = para  "Download progress\t"
			@progress_download.left = 20
			@p_download = progress :width => 200, :height => 20, :top => 5
			@rect.left = @p_download.left
			@rect.top = @p_download.top
			@rect.height = @p_download.style[:height] + 10
		end

		flow do
			@status_head = para "Status download: "
			@status = para
		end

		@time_ellapsed =
			animate do |i|
				@time.text = "Time ellapsed: ", @vid.time / 1000 < 10 ? "0" + (@vid.time / 1000).to_s : @vid.time / 1000, " seconds"
				@p_time.fraction = (@vid.position)
			end
		@stack_controls = stack do
			@rect = rect(0, 0, 400, 20, 10)
			
			@controls = para "Controls: ",
				link("play")  { @vid.play; @time_ellapsed ; @vid = video @file_name_to_save if !@file_name_to_save.nil?}, ", ",
				#link("play")  { @vid.play; @time_ellapsed ; @vid = video @file_name_save.text}, ", ",
				link("pause") { @vid.pause }, ", ",
				link("stop")  { @vid.stop }, ", ",
				link("hide")  { @vid.hide }, ", ",
				link("show")  { @vid.show }, ", ",
				link("+5 sec") { @vid.time += 5000 if (@vid.time < @vid.length - 6000) }, ", ",
				link("-5 sec") { @vid.time -= 5000 if (@vid.time > 6000) }
			@controls.left = 10
			@rect.left = @controls.left
			@rect.top = @controls.top + 5
		end
		
	end
	def download_movie
		@default_url = "http://whytheluckystiff.net/o..e/adventure_time.flv"
		
		@url_movie.text == '' ? @url = @default_url : @url = @url_movie.text
		@file_name_save.text == '' ? @file_name_to_save = 'movie.flv' : @file_name_to_save = @file_name_save.text
		
		@status.text = "Fetching #{@file_name_to_save}"
		download @url,  :save =>  @file_name_to_save,
				# TODO	- search for local movies, list, etc
				# FIXME 	- free @vid from :start
				:start => proc { |dl| @status.text = "Connecting..." ; @vid = video @file_name_to_save if !@file_name_to_save.nil?},
				:progress => proc { |dl| @status.text = "#{dl.percent}% complete";  animate(24) {|i| @p_download.fraction = (dl.percent % 100) / 100.0}},
				:finish => proc { |dl| @status.text = "Download finished" },
				:error => proc { |dl, err| @status.text = "Error: #{err}" }
	end
			
	#@vid = video @file_name_to_save if !@file_name_to_save.nil?
end