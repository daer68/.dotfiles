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

(provide 'binds-config)
;;; binds-config.el ends here
