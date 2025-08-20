# K8s and Kubectl

Information about the use of:

* K3s/K8s - `kubectl`

## Discoverability

`kubectl` and `kubectl krew` extensions paths are enabled for easy discovery from both rancher desktop as well as standard paths like `$HOME/bin`.

## `kubectl` Extensions

* kubectl-config_swap - kubectl configuraiton switcher  

## Helper functions

* `install-krew` - run the official krew bash install script, `matrix.dot.files` extension for `k8s`  already injects the export PATH for you.

If you have a failure, you can safely `rm -rf ~/.krew` and rerun. This will reset the krew, and remove krew installed plugins.

```text
Adding "default" plugin index from https://github.com/kubernetes-sigs/krew-index.git.
Updated the local copy of plugin index.
Installing plugin: krew
Installed plugin: krew
\
 | Use this plugin:
 | 	kubectl krew
 | Documentation:
 | 	https://krew.sigs.k8s.io/
 | Caveats:
 | \
 |  | krew is now installed! To start using kubectl plugins, you need to add
 |  | krew's installation directory to your PATH:
 |  |
 |  |   * macOS/Linux:
 |  |     - Add the following to your ~/.bashrc or ~/.zshrc:
 |  |         export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
 |  |     - Restart your shell.
 |  |
 |  |   * Windows: Add %USERPROFILE%\.krew\bin to your PATH environment variable
 |  |
 |  | To list krew commands and to get help, run:
 |  |   $ kubectl krew
 |  | For a full list of available plugins, run:
 |  |   $ kubectl krew search
 |  |
 |  | You can find documentation at
 |  |   https://krew.sigs.k8s.io/docs/user-guide/quickstart/.
 | /
/
```

## Matrix specific
  
* powerline-kubernetes-toggle - Enable/Disable Kubernetes namespace in SHELL Prompt

