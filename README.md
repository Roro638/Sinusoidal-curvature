These are the files used for the Internship project "Morhping Thin sheets by imposed boundary curvature".

Data files are on a separate zip file.

The simulations must be run in the following order:
1. Open the python file "Python plate" and set up the simulation through the inputs at the start of the code.
2. Run the script on Abaqus (under File < Run Script). It will take a while to run as it is creating a .dat file with the displacement at each node.
3. Run matlab script called "different mesh" and adjust the inputs at the start depending on the settings you set up in the python code.
5. Plot results onto "curveplotfinal" file.

   On the matlab file there are several sanity checks that are omitted, that you can use if you are running into trouble (the parts that deligned by %%).
   There are 2 other codes "Process File" and "main script" that were an attempt at automating the whole process. However, those files are not completed yet.
