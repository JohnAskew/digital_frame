#/usr/bin/bash
set -aevx
export DISPLAY=:0
cd /home/<user>/Pictures
arr=`find . -name '{*.jpg|*.png|*.bmp|*.jpeg}' |shuf`
hide_image_time=10 
short_study_time=45
long_study_time=60 
quick_study_time=5
sleep_2=2 
sleep_5=5 
#=================================================
# F U N C T I O N S
#=================================================
get_random() {
#-------------------------------------------------
	my_list=(`find . -type f -regex '.*\(jpg\|jpeg\|png\|bmp\)'|awk '{print $0}'`)
	list_size=${#my_list[@]}
	echo "list_size: ${list_size}"
	random_index=$((RANDOM % list_size))
	random_element="${my_list[random_index]}"
	echo "${random_element}"

}
if [-f /tmp/digital_frame.log]; then
	rm -f /tmp/digital_frame.log
fi
while true
#==================================================
  do
#==================================================
	   start_image=$(get_random)   
	   #------------------------
	   # Display image ? seconds
	   #------------------------
           feh -dqYFKD5x  --randomize --no-jump-on-resort --draw-tinted --zoom max  --fullscreen --bg trans --recursive --start-at "${start_image}" /home/<user>/Pictures >> /tmp/digital_frame.log 2>&1  &
	   sleep "${short_study_time}"
	   #------------------------
	   # Hide image ? seconds
	   #------------------------
           export my_win="`wmctrl -l|grep -i feh|awk {'print $4'}`"
           echo "my_win=" "${my_win}"
           wmctrl -r "${my_win}" -b add,hidden
           sleep "${hide_image_time}" 
	   #------------------------
	   # Restore image for ? seconds
	   #------------------------
           echo "restoring my_win=" "${my_win}"
           wmctrl -r "${my_win}" -b remove,hidden
	   sleep "${long_study_time}"
	   #------------------------
	   # Kill feh and show "Get Ready" next image
	   #------------------------
           pkill feh
           feh -qZYKD2 --on-last-slide hold --draw-tinted --zoom max --fullscreen --bg trans  /home/<user>/Pictures/ready.png &
	   sleep "${sleep_2}"
           pkill feh
#==================================================
        done
#==================================================
exit
