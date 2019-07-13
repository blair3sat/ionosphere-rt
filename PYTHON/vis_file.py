f = open("abc.txt", "r")

line = f.readline()

def clean(arr_string):
    return [val.strip() for val in arr_string if val != " " and val != ""]

def numb(val):
    try:
        float(val)
        return True
    except:
        return False

x = []
y = []
z = []
density = []

x_point = 0
y_point = 0

counter = 0
while line:
    vals = clean(line.split(" "))
    if (vals[0] == "lat:"):
        x_point = float(vals[1])
        y_point = float(vals[3])

    elif numb(vals[0]):
        if float(vals[1]) != 0.0:
            if(counter%50 == 0):
                x.append(x_point)
                y.append(y_point)
                z.append(float(vals[0])) 
                density.append(float(vals[1]))
            counter += 1

        


    line = f.readline()


from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import numpy as np

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

ax.scatter(x, y, z, c=density)

ax.set_xlabel('Lat')
ax.set_ylabel('Long')
ax.set_zlabel('Height')

plt.show()
