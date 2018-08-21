(define para1 (list 0.3 0.32 0.34 0.36 0.38 0.4 0.42 0.44 0.46 0.48 0.50))
(define para2 (list 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15))

(define (listIter paraList para1 para2)
  (if (equal? (length para2) 0) 
      paraList
      (listIter (append paraList (list (pair para1 (first para2)))) para1 (rest para2))
      )  
  )

(define (paraIter paraList para1 para2)
  (if (equal? (length para1) 0)
      paraList
      (paraIter (append paraList (listIter (list ) (first para1) para2)) (rest para1) para2)
      )
  )

; List of parameter to go through 
(define allPara (paraIter (list ) para1 para2))


; Bayesian estimator
(define (meanEst para)

    (define (samples priorVar hapticVar)
    (mh-query 10000 100

    (define R (multinomial '(R0 R1 R2) (list 0.1 0.1 0.8)))  
    ;Competitive Prior. R0 equal density; R2 density expectation from material cue 
            
    (define V (gaussian 0 0.8)) ;0.8
    ;Prior for V. Same across all three cases; Independent with the density prior 
    ;In size-weight illusion the volumn and density priors are dependent  
            
    (define Y (gaussian V 0.3)) ;0.3
    ;P(Y|V) ~ N(y; V, sigma_y)
            
    (define D 
    (if (equal? R 'R0) (gaussian 0 0.1)             ;Sharp Density Prior
            (if (equal? R 'R1) (gaussian 0.6 0.6)   ;Wide Density Prior 
                (gaussian -3.296 priorVar)) ))      ;Estimated From Material Cue 
    
    (define W (+ D Y))
    (define X (gaussian W hapticVar))                   ;P(X|W) ~ N(x; W, sigma_x)
            
    W

    (and (equal? X (gaussian 0 0.01)) (equal? Y (gaussian 0 0.01)) )           
    ))

    (mean (samples (first para) (rest para)))
)

(map meanEst allPara)