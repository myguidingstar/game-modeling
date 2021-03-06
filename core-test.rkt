#lang racket
(require rackunit
         "core.rkt"
         rackunit/text-ui)

(define core-tests
  (test-suite
   "Tests for core.scm"
   (check-equal?
    (coor->color
     (list (vector X X)
           (vector O _))
     '(0 1))
    O)
   (check-equal?
    (let ([world (list
                  (vector O O O _)
                  (vector _ X O X)
                  (vector O O _ _)
                  (vector O X O _))])
      (set-color! world '(2 1) X)
      world)
    (list
     (vector O O O _)
     (vector _ X X X)
     (vector O O _ _)
     (vector O X O _))
    "set-color! test")
   (check-equal?
    (let ([world (list
                  (vector O O O _)
                  (vector _ X O X)
                  (vector O O _ _)
                  (vector O X O _))])
      (list (swap-cells! world '(1 1) '(0 1))
            world))

    ;; Input world with highlighted source and target cells:
    ;; - source cell is marked with brackets []
    ;; - target cell is marked with curly    {}
    ;; (list
    ;;  (vector  O   O  O _)
    ;;  (vector {_} [X] O X)
    ;;  (vector  O   O  _ _)
    ;;  (vector  O   X  O _))


    (list
     ;; what swap-cells! returns
     '(((1 1) _)
       ((0 1) X))
     ;; Output world
     (list
      (vector O O O _)
      (vector X _ O X)
      (vector O O _ _)
      (vector O X O _)))
    "swap-cells! tests")
   (check-equal?
    (colors->minority-index '(O O O O _ O O _) X)
    1/7
    "colors->minority-index test")
   (check-equal?
    (minor? '(O O O O _ O O _) X)
    #t
    "minor? return #t test")
   (check-equal?
    (minor? '(O O O O _ O O _) O)
    #f
    "minor? return #f test")
   (check-equal?
    (get-neighbors-colors
     (list
      (vector O O O _)
      (vector _ X O X)
      (vector O O _ _)
      (vector O X O _))
     '(1 1))
    ;; order: NW - N - NE - E - SW - S - SE - W
    '(O O O O O O _ _)
    "get-neighbors-colors test")

   '(check-equal?
     (get-neighbors-colors
      (list
       (vector O O )
       (vector _ X ))
      '(1 0))
     ;; order: NW - N - NE - E - SW - S - SE - W
     '(O _ X O O)
     "get-neighbors-colors test")

   (check-equal?
    (find-free-spaces
     (list
      (vector O O O _)
      (vector _ X O X)
      (vector O O _ _)
      (vector O X O _))
     '(1 1)
     1)
    ;; Central cell is marked with brackets []
    ;; Free spaces with distance 1 are marked with curly {}
    ;; (list
    ;;  (vector  O   O   O  _)
    ;;  (vector {_} [X]  O  X)
    ;;  (vector  O   O  {_} _)
    ;;  (vector  O   X   O  _))
    ;; order: NW - N - NE - E - SE - S - SW - W
    '((2 2) (0 1))
    "find-free-spaces with distance 1 test")

   (check-equal?
    (find-free-spaces
     (list
      (vector O O O _)
      (vector _ X O X)
      (vector O O _ _)
      (vector O X O _))
     '(1 1)
     2)
    '((3 0) (3 2) (3 3))
    "find-free-spaces with distance 2 test")

   (check-equal?
    (find-nearby-cells-helper '(1 1) 1)
    '((0 0) (1 0) (2 0) ;; upper row (including upper corners)
      (2 1)             ;; right col (excluding right corners)
      (0 2) (1 2) (2 2) ;; lower row (including lower corners)
      (0 1))            ;; right col (excluding right corners)
    "find-nearby-cells-helper with distance 1 test")

   (check-equal?
    (find-nearby-cells-helper '(1 1) 2)
    '((-1 -1) (0 -1) (1 -1) (2 -1) (3 -1)
      (3   0) (3  1) (3  2)
      (-1  3) (0  3) (1  3) (2  3) (3  3)
      (-1  0) (-1 1) (-1 2))
    "find-nearby-cells-helper with distance 2 test")

   (check-equal?
    (find-nearby-cells
     (list (vector O X)
           (vector X X))
     '(1 0)
     1)
    '((0 1) (1 1) (0 0)))

   (check-equal?
    (all-cells
     (list (vector O X)
           (vector O X)))
    '((0 0) (1 0) (0 1) (1 1))
    "all-cells test")

   (check-equal?
    (find-nearby-cells
     (list
      (vector O O O _)
      (vector _ X O X)
      (vector O O _ _)
      (vector O X O _))
     '(1 1)
     1)
    ;; Central cell is marked with brackets []
    ;; nearby cells with distance 1 are marked with curly {}
    ;; (list
    ;;  (vector {O} {O} {O} _)
    ;;  (vector {_} [X] {O} X)
    ;;  (vector {O} {O} {_} _)
    ;;  (vector  O   X   O  _))
    '((0 0) (1 0) (2 0) ;; upper row (including upper corners)
      (2 1)             ;; right col (excluding right corners)
      (0 2) (1 2) (2 2) ;; lower row (including lower corners)
      (0 1))            ;; right col (excluding right corners)
    "find-nearby-cells test")

   (check-equal?
    (minor-agents
     (list
      (vector O X O O O)
      (vector O X O _ O)
      (vector O X O O O)
      (vector _ X X X X)
      (vector O O O O O)))
    '((1 0) (1 1) (0 2) (2 2) (1 3) (3 3) (4 3))
    "minor-agents test")

   (check-equal?
    (find-free-spaces-incrementally
     (list
      (vector O X _ O O)
      (vector O X O O O)
      (vector O X O O O)
      (vector O X X O X)
      (vector O O O _ _))
     '(4 3) 3)
    '((3 4) (4 4))
    "find-free-spaces-incrementally test, found two at distance 1")

   (check-equal?
    (find-free-spaces-incrementally
     (list
      (vector O X _ O O)
      (vector O X O O O)
      (vector O X O O O)
      (vector _ X X O X)
      (vector O O O O _))
     '(2 2) 3)
    '((2 0) (4 4) (0 3))
    "find-free-spaces-incrementally test, found three at distance 2")

   (check-equal?
    (find-free-spaces-incrementally
     (list
      (vector O X _ O O)
      (vector O X O O O)
      (vector O X O O O)
      (vector O X X O X)
      (vector O O O O X))
     '(1 3) 3)
    '((2 0))
    "find-free-spaces-incrementally test, found one at distance 3")

   (check-equal?
    (find-free-spaces-incrementally
     (list
      (vector O X _ O O)
      (vector O X O O O)
      (vector O X O O O)
      (vector O X X O X)
      (vector O O O O X))
     '(0 5) 3)
    #f
    "find-free-spaces-incrementally test, found nothing because the
 only free space is beyond the limit distance")

   (check-equal?
    (but-ref  '(0 1 2 3 4) 3)
    '(0 1 2 4)
    "check-equal? test")
   ))

(run-tests core-tests)
