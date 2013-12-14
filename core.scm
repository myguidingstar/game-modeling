#lang racket

;; faster naming so that sample input can be typed with ease
;; These names' values are symbols (instead of color strings)
;; so that they can be printed with same look.

(define O 'O)
(define X 'X)
(define _ '_)

;; creates an initial state for a new world
(define (create-world n-of-Os n-of-Xs n-of-cols n-of-rows)
  "todo")

(define (symbol->color sym)
  (cond [(equal? 'O sym)
         "red"]
        [(equal? 'X sym)
         "blue"]
        [else "white"]))

;; A sample 4x4 world should look like this
(list
 ;; cols 0 1 2 3  /  rows
 (vector O O O _) ;   0
 (vector _ X O X) ;   1
 (vector O O _ _) ;   2
 (vector O X O _));   3

;; looks up cell's color by coordinates
(define (coor->color world cell-coor)
  (let ([col (first cell-coor)]
        [row (second cell-coor)])
    (vector-ref (list-ref world row) col)))

;; swaps two cells (swap their colours)
(define (swap-cells! world source target)
  "todo")

;; returns list of all cells nearby the given cell with a specific distance
(define (find-nearby-cells world central-cell distance)
  "todo")

;; returns list of all free spaces (cells) nearby the given cell with a specific distance
(define (find-free-spaces world central-cell distance)
  "todo")

;; returns list of colors of the given cell's neighbors
(define (get-neighbours-colors world central-cell)
  "todo")

;; receives a cell's color and its neighbors' colors
;; returns true if the cell is minor
(define (minor? neighbours color)
  "todo")

;; exports symbols into a module that can be reused from other files
(provide O X _
         coor->color
         symbol->color
         swap-cells!
         get-neighbours-colors
         minor?
         find-nearby-cells
         find-free-spaces)
