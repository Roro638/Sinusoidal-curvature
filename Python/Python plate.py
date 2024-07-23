#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul 15 10:42:46 2024

@author: s2239369
"""

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul  2 11:15:45 2024

@author: s2239369
"""

# -*- coding: mbcs -*-
from part import *
from material import *
from section import *
from assembly import *
from step import *
from interaction import *
from load import *
from mesh import *
from optimization import *
from job import *
from sketch import *
from visualization import *
from connectorBehavior import *
import numpy as np

## Initializing the simulation
    ##Decide where to store your simulation results

os.chdir(r'/home/s2239369/Internship/FEA results')

BaseDir = os.getcwd()
Foldername = 1

while os.path.exists(BaseDir+"/"+str(Foldername)) == True:
    Foldername = Foldername + 1

os.mkdir(BaseDir+"/"+str(Foldername))
os.chdir(BaseDir+"/"+str(Foldername))

## Variables
mesh = 0.05
Thickness = 0.01
Curvature = 'sin(2*pi*(X-0.5))'            ##0.5*sin(X/0.5+pi/2)-0.5
Youngs_modulus = 1000000
Poisson_ratio = 0.5

## Function to create simulation

def Create_plate():
    
    ##Create sheet
    
    mdb.models['Model-1'].ConstrainedSketch(name='__profile__', sheetSize=200.0)
    mdb.models['Model-1'].sketches['__profile__'].Line(point1=(-5.0, 0.0), point2=(
        0.0, 0.0))
    mdb.models['Model-1'].sketches['__profile__'].HorizontalConstraint(
        addUndoState=False, entity=
        mdb.models['Model-1'].sketches['__profile__'].geometry[2])
    mdb.models['Model-1'].sketches['__profile__'].ObliqueDimension(textPoint=(
        -2.83718872070313, 4.57597351074219), value=0.5, vertex1=
        mdb.models['Model-1'].sketches['__profile__'].vertices[0], vertex2=
        mdb.models['Model-1'].sketches['__profile__'].vertices[1])
    mdb.models['Model-1'].sketches['__profile__'].Line(point1=(0.0, 0.0), point2=(
        0.82270336151123, 0.0))
    mdb.models['Model-1'].sketches['__profile__'].HorizontalConstraint(
        addUndoState=False, entity=
        mdb.models['Model-1'].sketches['__profile__'].geometry[3])
    mdb.models['Model-1'].sketches['__profile__'].ParallelConstraint(addUndoState=
        False, entity1=mdb.models['Model-1'].sketches['__profile__'].geometry[2], 
        entity2=mdb.models['Model-1'].sketches['__profile__'].geometry[3])
    mdb.models['Model-1'].sketches['__profile__'].ObliqueDimension(textPoint=(
        0.587713241577148, 0.624966740608215), value=0.5, vertex1=
        mdb.models['Model-1'].sketches['__profile__'].vertices[1], vertex2=
        mdb.models['Model-1'].sketches['__profile__'].vertices[2])
    mdb.models['Model-1'].sketches['__profile__'].Line(point1=(0.5, 0.0), point2=(
        0.5, -8.75))
    mdb.models['Model-1'].sketches['__profile__'].VerticalConstraint(addUndoState=
        False, entity=mdb.models['Model-1'].sketches['__profile__'].geometry[4])
    mdb.models['Model-1'].sketches['__profile__'].PerpendicularConstraint(
        addUndoState=False, entity1=
        mdb.models['Model-1'].sketches['__profile__'].geometry[3], entity2=
        mdb.models['Model-1'].sketches['__profile__'].geometry[4])
    mdb.models['Model-1'].sketches['__profile__'].Line(point1=(-0.5, 0.0), point2=(
        -0.5, -8.75))
    mdb.models['Model-1'].sketches['__profile__'].VerticalConstraint(addUndoState=
        False, entity=mdb.models['Model-1'].sketches['__profile__'].geometry[5])
    mdb.models['Model-1'].sketches['__profile__'].PerpendicularConstraint(
        addUndoState=False, entity1=
        mdb.models['Model-1'].sketches['__profile__'].geometry[2], entity2=
        mdb.models['Model-1'].sketches['__profile__'].geometry[5])
    mdb.models['Model-1'].sketches['__profile__'].Line(point1=(-0.5, -8.75), 
        point2=(0.5, -8.75))
    mdb.models['Model-1'].sketches['__profile__'].HorizontalConstraint(
        addUndoState=False, entity=
        mdb.models['Model-1'].sketches['__profile__'].geometry[6])
    mdb.models['Model-1'].sketches['__profile__'].PerpendicularConstraint(
        addUndoState=False, entity1=
        mdb.models['Model-1'].sketches['__profile__'].geometry[5], entity2=
        mdb.models['Model-1'].sketches['__profile__'].geometry[6])
    mdb.models['Model-1'].Part(dimensionality=THREE_D, name='Part-1', type=
        DEFORMABLE_BODY)
    mdb.models['Model-1'].parts['Part-1'].BaseShell(sketch=
        mdb.models['Model-1'].sketches['__profile__'])
    del mdb.models['Model-1'].sketches['__profile__']
    
    ## Create material
    
    mdb.models['Model-1'].Material(name='Material-1')
    mdb.models['Model-1'].materials['Material-1'].Elastic(table=((Youngs_modulus, Poisson_ratio), 
        ))
    mdb.models['Model-1'].HomogeneousShellSection(idealization=NO_IDEALIZATION, 
        integrationRule=SIMPSON, material='Material-1', name='Section-1', 
        nodalThicknessField='', numIntPts=5, poissonDefinition=DEFAULT, 
        preIntegrate=OFF, temperature=GRADIENT, thickness=Thickness, thicknessField='', 
        thicknessModulus=None, thicknessType=UNIFORM, useDensity=OFF)
    mdb.models['Model-1'].parts['Part-1'].Set(faces=
        mdb.models['Model-1'].parts['Part-1'].faces.getSequenceFromMask(('[#1 ]', 
        ), ), name='Set-1')
    mdb.models['Model-1'].parts['Part-1'].SectionAssignment(offset=0.0, 
        offsetField='', offsetType=MIDDLE_SURFACE, region=
        mdb.models['Model-1'].parts['Part-1'].sets['Set-1'], sectionName=
        'Section-1', thicknessAssignment=FROM_SECTION)
    
    ## Create Mesh
    
    mdb.models['Model-1'].rootAssembly.DatumCsysByDefault(CARTESIAN)
    mdb.models['Model-1'].rootAssembly.Instance(dependent=ON, name='Part-1-1', 
        part=mdb.models['Model-1'].parts['Part-1'])
    mdb.models['Model-1'].parts['Part-1'].seedPart(deviationFactor=0.1, 
        minSizeFactor=0.1, size=0.07)
    mdb.models['Model-1'].parts['Part-1'].generateMesh()
    mdb.models['Model-1'].rootAssembly.regenerate()
    mdb.models['Model-1'].parts['Part-1'].deleteMesh()
    mdb.models['Model-1'].parts['Part-1'].seedPart(deviationFactor=0.1, 
        minSizeFactor=0.1, size=mesh)
    mdb.models['Model-1'].parts['Part-1'].generateMesh()
    mdb.models['Model-1'].rootAssembly.regenerate()
    mdb.models['Model-1'].rootAssembly.Set(name='Set-1', nodes=
    mdb.models['Model-1'].rootAssembly.instances['Part-1-1'].nodes.getSequenceFromMask(mask=('[#1]', ), ))
    
    ## Create Step
    
    mdb.models['Model-1'].StaticStep(name='Step-1', nlgeom=ON, previous='Initial')
    mdb.models['Model-1'].rootAssembly.Set(name='Set-2', vertices=
        mdb.models['Model-1'].rootAssembly.instances['Part-1-1'].vertices.getSequenceFromMask(
        ('[#10 ]', ), ))
    
    mdb.models['Model-1'].FieldOutputRequest(createStepName='Step-1', name=
        'F-Output-2', variables=('SE', 'SEE'))
    
    ## Create Boundary conditions

    mdb.models['Model-1'].DisplacementBC(amplitude=UNSET, createStepName='Step-1', 
        distributionType=UNIFORM, fieldName='', fixed=OFF, localCsys=None, name=
        'Fixed X', region=mdb.models['Model-1'].rootAssembly.sets['Set-2'], u1=0.0, 
        u2=UNSET, u3=UNSET, ur1=UNSET, ur2=UNSET, ur3=UNSET)
    mdb.models['Model-1'].rootAssembly.Set(edges=
        mdb.models['Model-1'].rootAssembly.instances['Part-1-1'].edges.getSequenceFromMask(
        ('[#18 ]', ), ), name='Set-3')
    mdb.models['Model-1'].DisplacementBC(amplitude=UNSET, createStepName='Step-1', 
        distributionType=UNIFORM, fieldName='', fixed=OFF, localCsys=None, name=
        'Fixed Y', region=mdb.models['Model-1'].rootAssembly.sets['Set-3'], u1=
        UNSET, u2=0.0, u3=UNSET, ur1=UNSET, ur2=UNSET, ur3=UNSET)
    mdb.models['Model-1'].rootAssembly.Set(edges=
        mdb.models['Model-1'].rootAssembly.instances['Part-1-1'].edges.getSequenceFromMask(
        ('[#18 ]', ), ), name='Set-4')
    mdb.models['Model-1'].DisplacementBC(amplitude=UNSET, createStepName='Step-1', 
        distributionType=UNIFORM, fieldName='', fixed=OFF, localCsys=None, name=
        'X-rotation', region=mdb.models['Model-1'].rootAssembly.sets['Set-4'], u1=
        UNSET, u2=UNSET, u3=UNSET, ur1=0.0, ur2=UNSET, ur3=UNSET)
    mdb.models['Model-1'].ExpressionField(description='', expression=
        Curvature, localCsys=None, name='Curvature')
    mdb.models['Model-1'].rootAssembly.Set(edges=
        mdb.models['Model-1'].rootAssembly.instances['Part-1-1'].edges.getSequenceFromMask(
        ('[#18 ]', ), ), name='Set-5')
    mdb.models['Model-1'].DisplacementBC(amplitude=UNSET, createStepName='Step-1', 
        distributionType=FIELD, fieldName='Curvature', fixed=OFF, localCsys=None, 
        name='Curvature', region=mdb.models['Model-1'].rootAssembly.sets['Set-5'], 
        u1=UNSET, u2=UNSET, u3=1.0, ur1=UNSET, ur2=UNSET, ur3=UNSET)
    mdb.Job(atTime=None, contactPrint=OFF, description='', echoPrint=OFF, 
        explicitPrecision=SINGLE, getMemoryFromAnalysis=True, historyPrint=OFF, 
        memory=90, memoryUnits=PERCENTAGE, model='Model-1', modelPrint=OFF, 
        multiprocessingMode=DEFAULT, name='Job-1', nodalOutputPrecision=SINGLE, 
        numCpus=1, numGPUs=0, queue=None, resultsFormat=ODB, scratch='', type=
        ANALYSIS, userSubroutine='', waitHours=0, waitMinutes=0)

        # Submit job
    mdb.jobs['Job-1'].submit(consistencyChecking=OFF)
        
        # Wait for job completion
    mdb.jobs['Job-1'].waitForCompletion()
    print('Flat plate Model finished running')
        
