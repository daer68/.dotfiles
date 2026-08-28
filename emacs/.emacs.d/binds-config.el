;;; binds-config.el --- CUA mode and related keybindings -*- lexical-binding: t; -*-

;;; Commentary:

;; cua-mode is context-sensitive: C-x/C-c/C-v only act as cut/copy/paste
;; when a region is active, otherwise they fall through to their normal
;; Emacs prefix-key meaning (C-x b, C-c ..., etc). Nothing here overrides
;; those keymaps.
;;
;; C-z / C-S-z are intentionally left untouched: post-init.el already binds
;; them to `undo-fu-only-undo' / `undo-fu-only-redo', and cua-mode doesn't
;; bind C-z itself, so the two don't collide.
;;
;; The default rectangle-mark key is C-RET (`cua-rectangle-mark-key'), which
;; most terminals can't distinguish from plain RET, and which this daemon
;; setup can't detect at load time anyway (no frame exists yet when this
;; file loads). It's replaced below with a plain key sequence that works
;; identically in every frame type instead of branching on `display-graphic-p'.
;;
;; C-a is deliberately NOT rebound to select-all: it's beginning-of-line
;; everywhere in Emacs (including the minibuffer and shells), and CUA's own
;; convention only claims it inside its own C-c/C-x/C-v/C-z quartet.
;; Select-all lives on C-S-a instead (below), alongside the stock C-x h.
;;
;; windmove is not enabled anywhere in this config, so there's no live
;; conflict today. If it ever is enabled, bind it with a non-shift modifier
;; (e.g. `super') — CUA's shift-selection also lives on S-<arrow>, and the
;; two will otherwise fight over the same keys.

;;; Code:

(use-package cua-base
  :ensure nil
  :init
  (setq cua-rectangle-mark-key (kbd "C-c SPC"))
  (cua-mode t)
  :custom
  (cua-keep-region-after-copy t)   ; copying shouldn't collapse the selection
  (cua-auto-tabify-rectangles nil)) ; rectangle edits shouldn't silently retab

;; C-<up>/C-<down>/C-<left>/C-<right> already move by paragraph/word (stock
;; Emacs bindings), and Shift should extend the region the same way it does
;; for every other motion command. That normally happens for free: Emacs
;; auto-translates an unbound shifted key to its unshifted binding and sets
;; `this-command-keys-shift-translated', which `handle-shift-selection'
;; checks. But that auto-translation is a known rough edge for keys arriving
;; via `input-decode-map' (TTY frames, some terminal emulators), so it
;; doesn't always fire. Binding the shifted keys explicitly — while manually
;; setting the same flag — reuses the identical `handle-shift-selection'
;; machinery without depending on the fragile auto-translation step.
(defun binds-config--shift-translate (command)
  "Invoke COMMAND as if reached via a shift-translated key,
so `handle-shift-selection' extends the region exactly like a
plain shifted arrow key already does."
  (lambda ()
    (interactive)
    (let ((this-command-keys-shift-translated t))
      (call-interactively command))))

(global-set-key (kbd "C-S-<down>")  (binds-config--shift-translate #'forward-paragraph))
(global-set-key (kbd "C-S-<up>")    (binds-config--shift-translate #'backward-paragraph))
(global-set-key (kbd "C-S-<right>") (binds-config--shift-translate #'right-word))
(global-set-key (kbd "C-S-<left>")  (binds-config--shift-translate #'left-word))

(global-set-key (kbd "C-S-a") #'mark-whole-buffer)

;; Move the current line, or the active region as a block, up/down with
;; M-up/M-down (VS Code's convention). Ctrl+Shift+Up/Down was avoided since
;; it's already bound above to extend the selection by paragraph.
(use-package move-text
  :ensure t
  :config
  (move-text-default-bindings))

(provide 'binds-config)
;;; binds-config.el ends here
