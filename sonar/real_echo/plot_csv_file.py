import matplotlib.pyplot as plt
import csv
from sys import argv

X = []
Y = []

with open(argv[1], 'r') as datafile:
    plotting = csv.reader(datafile, delimiter=',')
    for ROWS in plotting:
        X.append(float(ROWS[int(argv[2])]))
        Y.append(float(ROWS[int(argv[3])]))

print ('X {} Nums {}'.format(len(X),type(X)  )  )
print ('Y {} Nums {}'.format(len(Y),type(Y)  )  )

#plt.scatter(X, Y, color='blue', alpha=0.05, s=1)
# plt.plot(X, Y, alpha=0.4)
plt.plot(X, Y)
plt.title('Plot')
plt.xlabel(argv[4])
plt.ylabel(argv[5])
plt.grid()
#plt.yscale("log")  
plt.xticks(rotation=-90)
#plt.xscale('log' )
plt.show()