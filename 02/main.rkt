#lang racket

(struct game-round-color (color amount) #:transparent)
(struct game (id rounds) #:transparent)

(define (parse-line l)
  (define split-by-game-line (string-split l ": " #:trim? #t))
  (define id-game (second (string-split (first split-by-game-line) " " #:trim? #t)))
  (define game-rounds (second split-by-game-line))
  (define split-by-round-game (string-split game-rounds "; " #:trim? #t))
  (define games null)
  (for/list ([gr split-by-round-game])
    (define split-game-round (string-split gr ", " #:trim? #t))

    (define r (game-round-color "red" 0))
    (define g (game-round-color "green" 0))
    (define b (game-round-color "blue" 0))

    (for/list ([c split-game-round])
      (define split-c (string-split c " " #:trim? #t))
      (define (to-color c) (game-round-color (second split-c) (string->number (first split-c))))

      (match (second split-c)
        ["red" (set! r (to-color split-c))]
        ["green" (set! g (to-color split-c))]
        ["blue" (set! b (to-color split-c))]))

    (define played-game (game id-game (list r g b)))

    (set! games (append games (list played-game))))
  games)

(define read-input-lines (file->lines "02/input"))

(define (part n)
  (cond
    [(eq? n 1) 
      (define max-red 12)
      (define max-green 13)
      (define max-blue 14)

      (define possible-games '())

      (define parsed-lines null)

      (for/list ([l read-input-lines])
        (cond
          [(string-length l) (set! parsed-lines (append parsed-lines (list (parse-line l))))]
          [else (error "Nope...")]))
      

      (define res 0)

      (for/list ([played-game parsed-lines])
        (define id-current-game -1)
        (define max-r 0)
        (define max-g 0)
        (define max-b 0)

        (println played-game)
        (println "--------------------------------------------------")
        (match played-game
          [(list (game id (list (game-round-color "red" r) (game-round-color "green" g) (game-round-color "blue" b))) ...)
            (set! id-current-game id)
            (cond [max-r <= r (set! max-r r)])
            (cond [max-g <= g (set! max-g g)])
            (cond [max-b <= b (set! max-b b)])]
          [else (println "Not matched")])
        
        (set! max-r (foldl (lambda (x y) (if (> x y) x y)) 0 max-r))
        (set! max-g (foldl (lambda (x y) (if (> x y) x y)) 0 max-g))
        (set! max-b (foldl (lambda (x y) (if (> x y) x y)) 0 max-b))

        (set! id-current-game (string->number (first id-current-game)))

        (if
          (and (<= max-r max-red) (and (<= max-g max-green) (<= max-b max-blue)))
          (set! res (+ res id-current-game))
          #f))

      (println (string-append "Part 1: " (number->string res)))
    ]
    [(eq? n 2) (println "Part 2: Not implemented yet!")]))


(part 1)
(part 2)
