#!/usr/bin/env bash
pip install virtualenvwrapper
export WORKON_HOME=.env
source /usr/local/bin/virtualenvwrapper.sh
mkvirtualenv -r requirements.txt -p /usr/bin/python2.7 sxapi-demo-openshift
#workon sxapi-demo-openshift
source ~/.env/sxapi-demo-openshift/bin/activate
ansible-playbook setup.yml
#cf. docs.python-guide.org/en/latest/dev/virtualenvs/
