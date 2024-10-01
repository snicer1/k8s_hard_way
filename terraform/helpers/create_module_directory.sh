module_name=$1

cd ../modules
mkdir $module_name

cd $module_name

touch data.tf variables.tf main.tf outputs.tf README.md