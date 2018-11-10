<div align="center">
  <h1>webpack-dev-server.el</h1>
  <i>Emacs mode to help you manage webpack-dev-server</i>
</div>

### Installation

Clone the package:

```
$ git clone https://github.com/creichert/webpack-dev-server.el 
```

`webpack-dev-server.el` does not require any configuration. By default, you can
load the mode and run `M-x webpack-dev-server` and everything will "just work"
if webpack-dev-server is configured on your machine properly.

The following example shows how to customize `webpack-dev-server.el` with
`projectile`:

```elisp
(use-package webpack-dev-server
  :load-path "site-lisp/webpack-dev-server.el"
  :commands (webpack-dev-server)

  ;; Use any custom command to launch webpack
  :custom
  (webpack-dev-server-command  "make webpack-dev-server")

  ;; Always run webpack-dev-server from projectile-project-root
  :config
  (use-package projectile :demand :ensure t)
  (setq webpack-dev-server-project-root (projectile-project-root))

  ;; Binding within projectile-mode-map is not required, but I primarily use
  ;; webpack-dev-server inside projectile projects
  :bind (:map projectile-mode-map
              ("C-c w p" . webpack-dev-server)
              ("C-c w k" . webpack-dev-server-stop)
              ("C-c w b" . webpack-dev-server-browse)))
```


### License

MIT

---

> Let's connect:  &nbsp;&middot;&nbsp;
> [creichert.io](https://creichert.io) &nbsp;&middot;&nbsp;
> [GitHub](https://github.com/creichert.io) &nbsp;&middot;&nbsp;
> [Twitter](https://twitter.com/creichert07)
