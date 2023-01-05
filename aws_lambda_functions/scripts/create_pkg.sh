#Criar e ativar venv antes de executar.
pip3 install virtualenv --user
rm -rf .venv/
$HOME/.local/bin/virtualenv --python=python3 .venv
sleep 2
source .venv/bin/activate
sleep 2
pip install -r zip
pip3 install -r ${path_cwd}/${source_code_path}/requirements.txt
cd .venv/lib/Python3.8/site-packages/
zip -r9 ${path_cwd}/${source_code_path}/aws_lambda_functions.zip .
sleep 2
cd .venv/lib64/Python3.8/site-packages/
zip -r9 ${path_cwd}/${source_code_path}/aws_lambda_functions.zip .
cd ${path_cwd}/
sleep 2
zip -g aws_lambda_functions.zip lambda_*
zip -g aws_lambda_functions.zip requirements.txt
