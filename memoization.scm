(use-syntax (ice-9 syncase))

(define-syntax lazy-cons
  (syntax-rules ()   
    ((lazy-cons a b) (cons a (delay b)))))

(define lazy-car car)

(define (lazy-cdr ls)
  (force (cdr ls)))

(define (lazy-head lst n)
  (if (= n 0)
      '()
      (cons (lazy-car lst) (lazy-head (lazy-cdr lst) (- n 1)))))

(define (lazy-ref lst n)
  (if (= n 0)
      (lazy-car lst)
      (lazy-ref (lazy-cdr lst) (- n 1))))

(define (naturals start)
  (lazy-cons start (naturals (+ start 1))))

(define (factorial-list n)
  (lazy-cons (factorial n) (factorial-list (+ n 1))))

(define (lazy-factorial n)
  (lazy-ref (factorial-list 0) n))
    
(define memoize (lambda (f)
                  (let ((lst '()))
                    (lambda args
                      (let ((match (assoc args lst)))
                        (if match
                            (cadr match)                  
                            (let ((value (apply f args)))
                              (set! lst (cons (list args value) lst))
                              value)))))))

(define (memoized-factorial n)
  (factorial n))

(define (factorial n)
   (if (= n 0)
       1
       (* (factorial (- n 1)) n)))

(set! factorial (memoize factorial))
