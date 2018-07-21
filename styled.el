;;; styled.el --- Styled components for emacs.       -*- lexical-binding: t; -*-

;; Copyright (C) 2018 Eduardo V.

;;; Commentary:

;;; Code:

(require 'css-mode)
(require 'fence-edit)
(require 'rx)
(require 'ov)

(setq
 styled-component-start
 (rx-to-string '(: (1+ (and (+ word) (0+ "\.") (0+ "(" (+ alpha) ")"))) "`" eol)))

(setq styled-component-end (rx-to-string '(: "`;" eol)))

(setq
 styled-component-region
 (rx-to-string '(: (minimal-match
                    (seq
                     (and (1+ (and (+ word) (0+ "\.") (0+ "(" (+ alpha) ")"))) "`")
                     (or "\n" "\r")
                     (0+ (+ any) (or "\n" "\r"))
                     (and "`;" eol))))))

(setq fence-edit-blocks `((,styled-component-start ,styled-component-end)))
(setq fence-edit-default-mode 'css-mode)

(defun styled/get-component ()
  "Get current buffer styled components."
  (interactive)
  (let (matches match beg end)
    (save-match-data
      (save-excursion
        (goto-char (point-min))
        (while (search-forward-regexp styled-component-region nil t 1)
          (setq match (match-string-no-properties 0))
          (setq beg (match-beginning 0))
          (setq end (match-end 0))
          (push (list beg end match) matches))
        ))
    (reverse matches)))

(provide 'styled)
;;; styled.el ends here
