#!/bin/bash 
INSTITUTIONS="abac atlm ccga dalton gcsu gordon sgsc ung uwg augusta clayton ftv ggc gsw mga asu csu ega gasou ghc ksu savst uga vsu"
#INSTITUTIONS="uga augusta gsu"

for INST in $INSTITUTIONS;
do 

bundle exec rake "get_new_titles[$INST, electronic]" RAILS_ENV=development
bundle exec rake "get_new_titles[$INST, physical]" RAILS_ENV=development

done

# GSU runs with special report
bundle exec rake "get_new_titles[gsu, physical, New Titles Physical - Temp Location]" RAILS_ENV=development
bundle exec rake "get_new_titles[gsu, electronic]" RAILS_ENV=development

exit