from sympy import *



p1, p2, L1, L2, t, c, a, B = symbols('p1 p2 L1 L2 t c a B')
init_printing(use_unicode=True)



def expr(p1, p2, L1, L2, t, c, a, B): 
    return ( p1 * (L1 * ( (1 - L2)(1-B) + L2*B*(1/(2*t))*(t-p1+p2) ) ) 
            - c * (L1 * ( (1 - L2)(1-B) + L2*B*(1/(2*t))*(t-p1+p2) ) )
            - a*pow(L1, 2)/2 )

e = expr(p1, p2, L1, L2, t, c, a, B)
print(expr.diff(p1))
print(expr.diff(L1))


B*L1*L2*c/(2*t) 
- B*L1*L2*p1/(2*t) 
+ L1*(B*L2*(-p1 + p2 + t)/(2*t) + (1 - B)*(1 - L2))



def expr(p1, p2, L1, L2, t, c, a, B): 
    return ( p1 * (L2 * ( (1 - L1)*(1-B) + L1*B*(1/(2*t))*(t-p1+p2) ) ) 
            - c * (L2 * ( (1 - L1)*(1-B) + L1*B*(1/(2*t))*(t-p1+p2) ) )
            - a*pow(L2, 2)/2 )




Algorithm 1 Pseudo code of recommender system

Input: Current task t, current user x
Retrieve rhe set of taks {t1, t2, ..., tn} sorted descending by similarity to taks t

L := {}

def RecommenderSystem_BETA(t, x, I):
    for i in zip(category, c) =:
        if in t:
            for k in range(1, n):
                Let Ic = union(i, k )
                if j in i**2: 
                    p**3
                elif (p - v)> threshold: L['j'] = p
        print(L)
    return L









