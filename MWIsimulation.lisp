(define samples
 (mh-query 10000 100

 (define R (multinomial '(R0 R1 R2) (list 0.1 0.1 0.8)))  
 ;Competitive Prior. R0 equal density; R2 density expectation from material cue 
           
 (define V (gaussian 0 0.8)) ;0.8
 ;Prior for V. Same across all three cases; Independent with the density prior 
 ;In size-weight illusion the volumn and density priors are dependent  
           
 (define Y (gaussian V 0.31)) ;0.31
 ;P(Y|V) ~ N(y; V, sigma_y)
         
 (define D 
   (if (equal? R 'R0) (gaussian 0 0.1)         ;Sharp Density Prior
        (if (equal? R 'R1) (gaussian 0.6 0.6)    ;Wide Density Prior 
            (gaussian -1.946 0.1)) ))          ;Estimated From Material Cue 
 
 (define W (+ D Y))
 (define X (gaussian W 0.4))                   ;P(X|W) ~ N(x; W, sigma_x)
           
 W

 (and (equal? X (gaussian 0 0.01)) (equal? Y (gaussian 0 0.01)) )           
))

(mean samples)

