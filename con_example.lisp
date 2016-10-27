(define make-coin (lambda (weight) (lambda () (if (flip weight) 'h 't))))

(define (samples data)
  (mh-query
   400 10

   (define coin-weight (uniform 0 1))
   (define coin (make-coin coin-weight))
   coin-weight
   
   ;; use factor statement to simulate flipping the coin and obtaining each observation
   (factor (sum (map
                 (lambda (obs) (if (equal? obs 'h)
                                   (log coin-weight)
                                   (log (- 1 coin-weight))))                 
                 data))) 
   
   ;; (equal? data (repeat (length data) coin))
   ))


(define true-weight 0.9)
(define true-coin (make-coin true-weight))
(define full-data-set (repeat 100 true-coin))
(define observed-data-sizes '(1 3 6 20 30))
(define (estimate N) (mean (samples (take full-data-set N))))
(lineplot (map (lambda (N) (list N (estimate N)))
               observed-data-sizes))