## Post Processing

def Post_Processing():
    odb = session.openOdb(r'/home/s2239369/Internship/FEA results/' + str(Foldername) + '/Job-1.odb')    ## Create Folder for all files
    
    Nr_steps = len(odb.steps['Step-1'].frames)
    Nr_nodes = len(odb.steps['Step-1'].frames[5].fieldOutputs['U'].values)
    Front_left_disp = odb.steps['Step-1'].frames[5].fieldOutputs['U'].values[1].data[1]
    print('Front left displacement:', Front_left_disp)
    print('Number of nodes:', Nr_nodes)
    
    y_displacements = []
    x_displacements = []
    z_displacements = []
    
    for i in range(Nr_nodes):
        x_disp = odb.steps['Step-1'].frames[5].fieldOutputs['U'].values[i].data[0]
        y_disp = odb.steps['Step-1'].frames[5].fieldOutputs['U'].values[i].data[2]
        z_disp = odb.steps['Step-1'].frames[5].fieldOutputs['U'].values[i].data[1]
        y_displacements.append(y_disp)
        x_displacements.append(x_disp)
        z_displacements.append(z_disp)
    nodes = np.arange(0,Nr_nodes+1,1)
    
    # Prepare the data to write to the file
    data = list(zip(nodes, x_displacements, y_displacements, z_displacements))
    
    # Write data to a .dat file
    file_path = r'/home/s2239369/Internship/FEA results/' + str(Foldername) + '/variables.dat'     ## Create storing place for .dat file
    with open(file_path, 'w') as file:
        file.write('Node\tX_Displacement\tY_Displacement\tZ_Displacement\n')
        for node, x_disp, y_disp, z_disp in data:
            file.write('{}\t{}\t{}\t{}\n'.format(node, x_disp, y_disp, z_disp))       ## Send all necessary variables to the .dat file from abaqus
    
Create_plate()
Post_Processing()