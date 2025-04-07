#!/usr/bin/env python3

"""
script to handle restart and port-forwarding of k8s pods
Usage: restart-init.py <config> [--restart] [--port-forward]
Config file should be in yaml format and it may contain the following fields:

'''
namespace: my-namespace
deployments:
  deployment1:
    labels:
      app: app1 
    port_forward:
      - local_port: 8080
        remote_port: 80
  deployment2:
    labels:
      app: app2
    port_forward:
      - local_port: 9090
        remote_port: 90
'''
"""

#!/usr/bin/env python3

import subprocess
import yaml
import argparse
import time

def load_config(config_file):
    with open(config_file, 'r') as file:
        return yaml.safe_load(file)

def get_deployments(namespace, labels):
    label_selector = ','.join([f'{k}={v}' for k, v in labels.items()])
    result = subprocess.run(
        ['kubectl', 'get', 'deployments', '-n', namespace, '-l', label_selector, '-o', 'jsonpath={.items[*].metadata.name}'],
        capture_output=True, text=True
    )
    return result.stdout.split()

def scale_deployment(namespace, deployment, replicas):
    subprocess.run(['kubectl', 'scale', 'deployment', deployment, '--replicas', str(replicas), '-n', namespace])

def restart_pods(namespace, deployments):
    for deployment, config in deployments.items():
        print(f"Restarting deployment: {deployment}")
        scale_deployment(namespace, deployment, 0)
        time.sleep(5)  # Wait for pods to terminate
        scale_deployment(namespace, deployment, 1)
        print(f"Deployment {deployment} restarted")

def port_forward(namespace, pod, local_port, remote_port):
    subprocess.Popen(['kubectl', 'port-forward', pod, f'{local_port}:{remote_port}', '-n', namespace])

def get_pods(namespace, labels):
    label_selector = ','.join([f'{k}={v}' for k, v in labels.items()])
    result = subprocess.run(
        ['kubectl', 'get', 'pods', '-n', namespace, '-l', label_selector, '-o', 'jsonpath={.items[*].metadata.name}'],
        capture_output=True, text=True
    )
    return result.stdout.split()

def main():
    parser = argparse.ArgumentParser(description='Manage k8s pods.')
    parser.add_argument('config', help='Path to the configuration YAML file')
    parser.add_argument('--restart', action='store_true', help='Restart pods')
    parser.add_argument('--port-forward', action='store_true', help='Port forward pods')
    args = parser.parse_args()

    config = load_config(args.config)
    namespace = config['namespace']
    deployments = config['deployments']

    if args.restart:
        restart_pods(namespace, deployments)

    if args.port_forward:
        for deployment, config in deployments.items():
            labels = config['labels']
            port_forward_rules = config.get('port_forward', [])
            pods = get_pods(namespace, labels)
            for rule in port_forward_rules:
                for pod in pods:
                    port_forward(namespace, pod, rule['local_port'], rule['remote_port'])

if __name__ == '__main__':
    main()