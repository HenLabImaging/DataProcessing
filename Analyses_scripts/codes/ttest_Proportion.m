p1=0.26
p2=0.24
n1=270
n2=216

p=(p1*n1+p2*n2)/(n1+n2)
se=sqrt(p*(1-p)*(1/n1+1/n2))
z=(p1-p2)/se