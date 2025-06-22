# Fast port-forward to a pod
# Usage: kport <pod-name> <local-port> [remote-port]
kport() {
    local pod=$(kubectl get pods | grep $1 | awk '{print $1}')
    
    if [ -z "$3" ]; then
        # If there are only two arguments, use the same port for both
        kubectl port-forward $pod $2:$2
    else
        # If there are three arguments, forward $2:$3
        kubectl port-forward $pod $2:$3
    fi
}

# Logs for container
# Usage: klogs <pod-name (might be part of name)>
klogs() {
    local pod=$(kubectl get pods | grep $1 | awk '{print $1}')
    kubectl logs $pod --tail=100 -f 
}

# Search in logs
# Usage: klogsearch <pod-name> <search-term>
klogsearch() {
    local pod=$(kubectl get pods | grep $1 | awk '{print $1}')
    kubectl logs $pod | grep $2
}

