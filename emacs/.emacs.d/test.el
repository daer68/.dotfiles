;; Dirvish (miller-column file manager) and Evil (vim keybindings).
;; https://github.com/alexluigit/dirvish
;; https://github.com/emacs-evil/evil
;;
;; This file is loaded from the top of post-init.el. To disable everything
;; in it, comment out the `load' line in post-init.el that references it.

(use-package dirvish
  :ensure t
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-quick-access-entries
   '(("h" "~/"             "Home")
     ("p" "~/Projects/"    "Projects")
     ("d" "~/Downloads/"   "Downloads")))
  ;; Dirvish hides the cursor by default and shows the current line via a
  ;; highlight face instead (barely visible under gruber-darker). Show a
  ;; normal cursor instead.
  (dirvish-hide-cursor nil)
  :config
  ;; `nerd-icons-dired-mode' (configured elsewhere) inserts icons directly
  ;; into the buffer text, which conflicts with Dirvish's own overlay-based
  ;; `nerd-icons' attribute below. Disable the former just for Dirvish
  ;; sessions so icons render once, via Dirvish's attribute system.
  (remove-hook 'dired-mode-hook #'nerd-icons-dired-mode)

  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-attributes
        '(vc-state subtree-state nerd-icons collapse git-msg file-time file-size))
  (setq dirvish-side-attributes
        '(vc-state nerd-icons collapse file-size))
  (setq delete-by-moving-to-trash t)
  :bind
  (("C-c f" . dirvish-fd)
   :map dirvish-mode-map
   ("a"   . dirvish-quick-access)
   ("f"   . dirvish-file-info-menu)
   ("y"   . dirvish-yank-menu)
   ("N"   . dirvish-narrow)
   ("^"   . dirvish-history-last)
   ("h"   . dirvish-history-jump)
   ("s"   . dirvish-quicksort)
   ("v"   . dirvish-vc-menu)
   ("TAB" . dirvish-subtree-toggle)
   ("M-f" . dirvish-history-go-forward)
   ("M-b" . dirvish-history-go-backward)
   ("M-l" . dirvish-ls-switches-menu)
   ("M-m" . dirvish-mark-menu)
   ("M-t" . dirvish-layout-toggle)
   ("M-s" . dirvish-setup-menu)
   ("M-e" . dirvish-emerge-menu)
   ("M-j" . dirvish-fd-jump)))

;; Evil: vim-style modal editing across all of Emacs.
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  ;; Use the already-configured undo-fu instead of evil's own undo-tree.
  (setq evil-undo-system 'undo-fu)
  :config
  (evil-mode 1))

;; evil-collection: vim bindings for built-in and third-party modes
;; (Dired/Dirvish, magit, etc.) that evil itself doesn't cover.
(use-package evil-collection
  :ensure t
  :after evil
  :custom
  (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))

;; general.el: SPC leader key (Spacemacs/Doom-style) for Evil's Normal,
;; Visual, and Motion states. Descriptions show up via which-key (already
;; configured elsewhere) when you hold SPC.
(use-package general
  :ensure t
  :after evil
  :config
  (general-create-definer my-leader-def
    :states '(normal visual motion)
    :keymaps 'override
    :prefix "SPC")

  (my-leader-def
    "f"  '(:ignore t :which-key "file")
    "ff" 'find-file
    "fs" 'save-buffer

    "b"  '(:ignore t :which-key "buffer")
    "bb" 'switch-to-buffer
    "bk" 'kill-buffer

    "d"  'dirvish))
