# help()
# {
#   commands
#    # Display Help
#   echo "Trigger a single run of code validation."
#   echo
#   echo "Syntax: validatecodeonce [reports] [-h|]"
#   echo
#   echo "Positional arguments:"
#   echo "reports    Save test results in ${REPORTS_FOLDER}".
#   echo
#   echo "Options:"
#   echo "h    Print this help."
#   echo "n    Invokes Pytest option -k to run specific tests based on a substring match to the test name."
#   echo
# }

# help
# # help
# # echo "Hello world!"

# while getopts ":h" option; do
#   case $option in
#     h) # display Help
#       help
#       exit;;
#   esac
# done
echo $@