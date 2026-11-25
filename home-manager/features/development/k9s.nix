{ pkgs, ... }:

# Plugins adapted from https://github.com/derailed/k9s/tree/master/plugins
{
  home.packages = with pkgs; [
    cmctl
    kubectl-cnpg
  ];

  programs.k9s = {
    enable = true;

    views = {
      "argoproj.io/v1alpha1/applications" = {
        columns = [
          "NAMESPACE"
          "NAME"
          "SYNC STATUS"
          "HEALTH STATUS"
          "OP:.status.operationState.phase"
          "MESSAGE:.status.operationState.message"
          "AUTO:.spec.syncPolicy.automated.selfHeal"
          "REVISION:.status.sync.revision|W"
          "AGE:.metadata.creationTimestamp|T"
        ];
        sortColumn = "SYNC STATUS:asc";
      };
    };

    plugins = {
      # --- Argo CD (homelab + work) ---
      argocd-out-of-sync = {
        shortCut = "Shift-D";
        description = "Argo drift + app health";
        scopes = [ "applications" ];
        command = "sh";
        background = false;
        confirm = false;
        args = [
          "-c"
          ''
            a=$(kubectl --context $CONTEXT -n $NAMESPACE get application $NAME -o json) || exit 1
            {
              echo "$a" | jq -r '"sync: \(.status.sync.status // "-")   health: \(.status.health.status // "-")   \(.status.health.message // "")"'
              echo
              echo "$a" | jq -r '.status.resources[]? | select(.status != "Synced") | "\(.kind)/\(.name)\t\(.status)\t\(.health.status // "-")"' | column -t
            } | less -K
          ''
        ];
      };

      argocd-why = {
        shortCut = "Shift-G";
        description = "Argo health, conditions + last sync error";
        scopes = [ "applications" ];
        command = "sh";
        background = false;
        confirm = false;
        args = [
          "-c"
          ''
            kubectl --context $CONTEXT -n $NAMESPACE get application $NAME -o json |
              jq -r '"== health ==", "status: \(.status.health.status // "-")", "message: \(.status.health.message // "-")", "", "== conditions ==", (if (.status.conditions | length) > 0 then (.status.conditions[] | "\(.type): \(.message)") else "(none)" end), "", "== last operation ==", "phase: \(.status.operationState.phase // "-")", "message: \(.status.operationState.message // "-")", "revision: \(.status.sync.revision // "-")"' |
              less -K
          ''
        ];
      };

      argocd-history = {
        shortCut = "Shift-H";
        description = "Argo sync history";
        scopes = [ "applications" ];
        command = "sh";
        background = false;
        confirm = false;
        args = [
          "-c"
          ''
            kubectl --context $CONTEXT -n $NAMESPACE get application $NAME -o json |
              jq -r '.status.history[]? | "\(.id)\t\(.deployedAt)\t\(.revision[0:12])"' |
              column -t | less -K
          ''
        ];
      };

      argocd-refresh = {
        shortCut = "Shift-R";
        description = "Argo refresh";
        confirm = true;
        scopes = [ "applications" ];
        command = "kubectl";
        background = false;
        args = [
          "--context"
          "$CONTEXT"
          "-n"
          "$NAMESPACE"
          "annotate"
          "--overwrite"
          "application"
          "$NAME"
          "argocd.argoproj.io/refresh=normal"
        ];
      };

      argocd-hard-refresh = {
        shortCut = "Shift-Y";
        description = "Argo HARD refresh";
        confirm = true;
        dangerous = true;
        scopes = [ "applications" ];
        command = "kubectl";
        background = false;
        args = [
          "--context"
          "$CONTEXT"
          "-n"
          "$NAMESPACE"
          "annotate"
          "--overwrite"
          "application"
          "$NAME"
          "argocd.argoproj.io/refresh=hard"
        ];
      };

      argocd-sync = {
        shortCut = "Shift-Z";
        description = "Argo SYNC";
        confirm = true;
        dangerous = true;
        scopes = [ "applications" ];
        command = "sh";
        background = false;
        args = [
          "-c"
          ''
            u=$(kubectl --context $CONTEXT auth whoami -o jsonpath='{.status.userInfo.username}')
            kubectl --context $CONTEXT -n $NAMESPACE patch application $NAME --type=merge -p "{\"operation\":{\"initiatedBy\":{\"username\":\"$u\"},\"sync\":{}}}" || exit 1
            echo
            echo 'Sync triggered. Watch the OP/MESSAGE columns.'
            sleep 3
            kubectl --context $CONTEXT -n $NAMESPACE get application $NAME -o json |
              jq -r '"phase: \(.status.operationState.phase)", "message: \(.status.operationState.message)"' |
              less -K
          ''
        ];
      };

      # --- Debugging ---
      debug = {
        shortCut = "Shift-D";
        description = "Add debug container";
        dangerous = true;
        scopes = [ "containers" ];
        command = "bash";
        background = false;
        confirm = true;
        inputs = [
          {
            name = "image";
            label = "Debug image";
            type = "dropdown";
            required = true;
            default = "nicolaka/netshoot:v0.15";
            options = [
              "nicolaka/netshoot:v0.15"
              "busybox:1.37"
              "alpine:3.23"
            ];
          }
          {
            name = "profile";
            label = "Debug profile";
            type = "dropdown";
            required = true;
            default = "general";
            options = [
              "general"
              "baseline"
              "restricted"
              "netadmin"
              "sysadmin"
            ];
          }
        ];
        args = [
          "-c"
          "kubectl debug -it --context $CONTEXT -n=$NAMESPACE $POD --target=$NAME --image=$INPUT_IMAGE --profile=$INPUT_PROFILE --share-processes -- sh"
        ];
      };

      # --- Helm ---
      helm-values = {
        shortCut = "v";
        confirm = false;
        description = "Values";
        scopes = [ "helm" ];
        command = "sh";
        background = false;
        args = [
          "-c"
          "helm get values $COL-NAME -n $NAMESPACE --kube-context $CONTEXT | less -K"
        ];
      };

      # --- cert-manager ---
      cert-status = {
        shortCut = "Shift-S";
        override = true;
        confirm = false;
        description = "Certificate status";
        scopes = [ "certificates" ];
        command = "bash";
        background = false;
        args = [
          "-c"
          "cmctl status certificate --context $CONTEXT -n $NAMESPACE $NAME |& less -K"
        ];
      };

      cert-renew = {
        shortCut = "Shift-R";
        confirm = true;
        description = "Certificate renew";
        scopes = [ "certificates" ];
        command = "bash";
        background = false;
        args = [
          "-c"
          "cmctl renew --context $CONTEXT -n $NAMESPACE $NAME |& less -K"
        ];
      };

      # --- External Secrets (work) ---
      refresh-external-secrets = {
        shortCut = "Shift-R";
        confirm = false;
        description = "Refresh the ExternalSecret";
        scopes = [ "externalsecrets" ];
        command = "bash";
        background = true;
        args = [
          "-c"
          "kubectl annotate externalsecrets.external-secrets.io --context $CONTEXT -n $NAMESPACE $NAME force-sync=$(date +%s) --overwrite"
        ];
      };

      # --- KEDA (work) ---
      toggle-keda = {
        shortCut = "Ctrl-N";
        confirm = true;
        dangerous = true;
        description = "Toggle KEDA autoscaling";
        scopes = [ "scaledobjects" ];
        command = "bash";
        background = true;
        args = [
          "-c"
          ''
            ANNOTATION="autoscaling.keda.sh/paused-replicas"
            if kubectl get scaledobject $NAME -n $NAMESPACE --context $CONTEXT -o yaml | grep -q "$ANNOTATION: \"0\""; then
              kubectl annotate scaledobject $NAME "$ANNOTATION"- -n $NAMESPACE --context $CONTEXT >/dev/null && echo "KEDA autoscaling for $NAME enabled"
            else
              kubectl annotate scaledobject $NAME "$ANNOTATION"=0 -n $NAMESPACE --context $CONTEXT >/dev/null && echo "KEDA autoscaling for $NAME paused"
            fi
          ''
        ];
      };

      # --- CloudNativePG (homelab) ---
      cnpg-status = {
        shortCut = "s";
        description = "CNPG status";
        scopes = [ "cluster" ];
        command = "bash";
        background = false;
        args = [
          "-c"
          "kubectl cnpg status $NAME -n $NAMESPACE --context \"$CONTEXT\" 2>&1 | less -R"
        ];
      };

      cnpg-psql = {
        shortCut = "p";
        description = "CNPG psql shell";
        scopes = [ "cluster" ];
        command = "bash";
        background = false;
        args = [
          "-c"
          "kubectl cnpg psql $NAME -n $NAMESPACE --context $CONTEXT"
        ];
      };

      cnpg-logs = {
        shortCut = "l";
        description = "CNPG logs (pretty)";
        scopes = [ "cluster" ];
        command = "bash";
        background = false;
        args = [
          "-c"
          "kubectl cnpg logs cluster $NAME -f -n $NAMESPACE --context $CONTEXT | kubectl cnpg logs pretty"
        ];
      };

      cnpg-backup = {
        shortCut = "b";
        description = "CNPG backup";
        scopes = [ "cluster" ];
        command = "bash";
        confirm = true;
        background = false;
        args = [
          "-c"
          "kubectl cnpg backup $NAME -n $NAMESPACE --context \"$CONTEXT\" 2>&1 | less -R"
        ];
      };

      cnpg-restart = {
        shortCut = "Shift-R";
        description = "CNPG restart";
        confirm = true;
        dangerous = true;
        scopes = [ "cluster" ];
        command = "bash";
        background = false;
        args = [
          "-c"
          "kubectl cnpg restart $NAME -n $NAMESPACE --context \"$CONTEXT\" 2>&1 | less -R"
        ];
      };
    };
  };
}
