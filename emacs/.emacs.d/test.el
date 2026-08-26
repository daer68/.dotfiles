;; Dirvish: miller-column style file manager for Dired.
;; https://github.com/alexluigit/dirvish
;;
;; This file is loaded from the top of post-init.el. To disable Dirvish,
;; comment out the `load' line in post-init.el that references this file.

(use-package dirvish
  :ensure t
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-quick-access-entries
   '(("h" "~/"             "Home")
     ("p" "~/Projects/"    "Projects")
     ("d" "~/Downloads/"   "Downloads")))
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
