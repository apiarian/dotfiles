(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wombat)))
 '(sh-indentation 2)
 '(tls-checktrust nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#242424" :foreground "#f6f3e8" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 130 :width normal :foundry "nil" :family "Menlo"))))
 '(whitespace-hspace ((t nil)))
 '(whitespace-indentation ((t nil)))
 '(whitespace-line ((t nil)))
 '(whitespace-newline ((t (:foreground "#444" :weight normal))))
 '(whitespace-space ((t nil)))
 '(whitespace-space-after-tab ((t nil)))
 '(whitespace-tab ((t (:foreground "#444")))))

(if (not (getenv "TERM_PROGRAM"))
		(setenv "PATH"
						(shell-command-to-string "source $HOME/.bashrc && printf $PATH")))

(require 'package)
(add-to-list 'package-archives
						 '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
	(add-to-list 'package_archives
							 '("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(when (not package-archive-contents)
	(package-refresh-contents))

(global-hl-line-mode 0)
(setq scroll-step 1)

(setq inhibit-splash-screen t)

(transient-mark-mode 1)

(setq backup-directory-alist '(("." . "~/.emacs.d/bakups")))
(setq version-control t)
(setq vc-make-backup-files t)
(setq delete-old-versions t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))

(setq sentence-end-double-space nil)

(fset 'yes-or-no-p 'y-or-n-p)

(prefer-coding-system 'utf-8)
(when (display-graphic-p)
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))

(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

(defun my/smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of thel ine.

If ARG is not nil or 1, move forward ARG - 1 lines first. If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

(global-set-key [remap move-beginning-of-line]
                'my/smarter-move-beginning-of-line)

(require 'recentf)
(setq recentf-max-saved-items 200
      recentf-max-menu-items 15)
(recentf-mode)

                                        ; (linum-mode)

(setq-default indent-tabs-mode nil)
(setq default-tab-width 2)
(setq-default tab-width 2)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)

(global-set-key (kbd "RET") 'newline-and-indent)

(defun sanityinc/kill-back-to-indentation ()
  "Kill from the point back to the first non-whitespace character on the line."
  (interactive)
  (let ((prev-pos (point)))
    (back-to-indentation)
    (kill-region (point) prev-pos)))
(global-set-key [C-M-backspace] 'sanityinc/kill-back-to-indentation)

(eval-after-load 'python-mode
	'(global-set-key [C-c C-c] 'compile python-mode-map))

(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

(require 'diminish)
(diminish 'wrap-region-mode)
(diminish 'yas/minor-mode)

(defun goto-line-with-feedback ()
	"Show line numbers temporarily, while prompting for line number input"
	(interactive)
	(unwind-protect
			(progn
				(linum-mode 1)
				(goto-line (read-number "Goto line: ")))
		(linum-mode -1)))
(global-set-key [remap goto-line] 'goto-line-with-feedback)

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

(defun comint-delchar-or-eof-or-kill-buffer (arg)
	(interactive "p")
	(if (null (get-buffer-process (current-buffer)))
			(kill-buffer)
		(comint-delchar-or-maybe-eof arg)))
(add-hook 'shell-mode-hook
					(lambda ()
						(define-key shell-mode-map
							(kbd "C-d") 'comint-delchar-or-eof-or-kill-buffer)))

(defun open-line-below ()
	(interactive)
	(end-of-line)
	(newline)
	(indent-for-tab-command))
(defun open-line-above ()
	(interactive)
	(beginning-of-line)
	(newline)
	(forward-line -1)
	(indent-for-tab-command))
(global-set-key (kbd "<C-return>") 'open-line-below)
(global-set-key (kbd "<C-S-return>") 'open-line-above)

(defun move-line-down()
	(interactive)
	(let ((col (current-column)))
		(save-exursion
		 (forward-line)
		 (transpose-lines 1))
		(forward-line)
		(move-to-column col)))
(defun move-line-up()
	(interactive)
	(let ((col (current-column)))
		(save-exursion
		 (forward-line)
		 (transpose-lines -1))
		(move-to-column col)))
(global-set-key (kbd "<C-S-down>") 'move-line-down)
(global-set-key (kbd "<C-S-up>") 'move-line-up)

(defun rename-current-buffer-file ()
	"Renames the current buffer and the file it is visiting."
	(interactive)
	(let ((name (buffer-name))
				(filename (buffer-file-name)))
		(if (not (and filename (file-exists-p filename)))
				(error "Buffer '%s' is not visiting a file!" name)
			(let ((new-name (read-file-name "New name: " filename)))
				(if (get-buffer new-name)
						(error "A buffer named '%s' already exists!" new-name)
					(rename-file filename new-name 1)
					(rename-buffer new-name)
					(set-visited-file-name new-name)
					(set-buffer-modified-p nil)
					(message "File '%s' successfully renamed to '%s'"
									 name (file-name-nondirectory new-name)))))))
(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file)

(defun delete-current-buffer-file ()
	"Removes the file connected to the current buffer and kills the buffer."
	(interactive)
	(let ((filename (buffer-file-name))
				(buffer (current-buffer))
				(name (buffer-name)))
		(if (not (and filename (file-exists-p filename)))
				(ido-kill-buffer)
			(when (yes-or-no-p "Are you sure you want to remove this file? ")
				(delete-file filename)
				(kill-buffer buffer)
				(message "File '%s' successfully removed" filename)))))
(global-set-key (kbd "C-x C-k") 'delete-current-buffer-file)

(require 'dired-details)
(setq-default dired-details-hidden-string "--- ")
(dired-details-install)

(require 'ido-ubiquitous)
(ido-ubiquitous-mode 1)
(defmacro ido-ubiquitous-use-new-completing-read (cmd package)
	`(eval-after-load ,package
		 '(defadvice ,cmd (around ido-ubiquitous-new activate)
				(let ((ido-ubiquitous-enable-compatibility nil))
					ad-do-it))))
(ido-ubiquitous-use-new-completing-read webjump 'webjump)
(ido-ubiquitous-use-new-completing-read yas/expand 'yasnippet)
(ido-ubiquitous-use-new-completing-read yas/visit-snippet-file 'yasnippet)

(global-set-key (kbd "C-S-n")
								(lambda ()
									(interactive)
									(ignore-errors (next-line 5))))
(global-set-key (kbd "C-S-p")
								(lambda ()
									(interactive)
									(ignore-errors (previous-line 5))))
(global-set-key (kbd "C-S-f")
								(lambda ()
									(interactive)
									(ignore-errors (forward-char 5))))
(global-set-key (kbd "C-S-b")
								(lambda ()
									(interactive)
									(ignore-errors (backward-char 5))))

(global-set-key (kbd "M-j")
								(lambda ()
									(interactive)
									(join-line -1)))

(defadvice undo-tree-undo (around keep-region activate)
	(if (use-region-p)
			(let ((m (set-marker (make-marker) (mark)))
						(p (set-marker (make-marker) (point))))
				ad-do-it
				(goto-char p)
				(set-mark m)
				(set-marker p nil)
				(set-marker m nil))
		ad-do-it))

(defmacro rename-modeline (package-name mode new-name)
	`(eval-after-load ,package-name
		 '(defadvice ,mode (after rename-modeline activate)
				(setq mode-name ,new-name))))
(rename-modeline "lisp-mode" emacs-lisp-mode "EL")

(add-hook 'python-mode-hook
					(lambda ()
						(setq indent-tabs-mode t)
						(setq tab-width (default-value 'tab-width))
						(setq python-indent (default-value 'tab-width))))

(require 'whitespace)
(setq whitespace-display-mappings
			'(
				(space-mark 32 [32] [32])
				(newline-mark 10 [8617 10])
				(tab-mark 9 [9655 9] [92 9])
				))
(global-whitespace-mode)

(smart-tabs-insinuate 'c 'javascript 'python 'cperl)

