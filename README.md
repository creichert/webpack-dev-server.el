<div align="center">
  <h1>webpack-dev-server.el</h1>
  <i>Emacs minor mode to help you manage webpack-dev-server</i> 
</div>

### Installation

Clone the package:

```
$ git clone https://github.com/creichert/webpack-dev-server.el 
```

Enable with your mode of choice:

```elisp
(use-package webpack-dev-server
  :defer
  :load-path "site-lisp/"
  :preface
  (defun webpack-dev-server-command (h)
    (format "make frontend-dev\n"))
  :bind (:map projectile-mode-map
              ("C-c w p" . webpack-dev-server))
              ("C-c w p" . webpack-dev-server-browse)))
```


### License

MIT

---

> Let's connect:  &nbsp;&middot;&nbsp;
> [creichert.io](https://creichert.io) &nbsp;&middot;&nbsp;
> [GitHub](https://github.com/creichert.io) &nbsp;&middot;&nbsp;
> [Twitter](https://twitter.com/creichert07)
