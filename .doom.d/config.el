;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; theme
(require 'doom-themes)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled
(load-theme 'doom-one t)
(doom-themes-neotree-config)
(doom-themes-visual-bell-config)
(doom-themes-org-config)

;; workaround for yabai
(menu-bar-mode t)

;; delete and show whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq-default show-trailing-whitespace t)

;; insert tabstop instead of indenting to the beginning of the line
(define-key evil-insert-state-map (kbd "<tab>") 'tab-to-tab-stop)
;; use tab to switch windows and shift + tab to switch buffers
(define-key evil-normal-state-map (kbd "<tab>") 'other-window)
(define-key evil-normal-state-map (kbd "<backtab>") 'evil-next-buffer)
;; use tab to switch between windows in neotree, rebind  quick look to q
(with-eval-after-load 'neotree
  (evil-define-key 'evilified neotree-mode-map (kbd "<tab>") 'other-window)
  (evil-define-key 'normal neotree-mode-map (kbd "<tab>") 'other-window)
  (evil-define-key 'evilified neotree-mode-map (kbd "q") 'neotree-quick-look)
  (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-quick-look))

  ;; (setq neo-window-fixed-size 25)
  ;; (setq neo-reset-size-on-open nil)
  ;; (setq neo-window-width 25)

