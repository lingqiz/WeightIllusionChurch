(define samples
 (mh-query 1000 100

 (define R (multinomial '(R0 R1 R2) (list 0.1 0.1 0.8)))  
 ;Competitive Prior. R0 equal density; R2 density expectation from material cue 
           
 (define V (gaussian 0 0.8)) ;0.8
 ;Prior for V. Same across all three cases; Independent with the density prior 
 ;In size-weight illusion the volumn and density priors are dependent  
           
 (define Y (gaussian V 0.31)) ;0.31
 ;P(Y|V) ~ N(y; V, sigma_y)
         
 (define D 
   (if (equal? R 'R0) (gaussian 0 0.1)         ;Sharp Density Prior
        (if (equal? R 'R1) (gaussian 0.6 0.6)  ;Wide Density Prior 
            (gaussian -5 0.1)) ))              ;Estimated From Material Cue 
 
 (define W (+ D Y))
 (define X (gaussian W 0.6))
 ;P(X|W) ~ N(x; W, sigma_x)
           
 W

 (and (equal? X (gaussian 0 0.01)) (equal? Y (gaussian 0 0.01)) )           
))

(mean samples)


(define (R) (multinomial '(R0 R1 R2) (list 0.34 0.33 0.33)))  
;Competitive Prior. R0 equal density; R2 density expectation from material cue 
           
(define (V) (gaussian 0 0.92))
;Prior for V. Same across all three cases; Independent with the density prior 
;In size-weight illusion the volumn and density priors are dependent  
           
(define (Y V_Prior) (gaussian V_Prior 0.31))  
;P(Y|V) ~ N(y; V, sigma_y)
         
(define (D R_Prior)
 (if (equal? R_Prior 'R0) (gaussian 0 0.1)         ;Sharp Density Prior
      (if (equal? R_Prior 'R1) (gaussian 0.8 1.1)  ;Wide Density Prior 
          (gaussian -1.9 0.5)) ))            ;Estimated From Material Cue 
 
(define (X D_Prior Y_Prior) (gaussian (+ D_Prior Y_Prior) 0.7))
(define weight-est (lambda () (X (D (R)) (Y (V))) ))

(hist (repeat 20000 weight-est) )