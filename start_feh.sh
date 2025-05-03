#/usr/bin/bash
set -aevx
export DISPLAY=:0
#shopt -s nullglob
imageHome=/home/jaskew/Pictures
cd "${imageHome}"

warm_up_dir="/home/jaskew/WarmUPs"
arr=`find . -name '{*.jpg|*.png|*.bmp|*.jpeg}' |shuf`
time_hide_image=2 
time_study_line_of_action_time_unit=5
time_study_long=60
time_study_quick=5
time_study_short=45
sleep_very_short=1 
sleep_kinda_short=5 
#=================================================
# F U N C T I O N S
#=================================================
get_time() {
#-------------------------------------------------
	hours=$(date +%H)
	echo ${hours}
#	return $hours
}

#-------------------------------------------------
gen_random() (
#-------------------------------------------------

	rand=$(od -N 1 -t uL -An /dev/urandom| tr -d " ")
	echo "$rand"
)
#-------------------------------------------------
get_random() {
#-------------------------------------------------
	my_list=(`find . -type f -regex '.*\(jpg\|jpeg\|png\|bmp\)'|awk '{print $0}'`)
	list_size=${#my_list[@]}
	echo "list_size: ${list_size}"
	alt_rand=gen_random
	#random_index=$((RANDOM % list_size))
	random_index=$(((RANDOM + alt_rand ) % list_size))
	random_element="${my_list[random_index]}"
	echo "${random_element}"

}
#-------------------------------------------------
practice_gesture() {
#-------------------------------------------------
       if [ -z $1 ]; then
	    echo "Error on setting display time on function practice_gesture()...Defaulting to 1 time_unit for display"
    	    time_units=1
    	    curr_time=$(get_time)
#       elif [[ "$1" =~ ^-?[0-6][0-9]+$ ]]; then
#      	    echo "Error due to setting display time between 0..6 (hours on a clock)..Defaulting to 1 time_unit_for display"
#            time_units=1
#	    curr_time=$(get_time)
       else
            time_units=$1
            curr_time=$(get_time)
            echo "practice_gesture time_units=${time_units},  curr_time=${curr_time}" 
       fi

       cd "${imageHome}"
       for i in {1..5};
#==================================================
           do
#==================================================
		   start_image=$(get_random)   
		   #------------------------
		   # Display image ? seconds
		   #------------------------
		   feh -dqYFKD5x  --randomize --no-jump-on-resort --draw-tinted --zoom max  --fullscreen  --image-bg ./check.png  --recursive --start-at "${start_image}" /home/jaskew/Pictures >> /tmp/start_feh.log 2>&1  &
		   sleep $((time_study_line_of_action_time_unit * time_units))
		   #------------------------
		   # Kill feh and show "Get Ready" next image
		   #------------------------
		   pkill feh
		   feh -qZYKD2 --on-last-slide hold --draw-tinted --zoom max --fullscreen --bg trans  /home/jaskew/Pictures/ready.png &
		   sleep "${sleep_very_short}"
		   pkill feh
#==================================================
	done
#==================================================
}
#=================================================
# H O U S E   K E E P I N G
#=================================================
if test -f /tmp/start_feh.log; then
    rm -f  /tmp/feh.log
fi

#=================================================
#=================================================
# M A I N   L O G I C   L O O P 
#=================================================
#=================================================
counter=1
 
while true 
#==================================================
  do
#==================================================
	curr_time=$(get_time)	
	#-------------------------
	# Every EVEN hour, we do additional Gesture Practice!
	#------------------------
	if ((${curr_time} % 2 ==  0 )); then 
	   practice_gesture 6 #Image time is 6 times the value in "time_study_line_of_action_time_unit" 
	   practice_gesture 3 #Image time is 3 times the value in "time_study_line_of_action_time_unit" 
	   practice_gesture 1 #Image time is just the value in "time_study_line_of_action_time_unit" 
        fi
	echo "In do statement, Passed practice_gesture, with curr_time=$curr_time and return code=$?"
	#------------------------
	# Heart of our Practice Logic. 
	# --> Always do the next Part, despite the hour
	#------------------------
	 
	start_image=$(get_random)   
	 
	#------------------------
	# Display image ? seconds
	#------------------------
        feh -dqYFKD5x  --randomize --no-jump-on-resort --draw-tinted --zoom max  --fullscreen --bg trans --recursive --start-at "${start_image}" /home/jaskew/Pictures >> /tmp/start_feh.log 2>&1  &
	sleep "${time_study_short}"
	#------------------------
	# Hide image ? seconds
	#------------------------
        export my_win="`wmctrl -l|grep -i feh|awk {'print $4'}`"
        echo "my_win=" "${my_win}"
        wmctrl -r "${my_win}" -b add,hidden
        sleep "${time_hide_image}" 
	#------------------------
	# Restore image for ? seconds
	#------------------------
        echo "restoring my_win=" "${my_win}"
        wmctrl -r "${my_win}" -b remove,hidden
	sleep "${time_study_long}"
	#------------------------
	# Kill feh and show "Get Ready" next image
	#------------------------
        pkill feh
        feh -qZYKD1 --on-last-slide hold --draw-tinted --zoom max --fullscreen --bg trans  /home/jaskew/Pictures/ready.png &
	sleep "${sleep_very_short}"
        pkill feh
        echo "In Loop before done with return code: $?"
#==================================================
   done
#==================================================
exit
