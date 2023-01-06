#Criar e ativar venv antes de executar.
pip3 install virtualenv --user
rm -rf .venv/
$HOME/.local/bin/virtualenv --python=python3 .venv
sleep 2
source .venv/bin/activate
sleep 2

pip3 install -r ${path_cwd}/scripts/requirements.txt
deactivate

# Create deployment package...
echo "Creating deployment package..."

cd .venv/lib/python3.8/site-packages/
cp -r . $path_cwd/${function_name}
cp -r $path_cwd/ETL $path_cwd/${function_name}