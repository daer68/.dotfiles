;;transparency
(add-to-list 'default-frame-alist '(alpha-background . 90))
;; (add-to-list 'default-frame-alist '(alpha . 90))

(use-package vim-tab-bar
  :init
  (vim-tab-bar-mode 1)
  (tab-bar-mode 0))

(use-package magit)

;; make ESC quit prompts
(global-set-key(kbd "<escape>") 'keyboard-escape-quit)

;; use-package with package.el:
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(use-package gruber-darker-theme)
(let ((inhibit-redisplay t))
  ;; Disable all active themes
  (mapc #'disable-theme custom-enabled-themes)
  ;; Load the built-in theme
  (load-theme 'gruber-darker t))

;; Doom modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))


;; Set the default font to DejaVu Sans Mono with specific size and weight
(set-face-attribute 'default nil
                    :height 120 :weight 'normal :family "Iosevka Nerd Font")

;; The buffer-guardian Emacs package provides buffer-guardian-mode,
;; a global mode that automatically saves buffers without requiring manual intervention.

(use-package buffer-guardian
  :custom
  ;; When non-nil, include remote files in the auto-save process
  (buffer-guardian-inhibit-saving-remote-files nil)

  ;; When non-nil, buffers visiting nonexistent files are not saved
  (buffer-guardian-inhibit-saving-nonexistent-files nil)

  ;; Save the buffer even if the window change results in the same buffer
  (buffer-guardian-save-on-same-buffer-window-change t)

  ;; Non-nil to enable verbose mode to log when a buffer is automatically saved
  (buffer-guardian-verbose nil)

  ;; Save all buffers after N seconds of user idle time. (Disabled by default)
  ;; (buffer-guardian-save-all-buffers-idle 30)

  ;; Save all buffers every N seconds. (Disabled by default)
  ;; (setq buffer-guardian-save-all-buffers-interval (* 60 30))

  :init
  (buffer-guardian-mode 1))

;;fzf emacs
(use-package fzf
  :bind
  ;; Don't forget to set keybinds!
  :config
  (setq fzf/args "-x --color bw --print-query --margin=1,0 --no-hscroll"
        fzf/executable "fzf"
        fzf/git-grep-args "-i --line-number %s"))

;; Configure built-in sgml-mode to automatically enable
;; `sgml-electric-tag-pair-mode' in `html-mode' and `mhtml-mode', providing
;; automatic insertion of matching closing tags.
(use-package sgml-mode
  :ensure nil
  :commands (sgml-mode sgml-electric-tag-pair-mode)
  :hook ((html-mode mhtml-mode) . sgml-electric-tag-pair-mode))

;;; Enable automatic insertion and management of matching pairs of characters
;;; (e.g., (), {}, "") globally using `electric-pair-mode'.
(use-package elec-pair
  :ensure nil
  :init
  (electric-pair-mode 1))

;; Set the fringes to match the pixel height of a character. This ensures the
;; fringe is wide enough, scaling dynamically with the current font size.
(fringe-mode (frame-char-width))

;; When Delete Selection mode is enabled, typed text replaces the selection
;; if the selection is active.
(delete-selection-mode 1)

;; Display the current line and column numbers in the mode line
(setq line-number-mode t)
(setq column-number-mode t)
(setq mode-line-position-column-line-format '("%l:%C"))

;; Display of line numbers in the buffer:
(setq-default display-line-numbers-type 't)
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

;; Set the maximum level of syntax highlighting for Tree-sitter modes
(setq treesit-font-lock-level 4)

(use-package which-key
  :ensure nil
  :custom
  (which-key-idle-delay 0.5)
  (which-key-idle-secondary-delay 0.25)
  (which-key-add-column-padding 1)
  (which-key-max-description-length 40)
  :init
  (which-key-mode 1))

(unless (and (eq window-system 'mac)
             (bound-and-true-p mac-carbon-version-string))


  ;; Enables `pixel-scroll-precision-mode' on all operating systems and Emacs
  ;; versions, except for emacs-mac.
  ;;
  ;; Enabling `pixel-scroll-precision-mode' is unnecessary with emacs-mac, as
  ;; this version of Emacs natively supports smooth scrolling.
  ;; https://bitbucket.org/mituharu/emacs-mac/commits/65c6c96f27afa446df6f9d8eff63f9cc012cc738
  (setq pixel-scroll-precision-use-momentum nil) ; Precise/smoother scrolling
  (pixel-scroll-precision-mode 1))

;; Display the time in the modeline
(display-time-mode 0)

;; Paren match highlighting
(show-paren-mode 1)

;; Track changes in the window configuration, allowing undoing actions such as
;; closing windows.
(setq winner-boring-buffers '("*Completions*"
                              "*Minibuf-0*"
                              "*Minibuf-1*"
                              "*Minibuf-2*"
                              "*Minibuf-3*"
                              "*Minibuf-4*"
                              "*Compile-Log*"
                              "*inferior-lisp*"
                              "*Fuzzy Completions*"
                              "*Apropos*"
                              "*Help*"
                              "*cvs*"
                              "*Buffer List*"
                              "*Ibuffer*"
                              "*esh command on file*"))
(winner-mode 1)

(use-package uniquify
  :ensure nil
  :custom
  (uniquify-buffer-name-style 'reverse)
  (uniquify-separator "•")
  (uniquify-after-kill-buffer-p t))

;; Window dividers separate windows visually. Window dividers are bars that can
;; be dragged with the mouse, thus allowing you to easily resize adjacent
;; windows.
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Window-Dividers.html
(window-divider-mode 1)

;; Constrain vertical cursor movement to lines within the buffer
(setq dired-movement-style 'bounded-files)

;; nerd icons in dired
(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

;; nerd icons in ibuffer
(use-package nerd-icons-ibuffer
  :ensure t
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

;; Whether display the icons.
(setq nerd-icons-ibuffer-icon t)

;; Whether display the colorful icons.
;; It respects `nerd-icons-color-icons'.
(setq nerd-icons-ibuffer-color-icon t)

;; The default icon size in ibuffer.
(setq nerd-icons-ibuffer-icon-size 1.0)

;; Use human readable file size in ibuffer.
(setq  nerd-icons-ibuffer-human-readable-size t)

;; A list of ways to display buffer lines with `nerd-icons'.
;; See `ibuffer-formats' for details.
;; nerd-icons-ibuffer-formats

;; Slow Rendering
;; If you experience a slow down in performance when rendering multiple icons simultaneously,
;; you can try setting the following variable
(setq inhibit-compacting-font-caches nil)

;; Dired buffers: Automatically hide file details (permissions, size,
;; modification date, etc.) and all the files in the `dired-omit-files' regular
;; expression for a cleaner display.
(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;;Hide files from dired
(setq dired-omit-files (concat "\\`[.]\\'"
                               "\\|\\(?:\\.js\\)?\\.meta\\'"
                               "\\|\\.\\(?:elc|a\\|o\\|pyc\\|pyo\\|swp\\|class\\)\\'"
                               "\\|^\\.ds_store\\'"
                               "\\|^\\.\\(?:svn\\|agit\\)\\'"
                               "\\|^\\.ccls-cache\\'"
                               "\\|^__pycache__\\'"
                               "\\|^\\.project\\(?:ile\\)?\\'"
                               "\\|^flycheck_.*"
                               "\\|^flymake_.*"))
(add-hook 'dired-mode-hook #'dired-omit-mode)

;; dired: Group directories first
(with-eval-after-load 'dired
  (let ((args "--group-directories-first -ahlv"))
    (when (or (eq system-type 'darwin) (eq system-type 'berkeley-unix))
      (if-let* ((gls (executable-find "gls")))
          (setq insert-directory-program gls)
        (setq args nil)))
    (when args
      (setq dired-listing-switches args))))

;; Enables visual indication of minibuffer recursion depth after initialization.
(minibuffer-depth-indicate-mode 1)

;; Configure Emacs to ask for confirmation before exiting
(setq confirm-kill-emacs 'y-or-n-p)

;; Enabled backups save your changes to a file intermittently
(setq make-backup-files t)
(setq vc-make-backup-files t)
(setq kept-old-versions 10)
(setq kept-new-versions 10)

;; When tooltip-mode is enabled, certain UI elements (e.g., help text,
;; mouse-hover hints) will appear as native system tooltips (pop-up windows),
;; rather than as echo area messages. This is useful in graphical Emacs sessions
;; where tooltips can appear near the cursor.
(setq tooltip-hide-delay 20)    ; Time in seconds before a tooltip disappears (default: 10)
(setq tooltip-delay 0.4)        ; Delay before showing a tooltip after mouse hover (default: 0.7)
(setq tooltip-short-delay 0.08) ; Delay before showing a short tooltip (Default: 0.1)
(tooltip-mode 1)

;; Keep unmodified buffers A/B/C at session end
(setq ediff-keep-variants t)

;; Automatically apply verified, safe file-local variables. This eliminates
;; confirmation prompts when loading files, while ensuring that unauthorized or
;; risky configurations are silently ignored.
(setq enable-local-variables :safe)

;; Native compilation enhances Emacs performance by converting Elisp code into
;; native machine code, resulting in faster execution and improved
;; responsiveness.
;;
;; Ensure adding the following compile-angel code at the very beginning
;; of your `~/.emacs.d/post-init.el` file, before all other packages.
(use-package compile-angel
  :demand t
  :config
  ;; The following disables compilation of packages during installation;
  ;; compile-angel will handle it.
  (setq package-native-compile nil)

  ;; Set `compile-angel-verbose' to nil to disable compile-angel messages.
  ;; (When set to nil, compile-angel won't show which file is being compiled.)
  (setq compile-angel-verbose t)

  ;; The following directive prevents compile-angel from compiling your init
  ;; files. If you choose to remove this push to `compile-angel-excluded-files'
  ;; and compile your pre/post-init files, ensure you understand the
  ;; implications and thoroughly test your code. For example, if you're using
  ;; the `use-package' macro, you'll need to explicitly add:
  ;; (eval-when-compile (require 'use-package))
  ;; at the top of your init file.
  (push "/init.el" compile-angel-excluded-files)
  (push "/early-init.el" compile-angel-excluded-files)
  (push "/pre-init.el" compile-angel-excluded-files)
  (push "/post-init.el" compile-angel-excluded-files)
  (push "/pre-early-init.el" compile-angel-excluded-files)
  (push "/post-early-init.el" compile-angel-excluded-files)

  ;; A local mode that compiles .el files whenever the user saves them.
  ;; (add-hook 'emacs-lisp-mode-hook #'compile-angel-on-save-local-mode)

  ;; A global mode that compiles .el files prior to loading them via `load' or
  ;; `require'. Additionally, it compiles all packages that were loaded before
  ;; the mode `compile-angel-on-load-mode' was activated.
  (compile-angel-on-load-mode 1))

(use-package exec-path-from-shell
  :if (and (or (display-graphic-p) (daemonp))
           (eq system-type 'darwin)) ; macOS only
  :demand t
  :functions exec-path-from-shell-initialize
  :config
  (dolist (var '("TMPDIR"
                 "SSH_AUTH_SOCK" "SSH_AGENT_PID"
                 "GPG_AGENT_INFO"
                 "FZF_DEFAULT_COMMAND" "FZF_DEFAULT_OPTS" ; fzf
                 "VIRTUAL_ENV" ; Python
                 "GOPATH" "GOROOT" "GOBIN" ; Go
                 "CARGO_HOME" "RUSTUP_HOME" ; Rust
                 "NVM_DIR" "NODE_PATH" ; Node/JS
                 "LANG" "LC_CTYPE"))
    (add-to-list 'exec-path-from-shell-variables var))
  ;; Initialize
  (exec-path-from-shell-initialize))

;; Auto-revert in Emacs is a feature that automatically updates the
;; contents of a buffer to reflect changes made to the underlying file
;; on disk.
(use-package autorevert
  :ensure nil
  :init
  ;; (setq auto-revert-verbose t)
  (setq auto-revert-interval 3)
  (setq auto-revert-remote-files nil)
  (setq auto-revert-use-notify t)
  (setq auto-revert-avoid-polling nil)
  (global-auto-revert-mode 1))

;; Recentf is an Emacs package that maintains a list of recently
;; accessed files, making it easier to reopen files you have worked on
;; recently.
(use-package recentf
  :ensure nil
  :init
  (setq recentf-auto-cleanup (if (daemonp) 300 'never))
  (setq recentf-exclude
        (list "\\.tar$" "\\.tbz2$" "\\.tbz$" "\\.tgz$" "\\.bz2$"
              "\\.bz$" "\\.gz$" "\\.gzip$" "\\.xz$" "\\.zip$"
              "\\.7z$" "\\.rar$"
              "COMMIT_EDITMSG\\'"
              "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
              "-autoloads\\.el$" "autoload\\.el$"))
  ;; Enable `recentf-mode'
  (recentf-mode 1)

  :config
  ;; A cleanup depth of -90 ensures that `recentf-cleanup' runs before
  ;; `recentf-save-list', allowing stale entries to be removed before the list
  ;; is saved by `recentf-save-list', which is automatically added to
  ;; `kill-emacs-hook' by `recentf-mode'.
  (add-hook 'kill-emacs-hook #'recentf-cleanup -90)

  ;; savehist is an Emacs feature that preserves the minibuffer history between
  ;; sessions. It saves the history of inputs in the minibuffer, such as commands,
  ;; search strings, and other prompts, to a file. This allows users to retain
  ;; their minibuffer history across Emacs restarts.
  )
(use-package savehist
  :ensure nil
  :init
  (setq history-length 300)
  (setq savehist-autosave-interval 600)
  (savehist-mode 1))

;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off.
(use-package saveplace
  :ensure nil
  :init
  (setq save-place-limit 400)
  (save-place-mode 1))

;; Enable `auto-save-mode' to prevent data loss. Use `recover-file' or
;; `recover-session' to restore unsaved changes.
(setq auto-save-default t)

;; Trigger an auto-save after 300 keystrokes
(setq auto-save-interval 300)

;; Trigger an auto-save 30 seconds of idle time.
(setq auto-save-timeout 30)

;; Corfu enhances in-buffer completion by displaying a compact popup with
;; current candidates, positioned either below or above the point. Candidates
;; can be selected by navigating up or down.
(use-package corfu
  :custom
  ;; Hide commands in M-x which do not apply to the current mode.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Disable Ispell completion function. As an alternative try `cape-dict'.
  (text-mode-ispell-word-completion nil)
  (tab-always-indent 'complete)

  :init
  (global-corfu-mode 1))

;; Cape, or Completion At Point Extensions, extends the capabilities of
;; in-buffer completion. It integrates with Corfu or the default completion UI,
;; by providing additional backends through completion-at-point-functions.
(use-package cape
  :commands (cape-dabbrev cape-file cape-elisp-block)
  :bind ("C-c p" . cape-prefix-map)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

;; Vertico provides a vertical completion interface, making it easier to
;; navigate and select from completion candidates (e.g., when `M-x` is pressed).
(use-package vertico
  :custom
  (vertico-scroll-margin 0) ;; Different scroll margin
  (vertico-count 20) ;; Show more candidates
  (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode 1))

;; Vertico leverages Orderless' flexible matching capabilities, allowing users
;; to input multiple patterns separated by spaces, which Orderless then
;; matches in any order against the candidates.
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  ;; Emacs 31: partial-completion behaves like substring
  (completion-pcm-leading-wildcard t))

;; Marginalia allows Embark to offer you preconfigured actions in more contexts.
;; In addition to that, Marginalia also enhances Vertico by adding rich
;; annotations to the completion candidates displayed in Vertico's interface.
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode 1))

;; Embark integrates with Consult and Vertico to provide context-sensitive
;; actions and quick access to commands based on the current selection, further
;; improving user efficiency and workflow within Emacs. Together, they create a
;; cohesive environment for managing completions and interactions.
(use-package embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  ;; Add Embark to the mouse context menu. Also enable `context-menu-mode'.
  ;; (context-menu-mode 1)
  ;; (add-hook 'context-menu-functions #'embark-context-menu 100)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult)

;; Consult offers a suite of commands for efficient searching, previewing, and
;; interacting with buffers, file contents, and more, improving various tasks.

(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keettp-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
  )

;; The undo-fu package is a lightweight wrapper around Emacs' built-in undo
;; system, providing more convenient undo/redo functionality.
(use-package undo-fu
  :commands (undo-fu-only-undo
             undo-fu-only-redo
             undo-fu-only-redo-all
             undo-fu-disable-checkpoint)
  :init
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") 'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))

;; The undo-fu-session package complements undo-fu by enabling the saving
;; and restoration of undo history across Emacs sessions, even after restarting.
(use-package undo-fu-session
  :init
  (undo-fu-session-global-mode 1))

;; The easysession Emacs package is a session manager for Emacs that can persist
;; and restore file editing buffers, indirect buffers/clones, Dired buffers,
;; windows/splits, the built-in tab-bar (including tabs, their buffers, and
;; windows), and Emacs frames. It offers a convenient and effortless way to
;; manage Emacs editing sessions and utilizes built-in Emacs functions to
;; persist and restore frames.
(use-package easysession
  ;; ':demand t' ensures the package is loaded immediately upon startup
  :demand t

  :config
  ;; Key mappings
  (global-set-key (kbd "C-c sl") #'easysession-switch-to) ; Load session
  (global-set-key (kbd "C-c ss") #'easysession-save) ; Save session
  (global-set-key (kbd "C-c sL") #'easysession-switch-to-and-restore-geometry)
  (global-set-key (kbd "C-c sr") #'easysession-rename)
  (global-set-key (kbd "C-c sR") #'easysession-reset)
  (global-set-key (kbd "C-c su") #'easysession-unload)
  (global-set-key (kbd "C-c sd") #'easysession-delete)

  ;; Save every 10 minutes
  (setq easysession-save-interval (* 10 60))

  ;; Save the current session when using `easysession-switch-to'
  (setq easysession-switch-to-save-session t)

  ;; Do not exclude the current session when switching sessions
  (setq easysession-switch-to-exclude-current nil)

  ;; Display the active session name in the mode-line lighter.
  ;; (setq easysession-save-mode-lighter-show-session-name t)

  ;; Optionally, the session name can be shown in the modeline info area:
  ;; (setq easysession-mode-line-misc-info t)
  ;; non-nil: Make `easysession-setup' load the session automatically.
  ;; (nil: session is not loaded automatically; the user can load it manually.)
  (setq easysession-setup-load-session nil)

  ;; The `easysession-setup' function adds hooks:
  ;; - To enable automatic session loading during `emacs-startup-hook', or
  ;;   `server-after-make-frame-hook' when running in daemon mode.
  ;; - To save the session at regular intervals, and when Emacs exits.
  (easysession-setup))

;; Automatically generate a table of contents when editing Markdown files
(use-package markdown-toc
  :commands (markdown-toc-generate-toc
             markdown-toc-generate-or-refresh-toc
             markdown-toc-delete-toc
             markdown-toc--toc-already-present-p)
  :custom
  (markdown-toc-header-toc-title "**Table of Contents**"))

;; The markdown-mode package provides a major mode for Emacs for syntax
;; highlighting, editing commands, and preview support for Markdown documents.
;; It supports core Markdown syntax as well as extensions like GitHub Flavored
;; Markdown (GFM).
(use-package markdown-mode
  :commands (gfm-mode
             gfm-view-mode
             markdown-mode
             markdown-view-mode)
  :mode (("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode))
  :bind
  (:map markdown-mode-map
        ("C-c C-e" . markdown-do)))

;; Apheleia is an Emacs package designed to run code formatters (e.g., Shfmt,
;; Black and Prettier) asynchronously without disrupting the cursor position.
(use-package apheleia
  :commands (apheleia-mode
             apheleia-global-mode)
  :hook ((prog-mode . apheleia-mode)))


(use-package dumb-jump
  :commands dumb-jump-xref-activate
  :init
  ;; Register `dumb-jump' as an xref backend so it integrates with
  ;; `xref-find-definitions'. A priority of 80 ensures it is used only when no
  ;; more specific backend is available.
  (with-eval-after-load 'xref
    (add-hook 'xref-backend-functions #'dumb-jump-xref-activate 80))

  (setq dumb-jump-aggressive nil)
  ;; (setq dumb-jump-quiet t)

  ;; Number of seconds a rg/grep/find command can take before being warned to
  ;; use ag and config.
  (setq dumb-jump-max-find-time 3)

  ;; Use `completing-read' so that selection of jump targets integrates with the
  ;; active completion framework (e.g., Vertico, Ivy, Helm, Icomplete),
  ;; providing a consistent minibuffer-based interface whenever multiple
  ;; definitions are found.
  (setq dumb-jump-selector 'completing-read)

  :config
  ;; If ripgrep is available, force `dumb-jump' to use it because it is
  ;; significantly faster and more accurate than the default searchers (grep,
  ;; ag, etc.).
  (when (executable-find "rg")
    (setq dumb-jump-force-searcher 'rg)
    (setq dumb-jump-prefer-searcher 'rg)))

;; The stripspace Emacs package provides stripspace-local-mode, a minor mode
;; that automatically removes trailing whitespace and blank lines at the end of
;; the buffer when saving.
(use-package stripspace
  :commands stripspace-local-mode

  ;; Enable for prog-mode-hook, text-mode-hook, conf-mode-hook
  :hook ((prog-mode . stripspace-local-mode)
         (text-mode . stripspace-local-mode)
         (conf-mode . stripspace-local-mode))

  :custom
  ;; The `stripspace-only-if-initially-clean' option:
  ;; - nil to always delete trailing whitespace.
  ;; - Non-nil to only delete whitespace when the buffer is clean initially.
  ;; (The initial cleanliness check is performed when `stripspace-local-mode'
  ;; is enabled.)
  (stripspace-only-if-initially-clean nil)

  ;; Enabling `stripspace-restore-column' preserves the cursor's column position
  ;; even after stripping spaces. This is useful in scenarios where you add
  ;; extra spaces and then save the file. Although the spaces are removed in the
  ;; saved file, the cursor remains in the same position, ensuring a consistent
  ;; editing experience without affecting cursor placement.
  (stripspace-restore-column t))



(use-package diff-hl
  :commands (diff-hl-mode
             global-diff-hl-mode)
  :hook (prog-mode . diff-hl-mode)
  :init
  (setq diff-hl-flydiff-delay 0.4)  ; Faster
  (setq diff-hl-show-staged-changes nil)  ; Realtime feedback
  (setq diff-hl-update-async t)  ; Do not block Emacs
  (setq diff-hl-global-modes '(not pdf-view-mode image-mode)))

;; Org mode is a major mode designed for organizing notes, planning, task
;; management, and authoring documents using plain text with a simple and
;; expressive markup syntax. It supports hierarchical outlines, TODO lists,
;; scheduling, deadlines, time tracking, and exporting to multiple formats
;; including HTML, LaTeX, PDF, and Markdown.
(use-package org
  :commands (org-mode org-version)
  :mode
  ("\\.org\\'" . org-mode)
  :custom
  (org-hide-leading-stars t)
  (org-startup-indented t)
  (org-adapt-indentation nil)
  (org-edit-src-content-indentation 0)
  ;; (org-fontify-done-headline t)
  ;; (org-fontify-todo-headline t)
  ;; (org-fontify-whole-heading-line t)
  ;; (org-fontify-quote-and-verse-blocks t)
  (org-startup-truncated t))

(use-package org-appear
  :commands org-appear-mode
  :hook (org-mode . org-appear-mode))

;; Set up the Language Server Protocol (LSP) servers using Eglot.
(use-package eglot
  :ensure nil
  :commands (eglot-ensure
             eglot-rename
             eglot-format-buffer))

;; Configure Eglot to enable or disable certain options for the pylsp server
;; in Python development. (Note that a third-party tool,
;; https://github.com/python-lsp/python-lsp-server, must be installed),
(add-hook 'python-mode-hook #'eglot-ensure)
(add-hook 'python-ts-mode-hook #'eglot-ensure)
(setq-default eglot-workspace-configuration
              `(:pylsp (:plugins
                        (;; Fix imports and syntax using `eglot-format-buffer`
                         :isort (:enabled t)
                         :autopep8 (:enabled t)

                         ;; Syntax checkers (works with Flymake)
                         :pylint (:enabled t)
                         :pycodestyle (:enabled t)
                         :flake8 (:enabled t)
                         :pyflakes (:enabled t)
                         :pydocstyle (:enabled t)
                         :mccabe (:enabled t)

                         :yapf (:enabled :json-false)
                         :rope_autoimport (:enabled :json-false)))))

(use-package buffer-terminator
  :diminish
  :custom
  ;; Enable/Disable verbose mode to log buffer cleanup events
  (buffer-terminator-verbose nil)

  ;; Set the inactivity timeout (in seconds) after which buffers are considered
  ;; inactive (default is 30 minutes):
  (buffer-terminator-inactivity-timeout (* 30 60)) ; 30 minutes

  ;; Define how frequently the cleanup process should run (default is every 10
  ;; minutes):
  (buffer-terminator-interval (* 10 60)) ; 10 minutes

  :init
  (buffer-terminator-mode 1))

;; Helpful is an alternative to the built-in Emacs help that provides much more
;; contextual information.
(use-package helpful
  :commands (helpful-callable
             helpful-variable
             helpful-key
             helpful-command
             helpful-at-point
             helpful-function)
  :bind
  ([remap describe-command] . helpful-command)
  ([remap describe-function] . helpful-callable)
  ([remap describe-key] . helpful-key)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  :custom
  (helpful-max-buffers 7))

(use-package avy
  :commands (avy-goto-char
             avy-goto-char-2
             avy-next)
  :init
  (global-set-key (kbd "C-'") 'avy-goto-char-2))

(use-package bufferfile
  :commands (bufferfile-copy
             bufferfile-rename
             bufferfile-delete)
  :custom
  ;; If non-nil, display messages during file renaming operations
  (bufferfile-verbose nil)

  ;; If non-nil, enable using version control (VC) when available
  (bufferfile-use-vc nil)

  ;; Specifies the action taken after deleting a file and killing its buffer.
  (bufferfile-delete-switch-to 'parent-directory))

;; Enables automatic indentation of code while typing
(use-package aggressive-indent
  :commands aggressive-indent-mode
  :hook
  (emacs-lisp-mode . aggressive-indent-mode))

;; Highlights function and variable definitions in Emacs Lisp mode
(use-package highlight-defined
  :commands highlight-defined-mode
  :hook
  (emacs-lisp-mode . highlight-defined-mode))

;; Displays visible indicators for page breaks
(use-package page-break-lines
  :commands (page-break-lines-mode
             global-page-break-lines-mode)
  :hook
  (emacs-lisp-mode . page-break-lines-mode))

;; Provides functions to find references to functions, macros, variables,
;; special forms, and symbols in Emacs Lisp
(use-package elisp-refs
  :commands (elisp-refs-function
             elisp-refs-macro
             elisp-refs-variable
             elisp-refs-special
             elisp-refs-symbol))

;; The Emacs server allows external programs such as `emacsclient' to connect to
;; a single running instance of Emacs. This makes it possible to open files in
;; the existing session rather than starting a new Emacs process each time.
;;
;; Once the server is running, the `emacsclient' command can be used in the
;; terminal to open files in the active Emacs session. For example, running the
;; following command opens the file in the existing Emacs frame without blocking
;; the terminal process.
;;   emacsclient -n filename.txt
;;
(use-package server
  :ensure nil
  :if (not (daemonp))
  :preface
  (defun my-server-start ()
    "Start the Emacs server if no server process is currently active."
    (unless (server-running-p)
      (server-start)))
  :init
  ;; Defer starting the server until after Emacs has finished initializing
  (add-hook 'emacs-startup-hook #'my-server-start))

;; Support for Git files (.gitconfig, .gitignore, .gitattributes...)
(use-package git-modes
  :commands (gitattributes-mode
             gitconfig-mode
             gitignore-mode)
  :mode (("/\\.gitignore\\'" . gitignore-mode)
         ("/info/exclude\\'" . gitignore-mode)
         ("/git/ignore\\'" . gitignore-mode)

         ("/\\.gitconfig\\'" . gitconfig-mode)
         ("/\\.git/config\\'" . gitconfig-mode)
         ("/modules/.*/config\\'" . gitconfig-mode)
         ("/git/config\\'" . gitconfig-mode)
         ("/\\.gitmodules\\'" . gitconfig-mode)
         ("/etc/gitconfig\\'" . gitconfig-mode)

         ("/\\.gitattributes\\'" . gitattributes-mode)
         ("/info/attributes\\'" . gitattributes-mode)
         ("/git/attributes\\'" . gitattributes-mode)))

;; Configure built-in sgml-mode to automatically enable
;; `sgml-electric-tag-pair-mode' in `html-mode' and `mhtml-mode', providing
;; automatic insertion of matching closing tags.
(use-package sgml-mode
  :ensure nil
  :commands (sgml-mode sgml-electric-tag-pair-mode)
  :hook ((html-mode mhtml-mode) . sgml-electric-tag-pair-mode))

;; Support for YAML files.
;;
;; NOTE: Prefer the tree-sitter-based yaml-ts-mode over yaml-mode when
;; available, as it provides more accurate syntax parsing and enhanced editing
;; features.
(use-package yaml-mode
  :commands yaml-mode
  :mode (("\\.yaml\\'" . yaml-mode)
         ("\\.yml\\'" . yaml-mode)))

;; Support for Dockerfile files.
;;
;; NOTE: Prefer the tree-sitter-based dockerfile-ts-mode over dockerfile-mode
;; when available, as it provides more accurate syntax parsing and enhanced
;; editing features.
(use-package dockerfile-mode
  :commands dockerfile-mode
  :mode ("Dockerfile\\'" . dockerfile-mode))

;; Support for Gnuplot files
(use-package gnuplot
  :commands gnuplot-mode
  :mode ("\\.gp\\'" . gnuplot-mode))

;; Support for *.lua files.
;;
;; Prefer the tree-sitter-based lua-ts-mode over lua-mode when available, as it
;; provides more accurate syntax parsing and enhanced editing features.
(use-package lua-mode
  :commands lua-mode
  :mode ("\\.lua\\'" . lua-mode))

;; Jinja2 template support for files commonly used in configuration management
;; systems and web frameworks. This mode enables syntax highlighting and basic
;; editing facilities for templates written using the Jinja2 templating
;; language.
(use-package jinja2-mode
  :commands jinja2-mode
  :mode ("\\.j2\\'" . jinja2-mode))

;; CSV file support with automatic column alignment. This configuration enables
;; csv-align-mode whenever a CSV file is opened, improving readability by
;; keeping columns visually aligned according to a configurable maximum width
;; and a set of recognized field separators.
(use-package csv-mode
  :commands (csv-mode
             csv-align-mode
             csv-guess-set-separator)
  :mode ("\\.csv\\'" . csv-mode)
  :hook ((csv-mode . csv-align-mode)
         (csv-mode . csv-guess-set-separator))
  :custom
  (csv-align-max-width 100)
  (csv-separators '("," ";" " " "|" "\t")))

;; Support for Go
;;
;; NOTE: Prefer the tree-sitter-based go-ts-mode over go-mode
;; when available, as it provides more accurate syntax parsing and enhanced
;; editing features.
(use-package go-mode
  :commands go-mode
  :mode ("\\.go\\'" . go-mode))

;; Support for Rust
(use-package rust-mode
  :commands rust-mode
  :mode ("\\.rs\\'" . rust-mode)
  :custom
  (rust-indent-offset 2))

;; Major mode for editing crontab files
(use-package crontab-mode
  :commands crontab-mode
  :mode ("/crontab\\(\\.X*[[:alnum:]]+\\)?\\'"  . crontab-mode))

;; Major mode for editing Nginx configuration files
(use-package nginx-mode
  :commands nginx-mode
  :mode (("nginx\\.conf\\'" . nginx-mode)
         ("/nginx/.+\\.conf\\'" . nginx-mode)))

;; Major mode for HashiCorp Configuration Language (HCL) files
(use-package hcl-mode
  :commands hcl-mode
  :mode ("\\.hcl\\'" . hcl-mode))

;; Major mode for Nix expression language files
(use-package nix-mode
  :commands nix-mode
  :mode ("\\.nix\\'" . nix-mode))

;; Major mode for editing Fish shell scripts
(use-package fish-mode
  :commands fish-mode
  :mode ("\\.fish\\'" . fish-mode))

;; Vim configuration file support. This mode provides syntax highlighting and
;; editing support for various Vim configuration files, including vimrc, gvimrc,
;; local overrides, and project-specific configuration files.
(use-package vimrc-mode
  :commands vimrc-mode
  :mode ("\\.vim\\(rc\\)?\\'" . vimrc-mode))

;; Support for Jenkinsfile files
(use-package jenkinsfile-mode
  :commands jenkinsfile-mode
  :mode ("Jenkinsfile\\'" . jenkinsfile-mode))

;; Support for Haskell
;; (use-package haskell-mode
;;   :commands haskell-mode
;;   :mode ("\\.hs\\'" . haskell-mode))

(use-package kdl-mode
  :commands kdl-mode
  :mode ("\\.kdl\\'" . kdl-mode))

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
  (move-text-default-bindings)
  ;; Coalesce consecutive M-up/M-down presses into a single undo step,
  ;; the same way Emacs merges consecutive self-insert-command keystrokes.
  ;; `undo-auto-amalgamate' takes no arguments, but move-text-up/-down are
  ;; called with (start end n) from their interactive spec, and :before
  ;; advice is invoked with the same args as the advised function — so a
  ;; wrapper that discards them is needed, not the bare symbol.
  (dolist (cmd '(move-text-up move-text-down))
    (advice-add cmd :before (lambda (&rest _) (undo-auto-amalgamate)))))

;; Swap the paragraph at point with the next/previous one on
;; Ctrl+Alt+Shift+Up/Down. Plain Ctrl+Alt+Up/Down is left alone — it's
;; stock backward-up-list/down-list, used for structural navigation.
;;
;; Deliberately NOT using stock `transpose-paragraphs': its region math
;; (via `transpose-subr') splits a paragraph's blank-line separator
;; asymmetrically between the two paragraphs being swapped, so swapping
;; two blocks that don't carry a matching pair of half-separators loses
;; or merges blank lines (verified — corrupts even on the very first
;; call, not just on repeated ones).
;;
;; Instead: only ever swap each paragraph's actual TEXT (leading/trailing
;; blank lines excluded), and never touch the blank-line whitespace
;; itself — it stays at its original buffer position/size throughout.
;; Since gaps never move, there's nothing to miscount, regardless of gap
;; size, first/last-paragraph edges, or a missing final newline.
(defun binds-config--paragraph-text-bounds (pos)
  "Return (BEG . END) bounding the paragraph's actual text at POS,
excluding any surrounding blank lines."
  (save-excursion
    (cons (progn (goto-char pos) (backward-paragraph 1) (skip-chars-forward " \t\n") (point))
          (progn (goto-char pos) (forward-paragraph 1) (skip-chars-backward " \t\n") (point)))))

(defun binds-config--move-paragraph (direction)
  "Swap the paragraph at point's text with the next (DIRECTION > 0)
or previous (DIRECTION < 0) paragraph's text; a no-op at the first/last
paragraph in the buffer."
  (let* ((cur (binds-config--paragraph-text-bounds (point)))
         (cur-beg (car cur)) (cur-end (cdr cur))
         (offset (min (max 0 (- (point) cur-beg)) (- cur-end cur-beg))))
    (if (> direction 0)
        (let ((probe (save-excursion (goto-char cur-end) (skip-chars-forward " \t\n") (point))))
          (when (< probe (point-max))
            (let* ((nxt (binds-config--paragraph-text-bounds probe))
                   (next-beg (car nxt)) (next-end (cdr nxt))
                   (cur-text (buffer-substring cur-beg cur-end))
                   (next-text (buffer-substring next-beg next-end)))
              ;; Edit the later region first so CUR-BEG stays valid; use a
              ;; marker for the target point since the second edit (at an
              ;; earlier position) would otherwise shift NEXT-BEG's offset.
              (goto-char next-beg) (delete-region next-beg next-end) (insert cur-text)
              (let ((target (copy-marker (+ next-beg offset))))
                (goto-char cur-beg) (delete-region cur-beg cur-end) (insert next-text)
                (goto-char target)
                (set-marker target nil)))))
      (let ((probe (save-excursion (goto-char cur-beg) (skip-chars-backward " \t\n") (point))))
        (when (> probe (point-min))
          (let* ((prv (binds-config--paragraph-text-bounds (1- probe)))
                 (prev-beg (car prv)) (prev-end (cdr prv))
                 (cur-text (buffer-substring cur-beg cur-end))
                 (prev-text (buffer-substring prev-beg prev-end)))
            (goto-char cur-beg) (delete-region cur-beg cur-end) (insert prev-text)
            (goto-char prev-beg) (delete-region prev-beg prev-end) (insert cur-text)
            (goto-char (+ prev-beg offset))))))))

(defun binds-config-transpose-paragraph-down ()
  "Move the paragraph at point past the next paragraph."
  (interactive)
  (binds-config--move-paragraph 1))

(defun binds-config-transpose-paragraph-up ()
  "Move the paragraph at point past the previous paragraph."
  (interactive)
  (binds-config--move-paragraph -1))

(dolist (cmd '(binds-config-transpose-paragraph-down binds-config-transpose-paragraph-up))
  (advice-add cmd :before (lambda (&rest _) (undo-auto-amalgamate))))

(global-set-key (kbd "C-M-S-<down>") #'binds-config-transpose-paragraph-down)
(global-set-key (kbd "C-M-S-<up>")   #'binds-config-transpose-paragraph-up)

;; Real multi-cursor editing: mark several points, type once, it applies to
;; all of them. C->/C-</C-c C-< are multiple-cursors.el's own README
;; bindings. mc/edit-lines is NOT on its usual C-S-c C-S-c: verified live
;; (view-lossage) that this terminal/tmux setup delivers Ctrl+Shift+<letter>
;; as byte-for-byte identical to plain Ctrl+<letter> — same ambiguity
;; already worked around for C-S-a and cua-rectangle-mark-key elsewhere in
;; this file. C-c C-m avoids that entirely (plain, unshifted Ctrl-modified
;; keys only) and isn't bound to anything else in this config.
(use-package multiple-cursors
  :ensure t
  :bind (("C->"     . mc/mark-next-like-this)
         ("C-<"     . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)
         ("C-c C-m" . mc/edit-lines)))

(windmove-default-keybindings '(meta super))

(provide 'binds-config)


;; Thse following snippet configures Dired to open specific file extensions
;; ussing the default application handler of the host operating system. It
;; idsentifies the environment (macOS, Linux,or Windows) and assigns the
;; cosrresponding system command (open, xdg-open, or start) to the
;; disred-guess-shell-alist-user variable for documents, images, and media
;; fisles. The main benefit is that it delegates file association management
;; tos the operating system, removing the need to configured individual
;; apsdplications within Emacs for every file type.

(defvar my-dired-xdg-open-cmd nil)
(with-eval-after-load 'dired
  (when-let* ((cmd (cond
                    ((eq system-type 'darwin)
                     "open")
                    ((memq system-type '(gnu gnu/linux gnu/kfreebsd
                                             berkeley-unix))
                     "xdg-open")
                    ((memq system-type '(cygwin windows-nt ms-dos))
                     "start"))))
    (setq dired-guess-shell-alist-user
          `(("\\.\\(?:docx\\|pdf\\|odt\\|odg\\|ods\\|djvu\\|eps\\)\\'" ,cmd)
            ("\\.\\(?:jpe?g\\|webp\\|png\\|gif\\|xpm\\)\\'" ,cmd)
            ("\\.\\(?:xcf\\)\\'" ,cmd)
            ("\\.tex\\'" ,cmd)
            ("\\.\\(?:mp4\\|mkv\\|m4a\\|avi\\|flv\\|rm\\|rmvb\\|ogv\\)\\(?:\\.part\\)?\\'" ,cmd)
            ("\\.\\(?:mp3\\|flac\\)\\'" ,cmd)))
    (when cmd
      (setq my-dired-xdg-open-cmd cmd))))
