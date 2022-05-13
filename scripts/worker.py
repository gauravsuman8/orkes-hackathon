from __future__ import print_function
from conductor.ConductorWorker import ConductorWorker
from subprocess import call

def deploy_task(task):
    print(type(task))
    cmd = "./deploy.sh "+ task['inputData']['chartVersion'] + " " + task['inputData']['acrName'] + " " + task['inputData']['helmChartName'] + " " +  task['inputData']['resourceGroup'] + " " + task['inputData']['aksName'] + " " + task['inputData']['subscription'] + " " + task['inputData']['namespace'] + " " + task['inputData']['releaseName'] + " " + task['inputData']['tenantId']
    print("cmd is " + str(cmd))
    rc = call(cmd, shell=True)
    print("VAlue of task" + str(task))
    if rc == 0:
        return {'status': 'COMPLETED', 'output': {'isDeploymentComplete' : 'True'}, 'logs': ['Helm upgrade completed successfully']}
    else:
        return {'status': 'COMPLETED', 'output': {'isDeploymentComplete' : 'False'}, 'logs': ['Helm upgrade Failed']}

def install_packages(task):
    rc = call("./install_packages.sh", shell=True)
    return {'status': 'COMPLETED', 'output': {'isPackageInstalled': 'True'}, 'logs': ['Package installation complete']}

def validate_input(task):
    cmd = "./validation.sh " + task['inputData']['chartVersion'] + " " + task['inputData']['acrName'] +  " " + task['inputData']['acrSubscription'] + " " + task['inputData']['helmChartName'] + " " + task['inputData']['tenantId']
    rc = call(cmd, shell=True)
    return {'status': 'COMPLETED', 'output': {'isPackageInstalled': 'True'}, 'logs': ['Package installation complete']}

def main():
    print('Starting Hi Bye')
    cc = ConductorWorker('http://172.29.112.149:8080/api', 1, 0.1)
    cc.start('install_packages', install_packages, False)
    cc.start('deploy_task', deploy_task, False)
    cc.start('validate_input', validate_input, True)
if __name__ == '__main__':
    main()
