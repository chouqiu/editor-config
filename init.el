
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;;(add-to-list 'load-path (expand-file-name "~/.emacs.d"))
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'tango-dark t)
;;(require 'init-themes)

;;==============================================================
;; base configure for common using
;;=============================================================
;; start server , 这样在终端下主可以通过emacsclient -n 直接于GUI emacs打开文件
;;(require 'server)
;;(unless (server-running-p "server")
;;  (server-start))

(require 'package)
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

;; package server
;; (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;; ("melpa-stable" . "https://stable.melpa.org/packages/")))

;; (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;; ("melpa-stable" . "https://stable.melpa.org/packages/")
;; ("marmalade" . "http://marmalade-repo.org/packages/")
;; ("melpa" . "http://melpa.milkbox.net/packages/")))

;; background color , 苹果绿，爱护眼睛
;;(when window-system
;;  (custom-set-faces
;;   '(default ((t (:background "#B4EEB4"))))))


;; copy content from elsewhere to emacs or emacs copied to other places
(setq x-select-enable-clipboard t)

;; show line number
;;(require 'linum)
;;(global-linum-mode t)

;; kill current buffer
(global-set-key (kbd "C-x k") (lambda () (interactive) (kill-buffer (current-buffer))))


;; open .emacs
(global-set-key (kbd "M-h") (lambda () (interactive) (find-file "~/.emacs")))

(blink-cursor-mode nil)

;; hide memubar,false
;;(menu-bar-mode -1)

;; hide toolbar,false
;;(tool-bar-mode -1)

;; show file path in window's tile
(setq frame-title-format
      '("%S" (buffer-file-name "%f"
			       (dired-directory dired-directory "%b"))))

;; hide scroll-bar
;;(scroll-bar-mode nil)
(setq scroll-preserve-screen-position t)

(when window-system
  (global-hl-line-mode t)
  (set-face-background 'hl-line "#CAFF70"))

;; 成对显示括号，但不来回弹跳
(show-paren-mode t)
(setq show-paren-style 'parentheses)

;; tab width
(standard-display-ascii ?\t "#---")
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)
(defun my-c-mode-hook ()
  (c-set-style "stroustrup")
  (c-set-offset 'innamespace 0))
(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)

;; ibuffer
(require 'ibuffer)
(global-set-key "\C-x\C-b" 'ibuffer)

;; yes /no -> y/n
(fset 'yes-or-no-p 'y-or-n-p)

;; close autosave
(setq backup-inhibited t)
;; stop creating those #autosave# files
(setq auto-save-default nil)

;; ido
(require 'ido)
(ido-mode t)

;; 字体设置,使用等宽字体
;;(dolist (charset '(kana han symbol cjk-misc bopomofo))
;;  (set-fontset-font (frame-parameter nil 'font)
;;		    charset
;;		    (font-spec :family "STHeiti" :size 12)))
;;(set-default-font "Bitstream Vera Sans Mono 12")

;;======================================================
;; 自定义功能或函数
;;======================================================
;; 换行格式转化 dos to unix
(defun dos2unix ()
  "Automate M-% C-q C-m RET RET"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward (string ?\C-m)  nil t)
      (replace-match "" nil t))))

;; using pgup,pgDn scroll
(defun window-half-height ()
  (max 1 (/ (1- (window-height (selected-window))) 2)))
(defun scroll-up-half ()
  (interactive)
  (scroll-up (window-half-height)))
(defun scroll-down-half ()
  (interactive)
  (scroll-down (window-half-height)))
(global-set-key [next] 'scroll-up-half)
(global-set-key [prior] 'scroll-down-half)

;; occur
(defun isearch-occur ()
  "*Invoke `occur' from within isearch."
  (interactive)
  (let ((case-fold-search isearch-case-fold-search))
    (occur (if isearch-regexp isearch-string (regexp-quote isearch-string)))))

(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)
